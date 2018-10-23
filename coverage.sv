`ifndef AP_BMX_FUNC_COV_SV
`define AP_BMX_FUNC_COV_SV
class ap_bmx_func_cov;

    virtual svt_ahb_if i_ahb_active_if;

    function new(virtual svt_ahb_if vif);
		i_ahb_active_if = vif;
	   //covergroup new here
		access_s00_0 = new();
        access_s00_1 = new();

		access_s10_0 = new();
        access_s10_1 = new();

		access_s20_0 = new();
        access_s20_1 = new();

		access_s21_0 = new();
        access_s21_1 = new();
	endfunction

	//covergroup declare here
	
	//***************MASTER 0 1 2 3  access S00
	covergroup access_s00_0 @(posedge i_ahb_active_if.hclk);
		M0: coverpoint {i_ahb_active_if.master_if[0].haddr,i_ahb_active_if.master_if[0].htrans}
			{ wildcard bins m0s00 = {34'b0101_0100_0000_000?_0???_????_????_????_1?};}      //addr: 5400_0000 - 5401_7ffff  trans: 10 or 11
		M1: coverpoint {i_ahb_active_if.master_if[1].haddr,i_ahb_active_if.master_if[1].htrans}
			{ wildcard bins m1s00 = {34'b0101_0100_0000_000?_0???_????_????_????_1?};}      //addr: 5400_0000 - 5401_7ffff  trans: 10 or 11
		M2: coverpoint {i_ahb_active_if.master_if[2].haddr,i_ahb_active_if.master_if[2].htrans}
			{ wildcard bins m2s00 = {34'b0101_0100_0000_000?_0???_????_????_????_1?};}      //addr: 5400_0000 - 5401_7ffff  trans: 10 or 11
		M3: coverpoint {i_ahb_active_if.master_if[3].haddr,i_ahb_active_if.master_if[3].htrans}
			{ wildcard bins m3s00 = {34'b0101_0100_0000_000?_0???_????_????_????_1?};}      //addr: 5400_0000 - 5401_7ffff  trans: 10 or 11
		cross M0,M1,M2,M3;
	endgroup
	covergroup access_s00_1 @(posedge i_ahb_active_if.hclk);
		M0: coverpoint {i_ahb_active_if.master_if[0].haddr,i_ahb_active_if.master_if[0].htrans}
			{ wildcard bins m0s00 = {34'b0010_1100_0000_000?_0???_????_????_????_1?};}      //addr: 2c00_0000 - 2c01_7ffff  trans: 10 or 11
		M1: coverpoint {i_ahb_active_if.master_if[1].haddr,i_ahb_active_if.master_if[1].htrans}
			{ wildcard bins m1s00 = {34'b0010_1100_0000_000?_0???_????_????_????_1?};}      //addr: 2c00_0000 - 2c01_7ffff  trans: 10 or 11
		M2: coverpoint {i_ahb_active_if.master_if[2].haddr,i_ahb_active_if.master_if[2].htrans}
			{ wildcard bins m2s00 = {34'b0010_1100_0000_000?_0???_????_????_????_1?};}      //addr: 2c00_0000 - 2c01_7ffff  trans: 10 or 11
		M3: coverpoint {i_ahb_active_if.master_if[3].haddr,i_ahb_active_if.master_if[3].htrans}
			{ wildcard bins m3s00 = {34'b0010_1100_0000_000?_0???_????_????_????_1?};}      //addr: 2c00_0000 - 2c01_7ffff  trans: 10 or 11
		cross M0,M1,M2,M3;
	endgroup

    //**************MASTER 0 1 2 3 access S10
	covergroup access_s10_0 @(posedge i_ahb_active_if.hclk);
		M0: coverpoint {i_ahb_active_if.master_if[0].haddr,i_ahb_active_if.master_if[0].htrans}
			{ wildcard bins m0s10 = {34'b0101_0101_????_????_????_????_????_????_1?};}      //addr: 5500_0000 - 55ff_fffff  trans: 10 or 11
		M1: coverpoint {i_ahb_active_if.master_if[1].haddr,i_ahb_active_if.master_if[1].htrans}
			{ wildcard bins m1s10 = {34'b0101_0101_????_????_????_????_????_????_1?};}      //addr: 5500_0000 - 55ff_fffff  trans: 10 or 11
		M2: coverpoint {i_ahb_active_if.master_if[2].haddr,i_ahb_active_if.master_if[2].htrans}
			{ wildcard bins m2s10 = {34'b0101_0101_????_????_????_????_????_????_1?};}      //addr: 5500_0000 - 55ff_fffff  trans: 10 or 11
		M3: coverpoint {i_ahb_active_if.master_if[3].haddr,i_ahb_active_if.master_if[3].htrans}
			{ wildcard bins m3s10 = {34'b0101_0101_????_????_????_????_????_????_1?};}      //addr: 5500_0000 - 55ff_fffff  trans: 10 or 11
		cross M0,M1,M2,M3;
	endgroup
	covergroup access_s10_1 @(posedge i_ahb_active_if.hclk);
		M0: coverpoint {i_ahb_active_if.master_if[0].haddr,i_ahb_active_if.master_if[0].htrans}
			{ wildcard bins m0s10 = {34'b0010_1101_????_????_????_????_????_????_1?};}      //addr: 2d00_0000 - 2dff_fffff  trans: 10 or 11
		M1: coverpoint {i_ahb_active_if.master_if[1].haddr,i_ahb_active_if.master_if[1].htrans}
			{ wildcard bins m1s10 = {34'b0010_1101_????_????_????_????_????_????_1?};}      //addr: 2d00_0000 - 2dff_fffff  trans: 10 or 11
		M2: coverpoint {i_ahb_active_if.master_if[2].haddr,i_ahb_active_if.master_if[2].htrans}
			{ wildcard bins m2s10 = {34'b0010_1101_????_????_????_????_????_????_1?};}      //addr: 2d00_0000 - 2dff_fffff  trans: 10 or 11
		M3: coverpoint {i_ahb_active_if.master_if[3].haddr,i_ahb_active_if.master_if[3].htrans}
			{ wildcard bins m3s10 = {34'b0010_1101_????_????_????_????_????_????_1?};}      //addr: 2d00_0000 - 2dff_fffff  trans: 10 or 11
		cross M0,M1,M2,M3;
	endgroup

	//**************MASTER 0 1 2 3 access S20
	covergroup access_s20_0 @(posedge i_ahb_active_if.hclk);
		M0: coverpoint {i_ahb_active_if.master_if[0].haddr,i_ahb_active_if.master_if[0].htrans}
			{ wildcard bins m0s20 = {34'b0010_0000_????_????_????_????_????_????_1?};}      //addr: 2000_0000 - 20ff_fffff  trans: 10 or 11
		M1: coverpoint {i_ahb_active_if.master_if[1].haddr,i_ahb_active_if.master_if[1].htrans}
			{ wildcard bins m1s20 = {34'b0010_0000_????_????_????_????_????_????_1?};}      //addr: 2000_0000 - 20ff_fffff  trans: 10 or 11
		//M2: coverpoint {i_ahb_active_if.master_if[2].haddr,i_ahb_active_if.master_if[2].htrans}
		//	{ wildcard bins m2s20 = {34'b0010_0000_????_????_????_????_????_????_1?};}      //addr: 2000_0000 - 20ff_fffff  trans: 10 or 11
		M3: coverpoint {i_ahb_active_if.master_if[3].haddr,i_ahb_active_if.master_if[3].htrans}
			{ wildcard bins m3s20 = {34'b0010_0000_????_????_????_????_????_????_1?};}      //addr: 2000_0000 - 20ff_fffff  trans: 10 or 11
		cross M0,M1,M3;
	endgroup
	covergroup access_s20_1 @(posedge i_ahb_active_if.hclk);
		M0: coverpoint {i_ahb_active_if.master_if[0].haddr,i_ahb_active_if.master_if[0].htrans}
			{ wildcard bins m0s20 = {34'b0011_0000_????_????_????_????_????_????_1?};}      //addr: 3000_0000 - 30ff_fffff  trans: 10 or 11
		M1: coverpoint {i_ahb_active_if.master_if[1].haddr,i_ahb_active_if.master_if[1].htrans}
			{ wildcard bins m1s20 = {34'b0011_0000_????_????_????_????_????_????_1?};}      //addr: 3000_0000 - 30ff_fffff  trans: 10 or 11
		//M2: coverpoint {i_ahb_active_if.master_if[2].haddr,i_ahb_active_if.master_if[2].htrans}
		//	{ wildcard bins m2s20 = {34'b0011_0000_????_????_????_????_????_????_1?};}      //addr: 3000_0000 - 30ff_fffff  trans: 10 or 11
		M3: coverpoint {i_ahb_active_if.master_if[3].haddr,i_ahb_active_if.master_if[3].htrans}
			{ wildcard bins m3s20 = {34'b0011_0000_????_????_????_????_????_????_1?};}      //addr: 3000_0000 - 30ff_fffff  trans: 10 or 11
		cross M0,M1,M3;
	endgroup

	//**************MASTER 0 1 2 3 access S21
	covergroup access_s21_0 @(posedge i_ahb_active_if.hclk);
		M0: coverpoint {i_ahb_active_if.master_if[0].haddr,i_ahb_active_if.master_if[0].htrans}
			{ wildcard bins m0s21 = {34'b0101_0110_????_????_????_????_????_????_1?};}      //addr: 5600_0000 - 56ff_fffff  trans: 10 or 11
		M1: coverpoint {i_ahb_active_if.master_if[1].haddr,i_ahb_active_if.master_if[1].htrans}
			{ wildcard bins m1s21 = {34'b0101_0110_????_????_????_????_????_????_1?};}      //addr: 5600_0000 - 56ff_fffff  trans: 10 or 11
		//M2: coverpoint {i_ahb_active_if.master_if[2].haddr,i_ahb_active_if.master_if[2].htrans}
		//	{ wildcard bins m2s21 = {34'b0101_0110_????_????_????_????_????_????_1?};}      //addr: 5600_0000 - 56ff_fffff  trans: 10 or 11
		M3: coverpoint {i_ahb_active_if.master_if[3].haddr,i_ahb_active_if.master_if[3].htrans}
			{ wildcard bins m3s21 = {34'b0101_0110_????_????_????_????_????_????_1?};}      //addr: 5600_0000 - 56ff_fffff  trans: 10 or 11
		cross M0,M1,M3;
	endgroup
	covergroup access_s21_1 @(posedge i_ahb_active_if.hclk);
		M0: coverpoint {i_ahb_active_if.master_if[0].haddr,i_ahb_active_if.master_if[0].htrans}
			{ wildcard bins m0s21 = {34'b0010_1110_????_????_????_????_????_????_1?};}      //addr: 2e00_0000 - 2eff_fffff  trans: 10 or 11
		M1: coverpoint {i_ahb_active_if.master_if[1].haddr,i_ahb_active_if.master_if[1].htrans}
			{ wildcard bins m1s21 = {34'b0010_1110_????_????_????_????_????_????_1?};}      //addr: 2e00_0000 - 2eff_fffff  trans: 10 or 11
		//M2: coverpoint {i_ahb_active_if.master_if[2].haddr,i_ahb_active_if.master_if[2].htrans}
		//	{ wildcard bins m2s21 = {34'b0010_1110_????_????_????_????_????_????_1?};}      //addr: 2e00_0000 - 2eff_fffff  trans: 10 or 11
		M3: coverpoint {i_ahb_active_if.master_if[3].haddr,i_ahb_active_if.master_if[3].htrans}
			{ wildcard bins m3s21 = {34'b0010_1110_????_????_????_????_????_????_1?};}      //addr: 2e00_0000 - 2eff_fffff  trans: 10 or 11
		cross M0,M1,M3;
	endgroup




endclass
`endif


`ifndef AP_BMX_TOP_ENV_SV
`define AP_BMX_TOP_ENV_SV
class ap_bmx_top_env extends uvm_env;
	`uvm_component_utils(ap_bmx_top_env)
	virtual ap_bmx_top_if i_ap_bmx_top_if;
	svt_ahb_system_env ahb_active_env;
	svt_ahb_system_env ahb_passive_env;
	ap_bmx_cfg            ap_bmx_cfg_t;

    //for function coverage
	ap_bmx_func_cov       ap_bmx_func_cov_t;

	function new(string name = "ap_bmx_top_env",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual ap_bmx_top_if)::get(this,"","i_ap_bmx_top_if",i_ap_bmx_top_if))
			`uvm_fatal(get_type_name(),"can not get i_ap_bmx_top_if in ap_bmx_top_env")
	    if(!uvm_config_db#(ap_bmx_cfg)::get(this,"","ap_bmx_cfg_t",ap_bmx_cfg_t))
			`uvm_fatal(get_type_name(),"can not get ap_bmx_cfg in ap_bmx_top_env")

	    ahb_active_env  = svt_ahb_system_env::type_id::create("ahb_active_env",this);

		ahb_passive_env = svt_ahb_system_env::type_id::create("ahb_passive_env",this);

        //func cov
		ap_bmx_func_cov_t = new(i_ap_bmx_top_if.ahb_active_if);

		uvm_config_db#(svt_ahb_system_configuration)::set(this,"ahb_active_env","cfg",this.ap_bmx_cfg_t.ahb_active_cfg);
		uvm_config_db#(svt_ahb_system_configuration)::set(this,"ahb_passive_env","cfg",this.ap_bmx_cfg_t.ahb_passive_cfg);

		uvm_config_db#(virtual svt_ahb_if)::set(this, "ahb_active_env", "vif", i_ap_bmx_top_if.ahb_active_if);
		uvm_config_db#(virtual svt_ahb_if)::set(this, "ahb_passive_env", "vif", i_ap_bmx_top_if.ahb_passive_if);


	endfunction

endclass
`endif


