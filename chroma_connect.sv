`ifndef CHROMA_CONNECT_SVH
`define CHROMA_CONNECT_SVH

reg clk_chroma;
reg rst_chroma;
reg vsync_chroma;
reg hsync_chroma;
reg [31:0] tcnt_chroma;
reg [31:0] vcnt_chroma;
wire [7:0] img_y_in;
wire [7:0] img_uv_in;
always #50 clk_chroma = ~clk_chroma;

always@(*) begin
    if(tcnt_chroma > 5*(chroma_img_w+100) && tcnt_chroma <= (chroma_img_w+100)*(chroma_img_h+5))
      #1 vsync_chroma = 1;
    else
      #1 vsync_chroma = 0;
end

always@(*) begin
    if((tcnt_chroma%(chroma_img_w+100))>0 && (tcnt_chroma%(chroma_img_w+100))<=chroma_img_w)
      #1 hsync_chroma = 1;
    else
      #1 hsync_chroma = 0;
end
                                                              
/*********************************************/
//vsync_chroma&hsync_chroma input
  wire [31:0] tcnt_nxt_chroma = (tcnt_chroma == (chroma_img_w+100)*(chroma_img_h+10) || ~top_soc_tb.i_top_chip_if.chroma_if.TX_FLAG)? 0 : tcnt_chroma + 1;
  always@(posedge clk_chroma or negedge rst_chroma or ~top_soc_tb.i_top_chip_if.chroma_if.TX_FLAG)
   if(~rst_chroma || ~top_soc_tb.i_top_chip_if.chroma_if.TX_FLAG)
     tcnt_chroma <= 0;
   else
     tcnt_chroma <= tcnt_nxt_chroma;
/*********************************************/
integer i_chroma,j_chroma,k_chroma,k_clip_chroma;
assign i_chroma= ((tcnt_chroma - 5*(chroma_img_w+100) - 1)%(chroma_img_w+100));
assign j_chroma= ((tcnt_chroma - 5*(chroma_img_w+100))/(chroma_img_w+100))*chroma_img_w;
assign k_chroma = j_chroma + i_chroma;
assign k_clip_chroma = (k_chroma >= ((j_chroma/chroma_img_w+1)*chroma_img_w))? ((j_chroma/chroma_img_w+1)*chroma_img_w-1) : k_chroma;
assign img_y_in  = vsync_chroma ? chroma_y_in_buf[k_clip_chroma] : 0;
assign img_uv_in = vsync_chroma ? chroma_uv_in_buf[k_clip_chroma] : 0;

initial begin
    clk_chroma = 0;
    rst_chroma = 0;
    #500 rst_chroma = 1;
end

initial begin
   force i_top_chip_if.chroma_if.clk                     =  clk_chroma;
   force i_top_chip_if.chroma_if.out_y_dst               =  dut_chroma.y_out;
   force i_top_chip_if.chroma_if.out_uv_dst              =  dut_chroma.uv_out;
   force i_top_chip_if.chroma_if.rx_dst_data_core_en     =  dut_chroma.vsync_out & dut_chroma.hsync_out ;
end

reg hsync_chroma_d1,vsync_chroma_d1,vsync_chroma_d2,vsync_chroma_d3,vsync_chroma_d4;
reg [7:0]  y_in_d1;
reg [7:0]  uv_in_d1;
always@(posedge clk_chroma or negedge rst) begin
  if(~rst) begin
    y_in_d1     <= 0;  
    uv_in_d1    <= 0;  
    hsync_chroma_d1 <= 0;
    vsync_chroma_d1 <= 0;
    vsync_chroma_d2 <= 0;
    vsync_chroma_d3 <= 0;
    vsync_chroma_d4 <= 0;
  end else begin
    y_in_d1      <= img_y_in;
    uv_in_d1     <= img_uv_in;
    hsync_chroma_d1 <= hsync_chroma;
    vsync_chroma_d1 <= vsync_chroma;
    vsync_chroma_d2 <= vsync_chroma_d1;
    vsync_chroma_d3 <= vsync_chroma_d2;
    vsync_chroma_d4 <= vsync_chroma_d3;
  end
end

wire hsync_falling_edge = ~hsync_chroma & hsync_chroma_d1;
wire hsync_rise_edge    = hsync_chroma  & ~hsync_chroma_d1;
wire vsync_rise_edge = vsync_chroma & ~vsync_chroma_d1;

//DUT instance
bl_chroma_suppression dut_chroma
(
  .clk(clk_chroma),
  .rst_n(rst_chroma),
  .vsync_in(vsync_chroma_d1),
  .hsync_in(hsync_chroma_d1),
  .y_in(y_in_d1),
  .uv_in(uv_in_d1)
);
`endif              
