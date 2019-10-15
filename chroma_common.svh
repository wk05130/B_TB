`ifndef CHROMA_COMMON_DEF_SVH
`define CHROMA_COMMON_DEF_SVH

`define VSYNC_IN_CHROMA          top_soc_tb.DUT_WRAPPER.dut_chroma.vsync_in
int                              synwd_delayed           ;

int chroma_img_w;
int chroma_img_h;
int chroma_pattern;

bit [7:0]       chroma_y_in_buf             [0:1920*1080-1];
bit [7:0]       chroma_uv_in_buf            [0:1920*1080-1];
bit [7:0]       chroma_data_in_buf          [0:2*1920*1080-1];
bit [7:0]       chroma_y_out_buf            [0:1920*1080-1];
bit [7:0]       chroma_uv_out_buf           [0:1920*1080-1];
bit [7:0]       chroma_data_out_buf         [0:2*1920*1080-1];

typedef struct{
    bit [31:0] grey_th;				//  0~15
    bit [31:0] gain;				//  0~511
    bit [31:0] weight;	            //  0~16
    bit [31:0] src_file_from_yuv_en;	            //  1:src from .yuv 
    bit [31:0] width;	            //
    bit [31:0] height;	            //
}isp_chroma_param_t;

import "DPI-C" function int _chroma_tmain(input isp_chroma_param_t chroma_param_t_in);

`endif
