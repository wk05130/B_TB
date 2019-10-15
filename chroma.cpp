#include "chroma_suppression.h"
extern "C" { 
int _chroma_tmain(isp_chroma_param_t *chroma_param_t)
{
  //if (argc != 8)
  //{
  //  printf("Usage: chroma_suppression input_yuv_file output_yuv_file width height grey_th gain weight\n");

  //  return EXIT_FAILURE;
  //}

  //strcpy(filename_i, argv[1]);
  //strcpy(filename_o, argv[2]);
  //width = atoi(argv[3]);
  //height = atoi(argv[4]);
  printf("chroma_param_t-src_file_from_yuv_en:%d \n",chroma_param_t->src_file_from_yuv_en);
  printf("chroma_param_t-width:%d \n",chroma_param_t->width);
  printf("chroma_param_t-height:%d \n",chroma_param_t->height);
  printf("chroma_param_t-grey_th:%d \n",chroma_param_t->grey_th);
  printf("chroma_param_t-gain:%d \n",chroma_param_t->gain);
  printf("chroma_param_t-weight:%d \n",chroma_param_t->weight);

  strcpy(filename_i, "../src_in.yuv");
  strcpy(filename_i_y, "./src_y_in_ascii.txt");
  strcpy(filename_i_u, "./src_u_in_ascii.txt");
  strcpy(filename_i_v, "./src_v_in_ascii.txt");
  
  strcpy(filename_o, "./dst.yuv");
  width  = chroma_param_t->width;
  height = chroma_param_t->height;
  //printf("0chroma_param_t-weight:%d \n",chroma_param_t->weight);
  allocate_memory();
  //printf("1chroma_param_t-weight:%d \n",chroma_param_t->weight);
  if (chroma_param_t->src_file_from_yuv_en == 1)
  { 
      read_yuv();
  }
  else
  {
      read_txt();
  }
  set_default_reg();

  // set register
  //reg.grey_th = atoi(argv[5]);
  //reg.gain = atoi(argv[6]);
  //reg.weight = atoi(argv[7]);

  //reg.grey_th = 4;
  //reg.gain = 265;
  //reg.weight = 16;

  reg.grey_th = chroma_param_t->grey_th;
  reg.gain = chroma_param_t->gain;
  reg.weight = chroma_param_t->weight;

  FILE* fcz = NULL;
//  fcz = fopen("./cz_y_input.txt", "w+");
//
//  for (int32_t iy = 0; iy < height; iy++)
//  {
//	  for (int32_t ix = 0; ix < width; ix++)
//	  {
//		  fprintf(fcz, "%x\n", y_i[iy][ix]);
//	  }
//  }
//  fclose(fcz);
//
//  fcz = fopen("./cz_uv_input.txt", "w+");
//
//  for (int32_t iy = 0; iy < height; iy++)
//  {
//	  for (int32_t ix = 0; ix < width; ix++)
//	  {
//		  if (ix % 2 == 1) {
//			  fprintf(fcz, "%x\n", u_i[iy][ix / 2]);
//			  fprintf(fcz, "%x\n", v_i[iy][ix / 2]);
//		  }
//		  
//	  }
//  }
//  fclose(fcz);

  for (int32_t iy = 0; iy < height; iy++)
  {
    for (int32_t ix = 0; ix < width; ix++)
    {
      //printf("y_i[%d][%d]:%d \n",y_i[iy][ix]);
      //if (ix % 2 == 1)
      //{
      //  printf("u_i[%d][%d]:%d \n",u_i[iy][ix]);
      //}                                                                                                                            
      //else
      //{
      //  printf("v_i[%d][%d]:%d \n",v_i[iy][ix]);
      //}
      y_o[iy][ix] = y_i[iy][ix];
      if (ix == 95)
		  ix += 0;
      if (ix % 2 == 1)
      {
        chroma_suppression(reg.grey_th, reg.gain, reg.weight, u_i[iy][ix / 2], v_i[iy][ix / 2], u_o[iy][ix / 2], v_o[iy][ix / 2]);
      }
    }
  }
  // use .yuv ,so can del
  //fcz = fopen("./cz_y_output.txt", "w+");

  //for (int32_t iy = 0; iy < height; iy++)
  //{
  //    for (int32_t ix = 0; ix < width; ix++)
  //    {
  //  	  fprintf(fcz, "%x\n", y_o[iy][ix]);
  //    }
  //}
  //fclose(fcz);

  //fcz = fopen("./cz_uv_output.txt", "w+");

  //for (int32_t iy = 0; iy < height; iy++)
  //{
  //    for (int32_t ix = 0; ix < width; ix++)
  //    {
  //  	  if (ix % 2 == 1) {
  //  		  fprintf(fcz, "%x\n", u_o[iy][ix / 2]);
  //  		  fprintf(fcz, "%x\n", v_o[iy][ix / 2]);
  //  	  }
  //    }
  //}
  //fclose(fcz);
  write_yuv();
  release_memory();
  uv_plane_test();
  printf("137out_height:%d width:%d\n",height,width);
  return EXIT_SUCCESS;
}

}
void chroma_suppression(int32_t grey_th, int32_t gain, int32_t weight, int32_t u_i, int32_t v_i, int32_t& u_o, int32_t& v_o)
{
  int32_t u_offset_i_2s = u_i - CHROMA_CENTER;
  int32_t v_offset_i_2s = v_i - CHROMA_CENTER;

  int32_t u_mag_i = abs(u_offset_i_2s);
  int32_t v_mag_i = abs(v_offset_i_2s);

  bool u_larger;
  int32_t mag_max_i;
  int32_t mag_min_i;

  if (u_mag_i >= v_mag_i)
  {
    u_larger = true;
    mag_max_i = u_mag_i;
    mag_min_i = v_mag_i;
  }
  else
  {
    u_larger = false;
    mag_max_i = v_mag_i;
    mag_min_i = u_mag_i;
  }

  if (mag_max_i <= grey_th)
  {
    u_o = CHROMA_CENTER;
    v_o = CHROMA_CENTER;
  }
  else
  {
    int32_t mag_max_ini = round_off((mag_max_i - grey_th) * gain, GAIN_PRECISION);
    int32_t mag_max_o = __min(mag_max_i, mag_max_ini);
    int32_t mag_min_o = (mag_max_o * mag_min_i + (mag_max_i >> 1)) / mag_max_i;

    int32_t u_mag_o;
    int32_t v_mag_o;

    if (u_larger)
    {
      u_mag_o = mag_max_o;
      v_mag_o = mag_min_o;
    }
    else
    {
      u_mag_o = mag_min_o;
      v_mag_o = mag_max_o;
    }

    int32_t u_offset_o_2s = (u_offset_i_2s >= 0) ? u_mag_o : -u_mag_o;
    int32_t v_offset_o_2s = (v_offset_i_2s >= 0) ? v_mag_o : -v_mag_o;

    int32_t u_o_ini = clip(0, PIXEL_MAX, u_offset_o_2s + CHROMA_CENTER);
    int32_t v_o_ini = clip(0, PIXEL_MAX, v_offset_o_2s + CHROMA_CENTER);

    u_o = alpha_blend(u_o_ini, u_i, weight, WEIGHT_PRECISION);
    v_o = alpha_blend(v_o_ini, v_i, weight, WEIGHT_PRECISION);
  }
}

