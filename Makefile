quote := @
REGRESS := off
REG_TIME := NA
USE_CM4  := on
AP_RUN   := no
FPGA := no
FPGA_SEL := kc705
CASE_NAME := soc_base_test
C_CASE_NAME := hellow
C_CASE_NAME_AP := hellow
FLASH_INIIT_SWITCH := no
UART_PRINT := no
C_CASE_MODULE :=
DVCFG_VAL := NA
USE_BOOT_ROM_HEX := no

WORK_DIR := $(SIM_WORK)

ifeq ($(REGRESS), on)
    WORK_DIR = $(SIM_WORK)/regress/$(REG_TIME)
endif

SF_WINBOND :=on
SIM_ON_XIP :=off
PSRAM_MODE :=x8

C_CMP_DIR = $(WORK_DIR)/c_cmp
C_CPUID ?= np
FSDB_DUMP := on
VPD_DUMP := off
GUI      := off
USR_VCS_CMP_OPT :=
USR_VCS_RUN_OPT :=
SEED := AUTO
seed_val_tmp := 0
seed_val := 0
USER_RUN_DIR := NA
NETLIST := no
NETLIST_PG := no
SDF_SEL := WC1
C_CASE_LABAL := $(C_CASE_NAME).$(C_CASE_NAME_AP)
ifneq ($(USE_CM4), on)
  C_CASE_LABAL = C_CASE_NA
  C_CASE_NAME = dummy
  C_CASE_NAME_AP = dummy
else
  ifeq ($(AP_RUN), yes)
      C_CASE_LABAL := $(C_CASE_NAME).$(C_CASE_NAME_AP)
  else
      C_CASE_NAME_AP = dummy
      C_CASE_LABAL := $(C_CASE_NAME)
  endif
endif

ifeq ($(FPGA), yes)
  CMP_LABL_NAME = fpga_$(FPGA_SEL)_soc_sim_cmp
  SIM_LABL_NAME = fpga_$(FPGA_SEL)_soc_sim_run
else
ifeq ($(NETLIST), no)
  CMP_LABL_NAME = soc_sim_cmp
  SIM_LABL_NAME = soc_sim_run
else
  CMP_LABL_NAME = soc_sim_cmp_netlist
  SIM_LABL_NAME = soc_sim_run_netlist
endif
endif

CMP_DIR := $(WORK_DIR)/$(CMP_LABL_NAME).cm4_$(USE_CM4)

ifneq ($(USER_RUN_DIR), NA)
  RUN_DIR := $(WORK_DIR)/$(SIM_LABL_NAME).$(CASE_NAME).$(C_CASE_LABAL).cm4_$(USE_CM4).$(USER_RUN_DIR)
else
  RUN_DIR := $(WORK_DIR)/$(SIM_LABL_NAME).$(CASE_NAME).$(C_CASE_LABAL).cm4_$(USE_CM4)
endif

ifeq ($(SEED), AUTO)
    seed_val_tmp = $(shell head -200 /dev/urandom | cksum | cut -f1 -d " ") #generate random seed 
else
    seed_val_tmp = $(SEED)
endif

ifeq ($(seed_val), 0)
    seed_val = $(seed_val_tmp) 
endif



