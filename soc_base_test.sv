`ifndef SOC_BASE_TEST
`define SOC_BASE_TEST
`uvm_analysis_imp_decl(_ahb_slave_sys_np)
`uvm_analysis_imp_decl(_ahb_slave_periph_np)
`uvm_analysis_imp_decl(_ahb_slave_sys_ap)
`uvm_analysis_imp_decl(_ahb_slave_periph_ap)

class soc_base_test extends uvm_test;
    `uvm_component_utils(soc_base_test)
    virtual top_chip_if i_top_chip_if;
    
    top_cfg   env_cfg;
    top_env env;
    local bit[7:0]  print_msg_np[$];
    local bit[7:0]  print_msg_ap[$];
    local bit       print_msg_mark_np;
    local bit       print_msg_mark_ap;
    local bit       print_err_msg_mark_np;
    local bit       print_err_msg_mark_ap;
    protected bit   sw_sim_end_mark_np;
    protected bit   sw_sim_end_mark_ap;
    uvm_tlm_analysis_fifo #(ble_mac_transaction)        real_data_fifo;   //store real data 
    uvm_get_peek_port #(ble_mac_transaction)            real_data_port;   //dut send data from monitor

    uvm_analysis_imp_ahb_slave_sys_np#(svt_ahb_slave_transaction, soc_base_test) ahb_slave_write_imp_sys_np;
    uvm_analysis_imp_ahb_slave_sys_ap#(svt_ahb_slave_transaction, soc_base_test) ahb_slave_write_imp_sys_ap;
    uvm_analysis_imp_ahb_slave_periph_np#(svt_ahb_slave_transaction, soc_base_test) ahb_slave_write_imp_periph_np;
    uvm_analysis_imp_ahb_slave_periph_ap#(svt_ahb_slave_transaction, soc_base_test) ahb_slave_write_imp_periph_ap;

    function new(string name = "soc_base_test", uvm_component parent = null );
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        uvm_root root;
        uvm_user_report_server user_report_server;
        super.build_phase(phase);

        print_msg_mark_np = 0;
        print_msg_mark_ap = 0;
        print_err_msg_mark_np = 0;
        print_err_msg_mark_ap = 0;
        sw_sim_end_mark_np = 0;
        sw_sim_end_mark_ap = 0;

        //set user report server
        user_report_server = new();
        uvm_report_server::set_server(user_report_server);
        
        //set timeout
        root = uvm_root::get();
        root.set_timeout(100s, 0);

        //type override
        set_type_override_by_type (svt_ahb_system_env::get_type(),
                                   user_ahb_system_env::get_type());

        set_type_override_by_type ( svt_ahb_slave_monitor::get_type(),
                                   user_ahb_slave_monitor::get_type());


        set_type_override_by_type ( svt_ahb_master_monitor::get_type(),
                                   user_ahb_master_monitor::get_type());

        
        set_type_override_by_type (svt_uart_agent::get_type(),
                                   user_uart_agent::get_type());


        //create components
        env = top_env::type_id::create ("env", this);
        env_cfg = top_cfg::type_id::create("env_cfg");

        ahb_slave_write_imp_sys_np = new("ahb_slave_write_imp_sys_np", this);
        ahb_slave_write_imp_sys_ap = new("ahb_slave_write_imp_sys_ap", this);
        ahb_slave_write_imp_periph_np = new("ahb_slave_write_imp_periph_np", this);
        ahb_slave_write_imp_periph_ap = new("ahb_slave_write_imp_periph_ap", this);

        //get config db
        if(!uvm_config_db#(virtual top_chip_if)::get(this, "", "i_top_chip_if", i_top_chip_if))
            `uvm_fatal(get_type_name(), "can not get i_top_chip_if in test case")

        //set config db
        uvm_config_db#(virtual top_chip_if)::set(this, "env", "i_top_chip_if", i_top_chip_if);
        uvm_config_db#(top_cfg)::set(this, "env", "env_cfg", env_cfg);

        real_data_fifo  = new("real_data_fifo",this);
        real_data_port  = new("real_data_port",this);

    endfunction
    virtual function void connect_phase(uvm_phase phase);
        user_ahb_slave_monitor_callback_tfer ahb_slave_monintor_cb_np_sys;
        user_ahb_slave_monitor_callback_tfer ahb_slave_monintor_cb_ap_sys;
        user_ahb_slave_monitor_callback_tfer ahb_slave_monintor_cb_np_periph;
        user_ahb_slave_monitor_callback_tfer ahb_slave_monintor_cb_ap_periph;
        user_ahb_slave_monitor tmp_monitor;
        super.connect_phase(phase);
        ahb_slave_monintor_cb_np_sys         = user_ahb_slave_monitor_callback_tfer::type_id::create("ahb_slave_monintor_cb_np_sys");
        ahb_slave_monintor_cb_ap_sys         = user_ahb_slave_monitor_callback_tfer::type_id::create("ahb_slave_monintor_cb_ap_sys");
        ahb_slave_monintor_cb_np_periph      = user_ahb_slave_monitor_callback_tfer::type_id::create("ahb_slave_monintor_cb_np_periph");
        ahb_slave_monintor_cb_ap_periph      = user_ahb_slave_monitor_callback_tfer::type_id::create("ahb_slave_monintor_cb_ap_periph");

        svt_ahb_slave_monitor_callback_pool::add(env.ahb_passive_env.slave[SYS_NP].monitor, ahb_slave_monintor_cb_np_sys);
        svt_ahb_slave_monitor_callback_pool::add(env.ahb_passive_env.slave[SYS_AP].monitor, ahb_slave_monintor_cb_ap_sys);
        svt_ahb_slave_monitor_callback_pool::add(env.ahb_passive_env.slave[PERI_NP].monitor, ahb_slave_monintor_cb_np_periph);
        svt_ahb_slave_monitor_callback_pool::add(env.ahb_passive_env.slave[PERI_AP].monitor, ahb_slave_monintor_cb_ap_periph);
        //connect analysis port
        if (!$cast(tmp_monitor, env.ahb_passive_env.slave[SYS_NP].monitor)) `uvm_fatal(get_type_name(), "monitor caset fail in callback")
        tmp_monitor.ahb_tran_ap.connect(this.ahb_slave_write_imp_sys_np);
        if (!$cast(tmp_monitor, env.ahb_passive_env.slave[SYS_AP].monitor)) `uvm_fatal(get_type_name(), "monitor caset fail in callback")
        tmp_monitor.ahb_tran_ap.connect(this.ahb_slave_write_imp_sys_ap);
        if (!$cast(tmp_monitor, env.ahb_passive_env.slave[PERI_NP].monitor)) `uvm_fatal(get_type_name(), "monitor caset fail in callback")
        tmp_monitor.ahb_tran_ap.connect(this.ahb_slave_write_imp_periph_np);
        if (!$cast(tmp_monitor, env.ahb_passive_env.slave[PERI_AP].monitor)) `uvm_fatal(get_type_name(), "monitor caset fail in callback")
        tmp_monitor.ahb_tran_ap.connect(this.ahb_slave_write_imp_periph_ap);


        env.ble_mac_agt.monitor.rx_put_port.connect(real_data_fifo.blocking_put_export);
        real_data_port.connect(real_data_fifo.get_peek_export);
    endfunction
    virtual function void write_ahb_slave_sys_np(svt_ahb_slave_transaction xact);
       //if (xact.xact_type == svt_ahb_transaction::WRITE) $display("debug_e21_sys %x, w, %x, %t",xact.beat_addr, xact.data[xact.current_data_beat_num], $time );
       //if (xact.xact_type == svt_ahb_transaction::READ)  $display("debug_e21_sys %x, r, %x, %t",xact.beat_addr, xact.data[xact.current_data_beat_num], $time );
        if (xact.xact_type == svt_ahb_transaction::WRITE) begin
            case (xact.beat_addr) inside
                `MSG_PRINT_MARK_ADR_NP:begin
                    if (xact.data[xact.current_data_beat_num] == `MSG_PRINT_MSG_MARK) 
                        print_msg_mark_np = 1;
                     else if (xact.data[xact.current_data_beat_num] == `MSG_PRINT_ERR_MSG_MARK) 
                        print_err_msg_mark_np = 1;
                     else 
                        `uvm_fatal(get_type_name(), $sformatf("sw print msg mark not correct! val is %h", xact.data[xact.current_data_beat_num]))
                end
                [`MSG_PRINT_MSG_ADR_NP : `MSG_PRINT_MSG_ADR_NP + `MSG_PRINT_MSG_LEN - 4] : begin
                    if ((xact.data[xact.current_data_beat_num][7  : 0] != 8'h00)&&(xact.data[xact.current_data_beat_num][7  :  0] !=8'h0A)) print_msg_np.push_back(xact.data[xact.current_data_beat_num][7  : 0]);
                    if ((xact.data[xact.current_data_beat_num][15 : 8] != 8'h00)&&(xact.data[xact.current_data_beat_num][15 :  8] !=8'h0A)) print_msg_np.push_back(xact.data[xact.current_data_beat_num][15 : 8]);
                    if ((xact.data[xact.current_data_beat_num][23 :16] != 8'h00)&&(xact.data[xact.current_data_beat_num][23 : 16] !=8'h0A)) print_msg_np.push_back(xact.data[xact.current_data_beat_num][23 :16]);
                    if ((xact.data[xact.current_data_beat_num][31 :24] != 8'h00)&&(xact.data[xact.current_data_beat_num][31 : 24] !=8'h0A)) print_msg_np.push_back(xact.data[xact.current_data_beat_num][31 :24]);
                end
                `MSG_PRINT_END_MARK_ADR_NP:begin
                      if (xact.data[xact.current_data_beat_num] == `MSG_PRINT_MSG_END_MARK)  begin
                           display_print_np();
                      end
                      else 
                          `uvm_fatal(get_type_name(), $sformatf("np sw print msg end mark not correct! val is %h", xact.data[xact.current_data_beat_num]))
                end
                `SIM_END_MARK_ADR_NP:begin
                     sw_sim_end_mark_np = 1; 
                end
            endcase
        end
    endfunction
    virtual function void write_ahb_slave_periph_np(svt_ahb_slave_transaction xact);
       //if (xact.xact_type == svt_ahb_transaction::WRITE) $display("debug_e21_periph %x, w, %x, %t",xact.beat_addr, xact.data[xact.current_data_beat_num], $time );
       //if (xact.xact_type == svt_ahb_transaction::READ)  $display("debug_e21_periph %x, r, %x, %t",xact.beat_addr, xact.data[xact.current_data_beat_num], $time );
    endfunction
    virtual function void write_ahb_slave_sys_ap(svt_ahb_slave_transaction xact);
        if (xact.xact_type == svt_ahb_transaction::WRITE) begin
            case (xact.beat_addr) inside
                `MSG_PRINT_MARK_ADR_AP:begin
                    if (xact.data[xact.current_data_beat_num] == `MSG_PRINT_MSG_MARK) 
                        print_msg_mark_ap = 1;
                     else if (xact.data[xact.current_data_beat_num] == `MSG_PRINT_ERR_MSG_MARK) 
                        print_err_msg_mark_ap = 1;
                     else 
                        `uvm_fatal(get_type_name(), $sformatf("sw print msg mark not correct! val is %h", xact.data[xact.current_data_beat_num]))
                end
                [`MSG_PRINT_MSG_ADR_AP : `MSG_PRINT_MSG_ADR_AP + `MSG_PRINT_MSG_LEN - 4] : begin
                    if ((xact.data[xact.current_data_beat_num][7  : 0] != 8'h00)&&(xact.data[xact.current_data_beat_num][7  :  0] !=8'h0A)) print_msg_ap.push_back(xact.data[xact.current_data_beat_num][7  : 0]);
                    if ((xact.data[xact.current_data_beat_num][15 : 8] != 8'h00)&&(xact.data[xact.current_data_beat_num][15 :  8] !=8'h0A)) print_msg_ap.push_back(xact.data[xact.current_data_beat_num][15 : 8]);
                    if ((xact.data[xact.current_data_beat_num][23 :16] != 8'h00)&&(xact.data[xact.current_data_beat_num][23 : 16] !=8'h0A)) print_msg_ap.push_back(xact.data[xact.current_data_beat_num][23 :16]);
                    if ((xact.data[xact.current_data_beat_num][31 :24] != 8'h00)&&(xact.data[xact.current_data_beat_num][31 : 24] !=8'h0A)) print_msg_ap.push_back(xact.data[xact.current_data_beat_num][31 :24]);
                end
                `MSG_PRINT_END_MARK_ADR_AP:begin
                      if (xact.data[xact.current_data_beat_num] == `MSG_PRINT_MSG_END_MARK)  begin
                           display_print_ap();
                      end
                      else 
                          `uvm_fatal(get_type_name(), $sformatf("ap sw print msg end mark not correct! val is %h", xact.data[xact.current_data_beat_num]))
                end
                `SIM_END_MARK_ADR_AP:begin
                     sw_sim_end_mark_ap = 1; 
                end
            endcase
        end
    endfunction
    virtual function void write_ahb_slave_periph_ap(svt_ahb_slave_transaction xact);
    endfunction

    local virtual function void display_print_np();
        string tmp_print_msg;
        int msg_size;
        msg_size = print_msg_np.size();
        for (int i = 0; i < msg_size; i++) begin
             tmp_print_msg = {tmp_print_msg, $sformatf("%s", print_msg_np.pop_front())};
        end
        if (print_msg_mark_np) begin
            `uvm_info("PRINT_NP", tmp_print_msg, UVM_LOW)
            print_msg_mark_np = 0;
        end
        if (print_err_msg_mark_np) begin
            `uvm_error("PRINT_NP", tmp_print_msg)
            print_err_msg_mark_np = 0;
        end
    endfunction
    local virtual function void display_print_ap();
        string tmp_print_msg;
        int msg_size;
        msg_size = print_msg_ap.size();
        for (int i = 0; i < msg_size; i++) begin
             tmp_print_msg = {tmp_print_msg, $sformatf("%s", print_msg_ap.pop_front())};
        end
        if (print_msg_mark_np) begin
            `uvm_info("PRINT_AP", tmp_print_msg, UVM_LOW)
            print_msg_mark_np = 0;
        end
        if (print_err_msg_mark_np) begin
            `uvm_error("PRINT_AP", tmp_print_msg)
            print_err_msg_mark_np = 0;
        end
    endfunction

    virtual task switch_cpu_ap(CPU_SEL_T cpu_sel);
        if(cpu_sel == CPU_NONE) wait (sw_sim_end_mark_ap == 1'b1);
        if(cpu_sel == CPU_E24)  sw_sim_end_mark_ap = 1'b0;
        `TOP_TB.DUT_WRAPPER.cpu_ap_sel = cpu_sel;
        ->`TOP_TB.DUT_WRAPPER.cpu_switch_e_ap;
    endtask
    virtual task switch_cpu_np(CPU_SEL_T cpu_sel);
        if(cpu_sel == CPU_NONE) wait (sw_sim_end_mark_np == 1'b1);
        if(cpu_sel == CPU_E24)  sw_sim_end_mark_np = 1'b0;
        `TOP_TB.DUT_WRAPPER.cpu_np_sel = cpu_sel;
        ->`TOP_TB.DUT_WRAPPER.cpu_switch_e_np;
    endtask
    virtual task mem_init();
        uvm_cmdline_processor cmdline_processor;

        string sw_bin_f_np;
        string sw_bin_f_ap;
        bit[31:0] sw_bin_mem;
        int bin_fl;
        int index_bin;
        for (int i = 0; i < 12288; i++) `OCRAM_SEL_SET(i, 0)
        for (int i = 0; i < 12288; i++) `HSRAM_SEL_SET(i, 0)
        cmdline_processor = uvm_cmdline_processor::get_inst();
        //sw_bin_f = "/proj/soc707/wa/jqin/dv707_a0/top_case/local_interrupts_fix_addr.bin";
        cmdline_processor.get_arg_value("+bin_file_np=", sw_bin_f_np);
        bin_fl = $fopen(sw_bin_f_np, "r");
        while (!$feof(bin_fl)) begin
             $fread(sw_bin_mem, bin_fl);
             `OCRAM_SEL_SET(index_bin, { << byte {sw_bin_mem} })
             index_bin++;
        end
        cmdline_processor.get_arg_value("+bin_file_ap=", sw_bin_f_ap);
        bin_fl = $fopen(sw_bin_f_ap, "r");
    endtask
    virtual task reset_phase(uvm_phase phase);
        phase.raise_objection(this);
        super.reset_phase(phase);
        mem_init();
        wait (`DUT_PATH.ext_rst === 0); //wait reset released
        sw_sim_end_mark_ap = 1'b1; //fixme, this code added tempory because not run ap , need fix
        switch_cpu_ap(CPU_NONE);
        switch_cpu_np(CPU_E24);
       //switch_cpu_ap(CPU_NONE);
       //switch_cpu_np(CPU_NONE);
       //switch_cpu_ap(CPU_E24);
       //switch_cpu_np(CPU_E24);
       //switch_cpu_ap(CPU_NONE);
       //switch_cpu_np(CPU_NONE);
        phase.drop_objection(this);
    endtask
    virtual task main_phase(uvm_phase phase);
        zb_mac_transaction  zb_tran;
        ble_mac_transaction ble_tran_tx;
        ble_mac_transaction ble_tran_rx;
        bit packet [];
        
        phase.raise_objection(this);
        super.main_phase(phase);
        phase.phase_done.set_drain_time(this, 0.5us);
        #50us;
        //zb_tran = new();
        //zb_tran.randomize();
        //zb_tran.print();
        //zb_tran.transaction_check();
        //ble_tran_tx = new();
        //ble_tran_rx = new();
        //ble_tran_tx.channel_index = 6'd7;
        //ble_tran_tx.randomize() with    {   //adv_type == AUX_SCAN_RSP;
        //                                    pkt_type == 1;
        //                                    llid == 2'b11;
        //                                    opcode == 8'h14;
        //                                };
        //ble_tran_tx.print();
        //ble_tran_tx.pack(packet);
        //ble_tran_tx.print();
        //ble_tran_rx.channel_index = 6'd37;
        //ble_tran_rx.crc_check_en  = 1'd1;
        //ble_tran_rx.unpack(packet);
        //ble_tran_rx.print();

        phase.drop_objection(this);
    endtask
    virtual task post_main_phase(uvm_phase phase);
        phase.raise_objection(this);
        super.post_main_phase(phase);
       //wait (sw_sim_end_mark_np == 1);
       //wait (sw_sim_end_mark_ap == 1);
        phase.drop_objection(this);
    endtask

endclass
`endif