void set_default_reg()
{
  reg.grey_th = 0;
  reg.gain = 1 << GAIN_PRECISION;
  reg.weight = 0;
}

void allocate_memory()
{
  y_i = new int32_t * [height];
  u_i = new int32_t * [height];
  v_i = new int32_t * [height];

  y_o = new int32_t * [height];
  u_o = new int32_t * [height];
  v_o = new int32_t * [height];

  for (int32_t iy = 0; iy < height; iy++)
  {
    y_i[iy] = new int32_t[width];
    u_i[iy] = new int32_t[width / 2];
    v_i[iy] = new int32_t[width / 2];

    y_o[iy] = new int32_t[width];
    u_o[iy] = new int32_t[width / 2];
    v_o[iy] = new int32_t[width / 2];
  }
}

void release_memory()
{
  for (int32_t iy = 0; iy < height; iy++)
  {
    delete[] y_i[iy];
    delete[] u_i[iy];
    delete[] v_i[iy];

    delete[] y_o[iy];
    delete[] u_o[iy];
    delete[] v_o[iy];
  }

  delete[] y_i;
  delete[] u_i;
  delete[] v_i;

  delete[] y_o;
  delete[] u_o;
  delete[] v_o;
}

void read_yuv()
{
  FILE* fp_i_yuv = fopen(filename_i, "rb");

  if (fp_i_yuv == NULL)
  {
    printf("ERROR: Open input file %s failed.\n", filename_i);
  }
  else
  {
    for (int32_t iy = 0; iy < height; iy++)
    {
      for (int32_t ix = 0; ix < width; ix++)
      {
        y_i[iy][ix] = fgetc(fp_i_yuv);

        if (ix % 2 == 0)
        {
          u_i[iy][ix / 2] = fgetc(fp_i_yuv);
        }
        else
        {
          v_i[iy][ix / 2] = fgetc(fp_i_yuv);
        }
      }
    }

    fclose(fp_i_yuv);
  }
}