# general compile options
VCS_CMP_OPT := -full64 -timescale=1ns/1ps -fsdb -Mupdate=1 -Mdir=$(CMP_DIR)/csrc
VCS_RUN_OPT := -l vcs_run.log +UVM_TESTNAME=$(CASE_NAME) +ntb_random_seed=$(seed_val)
VHDLAN_OPT  := 
VLOGAN_OPT  := -timescale=1ns/1ps -sverilog -full64 +v2k +define+SIM_SPEEDUP +define+PSRAM_FUNCTIONAL
ifeq ($(NETLIST), no)
VLOGAN_OPT += +nospecify
endif
ifeq ($(FPGA), yes)
    VLOGAN_OPT += +define+FPGA_PROJ
    VLOGAN_OPT += +define+SYN
    VLOGAN_OPT += +define+GENERIC_BEHAV
    VLOGAN_OPT += +define+FPGA
    ifeq ($(FPGA_SEL), kc705)
      VLOGAN_OPT += +define+FPGA_KC705
    endif
    ifeq ($(FPGA_SEL), xcvu9p)
      VLOGAN_OPT += +define+FPGA_XCVU9P
    endif
    ifeq ($(FPGA_SEL), ceva)
      VLOGAN_OPT += +define+FPGA_CEVA
    endif
    ifeq ($(FPGA_SEL), t1)
      VLOGAN_OPT += +define+FPGA_T1
    endif
endif
ifeq ($(USE_CM4), on)
    VLOGAN_OPT += +define+USE_CM4_SW
endif
ifeq ($(USE_CM4), trustzone)
    VLOGAN_OPT += +define+USE_TRUSTZONE
endif


ifeq ($(PSRAM_MODE), x8)
    VCS_RUN_OPT += +psram_mode=psramx8
    ifeq ($(NETLIST), yes)
        VLOGAN_OPT += +define+PSRAM_MODE_X8
    endif
else
     ifeq ($(PSRAM_MODE), opi)
       VCS_RUN_OPT += +psram_mode=psramopi
       ifeq ($(NETLIST), yes)
           VLOGAN_OPT += +define+PSRAM_MODE_OPI
       endif
     else
       VCS_RUN_OPT += +psram_mode=psramx8
       ifeq ($(NETLIST), yes)
           VLOGAN_OPT += +define+PSRAM_MODE_X8
       endif
    endif
endif

ifeq ($(NETLIST), no)
    VLOGAN_OPT += +define+SEC_ENG_TRNG_SIM #let sec eng trng osc work to gen clk in rtl, not need this macro in netlist sim with sdf
endif
ifeq ($(NETLIST), yes)
    VLOGAN_OPT += +define+SYN +define+PRE_POST_SIM +define+SDF_$(SDF_SEL)
    ifeq ($(NETLIST_PG), no)
        VLOGAN_OPT += +define+POSTSIM_NOPG
    endif
    VCS_RUN_OPT += -ucli -do $(SIM_ROOT)/top_soc_tb/soc606_a0_tb/common/async_ff_no_timing_dv.cmd 
endif
#wave form compile options
ifeq ($(SF_WINBOND), on)
    VLOGAN_OPT += +define+SF_WINBOND
    VLOGAN_OPT += +define+SF_SPEED_UP
endif
ifeq ($(GUI), on)
    VCS_CMP_OPT += -debug_all
    VCS_RUN_OPT += -gui
    VLOGAN_OPT += -debug_all
endif


#Denali vip compile option setup
#VCS_CMP_OPT += +vcs+lic+wait \
#              -Mupdate=1 +vpi -ucli -LDFLAGS -Wl,-E \
#              -P $(CDN_VIP_ROOT)/specman/src/pli.tab \
#              -top specman -top specman_wave \
#              +define+DENALI_SV_VCS -lca -ntb_opts svp \
#              -CFLAGS '-DDENALI_SV_VCS=1 -I../ -I/usr/local/include -I$(DENALI) -I$(DENALI)/ddvapi -O2 -c' \
#              -CFLAGS '-DCDN_UVC_USING_INTELLIGEN -DDSN_USE_DYNAMIC_C_INTERFACE' \
#              -P $(DENALI)/verilog/pli.tab -LDFLAGS '-rdynamic $(DENALI)/verilog/libdenver.so' \
#              -LDFLAGS '-rdynamic $(DENALI)/lib/libviputil.so' H
#              -LDFLAGS '-rdynamic $(CDN_VIP_LIB_PATH)/libsn_uvc.so' \
#              +incdir+$(DENALI)/ddvapi/sv 

