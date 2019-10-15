`ifndef CHROMA_MONITOR_SV
`define CHROMA_MONITOR_SV
class chroma_monitor extends uvm_monitor;
    `uvm_component_utils(chroma_monitor)
    virtual chroma_if vif;
    UVM_FILE    monitor_y_dst_log;
    UVM_FILE    monitor_uv_dst_log;
    bit         packet [];
    bit         rx_print_en;   
    int i,j;
    int p,k;
    int x,y;
    function new(string name = "chroma_monitor",uvm_component parent = null);
		super.new(name,parent);
	endfunction
    virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
        rx_print_en                   = 1'h1;
        monitor_y_dst_log             = $fopen("chroma_y_out_dst.log","w"); 
        set_report_severity_id_file(UVM_INFO,"chroma_y_out_dst",monitor_y_dst_log);
        monitor_uv_dst_log            = $fopen("chroma_uv_out_dst.log","w"); 
        set_report_severity_id_file(UVM_INFO,"chroma_uv_out_dst",monitor_uv_dst_log);
        //set_report_id_action("chroma_y_out_dst",UVM_LOG|UVM_DISPLAY);
        set_report_id_action("chroma_y_out_dst",UVM_LOG);
        set_report_id_action("chroma_uv_out_dst",UVM_LOG);
    endfunction


    extern virtual task collect_dst_rx();
    extern virtual task main_phase(uvm_phase phase);
 

endclass
task chroma_monitor :: main_phase(uvm_phase phase);
    super.main_phase(phase);
    fork
        collect_dst_rx();
    join
endtask

task chroma_monitor::collect_dst_rx();

    bit [7:0] tmp_y;
    bit [7:0] tmp_uv;
    forever begin
        #1;
        wait (vif.RX_FLAG == 1'b1);
        if (vif.rx_dst_data_core_en)
        begin
            #1;
            tmp_y  = chroma_y_out_buf[p];
            tmp_uv = chroma_uv_out_buf[p];
            if(vif.out_y_dst != tmp_y || vif.out_uv_dst != tmp_uv)  begin `uvm_error(get_name(),$sformatf("out_y_dst[%d] is %h and exp[%d][%d] is %h \n out_uv_dst[%d] is %h and exp[%d][%d] is %h",p,vif.out_y_dst,p/chroma_img_w,p%chroma_img_w,tmp_y,p,vif.out_uv_dst,p/chroma_img_w,p%chroma_img_w,tmp_uv)); end
            else                    begin 
                `uvm_info("chroma_y_out_dst", $sformatf("out_y_dst[%d]%h and compare with exp pass",p,vif.out_y_dst),UVM_NONE);
                `uvm_info("chroma_uv_out_dst",$sformatf("out_uv_dst[%d]%h and compare with exp pass",p,vif.out_uv_dst),UVM_NONE);
            end
            p++;
        end
        else
        begin
            #1;
        end
        k++;
        @(posedge vif.clk);
        if (p == chroma_img_w*chroma_img_h)
        begin
            `uvm_info("chroma_out_dst",$sformatf("[vsyn]pix_num is %d and compare out_dst with exp pass",p),UVM_NONE);
            p=0;
            uvm_hdl_force("top_soc_tb.i_top_chip_if.chroma_if.RX_FLAG",1'b0);
        end
    end
endtask

`endif