void read_txt()
{
  FILE* fp_i_y = fopen(filename_i_y, "r");
  FILE* fp_i_u = fopen(filename_i_u, "r");
  FILE* fp_i_v = fopen(filename_i_v, "r");
  char tmp_y[3];
  char tmp_u[3];
  char tmp_v[3];
  uint8_t src_tmp_y;
  uint8_t src_tmp_u;
  uint8_t src_tmp_v;

  //printf("height:%d width:%d\n",height,width);
  if ((fp_i_y == NULL) || (fp_i_u == NULL) || (fp_i_v == NULL) )
  {
    printf("ERROR: Open input file %s %s %s failed.\n", fp_i_y,fp_i_u,fp_i_v);
  }
  else
  {
    printf("src_tmp_y:%d",src_tmp_y);
    for (int32_t iy = 0; iy < height; iy++)
    {
      for (int32_t ix = 0; ix < width; ix++)
      {
        fread(tmp_y,3,1,fp_i_y);
        //tmp_y[2]=0;       
        //src_tmp_y =(uint8_t)atoi(tmp_y); // 10 binary change
        src_tmp_y =(uint8_t)strtol(tmp_y,NULL,16); // 16 binary sysytem
        //if(ix<30 && iy<1)
        //{
        //   printf("tmp_y[0]:%d,tmp_y[1]:%d,tmp_y[2]:%d \n",tmp_y[0],tmp_y[1],tmp_y[2]);
        //   printf("src_tmp_y:%d \n",src_tmp_y);
        //}
        y_i[iy][ix] = src_tmp_y;
        if (ix % 2 == 0)
        {
          fread(tmp_u,3,1,fp_i_u);
          src_tmp_u =(uint8_t)strtol(tmp_u,NULL,16); // 16 binary sysytem 
          //if(ix<30 && iy<1)
          //{
          //   printf("tmp_u[0]:%d,tmp_u[1]:%d,tmp_u[2]:%d \n",tmp_u[0],tmp_u[1],tmp_u[2]);
          //   printf("src_tmp_u:%d \n",src_tmp_u);
          //}
          u_i[iy][ix/2] = src_tmp_u;
        }
        else
        {
          fread(tmp_v,3,1,fp_i_v);
          src_tmp_v =(uint8_t)strtol(tmp_v,NULL,16); // 16 binary sysytem 
          //if(ix<30 && iy<1)
          //{
          //   printf("tmp_v[0]:%d,tmp_v[1]:%d,tmp_v[2]:%d \n",tmp_v[0],tmp_v[1],tmp_v[2]);
          //   printf("src_tmp_v:%d \n",src_tmp_v);
          //}
          v_i[iy][ix/2] = src_tmp_v;
        }
      }
    }
    fclose(fp_i_y);
    fclose(fp_i_u);
    fclose(fp_i_v);
  }
}

void write_yuv()
{
  FILE* fp_o_yuv = fopen(filename_o, "wb");

  if (fp_o_yuv == NULL)
  {
    printf("ERROR: Open output file %s failed.\n", filename_o);
  }
  else
  {
    for (int32_t iy = 0; iy < height; iy++)
    {
      for (int32_t ix = 0; ix < width; ix++)
      {
        fputc(y_o[iy][ix], fp_o_yuv);

        if (ix % 2 == 0)
        {
          fputc(u_o[iy][ix / 2], fp_o_yuv);
        }
        else
        {
          fputc(v_o[iy][ix / 2], fp_o_yuv);
        }
      }
    }

    fclose(fp_o_yuv);
  }
}