#user defined comile option
#VCS_CMP_OPT += $(USR_VCS_CMP_OPT)
VHDLAN_OPT  += $(USR_VCS_CMP_OPT)
VLOGAN_OPT  += $(USR_VCS_CMP_OPT)
VCS_CMP_OPT += -top top_soc_tb  
ifeq ($(FPGA), yes)
    VCS_CMP_OPT += -top glbl
endif

VHDL_CMP_LST := -f $(SIM_RTL_A0)/CHIPTOP_11n_vhdl.f
ifeq ($(FPGA), yes)
    VLOG_CMP_LST := -f $(SIM_RTL_A0)/../../FPGA_soc606_a0/fpga_lib.f \
                    $(XILINX_VIVADO)/verilog/src/glbl.v \
                    -f $(SIM_RTL_A0)/rtl.f -ssv \
                    $(SIM_RTL_A0)/../empty/wifi_top_empty.v \
                    -f $(SIM_RTL_A0)/../../wifi_top/sim/rtl.f \
                    -f $(SIM_RTL_A0)/../../common/rtl_lib/rtl_lib.f \
                    -f $(SIM_RTL_A0)/../../common/macro_lib.f \
                    -f $(SIM_TOP_SOC606_A0_TB)/top_soc_tb_list
else
ifeq ($(NETLIST), no)
    VLOG_CMP_LST := -f $(SIM_RTL_A0)/rtl.f -ssv \
                    $(SIM_RTL_A0)/../empty/wifi_top_empty.v \
                    -f $(SIM_RTL_A0)/../../wifi_top/sim/rtl.f \
                    -f $(SIM_RTL_A0)/../../common/rtl_lib/rtl_lib.f \
                    -f $(SIM_RTL_A0)/../../common/macro_lib.f \
                    -f $(SIM_TOP_SOC606_A0_TB)/top_soc_tb_list
else
    VLOG_CMP_LST := -f $(SIM_RTL_A0)/../../common/macro_lib.f \
                       $(SIM_RTL_A0)/../../common/rtl_lib/handcode_mux_2.v \
                       $(SIM_RTL_A0)/../../common/rtl_lib/clk_inv.v \
                       $(SIM_ROOT)/common/dv_lib/umc40/uk40lsclp11l7bh_sdf21.v \
                       $(SIM_ROOT)/common/dv_lib/umc40/uk40lsclp11bdl_sdf21.v \
                    -f $(SIM_RTL_A0)/post.f \
                    -f $(SIM_TOP_SOC606_A0_TB)/top_soc_tb_list
endif
endif

#denali vip simumation option
#VCS_RUN_OPT := +vcs+lic+wait -ucli -i inp_viprun.vcs

#user defined simuation option
VCS_RUN_OPT += $(USR_VCS_RUN_OPT) +c_case_bin_np=$(C_CMP_DIR)/DVTest/dvtest_$(C_CASE_NAME)_np.bin +c_case_bin_ap=$(C_CMP_DIR)/DVTest/dvtest_$(C_CASE_NAME_AP)_ap.bin +boot_rom_np_bin=$(C_CMP_DIR)/DVTest/dvtest_bootrom_np.bin +boot_rom_ap_bin=$(C_CMP_DIR)/DVTest/dvtest_bootrom_ap.bin +DVCFG_VAL=$(DVCFG_VAL) 
ifeq ($(USE_BOOT_ROM_HEX), yes)
  VCS_RUN_OPT += +boot_rom0_hex=$(SIM_WORK)/bootrom_release/bootrom_img_rom0.hex
  VCS_RUN_OPT += +boot_rom1_hex=$(SIM_WORK)/bootrom_release/bootrom_img_rom1.hex
  VCS_RUN_OPT += +efuse0_bin=$(SIM_WORK)/bootrom_release/efuse0.bin
  VCS_RUN_OPT += +efuse1_bin=$(SIM_WORK)/bootrom_release/efuse1.bin
else
  VCS_RUN_OPT += +boot_rom0_hex=NA
  VCS_RUN_OPT += +boot_rom1_hex=NA
  VCS_RUN_OPT += +efuse0_bin=NA
  VCS_RUN_OPT += +efuse1_bin=NA
endif
ifeq ($(SIM_ON_XIP), on)
  VCS_RUN_OPT += +SIM_ON_XIP=on
else
  VCS_RUN_OPT += +SIM_ON_XIP=off
endif

ifeq ($(FLASH_INIIT_SWITCH), yes)
  VCS_RUN_OPT += +flash_init_switch=yes
  VCS_RUN_OPT +flash_init_bin=$(SIM_ROOT)/top_soc_case/soc606_a0_case/case/flash_init_bin/test.bin
else
  ifeq ($(USE_BOOT_ROM_HEX), yes)
    VCS_RUN_OPT += +flash_init_switch=yes
    VCS_RUN_OPT += +flash_init_bin=$(SIM_WORK)/bootrom_release/flash.bin
  else
    VCS_RUN_OPT += +flash_init_switch=NA
  endif
endif

ifeq ($(AP_RUN), yes)
  VCS_RUN_OPT += +ap_run=yes
else
  VCS_RUN_OPT += +ap_run=no
endif
ifeq ($(UART_PRINT), yes)
  VCS_RUN_OPT += +uart_print=yes
endif
ifeq ($(FSDB_DUMP), on)
  VCS_RUN_OPT += +fsdb_dump=yes
endif
ifeq ($(VPD_DUMP), on)
  VLOGAN_OPT += -assert quiet
  VCS_RUN_OPT += +vcd_dump=yes
endif
   

#uvm dpi so compile command
UVM_DPI_CMP_CMD := gcc -m64 -fPIC -g -w -shared -x c -DVCS -I$(VCS_HOME)/include \
	-I$(SIM_UVM_HOME)/src/dpi -I$(VCS_HOME)/include $(SIM_UVM_HOME)/src/dpi/uvm_dpi.cc -o $(SIM_UVM_DPI_HOME)/uvm_dpi.so 

.PHONY: build_cmp_dir cmp_setup build_run_dir run_setup cmp run clean all clean_all help uvm_dpi verdi c_cmp_dir_build c_cmp c_clean vlog_an vhdl_an run_log vlo_log vhd_log cmp_log

clean:
	$(quote) rm -rf $(CMP_DIR)
	$(quote) rm -rf $(RUN_DIR)