void uv_plane_test()
{
  int32_t** r_i;
  int32_t** g_i;
  int32_t** b_i;

  int32_t** r_o;
  int32_t** g_o;
  int32_t** b_o;

  r_i = new int32_t * [256];
  g_i = new int32_t * [256];
  b_i = new int32_t * [256];

  r_o = new int32_t * [256];
  g_o = new int32_t * [256];
  b_o = new int32_t * [256];

  for (int32_t iy = 0; iy < 256; iy++)
  {
    r_i[iy] = new int32_t[256];
    g_i[iy] = new int32_t[256];
    b_i[iy] = new int32_t[256];

    r_o[iy] = new int32_t[256];
    g_o[iy] = new int32_t[256];
    b_o[iy] = new int32_t[256];
  }

  for (int32_t iy = 0; iy < 256; iy++)
  {
    for (int32_t ix = 0; ix < 256; ix++)
    {
      int32_t y_i = 128;
      int32_t u_i = ix;
      int32_t v_i = 255 - iy;

      int32_t y_o;
      int32_t u_o;
      int32_t v_o;

      y_o = y_i;
      chroma_suppression(reg.grey_th, reg.gain, reg.weight, u_i, v_i, u_o, v_o);

      yuv2rgb(y_i, u_i, v_i, r_i[iy][ix], g_i[iy][ix], b_i[iy][ix], 8);
      yuv2rgb(y_o, u_o, v_o, r_o[iy][ix], g_o[iy][ix], b_o[iy][ix], 8);
    }
  }

  write_bmp("uv_plane_i.bmp", r_i, g_i, b_i, 256, 256);
  write_bmp("uv_plane_o.bmp", r_o, g_o, b_o, 256, 256);

  for (int32_t iy = 0; iy < 256; iy++)
  {
    delete[] r_i[iy];
    delete[] g_i[iy];
    delete[] b_i[iy];

    delete[] r_o[iy];
    delete[] g_o[iy];
    delete[] b_o[iy];
  }

  delete[] r_i;
  delete[] g_i;
  delete[] b_i;

  delete[] r_o;
  delete[] g_o;
  delete[] b_o;
}

void yuv2rgb(int32_t y, int32_t u, int32_t v, int32_t& r, int32_t& g, int32_t& b, int32_t bit)
{
  r = clip(0, (1 << bit) - 1, (int32_t)floor(y + 1.13983 * ((int64_t)v - 128) + 0.5));
  g = clip(0, (1 << bit) - 1, (int32_t)floor(y - 0.39465 * ((int64_t)u - 128) - 0.58060 * ((int64_t)v - 128) + 0.5));
  b = clip(0, (1 << bit) - 1, (int32_t)floor(y + 2.03211 * ((int64_t)u - 128) + 0.5));
}

void write_bmp(const char* filename, int32_t** r, int32_t** g, int32_t** b, int32_t width, int32_t height)
{
  FILE* fp_o_bmp = fopen(filename, "wb");

  if (fp_o_bmp == NULL)
  {
    printf("ERROR: Open output file %s failed.\n", filename);
  }
  else
  {
    unsigned char header[54] = { 0 };

    int32_t bitmap_data_size = (((3 * width + 3) >> 2) << 2) * height;
    int32_t file_size = bitmap_data_size + 54;

    header[0] = 0x42;
    header[1] = 0x4D;
    header[2] = file_size & 0xFF;
    header[3] = (file_size >> 8) & 0xFF;
    header[4] = (file_size >> 16) & 0xFF;
    header[5] = (file_size >> 24) & 0xFF;
    header[10] = 54;
    header[14] = 40;
    header[18] = width & 0xFF;
    header[19] = (width >> 8) & 0xFF;
    header[20] = (width >> 16) & 0xFF;
    header[21] = (width >> 24) & 0xFF;
    header[22] = height & 0xFF;
    header[23] = (height >> 8) & 0xFF;
    header[24] = (height >> 16) & 0xFF;
    header[25] = (height >> 24) & 0xFF;
    header[26] = 1;
    header[28] = 24;
    header[34] = bitmap_data_size & 0xFF;
    header[35] = (bitmap_data_size >> 8) & 0xFF;
    header[36] = (bitmap_data_size >> 16) & 0xFF;
    header[37] = (bitmap_data_size >> 24) & 0xFF;

    for (int32_t byte = 0; byte < 54; byte++)
    {
      fputc(header[byte], fp_o_bmp);
    }

    for (int32_t iy = height - 1; iy >= 0; iy--)
    {
      for (int32_t ix = 0; ix < width; ix++)
      {
        // shift from PIXEL_BW to 8 bits for experiment
        fputc(b[iy][ix] >> (PIXEL_BW - 8), fp_o_bmp);
        fputc(g[iy][ix] >> (PIXEL_BW - 8), fp_o_bmp);
        fputc(r[iy][ix] >> (PIXEL_BW - 8), fp_o_bmp);
      }

      for (int32_t byte = 0; byte < (((3 * width + 3) >> 2) << 2) - 3 * width; byte++)
      {
        fputc(0, fp_o_bmp);
      }
    }

    fclose(fp_o_bmp);
  }
}