clean_all:
	$(quote) rm -rf $(WORK_DIR)/*
uvm_dpi:
	$(quote) cd $(CMP_DIR) && $(UVM_DPI_CMP_CMD) 

c_cmp_dir_build:
	$(quote) [ -d $(C_CMP_DIR) ] || mkdir -p $(C_CMP_DIR)	
ifeq ($(AP_RUN), yes) 
c_cmp: c_cmp_dir_build
	$(quote) cd $(SIM_C_CASE_SOC) && make objclean TARGET_OUT_PATH=$(C_CMP_DIR) CPU_ID=np BOOTROM=y
	$(quote) cd $(SIM_C_CASE_SOC) && make dvtest TARGET_OUT_PATH=$(C_CMP_DIR) CPU_ID=np BOOTROM=y
	$(quote) cd $(SIM_C_CASE_SOC) && make objclean TARGET_OUT_PATH=$(C_CMP_DIR) CPU_ID=ap BOOTROM=y
	$(quote) cd $(SIM_C_CASE_SOC) && make dvtest TARGET_OUT_PATH=$(C_CMP_DIR) CPU_ID=ap BOOTROM=y
	$(quote) cd $(SIM_C_CASE_SOC) && make objclean TARGET_OUT_PATH=$(C_CMP_DIR) CPU_ID=np TEST_MODULE=$(C_CASE_MODULE)
	$(quote) cd $(SIM_C_CASE_SOC) && make dvtest TARGET_OUT_PATH=$(C_CMP_DIR) CPU_ID=np TEST_MODULE=$(C_CASE_MODULE)
	$(quote) cd $(SIM_C_CASE_SOC) && make objclean TARGET_OUT_PATH=$(C_CMP_DIR) CPU_ID=ap TEST_MODULE=$(C_CASE_MODULE)
	$(quote) cd $(SIM_C_CASE_SOC) && make dvtest TARGET_OUT_PATH=$(C_CMP_DIR) CPU_ID=ap TEST_MODULE=$(C_CASE_MODULE)
else
c_cmp: c_cmp_dir_build
	$(quote) cd $(SIM_C_CASE_SOC) && make objclean TARGET_OUT_PATH=$(C_CMP_DIR) CPU_ID=np BOOTROM=y
	$(quote) cd $(SIM_C_CASE_SOC) && make dvtest TARGET_OUT_PATH=$(C_CMP_DIR) CPU_ID=np BOOTROM=y
	$(quote) cd $(SIM_C_CASE_SOC) && make objclean TARGET_OUT_PATH=$(C_CMP_DIR) CPU_ID=np TEST_MODULE=$(C_CASE_MODULE)
	$(quote) cd $(SIM_C_CASE_SOC) && make dvtest TARGET_OUT_PATH=$(C_CMP_DIR) CPU_ID=np TEST_MODULE=$(C_CASE_MODULE)
endif
c_clean:
	$(quote) cd $(SIM_C_CASE_SOC) && make clean TARGET_OUT_PATH=$(C_CMP_DIR) CPU_ID=np
	$(quote) cd $(SIM_C_CASE_SOC) && make clean TARGET_OUT_PATH=$(C_CMP_DIR) CPU_ID=ap
build_cmp_dir:
	$(quote) [ -d $(CMP_DIR) ] || mkdir -p $(CMP_DIR)	
cmp_setup: build_cmp_dir
	$(quote) cd $(CMP_DIR) && rm -rf synopsys_sim.setup && ln -s $(SIM_ROOT)/common/dv_lib/vcs_elba/synopsys_sim.setup .
vlog_an:cmp_setup
	$(quote) cd $(CMP_DIR) && vlogan $(VLOGAN_OPT) $(VLOG_CMP_LST) -l vlogan.log 
vhdl_an:cmp_setup
	$(quote) cd $(CMP_DIR) && vhdlan $(VHDLAN_OPT) $(VHDL_CMP_LST) -l vhdlan.log
cmp: vlog_an 
	$(quote) cd $(CMP_DIR) && vcs  $(VCS_CMP_OPT) $(SIM_UVM_DPI_HOME)/uvm_dpi.so  -l vcs_cmp.log
build_run_dir:
	$(quote) [ -d $(RUN_DIR) ] || mkdir -p $(RUN_DIR)

run_setup: build_run_dir
	$(quote) cd $(RUN_DIR) && rm -rf simv* && ln -s $(CMP_DIR)/simv* .
run: run_setup 
	$(quote) cd $(RUN_DIR) && ./simv $(VCS_RUN_OPT) && echo "$(VCS_RUN_OPT)" >> sim_run_opts 
run_log:
	$(quote) cd $(RUN_DIR) && gvim vcs_run.log
vlo_log:
	$(quote) cd $(CMP_DIR) && gvim vlogan.log
vhd_log:
	$(quote) cd $(CMP_DIR) && gvim vhdlan.log
cmp_log:
	$(quote) cd $(CMP_DIR) && gvim vcs_cmp.log
verdi:build_run_dir
	$(quote) cd $(RUN_DIR) && verdi   $(VLOG_CMP_LST)   $(VLOGAN_OPT)  -top top_soc_tb -ssy -ssf top.fsdb &
all: c_cmp cmp run

help:
	$(quote) echo "  ======================================================================================================="
	$(quote) echo "  ||make target name and usage"
	$(quote) echo "  ||help                     show this message"
	$(quote) echo "  ||build_cmp_dir            create compile directory for test case "
	$(quote) echo "  ||build_run_dir            create run directory for test case "
	$(quote) echo "  ||cmp                      compile test bench"
	$(quote) echo "  ||c_cmp                    compile c test cases"
	$(quote) echo "  ||run                      run simulation for case specified by case_name"
	$(quote) echo "  ||all                      compile sv and C and run simulation for case specified by case_name"
	$(quote) echo "  ||verdi                    lauch verdi to view waveform and trace signal"
	$(quote) echo "  ||uvm_dpi                  generate uvm_dpi so file, only needed when uvm version update should"
	$(quote) echo "  ||c_clean                  delete C compile files"
	$(quote) echo "  ||clean                    remove compile and simulation directory for case specified by case_name"
	$(quote) echo "  ||clean_all                remove all cases's compile and simulation directories"
	$(quote) echo "  ||REGRESS=on/off           to specify whether run regress"
	$(quote) echo "  ||FPGA=yes/no              to specify whether for fpga simulation "
	$(quote) echo "  ||FPGA_SEL=kc705/xcvu9p/ceva/t1 to specify fpga proj type"
	$(quote) echo "  ||GUI=on/off               to specify whether use debug mode for compile and simulation"
	$(quote) echo "  ||USE_CM4=on/off/trustzone to specify whether use CM4 to run c test, default is on"
	$(quote) echo "  ||CASE_NAME=xxx            to specify case you want to run, default is soc_base_test"
	$(quote) echo "  ||AP_RUN=yes/no            to specify whether use run c case in ap, default is no"
	$(quote) echo "  ||UART_PRINT=yes/no        to specify whether use uart to print msg"
	$(quote) echo "  ||DVCFG_VAL=xxxxx          to specify dvcfg val hex val"
	$(quote) echo "  ||C_CASE_NAME=xxx          to specify case you want to run on np, default is hellow"
	$(quote) echo "  ||C_CASE_NAME_AP=xxx       to specify case you want to run on al, default is hellow"
	$(quote) echo "  ||FSDB_DUMP=on/off         to specify whether dump fsdb waveform file, default is on"
	$(quote) echo "  ||VPD_DUMP=on/off          to specify whether dump vpd waveform file, default is off"
	$(quote) echo "  ||USR_VCS_CMP_OPT=xxx      to specify user needed compile options"
	$(quote) echo "  ||USR_VCS_RUN_OPT=xxx      to specify user needed simulation options"
	$(quote) echo "  ||SF_WINBOND=on/off        to specify use CM4 winbond flash model or mix"
	$(quote) echo "  ||SEED=xxx                 to specify random seed for simulation, otherwise, seed will random"
	$(quote) echo "  ||USER_RUN_DIR=xxx         to specify user specified simulation dir name in run dir"
	$(quote) echo "  ||NETLIST=yes/no           to specify whether use for netlist simulation"
	$(quote) echo "  ||PSRAM_MODE=x16/x8/opi    to specify whether use psram x16 mode x8 mode or opi mode, default not no, defautl use x8"
	$(quote) echo "  ||SIM_ON_XIP=on/off        to specify whether run c case in flash directly"
	$(quote) echo "  ||run_log                  to open the vcs_run.log for simulation"
	$(quote) echo "  ||vlo_log                  to open the vlogan.log for verilog analysis"
	$(quote) echo "  ||cmp_log                  to open the vcs_cmp.log for elabration"
	$(quote) echo "  ||FLASH_INIIT_SWITCH=yes/no to specify whether init flahs using bin file"
	$(quote) echo "  ||USE_BOOT_ROM_HEX=yes/no  to specify whether init boot code hex falsh in efuse bin for boot code simulation"
	$(quote) echo "  ======================================================================================================="

