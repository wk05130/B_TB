`ifndef BLE_MAC_TRANSACTION_SV
`define BLE_MAC_TRANSACTION_SV
class ble_mac_transaction extends uvm_sequence_item;
    //Common packet variables
    bit [5:0] channel_index;
    rand bit enc;
    bit  crc_check_en;
    rand bit [0:7]  preamble;             	// STARTING  OF PACKET
    rand bit [31:0] access_address;        
    rand bit [23:0] crc;
    // Type of packet
    typedef enum {ADV,DATA} bt_pkt_type;
    rand bt_pkt_type pkt_type;     			// data or adv packet.
    
    // Adv Header fields :
    typedef enum  {ADV_IND,ADV_DIRECT_IND,ADV_NONCONN_IND,SCAN_REQ,SCAN_RSP,CONNECT_REQ,ADV_SCAN_IND,AUX_SCAN_REQ,AUX_CONNECT_REQ,ADV_EXT_IND,AUX_ADV_IND,AUX_SCAN_RSP,AUX_SYNC_IND,AUX_CHAIN_IND} adv_pdu_type;
    rand adv_pdu_type adv_type;   // pdu type

    // Type of PHY
    typedef enum {LE_1M,LE_2M} bt_phy_type;
    bt_phy_type phy_type;     	        // LE 1M or adv LE 2M

    
    rand bit [3:0] frm_adv_pdu_type;
    bit duty_cycle_type;
    bit frm_adv_pdu_chsel;  // 0:LE 1M ; 1:LE 2M
 
    bit frm_adv_pdu_tx_add; // Indicates whether source device addr is public or random
    bit frm_adv_pdu_rx_add; // Indicates whether target device addr is public or random
    
    bit [1:0] adv_filter_policy;
    bit [2:0] adv_channel_map;
    
    //bit [5:0] frm_adv_pdu_length; // length field for ADV packets is 6 bits
    rand bit [7:0] frm_adv_pdu_length;      // length field for ADV packets is 8 bits
    // Device Address :
    rand bit [47:0] source_device_addr;   	// To store source device address   // not used in do_pack
    rand bit [47:0] target_device_addr;   	// To store target device address   // not used in do_pack
    rand bit [1:0]  rand_dev_addr_type;   	// For random device address which can be of static type (00)
                                    	    //  Non resolvable private address type(01) or 
    			                            //  Resolvable private address type (10)
    // Advertising PDU fields :
    rand bit [7:0]  frm_adv_data[];
    rand bit [47:0] frm_adv_addr;   	        // To store source device address
    rand bit [47:0] frm_adv_init_add;   	    // To store target device address    // not used in do_pack
    
    // Scanning PDU fields :
    rand    bit [7:0]  frm_scan_rsp_data[];					
    rand    bit [47:0] frm_scan_addr;   	    // To store target device address
    bit scan_type;                              // To show active or passive scanning
    bit [15:0]  scan_interval;
    bit [15:0]  scan_window;
    
    // Connect Pdu fields:
    bit [47:0]  frm_conn_init_add;   	        // To store source device address

    // Common Extended Advertising Payload Format
    rand bit [5:0]   frm_extended_header_length;     //  Extended Header Length
    rand bit [1:0]   frm_advmode;                    //  AdvMode
    //        Extended Header
    rand bit [7:0]   frm_extended_header_flags;      //  Extended Header Flags
    //        RFC
    bit [7:0]        frm_ext_rfc;                    //  RFC
    //        AdvDataInfo
    rand bit [11:0]  frm_DID;                        //  Advertising Data ID
    rand bit [3:0]   frm_SID;                        //  Advertising Set ID
    //        AuxPtr field
    rand bit         frm_ca;                         //  CA
    rand bit         frm_aux_offset_units;               //  Offset Units
    rand bit [12:0]  frm_aux_offset;                 //  AUX Offset
    rand bit [2:0]   frm_aux_phy;                    //  AUX PHY
    //        SyncInfo field
    rand bit [12:0]  frm_sync_packet_offset;         //  Sync Packet Offset
    rand bit         frm_offset_units;               //  Offset Units
    //rand bit [15:0]  frm_interval;                   //  Interval
    rand bit [36:0]  frm_sync_chm;                   //  ChM
    //bit [2:0]  frm_sca;
    //rand bit [31:0] frm_conn_acc_add;       
    //bit [23:0] frm_crc_init;         	             //  CRC initial value
    rand bit [15:0]  frm_event_counter;              //  Event Counter 
    //        TxPower field
    rand bit [7:0]   frm_txpower;                    //  TxPower
    //        ACAD field                             // The length of this field is the Extended Header
                                                     // length minus the sum of the size of the extended header flags (1 octet) and
                                                     // those fields indicated by the flags as present
    rand bit [7:0]   frm_acad_len;                                                    
    rand bit [7:0]   frm_acad[];
    // rand bit [7:0]  frm_adv_data[];
    // ************************************
    // LLDATA Field
    rand bit [31:0] frm_conn_acc_add;       
    bit [23:0] frm_crc_init;         	// CRC initial value for conn_req pkt
    bit [7:0]  frm_bits_q[];            // CRC data value
    rand bit [7:0]  frm_winsize;
    rand bit [15:0] frm_winoffset;
    rand bit [15:0] frm_interval;
    rand bit [15:0] frm_latency;
    rand bit [15:0] frm_timeout;
    rand bit [39:0] frm_chm;
    rand bit [4:0]  frm_hop;
    rand bit [2:0]  frm_sca;

    rand bit [15:0] frm_interval_min;
    rand bit [15:0] frm_interval_max;
    // Rand variable for connection state data pdu
    rand bit [1:0] llid;
    rand bit nesn;
    rand bit sn;
    rand bit md;
    //rand bit [4:0] data_pdu_length;
    rand bit [7:0] data_pdu_length;
    rand bit [7:0] data_payload[];
    rand bit [31:0] mic;

    // Rand variable for connection state control pdu
    rand bit [7:0] 	    opcode;
    rand bit [0:15]     instant;
    rand bit [0:63]     enc_rand;
    rand bit [0:15]     enc_ediv;
    rand bit [0:63]     enc_skd;
    rand bit [0:31]     enc_iv;
    rand bit [0:63]     feature_set_data;
    rand bit [0:7] 	    version_vernr;
    rand bit [0:15]     version_compid;
    rand bit [0:15]     version_sub_vernr;
    rand bit [0:119]    conn_param_offset;
    rand bit [0:7] 	    error_code;
    rand bit [0:7] 	    unknown_reject_opcode;
    rand bit [7:0] 	    tx_phys;
    rand bit [7:0] 	    rx_phys;
    rand bit [7:0] 	    m_to_s_phy;
    rand bit [7:0] 	    s_to_m_phy;
    //rand bit [15:0] 	instant;
    rand bit [7:0] 	    phys;
    rand bit [7:0] 	    minusedchannels;
    rand bit [15:0] 	maxrxoctets;
    rand bit [15:0] 	maxrxtime;
    rand bit [15:0]     maxtxoctets;
    rand bit [15:0] 	maxtxtime;
    // Storing complete header values
    bit [15:0] data_header;
    bit [15:0] adv_header;
    // whether to drive packets when TX = 1 or RX = 1. Based on these bits, in Tx agent driver I will drive the data on posedge of TX_ON or posedge of RX_ON.
    bit tx;
    bit rx;
    bit frame_pkt[];

    `uvm_object_utils(ble_mac_transaction)

    //******************************************************************************
    // constraint
    //******************************************************************************

    // PREAMBLE
    constraint PREAMBLE{
                        if(frm_conn_acc_add[0]==1)
                            preamble==8'b10101010;
    	                else
    	                    preamble==8'b01010101;
    }
    
    // BLE pkt access address
    constraint PKT_ACCESS_ADDRESS { (pkt_type == 0)  -> access_address == 32'h8E89BED6;}
    // adv_type
    //constraint PKT_ADV_TYPE { (pkt_type == 0)  -> adv_type == SCAN_REQ;}
    // Constraint on Advertising address channel PDU (just legacy advertising PDUs,nomore extended advertising PDUs)
    constraint ADV_PDU_TYPE{solve adv_type before frm_adv_pdu_type;
                  (adv_type == ADV_IND)             ->    frm_adv_pdu_type == 4'b0000;    // Adv undirected
    		      (adv_type == ADV_DIRECT_IND)      ->    frm_adv_pdu_type == 4'b0001;    // Adv directed high/low duty cycle
    		      (adv_type == ADV_NONCONN_IND)     ->    frm_adv_pdu_type == 4'b0010;    // Non connectable undirect
                  (adv_type == SCAN_REQ)            ->    frm_adv_pdu_type == 4'b0011;    // Scan req pdu
                  (adv_type == SCAN_RSP)            ->    frm_adv_pdu_type == 4'b0100;    // Scan rsp
                  (adv_type == CONNECT_REQ)         ->    frm_adv_pdu_type == 4'b0101;    // Conn req
    	          (adv_type == ADV_SCAN_IND)        ->    frm_adv_pdu_type == 4'b0110;    // Scannable undirected.
                  (adv_type == AUX_SCAN_REQ)        ->    frm_adv_pdu_type == 4'b0011;    // ADV_SCAN_IND
                  (adv_type == AUX_CONNECT_REQ)     ->    frm_adv_pdu_type == 4'b0101;    // AUX_CONNECT_REQ
                  (adv_type == ADV_EXT_IND)         ->    frm_adv_pdu_type == 4'b0111;    // ADV_EXT_IND
                  (adv_type == AUX_ADV_IND)         ->    frm_adv_pdu_type == 4'b0111;    // AUX_ADV_IND
                  (adv_type == AUX_SCAN_RSP)        ->    frm_adv_pdu_type == 4'b0111;    // AUX_SCAN_IND
                  (adv_type == AUX_SYNC_IND)        ->    frm_adv_pdu_type == 4'b0111;    // AUX_SYNC_IND
                  (adv_type == AUX_CHAIN_IND)       ->    frm_adv_pdu_type == 4'b0111;    // AUX_CHAIN_IND
    		 }
    
    
    // Access Address
    constraint AA{ if(pkt_type == 1) {foreach(frm_conn_acc_add[i])
    	 if(i<27)
    	    ((frm_conn_acc_add[i] && frm_conn_acc_add[i+1] && frm_conn_acc_add[i+2] && frm_conn_acc_add[i+3] && frm_conn_acc_add[i+4] && frm_conn_acc_add[i+5]) != 1);      //No 6 consecutive ones
    
    	 foreach(frm_conn_acc_add[j])
    	  if(j<27)
    	    ((frm_conn_acc_add[j] || frm_conn_acc_add[j+1] || frm_conn_acc_add[j+2] || frm_conn_acc_add[j+3] || frm_conn_acc_add[j+4] || frm_conn_acc_add[j+5]) != 0);      //No 6 consecutive zeroes
    
             frm_conn_acc_add != 32'h8E89BED6;          // Shall not be Advertising packet's Access address.
    
    	     frm_conn_acc_add[31:24] != frm_conn_acc_add[23:16]; frm_conn_acc_add[23:16] != frm_conn_acc_add[15:8]; frm_conn_acc_add[15:8] != frm_conn_acc_add[7:0];       // All 4 octects shall not be same
    
             //$countones(frm_conn_acc_add ^ (32'h8E89BED6))>1;
 
    	     //($countones(frm_conn_acc_add ^ (frm_conn_acc_add*2)) -(1&frm_conn_acc_add[0]))<25; // Shall not have more than 24 transitions
    
             //($countones(frm_conn_acc_add[31:26] ^ (frm_conn_acc_add[31:26]*2))-(1&frm_conn_acc_add[26]))>1; //Shall have a minimum of 2 transitions in most significant six bits
    
                              }
          
         }	
    // Constraint on Random device address
    constraint DEVICE_ADDRESS{ rand_dev_addr_type!=2'b11; solve rand_dev_addr_type before source_device_addr;
            if(frm_adv_pdu_tx_add==1) 
    	    { 
    	     if(rand_dev_addr_type==2'b00) {
              source_device_addr[47:46] ==   2'b11;
              source_device_addr[45:0]  !=   46'h3fffffffffff;
              source_device_addr[45:0]  !=   46'h0;
    	      //$countones(source_device_addr[45:0])!=46;           // Constraint for static random address.
    	      //$countones(source_device_addr[45:0])!=0;
             }
    	     else if(rand_dev_addr_type==2'b01) {
    	      source_device_addr[47:46]==2'b00;                   // Constraint for Non resolvable private address. 
              source_device_addr[45:0]  !=   46'h3fffffffffff;
              source_device_addr[45:0]  !=   46'h0;
    	      //$countones(source_device_addr[45:0])!=46;
    	      //$countones(source_device_addr[45:0])!=0; 
             }
    	    }
    }	
 
    // lenght || frm_advmode ||frm_extended_header_flags || frm_extended_header_length
    constraint ADV_LENGTH{solve adv_type before frm_adv_pdu_length; solve frm_adv_pdu_length before frm_adv_data; 
                          solve frm_adv_pdu_length before frm_scan_rsp_data; solve adv_type before frm_adv_data;
                          solve adv_type before frm_extended_header_flags;solve adv_type before frm_advmode;
                          solve frm_extended_header_flags before frm_extended_header_length;
                          solve frm_acad_len before frm_extended_header_length;
                          solve adv_type before frm_acad_len;
                          if(adv_type==1 || adv_type == 3 || adv_type == AUX_SCAN_REQ)
    		              {
    			             frm_adv_pdu_length == 12;
                             frm_adv_data.size() == 'd0;
    			             frm_scan_rsp_data.size() == 'd0;
    			          }
                          else if(adv_type == CONNECT_REQ || adv_type == AUX_CONNECT_REQ)
    		              {
    			             frm_adv_pdu_length == 'd34;
                             frm_adv_data.size() == 'd0;
    			             frm_scan_rsp_data.size() == 'd0;
    			          }
    	                  else if(adv_type == 0 || adv_type ==2 || adv_type == 4 || adv_type == 6)  
    	                  {
    		                 frm_adv_pdu_length inside {[6:37]};
    		                 frm_adv_data.size() == (frm_adv_pdu_length - 6);
    			             frm_scan_rsp_data.size() == (frm_adv_pdu_length - 6);
    	                  }
                          else if(adv_type == ADV_EXT_IND)
    		              {
    			              frm_advmode inside {[0:2]};
                              if(frm_advmode == 0)
                              { 
                                  frm_extended_header_flags inside{8'b1,8'b1000001, 8'b11000,8'b11001,8'b1011000,8'b1011001, 8'b11,8'b1000011, 8'b11000,8'b11001,8'b11010,8'b11011,8'b1011000,8'b1011001,8'b1011010,8'b1011011};
                                  frm_extended_header_length==    6*frm_extended_header_flags[0]
                                                               +  6*frm_extended_header_flags[1] 
                                                               +  1*frm_extended_header_flags[2] 
                                                               +  2*frm_extended_header_flags[3] 
                                                               +  3*frm_extended_header_flags[4] 
                                                               + 18*frm_extended_header_flags[5] 
                                                               +  1*frm_extended_header_flags[6] 
                                                               +  1;
                              }
                              else if(frm_advmode == 1 ||frm_advmode == 2 )
                              {
                                  frm_extended_header_flags inside{8'b1011000,8'b11000}; 
                                  frm_extended_header_length==    6*frm_extended_header_flags[0]
                                                               +  6*frm_extended_header_flags[1]
                                                               +  1*frm_extended_header_flags[2]
                                                               +  2*frm_extended_header_flags[3]
                                                               +  3*frm_extended_header_flags[4]
                                                               + 18*frm_extended_header_flags[5]
                                                               +  1*frm_extended_header_flags[6]
                                                               +  1;
                              }
                              frm_adv_pdu_length == frm_extended_header_length+1;
                              frm_acad.size() == 'd0;
                              frm_adv_data.size() == 'd0;
    			              frm_scan_rsp_data.size() == 'd0;
    			          }
                          else if(adv_type == AUX_ADV_IND)
    		              {
    			              frm_advmode inside {[0:2]};
                              if(frm_advmode == 0)
                              { 
                                  frm_extended_header_flags[2] == 1'b0;
                                  frm_acad_len dist{0:/50,[1:254]:/50};
                                  frm_extended_header_length==    6*frm_extended_header_flags[0]
                                                               +  6*frm_extended_header_flags[1] 
                                                               +  1*frm_extended_header_flags[2] 
                                                               +  2*frm_extended_header_flags[3] 
                                                               +  3*frm_extended_header_flags[4] 
                                                               + 18*frm_extended_header_flags[5] 
                                                               +  1*frm_extended_header_flags[6] 
                                                               +  1
                                                               +  frm_acad_len;
                                  frm_adv_pdu_length dist {(frm_extended_header_length+1):/50,[frm_extended_header_length+2:255]:/50};
                                  frm_acad.size() == frm_acad_len;
                                  frm_adv_data.size() == frm_adv_pdu_length - frm_extended_header_length-1;
                                  frm_scan_rsp_data.size() == frm_adv_pdu_length - frm_extended_header_length-1;
                              }
                              else if(frm_advmode == 1)
                              {
                                  frm_extended_header_flags[2] == 1'b0;
                                  frm_extended_header_flags[4] == 1'b0;
                                  frm_extended_header_flags[5] == 1'b0;
                                  frm_acad_len dist{0:/50,[1:254]:/50};
                                  frm_extended_header_length==    6*frm_extended_header_flags[0]
                                                               +  6*frm_extended_header_flags[1]
                                                               +  1*frm_extended_header_flags[2]
                                                               +  2*frm_extended_header_flags[3]
                                                               +  3*frm_extended_header_flags[4]
                                                               + 18*frm_extended_header_flags[5]
                                                               +  1*frm_extended_header_flags[6]
                                                               +  1
                                                               +  frm_acad_len;
                                  frm_adv_pdu_length dist {(frm_extended_header_length+1):/50,[frm_extended_header_length+2:255]:/50};
                                  frm_acad.size() == frm_acad_len;
                                  frm_adv_data.size() == frm_adv_pdu_length - frm_extended_header_length-1;
                                  frm_scan_rsp_data.size() == frm_adv_pdu_length - frm_extended_header_length-1;
                              }
                              else if(frm_advmode == 2)
                              {
                                  frm_extended_header_flags[2] == 1'b0;
                                  frm_extended_header_flags[4] == 1'b0;
                                  frm_extended_header_flags[5] == 1'b0;
                                  frm_acad_len dist{0:/50,[1:254]:/50};
                                  frm_extended_header_length==    6*frm_extended_header_flags[0]
                                                               +  6*frm_extended_header_flags[1]
                                                               +  1*frm_extended_header_flags[2]
                                                               +  2*frm_extended_header_flags[3]
                                                               +  3*frm_extended_header_flags[4]
                                                               + 18*frm_extended_header_flags[5]
                                                               +  1*frm_extended_header_flags[6]
                                                               +  1
                                                               +  frm_acad_len;
                                  frm_adv_pdu_length == frm_extended_header_length+1;
                                  frm_acad.size() == frm_acad_len;
                                  frm_adv_data.size() == frm_adv_pdu_length - frm_extended_header_length-1;
                                  frm_scan_rsp_data.size() == frm_adv_pdu_length - frm_extended_header_length-1;
                              }
    			          }
                          else if(adv_type == AUX_SCAN_RSP)
                          {
                              frm_advmode ==0;
                              frm_extended_header_flags[0] == 1'b1;
                              frm_extended_header_flags[1] == 1'b0;
                              frm_extended_header_flags[2] == 1'b0;
                              frm_extended_header_flags[3] == 1'b0;
                              frm_extended_header_flags[5] == 1'b0;
                              frm_acad_len dist{0:/50,[1:254]:/50};
                              frm_extended_header_length==    6*frm_extended_header_flags[0]
                                                           +  6*frm_extended_header_flags[1] 
                                                           +  1*frm_extended_header_flags[2] 
                                                           +  2*frm_extended_header_flags[3] 
                                                           +  3*frm_extended_header_flags[4] 
                                                           + 18*frm_extended_header_flags[5] 
                                                           +  1*frm_extended_header_flags[6] 
                                                           +  1
                                                           +  frm_acad_len;
                              frm_adv_pdu_length inside {[frm_extended_header_length+2:255]};   // frm_adv_data.size >0
                              frm_acad.size() == frm_acad_len;
                              frm_adv_data.size() == frm_adv_pdu_length - frm_extended_header_length-1;
                              frm_scan_rsp_data.size() == frm_adv_pdu_length - frm_extended_header_length-1;
                          }
                          else if(adv_type == AUX_SYNC_IND)
                          {
                              frm_advmode ==0;
                              frm_extended_header_flags[0] == 1'b0;
                              frm_extended_header_flags[1] == 1'b0;
                              frm_extended_header_flags[2] == 1'b0;
                              frm_extended_header_flags[3] == 1'b0;
                              frm_extended_header_flags[5] == 1'b0;
                              frm_acad_len dist{0:/50,[1:254]:/50};
                              frm_extended_header_length==    6*frm_extended_header_flags[0]
                                                           +  6*frm_extended_header_flags[1] 
                                                           +  1*frm_extended_header_flags[2] 
                                                           +  2*frm_extended_header_flags[3] 
                                                           +  3*frm_extended_header_flags[4] 
                                                           + 18*frm_extended_header_flags[5] 
                                                           +  1*frm_extended_header_flags[6] 
                                                           +  1
                                                           +  frm_acad_len;
                              frm_adv_pdu_length dist {(frm_extended_header_length+1):/50,[frm_extended_header_length+2:255]:/50};
                              frm_acad.size() == frm_acad_len;
                              frm_adv_data.size() == frm_adv_pdu_length - frm_extended_header_length-1;
                              frm_scan_rsp_data.size() == frm_adv_pdu_length - frm_extended_header_length-1;
                          }
                          else if(adv_type == AUX_CHAIN_IND)
                          {
                              frm_advmode ==0;
                              frm_extended_header_flags[0] == 1'b0;
                              frm_extended_header_flags[1] == 1'b0;
                              frm_extended_header_flags[2] == 1'b0;
                              frm_extended_header_flags[5] == 1'b0;
                              frm_acad_len == 'd0;
                              frm_extended_header_length==    6*frm_extended_header_flags[0]
                                                           +  6*frm_extended_header_flags[1] 
                                                           +  1*frm_extended_header_flags[2] 
                                                           +  2*frm_extended_header_flags[3] 
                                                           +  3*frm_extended_header_flags[4] 
                                                           + 18*frm_extended_header_flags[5] 
                                                           +  1*frm_extended_header_flags[6] 
                                                           +  1
                                                           +  frm_acad_len;
                              frm_adv_pdu_length dist {(frm_extended_header_length+1):/50,[frm_extended_header_length+2:255]:/50};
                              frm_acad.size() == frm_acad_len;
                              frm_adv_data.size() == frm_adv_pdu_length - frm_extended_header_length-1;
                              frm_scan_rsp_data.size() == frm_adv_pdu_length - frm_extended_header_length-1;
                          }
    }
    
    
    constraint LLID{llid != 2'b00;}

    constraint dt_length{solve data_pdu_length before data_payload; solve opcode before data_pdu_length;
                         if(llid == 2'b10)
                         {
                          data_pdu_length != 0;
                          data_pdu_length inside {[1:31]};
                          data_payload.size() == (data_pdu_length-4);
                         }
                         else if(llid == 2'b11)
                         {
                             opcode inside {[0:19],[20:25]};
                             if(opcode == 8'h00)
	                         {
	                           data_pdu_length == 12;
	                           data_payload.size() == 0;
	                         }
	                         else if(opcode == 8'h01)
	                         {
	                           data_pdu_length == 8;
	                           data_payload.size() == 0;
	                         }
                                 else if(opcode == 8'h02)
	                          {
	                           data_pdu_length == 2;
	                           data_payload.size() == 0;
	                          }
	                         else if(opcode == 8'h03)
	                          {
	                           data_pdu_length == 23;
	                           data_payload.size() == 0;
	                          }
	                         else if(opcode == 8'h04)
	                          {
	                           data_pdu_length == 13;
	                           data_payload.size() == 0;
	                          }
	                         else if(opcode == 8'h05)
	                          {
	                           data_pdu_length == 1;
	                           data_payload.size() == 0;
	                          }
	                         else if(opcode == 8'h06)
	                          {
	                           data_pdu_length == 1;
	                           data_payload.size() == 0;
	                          }
	                         else if(opcode == 8'h07)
	                          {
	                           data_pdu_length == 2;
	                           data_payload.size() == 0;
	                          }
	                         else if(opcode == 8'h08)
	                          {
	                           data_pdu_length == 9;
	                           data_payload.size() == 0;
	                          }
	                         else if(opcode == 8'h09)
	                          {
	                           data_pdu_length == 9;
	                           data_payload.size() == 0;
	                          }
	                         else if(opcode == 8'h0A)
	                          {
	                           data_pdu_length == 1;
	                           data_payload.size() == 0;
	                          }
	                         else if(opcode == 8'h0B)
	                          {
	                           data_pdu_length == 1;
	                           data_payload.size() == 0;
	                          }
	                         else if(opcode == 8'h0C)
	                          {
	                           data_pdu_length == 6;
	                           data_payload.size() == 0;
	                          }
	                         else if(opcode == 8'h0D)
	                          {
	                           data_pdu_length == 2;
	                           data_payload.size() == 0;
	                          }
	                         else if(opcode == 8'h0E)
	                          {
	                           data_pdu_length == 9;
	                           data_payload.size() == 0;
	                          }
	                         else if(opcode == 8'h0F)
	                          {
	                           data_pdu_length == 24;
	                           data_payload.size() == 0;
	                          }
	                         else if(opcode == 8'h10)
	                          {
	                           data_pdu_length == 24;
	                           data_payload.size() == 0;
	                          }
	                         else if(opcode == 8'h11)
	                          {
	                           data_pdu_length == 3;
	                           data_payload.size() == 0;
	                          }
	                         else if(opcode == 8'h12)
	                          {
	                           data_pdu_length == 1;
	                           data_payload.size() == 0;
	                          }
	                         else if(opcode == 8'h13)
	                         {
	                           data_pdu_length == 1;
	                           data_payload.size() == 0;
	                         }
	                         else if(opcode == 8'h16)
	                         {
	                           data_pdu_length == 3;
	                           data_payload.size() == 0;
	                         }
	                         else if(opcode == 8'h17)
	                         {
	                           data_pdu_length == 3;
	                           data_payload.size() == 0;
	                         }
	                         else if(opcode == 8'h18)
	                         {
	                           data_pdu_length == 5;
	                           data_payload.size() == 0;
	                         }
	                         else if(opcode == 8'h19)
	                         {
	                           data_pdu_length == 3;
	                           data_payload.size() == 0;
	                         }
	                         else if(opcode == 8'h15)
	                         {
	                           data_pdu_length == 9;
	                           data_payload.size() == 0;
	                         }
	                         else if(opcode == 8'h14)
	                         {
	                           data_pdu_length == 9;
	                           data_payload.size() == 0;
	                         }

                         }
                         else 
                         {
                          data_pdu_length inside {[0:31]};
                          data_payload.size() == (data_pdu_length-4);
                         }
    }

    constraint LL_LENGTH    {
                         maxrxoctets    >=  27;
                         maxtxoctets    >=  27;
                         maxrxtime      >=  328;
                         maxtxtime      >=  328;
    }











    extern function new(string name = "ble_mac_transaction");
    extern virtual function void do_pack(uvm_packer packer);
    extern virtual function void do_unpack(uvm_packer packer);
    extern virtual function void form_crc(uvm_packer packer);
    extern virtual function void form_crc_rx(uvm_packer packer);
    extern virtual function void calculate_crc(ref bit [15:0] header, ref bit [7:0] pdu[], ref bit [23:0] conn_crc_init);
    extern virtual function void do_print(uvm_printer printer);

    endclass: ble_mac_transaction



    //*************************************************************************************
    //                         function
    //*************************************************************************************
    
    function ble_mac_transaction::new(string name = "ble_mac_transaction");
        super.new(name);
    endfunction
    
    function void ble_mac_transaction::do_pack(uvm_packer packer);
        super.do_pack(packer);
    
        if(pkt_type==0)
        begin
            packer.pack_field(8'b01010101,8);
            packer.pack_field(32'h6B7D9171,32);             // Access addr for adv [LSB:MSB]
            frm_adv_pdu_type = {<< {frm_adv_pdu_type}};     // bit reverse
            packer.pack_field(frm_adv_pdu_type,4);
            frm_adv_pdu_type = {<< {frm_adv_pdu_type}};   
            //packer.pack_field(2'b00,2);
            packer.pack_field(1'b0,1);                      // RFC
            packer.pack_field(frm_adv_pdu_chsel,1);         // ChSel  just 1M,(just legacy advertising PDUs,nomore extended advertising PDUs)
            packer.pack_field(frm_adv_pdu_tx_add,1);
            packer.pack_field(frm_adv_pdu_rx_add,1);
            frm_adv_pdu_length = {<< {frm_adv_pdu_length}};
            packer.pack_field(frm_adv_pdu_length,8);
            frm_adv_pdu_length = {<< {frm_adv_pdu_length}};   
            //packer.pack_field(2'b00,2);                   // rfc del for ble 5.0
            if(frm_adv_pdu_type == 1)                       // Adv directed high/low duty cycle ,no frm_adv_data  12B  
            begin
 		    	source_device_addr = frm_adv_addr;               
                frm_adv_addr = {<< {frm_adv_addr}};
                packer.pack_field(frm_adv_addr,48);
                frm_adv_addr = {<< {frm_adv_addr}};     
                frm_conn_init_add = {<< {frm_conn_init_add}};
                packer.pack_field(frm_conn_init_add,48);
                frm_conn_init_add = {<< {frm_conn_init_add}};     
            end
            else if((frm_adv_pdu_type == 3) && (channel_index == 6'd37 || channel_index == 6'd38 || channel_index == 6'd39)) // Scan req pdu ,no frm_adv_data    
            begin
 		    	source_device_addr = frm_scan_addr;
                frm_scan_addr = {<< {frm_scan_addr}};
                packer.pack_field(frm_scan_addr,48);
                frm_scan_addr = {<< {frm_scan_addr}};
                frm_adv_addr = {<< {frm_adv_addr}};
                packer.pack_field(frm_adv_addr,48);
                frm_adv_addr = {<< {frm_adv_addr}};
            end
            else if((frm_adv_pdu_type == 3) && (channel_index != 6'd37 || channel_index != 6'd38 || channel_index != 6'd39)) // AUX_SCAN_REQ
            begin
 		    	source_device_addr = frm_scan_addr;
                frm_scan_addr = {<< {frm_scan_addr}};
                packer.pack_field(frm_scan_addr,48);
                frm_scan_addr = {<< {frm_scan_addr}};
                frm_adv_addr = {<< {frm_adv_addr}};
                packer.pack_field(frm_adv_addr,48);
                frm_adv_addr = {<< {frm_adv_addr}};
            end
            else if(frm_adv_pdu_type == 0 || frm_adv_pdu_type == 2 || frm_adv_pdu_type == 6)     // frm_adv_data
            begin
		    	source_device_addr = frm_adv_addr;
                frm_adv_addr = {<< {frm_adv_addr}};
                packer.pack_field(frm_adv_addr,48);
                frm_adv_addr = {<< {frm_adv_addr}};     
                foreach(frm_adv_data[i])
                begin
                    frm_adv_data[i] = {<< {frm_adv_data[i]}};
                    packer.pack_field(frm_adv_data[i],8);
                    frm_adv_data[i] = {<< {frm_adv_data[i]}};       
                end
            end
            else if(frm_adv_pdu_type == 4)                   // frm_scan_rsp_data
            begin
                frm_adv_addr = {<< {frm_adv_addr}};
                packer.pack_field(frm_adv_addr,48);
                frm_adv_addr = {<< {frm_adv_addr}};     
                foreach(frm_scan_rsp_data[i])
                begin
                  frm_scan_rsp_data[i] = {<< {frm_scan_rsp_data[i]}};
                  packer.pack_field(frm_scan_rsp_data[i],8);
                  frm_scan_rsp_data[i] = {<< {frm_scan_rsp_data[i]}};
                end
            end
            else if(frm_adv_pdu_type == 5)                   // CONNECT_REQ || AUX_CONNECT_REQ
            begin
                frm_conn_init_add = {<< {frm_conn_init_add}};
                packer.pack_field(frm_conn_init_add,48);
                frm_conn_init_add = {<< {frm_conn_init_add}};     
                frm_adv_addr = {<< {frm_adv_addr}};
                packer.pack_field(frm_adv_addr,48);
                frm_adv_addr = {<< {frm_adv_addr}};
                frm_conn_acc_add = {<< {frm_conn_acc_add}};
                packer.pack_field(frm_conn_acc_add,32);
                frm_conn_acc_add = {<< {frm_conn_acc_add}};
                frm_crc_init = {<< {frm_crc_init}};
                packer.pack_field(frm_crc_init,24);
                frm_crc_init = {<< {frm_crc_init}};
                frm_winsize = {<< {frm_winsize}};
                packer.pack_field(frm_winsize,8);
                frm_winsize = {<< {frm_winsize}};
                frm_winoffset = {<< {frm_winoffset}};
                packer.pack_field(frm_winoffset,16);
                frm_winoffset = {<< {frm_winoffset}};
                frm_interval = {<< {frm_interval}};
                packer.pack_field(frm_interval,16);
                frm_interval = {<< {frm_interval}};
                frm_latency = {<< {frm_latency}};
                packer.pack_field(frm_latency,16);
                frm_latency = {<< {frm_latency}};
                frm_timeout = {<< {frm_timeout}};
                packer.pack_field(frm_timeout,16);
                frm_timeout = {<< {frm_timeout}};
                frm_chm = {<< {frm_chm}};
                packer.pack_field(frm_chm,40);
                frm_chm = {<< {frm_chm}};
                frm_hop = {<< {frm_hop}};
                packer.pack_field(frm_hop,5);
                frm_hop = {<< {frm_hop}};
                frm_sca = {<< {frm_sca}};
                packer.pack_field(frm_sca,3);
                frm_sca = {<< {frm_sca}};
            end
            else if(frm_adv_pdu_type == 7)                   // Common Extended Advertising Payload Format 
            begin
                frm_extended_header_length = {<< {frm_extended_header_length}};
                packer.pack_field(frm_extended_header_length,6);
                frm_extended_header_length = {<< {frm_extended_header_length}};     
                frm_advmode = {<< {frm_advmode}};
                packer.pack_field(frm_advmode,2);
                frm_advmode = {<< {frm_advmode}};
                frm_extended_header_flags = {<< {frm_extended_header_flags}};
                packer.pack_field(frm_extended_header_flags,8);
                frm_extended_header_flags = {<< {frm_extended_header_flags}};
                if(frm_extended_header_flags[0] == 1)
                begin
                    frm_adv_addr = {<< {frm_adv_addr}};
                    packer.pack_field(frm_adv_addr,48);
                    frm_adv_addr = {<< {frm_adv_addr}};
                end
                if(frm_extended_header_flags[1] == 1)
                begin
                    target_device_addr = {<< {target_device_addr}};
                    packer.pack_field(target_device_addr,48);
                    target_device_addr = {<< {target_device_addr}};
                end
                if(frm_extended_header_flags[2] == 1)
                begin
                    frm_ext_rfc = {<< {frm_ext_rfc}};
                    packer.pack_field(frm_ext_rfc,8);
                    frm_ext_rfc = {<< {frm_ext_rfc}};
                end
                if(frm_extended_header_flags[3] == 1)
                begin
                    frm_DID = {<< {frm_DID}};
                    packer.pack_field(frm_DID,12);
                    frm_DID = {<< {frm_DID}};
                    frm_SID = {<< {frm_SID}};
                    packer.pack_field(frm_SID,4);
                    frm_SID = {<< {frm_SID}};
                end
                if(frm_extended_header_flags[4] == 1)
                begin
                    channel_index = {<< {channel_index}};
                    packer.pack_field(channel_index,6);
                    channel_index = {<< {channel_index}};
                    frm_ca = {<< {frm_ca}};
                    packer.pack_field(frm_ca,1);
                    frm_ca = {<< {frm_ca}};
                    frm_aux_offset_units = {<< {frm_aux_offset_units}};
                    packer.pack_field(frm_aux_offset_units,1);
                    frm_aux_offset_units = {<< {frm_aux_offset_units}};
                    frm_aux_offset = {<< {frm_aux_offset}};
                    packer.pack_field(frm_aux_offset,13);
                    frm_aux_offset = {<< {frm_aux_offset}};
                    frm_aux_phy = {<< {frm_aux_phy}};
                    packer.pack_field(frm_aux_phy,3);
                    frm_aux_phy = {<< {frm_aux_phy}};
                end
                if(frm_extended_header_flags[5] == 1)
                begin
                    frm_sync_packet_offset = {<< {frm_sync_packet_offset}};
                    packer.pack_field(frm_sync_packet_offset,13);
                    frm_sync_packet_offset = {<< {frm_sync_packet_offset}};
                    frm_offset_units = {<< {frm_offset_units}};
                    packer.pack_field(frm_offset_units,1);
                    frm_offset_units = {<< {frm_offset_units}};
                    packer.pack_field(0,2); //  RFC 2bit
                    frm_interval = {<< {frm_interval}};
                    packer.pack_field(frm_interval,16);
                    frm_interval = {<< {frm_interval}};
                    frm_sync_chm = {<< {frm_sync_chm}};
                    packer.pack_field(frm_sync_chm,37);
                    frm_sync_chm = {<< {frm_sync_chm}};
                    frm_sca = {<< {frm_sca}};
                    packer.pack_field(frm_sca,3);
                    frm_sca = {<< {frm_sca}};
                    frm_conn_acc_add = {<< {frm_conn_acc_add}};
                    packer.pack_field(frm_conn_acc_add,32);
                    frm_conn_acc_add = {<< {frm_conn_acc_add}};
                    frm_crc_init = {<< {frm_crc_init}};
                    packer.pack_field(frm_crc_init,24);
                    frm_crc_init = {<< {frm_crc_init}};
                    frm_event_counter = {<< {frm_event_counter}};
                    packer.pack_field(frm_event_counter,16);
                    frm_event_counter = {<< {frm_event_counter}};
                end
                if(frm_extended_header_flags[6] == 1)
                begin
                    frm_txpower = {<< {frm_txpower}};
                    packer.pack_field(frm_txpower,8);
                    frm_txpower = {<< {frm_txpower}};
                end

                foreach(frm_acad[i])
                begin
                  frm_acad[i] = {<< {frm_acad[i]}};
                  packer.pack_field(frm_acad[i],8);
                  frm_acad[i] = {<< {frm_acad[i]}};
                end
                
                foreach(frm_adv_data[i])
                begin
                    frm_adv_data[i] = {<< {frm_adv_data[i]}};
                    packer.pack_field(frm_adv_data[i],8);
                    frm_adv_data[i] = {<< {frm_adv_data[i]}};
                end
            end
            packer.m_packed_size = packer.count;
            form_crc(packer);  // call ble_mac_transaction.print() after calling pack method in tx_driver to get calculated value. If called in ble_controller, it shows 0 since form_crc is calculated only in pack method which in turn is called in tx_driver
            packer.pack_field(crc,24);
        end
        else
        begin
            packer.pack_field(preamble,8);
            if (phy_type == LE_2M) packer.pack_field(preamble,8);  // LE_2M preamble 16bit
            frm_conn_acc_add = {<< {frm_conn_acc_add}};
            packer.pack_field(frm_conn_acc_add,32);
            frm_conn_acc_add = {<< {frm_conn_acc_add}};
            access_address  = frm_conn_acc_add;
            llid = {<< {llid}};
            packer.pack_field(llid,2);
            llid = {<< {llid}};
            packer.pack_field(nesn,1);
            packer.pack_field(sn,1);
            packer.pack_field(md,1);
            packer.pack_field(3'b000,3);            // RFC
            data_pdu_length = {<< {data_pdu_length}};
            packer.pack_field(data_pdu_length,8);
            data_pdu_length = {<< {data_pdu_length}};
            //packer.pack_field(3'b000,3);
    
            if(llid == 2'b11)
            begin
                opcode = {<< {opcode}};   
                packer.pack_field(opcode,8);
                opcode = {<< {opcode}};   
                if (opcode == 8'h00)                                                 // LL_CONNECTION_UPDATE_IND 
                begin
                    frm_winsize = {<< {frm_winsize}};
                    packer.pack_field(frm_winsize,8);
                    frm_winsize = {<< {frm_winsize}};     
                    frm_winoffset = {<< {frm_winoffset}};
                    packer.pack_field(frm_winoffset,16);
                    frm_winoffset = {<< {frm_winoffset}};     
                    frm_interval = {<< {frm_interval}};
                    packer.pack_field(frm_interval,16);
                    frm_interval = {<< {frm_interval}};
                    frm_latency = {<< {frm_latency}};
                    packer.pack_field(frm_latency,16);
                    frm_latency = {<< {frm_latency}};     
                    frm_timeout = {<< {frm_timeout}};
                    packer.pack_field(frm_timeout,16);
                    frm_timeout = {<< {frm_timeout}};
                    packer.pack_field(instant,16);
                end
                else if(opcode == 8'h01)                                             // LL_CHANNEL_MAP_IND 
                begin
                    frm_chm = {<< {frm_chm}};
                    packer.pack_field(frm_chm,40);
                    frm_chm = {<< {frm_chm}};
                    packer.pack_field(instant,16);
                end
                else if(opcode == 8'h02 || opcode == 8'h0D)                          // LL_TERMINATE_IND || LL_REJECT_IND
                begin
                    packer.pack_field(error_code,8);
                end
                else if(opcode == 8'h03)                                             // LL_ENC_REQ 
                begin
                    packer.pack_field(enc_rand,64);
                    packer.pack_field(enc_ediv,16);
                    packer.pack_field(enc_skd,64);
                    packer.pack_field(enc_iv,32);
                end
                else if(opcode == 8'h04)                                             // LL_ENC_RSP
                begin
                    packer.pack_field(enc_skd,64);
                    packer.pack_field(enc_iv,32);
                end
                else if(opcode == 8'h08 || opcode == 8'h09 || opcode == 8'h0E)       // LL_FEATURE_REQ || LL_FEATURE_RSP || LL_SLAVE_FEATURE_REQ
                begin
                    packer.pack_field(feature_set_data,64);     
                end
                else if(opcode == 8'h0C)                                             // LL_VERSION_IND
                begin
                    packer.pack_field(version_vernr,8);     
                    packer.pack_field(version_compid,16);     
                    packer.pack_field(version_sub_vernr,16);     
                end
                else if(opcode == 8'h0F || opcode == 8'h10)                          // LL_CONNECTION_PARAM_REQ || LL_CONNECTION_PARAM_RSP
                begin
                    packer.pack_field(frm_interval_min,16);     
                    packer.pack_field(frm_interval_max,16);     
                    packer.pack_field(frm_latency,16);     
                    packer.pack_field(frm_timeout,16);     
                    packer.pack_field(conn_param_offset,120);     
                end
                else if(opcode == 8'h11)                                             // LL_REJECT_EXT_IND
                begin
                    packer.pack_field(unknown_reject_opcode,8);     
                    packer.pack_field(error_code,8);
                end
                else if(opcode == 8'h07)                                             // LL_UNKNOWN_RSP 
                begin
                    packer.pack_field(unknown_reject_opcode,8);     
                end
                else if(opcode == 8'h16)                                             // LL_PHY_REQ 
                begin
                    tx_phys = {<< {tx_phys}};
                    packer.pack_field(tx_phys,8);
                    tx_phys = {<< {tx_phys}};
                    rx_phys = {<< {rx_phys}};
                    packer.pack_field(rx_phys,8);
                    rx_phys = {<< {rx_phys}};
                end
                else if(opcode == 8'h17)                                             // LL_PHY_RSP 
                begin
                    tx_phys = {<< {tx_phys}};
                    packer.pack_field(tx_phys,8);
                    tx_phys = {<< {tx_phys}};
                    rx_phys = {<< {rx_phys}};
                    packer.pack_field(rx_phys,8);
                    rx_phys = {<< {rx_phys}};
                end
                else if(opcode == 8'h18)                                             // LL_PHY_UPDATE_IND 
                begin
                    m_to_s_phy = {<< {m_to_s_phy}};
                    packer.pack_field(m_to_s_phy,8);
                    m_to_s_phy = {<< {m_to_s_phy}};
                    s_to_m_phy = {<< {s_to_m_phy}};
                    packer.pack_field(s_to_m_phy,8);
                    s_to_m_phy = {<< {s_to_m_phy}};
                    //instant = {<< {instant}};
                    packer.pack_field(instant,16);
                    //instant = {<< {instant}};
                end
                else if(opcode == 8'h19)                                             // LL_MIN_USED_CHANNELS_IND 
                begin
                    phys = {<< {phys}};
                    packer.pack_field(phys,8);
                    phys = {<< {phys}};
                    minusedchannels = {<< {minusedchannels}};
                    packer.pack_field(minusedchannels,8);
                    minusedchannels = {<< {minusedchannels}};
                end
                else if(opcode == 8'h14)                                             // LL_LENGTH_REQ 
                begin
                    maxrxoctets = {<< {maxrxoctets}};   //  >=27B
                    packer.pack_field(maxrxoctets,16);
                    maxrxoctets = {<< {maxrxoctets}};
                    maxrxtime = {<< {maxrxtime}};       //  >=328us
                    packer.pack_field(maxrxtime,16);
                    maxrxtime = {<< {maxrxtime}};
                    maxtxoctets = {<< {maxtxoctets}};   //  >=27B
                    packer.pack_field(maxtxoctets,16);
                    maxtxoctets = {<< {maxtxoctets}};
                    maxtxtime = {<< {maxtxtime}};       //  >=328us
                    packer.pack_field(maxtxtime,16);
                    maxtxtime = {<< {maxtxtime}};
                end
                else if(opcode == 8'h15)                                             // LL_LENGTH_RSP  
                begin
                    maxrxoctets = {<< {maxrxoctets}};   //  >=27B
                    packer.pack_field(maxrxoctets,16);
                    maxrxoctets = {<< {maxrxoctets}};
                    maxrxtime = {<< {maxrxtime}};       //  >=328us
                    packer.pack_field(maxrxtime,16);
                    maxrxtime = {<< {maxrxtime}};
                    maxtxoctets = {<< {maxtxoctets}};   //  >=27B
                    packer.pack_field(maxtxoctets,16);
                    maxtxoctets = {<< {maxtxoctets}};
                    maxtxtime = {<< {maxtxtime}};       //  >=328us
                    packer.pack_field(maxtxtime,16);
                    maxtxtime = {<< {maxtxtime}};
                end






                else if((opcode == 8'h05)||(opcode == 8'h06)||(opcode == 8'h0A)||(opcode == 8'h0B)||(opcode == 8'h12)||(opcode == 8'h13))
                    `uvm_warning(get_full_name(),"UNSUPPORT OPCODE")
                else 
                    `uvm_error(get_full_name(),"INVALID OPCODE")
            end
            else                                                                     // LLID: 10 || 01
            begin
                foreach(data_payload[i])
                begin
                    data_payload[i] = {<< {data_payload[i]}};
                    packer.pack_field(data_payload[i],8);                            // include mic
                    data_payload[i] = {<< {data_payload[i]}};
                end
            end
            //packer.pack_field(mic,32);       // The MIC field shall not be included in an un-encrypted Link Layer connection
            packer.m_packed_size = packer.count;
            form_crc(packer);  // call ble_mac_transaction.print() after calling pack method in tx_driver to get calculated value. If called in ble_controller, it shows 0 since form_crc is calculated only in pack method which in turn is called in tx_driver
            packer.pack_field(crc,24);
        end
     
    endfunction

    function void ble_mac_transaction::form_crc(uvm_packer packer);
        bit [7:0]   dat_tmp_q[$];
        bit [7:0]   dat_tmp_a[];
        bit [7:0]   dat_tmp;
        //m_pack(packer);
        //packer.set_packed_size();
        //packer.m_packed_size = packer.count;
        packer.get_bytes(dat_tmp_a);
        //pack_bytes(dat_tmp_a);
        dat_tmp     =   packer.get_byte(1);
        //dat_tmp     =   dat_tmp_a[1];
        dat_tmp_q   =   dat_tmp_a;
        crc = 'h555555;
        if (dat_tmp == 8'b10101010 || dat_tmp == 8'b01010101)
        begin
            dat_tmp_q   =   dat_tmp_q[6:$];
            frm_bits_q  =   dat_tmp_q;   
            calculate_crc(adv_header, frm_bits_q, crc);
        end
        else
        begin
            dat_tmp_q   =   dat_tmp_q[5:$];
            frm_bits_q  =   dat_tmp_q;   
            calculate_crc(adv_header, frm_bits_q, crc);
        end
    endfunction

    function void ble_mac_transaction::form_crc_rx(uvm_packer packer);
        bit [7:0]   dat_tmp_q[$];
        bit [7:0]   dat_tmp_a[];
        bit [7:0]   dat_tmp;
        //m_pack(packer);
        //packer.set_packed_size();
        //packer.m_packed_size = packer.count;
        packer.get_bytes(dat_tmp_a);
        //pack_bytes(dat_tmp_a);
        dat_tmp     =   packer.get_byte(1);
        //dat_tmp     =   dat_tmp_a[1];
        dat_tmp_q   =   dat_tmp_a;
        crc = 'h555555;
        if (dat_tmp == 8'b10101010 || dat_tmp == 8'b01010101)
        begin
            dat_tmp_q   =   dat_tmp_q[6:($-3)];
            frm_bits_q  =   dat_tmp_q;   
            calculate_crc(adv_header, frm_bits_q, crc);
        end
        else
        begin
            dat_tmp_q   =   dat_tmp_q[5:($-3)];
            frm_bits_q  =   dat_tmp_q;   
            calculate_crc(adv_header, frm_bits_q, crc);
        end
    endfunction




    function void ble_mac_transaction::calculate_crc(ref bit [15:0] header, ref bit [7:0] pdu[], ref bit [23:0] conn_crc_init);

        //// 24th bit has to be transmitted into AIR first

        //for(int i=0;i<16;i++)
        //begin
	    //bit lfsr_value = conn_crc_init[23] ^ header[i];
	    //conn_crc_init[23] = conn_crc_init[22];
	    //conn_crc_init[22] = conn_crc_init[21];
	    //conn_crc_init[21] = conn_crc_init[20];
	    //conn_crc_init[20] = conn_crc_init[19];
	    //conn_crc_init[19] = conn_crc_init[18];
	    //conn_crc_init[18] = conn_crc_init[17];
	    //conn_crc_init[17] = conn_crc_init[16];
	    //conn_crc_init[16] = conn_crc_init[15];
	    //conn_crc_init[15] = conn_crc_init[14];
	    //conn_crc_init[14] = conn_crc_init[13];
	    //conn_crc_init[13] = conn_crc_init[12];
	    //conn_crc_init[12] = conn_crc_init[11];
	    //conn_crc_init[11] = conn_crc_init[10];
	    //conn_crc_init[10] = conn_crc_init[9] ^ lfsr_value;
	    //conn_crc_init[9]  = conn_crc_init[8] ^ lfsr_value ;
	    //conn_crc_init[8]  = conn_crc_init[7];
	    //conn_crc_init[7]  = conn_crc_init[6];
	    //conn_crc_init[6]  = conn_crc_init[5] ^ lfsr_value;
	    //conn_crc_init[5]  = conn_crc_init[4];
	    //conn_crc_init[4]  = conn_crc_init[3] ^ lfsr_value;
	    //conn_crc_init[3]  = conn_crc_init[2] ^ lfsr_value;
	    //conn_crc_init[2]  = conn_crc_init[1];
	    //conn_crc_init[1]  = conn_crc_init[0] ^ lfsr_value;
	    //conn_crc_init[0]  = lfsr_value;
        //end

        foreach (pdu[j])
        begin
            //for(int i=0;i<8;i++)
            for(int i=8;i>0;i--)
            begin
                bit lfsr_value = conn_crc_init[23] ^ pdu[j][i-1];
                conn_crc_init[23] = conn_crc_init[22];
                conn_crc_init[22] = conn_crc_init[21];
                conn_crc_init[21] = conn_crc_init[20];
                conn_crc_init[20] = conn_crc_init[19];
                conn_crc_init[19] = conn_crc_init[18];
                conn_crc_init[18] = conn_crc_init[17];
                conn_crc_init[17] = conn_crc_init[16];
                conn_crc_init[16] = conn_crc_init[15];
                conn_crc_init[15] = conn_crc_init[14];
                conn_crc_init[14] = conn_crc_init[13];
                conn_crc_init[13] = conn_crc_init[12];
                conn_crc_init[12] = conn_crc_init[11];
                conn_crc_init[11] = conn_crc_init[10];
                conn_crc_init[10] = conn_crc_init[9] ^ lfsr_value;
                conn_crc_init[9]  = conn_crc_init[8] ^ lfsr_value ;
                conn_crc_init[8]  = conn_crc_init[7];
                conn_crc_init[7]  = conn_crc_init[6];
                conn_crc_init[6]  = conn_crc_init[5] ^ lfsr_value;
                conn_crc_init[5]  = conn_crc_init[4];
                conn_crc_init[4]  = conn_crc_init[3] ^ lfsr_value;
                conn_crc_init[3]  = conn_crc_init[2] ^ lfsr_value;
                conn_crc_init[2]  = conn_crc_init[1];
                conn_crc_init[1]  = conn_crc_init[0] ^ lfsr_value;
                conn_crc_init[0]  = lfsr_value;
            end
        end
  
    endfunction

    function void ble_mac_transaction::do_unpack(uvm_packer packer);
        int         dummy;
        bit [7:0]   dat_tmp;
        bit [23:0]  crc_check;
        //packer.count = packer.m_packed_size;
        form_crc_rx(packer);   //  crc is exp crc; crc_check is actual crc;

        preamble = packer.unpack_field(8);
        if (preamble != 8'b10101010 && preamble != 8'b01010101) `uvm_error(get_name(),$sformatf("preamble is not 55 or aa! but %h",preamble)) 
        dat_tmp  = packer.get_byte(1);
        if (dat_tmp == 8'b10101010 || dat_tmp == 8'b01010101)
        begin
            preamble = packer.unpack_field(8);  // LE_2M preamble 16bit
            phy_type = LE_2M;
            preamble = {<< {preamble}};
        end
        else
        begin
            phy_type = LE_1M;
        end

        access_address      =   packer.unpack_field(32);
        access_address      =   {<< {access_address}};
        frm_conn_acc_add    =   access_address;
	    if(access_address=='h8e89bed6)
	    begin
		    pkt_type = ADV;
		    frm_adv_pdu_type = packer.unpack_field(4);
		    frm_adv_pdu_type = {<< {frm_adv_pdu_type}};
            dummy = packer.unpack_field(1);              // RFC
            frm_adv_pdu_chsel = packer.unpack_field(1);
		    frm_adv_pdu_tx_add = packer.unpack_field(1);
		    frm_adv_pdu_rx_add = packer.unpack_field(1);
		    frm_adv_pdu_length = packer.unpack_field(8);
		    frm_adv_pdu_length = {<< {frm_adv_pdu_length}};

            if(frm_adv_pdu_type == 4'd1)                              // Adv directed high/low duty cycle ,no frm_adv_data  12B  
		    begin
		    	frm_adv_addr = packer.unpack_field(48);
		    	frm_adv_addr = {<< {frm_adv_addr}};
		    	source_device_addr = frm_adv_addr;
		    	frm_conn_init_add = packer.unpack_field(48);
		    	frm_conn_init_add = {<< {frm_conn_init_add}};
		    	target_device_addr = frm_conn_init_add;
		    	frm_adv_data = new [0];
		    end
		    else if(frm_adv_pdu_type == 4'd3)                         // Scan req pdu ,no frm_adv_data    
		    begin
		    	frm_scan_addr = packer.unpack_field(48);
		    	frm_scan_addr = {<< {frm_scan_addr}};
		    	source_device_addr = frm_scan_addr;
		    	frm_adv_addr = packer.unpack_field(48);
		    	frm_adv_addr = {<< {frm_adv_addr}};
		    	target_device_addr = frm_adv_addr;
		    	frm_adv_data = new [0];
		    end
		    else if(frm_adv_pdu_type == 4'd0 || frm_adv_pdu_type == 4'd2 || frm_adv_pdu_type == 4'd6)  // frm_adv_data
		    begin
		    	frm_adv_addr = packer.unpack_field(48);
		    	frm_adv_addr = {<< {frm_adv_addr}};
		    	source_device_addr = frm_adv_addr;
		    	frm_adv_data = new [frm_adv_pdu_length - 6];
		    	foreach(frm_adv_data[i])
		    	begin
                    frm_adv_data[i] = packer.unpack_field(8);
                    frm_adv_data[i] = {<< {frm_adv_data[i]}};
		    	end
		    end
		    else if(frm_adv_pdu_type == 4)                            // frm_scan_rsp_data
		    begin
		    	frm_adv_addr = packer.unpack_field(48);
		    	frm_adv_addr = {<< {frm_adv_addr}};
		    	source_device_addr = frm_adv_addr;
		    	frm_scan_rsp_data = new [frm_adv_pdu_length - 6];
		    	foreach(frm_scan_rsp_data[i])
		    	begin
		    		frm_scan_rsp_data[i] = packer.unpack_field(8);
		    		frm_scan_rsp_data[i] = {<< {frm_scan_rsp_data[i]}};
		    	end
		    end
		    else if(frm_adv_pdu_type == 5)                            // CONNECT_REQ
		    begin
                frm_conn_init_add = packer.unpack_field(48);
                frm_conn_init_add = {<< {frm_conn_init_add}};
                source_device_addr = frm_conn_init_add;
                frm_adv_addr = packer.unpack_field(48);
                frm_adv_addr = {<< {frm_adv_addr}};
                target_device_addr = frm_adv_addr;
                frm_conn_acc_add = packer.unpack_field(32);
                frm_conn_acc_add = {<< {frm_conn_acc_add}};
                frm_crc_init = packer.unpack_field(24);
                frm_crc_init = {<< {frm_crc_init}};
                frm_winsize = packer.unpack_field(8);
                frm_winsize = {<< {frm_winsize}};
                frm_winoffset = packer.unpack_field(16);
                frm_winoffset = {<< {frm_winoffset}};
                frm_interval = packer.unpack_field(16);
                frm_interval = {<< {frm_interval}};
                frm_latency = packer.unpack_field(16);
                frm_latency = {<< {frm_latency}};
                frm_timeout = packer.unpack_field(16);
                frm_timeout = {<< {frm_timeout}};
                frm_chm = packer.unpack_field(40);
                frm_chm = {<< {frm_chm}};
                frm_hop = packer.unpack_field(5);
                frm_hop = {<< {frm_hop}};
                frm_sca = packer.unpack_field(3);
                frm_sca = {<< {frm_sca}};
		    end
		    else if(frm_adv_pdu_type == 7)                            // Common Extended Advertising Payload Format 
		    begin
                frm_extended_header_length = packer.unpack_field(6);
                frm_extended_header_length = {<< {frm_extended_header_length}};
                frm_advmode = packer.unpack_field(2);
                frm_advmode = {<< {frm_advmode}};
                frm_extended_header_flags = packer.unpack_field(8);
                frm_extended_header_flags = {<< {frm_extended_header_flags}};
                if(frm_extended_header_flags[0] == 1)
                begin
                    frm_adv_addr = packer.unpack_field(48);
                    frm_adv_addr = {<< {frm_adv_addr}};
                    source_device_addr = frm_adv_addr;
                end
                if(frm_extended_header_flags[1] == 1)
                begin
                    target_device_addr = packer.unpack_field(48);
                    target_device_addr = {<< {target_device_addr}};
                end
                if(frm_extended_header_flags[2] == 1)
                begin
                    frm_ext_rfc = packer.unpack_field(8);
                    frm_ext_rfc = {<< {frm_ext_rfc}};
                end
                if(frm_extended_header_flags[3] == 1)
                begin
                    frm_DID = packer.unpack_field(12);
                    frm_DID = {<< {frm_DID}};
                    frm_SID = packer.unpack_field(4);
                    frm_SID = {<< {frm_SID}};
                end
                if(frm_extended_header_flags[4] == 1)
                begin
                    channel_index = packer.unpack_field(6);
                    channel_index = {<< {channel_index}};
                    frm_ca = packer.unpack_field(1);
                    frm_ca = {<< {frm_ca}};
                    frm_aux_offset_units = packer.unpack_field(1);
                    frm_aux_offset_units = {<< {frm_aux_offset_units}};
                    frm_aux_offset = packer.unpack_field(13);
                    frm_aux_offset = {<< {frm_aux_offset}};
                    frm_aux_phy = packer.unpack_field(3);
                    frm_aux_phy = {<< {frm_aux_phy}};
                end
                if(frm_extended_header_flags[5] == 1)
                begin
                    frm_sync_packet_offset = packer.unpack_field(13);
                    frm_sync_packet_offset = {<< {frm_sync_packet_offset}};
                    frm_offset_units = packer.unpack_field(1);
                    frm_offset_units = {<< {frm_offset_units}};
                    packer.unpack_field(2);                  //RFC 2bit
                    frm_interval = packer.unpack_field(16);
                    frm_interval = {<< {frm_interval}};
                    frm_sync_chm = packer.unpack_field(37);
                    frm_sync_chm = {<< {frm_sync_chm}};
                    frm_chm      = {3'b0,frm_sync_chm};
                    frm_sca = packer.unpack_field(3);
                    frm_sca = {<< {frm_sca}};
                    frm_conn_acc_add = packer.unpack_field(32);
                    frm_conn_acc_add = {<< {frm_conn_acc_add}};
                    frm_crc_init = packer.unpack_field(24);
                    frm_crc_init = {<< {frm_crc_init}};
                    frm_event_counter = packer.unpack_field(16);
                    frm_event_counter = {<< {frm_event_counter}};
                end
                if(frm_extended_header_flags[6] == 1)
                begin
                    frm_txpower = packer.unpack_field(8);
                    frm_txpower = {<< {frm_txpower}};
                end
                
                
                frm_acad    = new [frm_extended_header_length -  6*frm_extended_header_flags[0]
                                                              -  6*frm_extended_header_flags[1]
                                                              -  1*frm_extended_header_flags[2]
                                                              -  2*frm_extended_header_flags[3]
                                                              -  3*frm_extended_header_flags[4]
                                                              - 18*frm_extended_header_flags[5]
                                                              -  1*frm_extended_header_flags[6]
                                                              -  1];
                foreach(frm_acad[i])
                begin
                    frm_acad[i] = packer.unpack_field(8);
                    frm_acad[i] = {<< {frm_acad[i]}};
                end
                
                frm_adv_data    = new [frm_adv_pdu_length - frm_extended_header_length -1];

                foreach(frm_adv_data[i])
                begin
                    frm_adv_data[i] = packer.unpack_field(8);
                    frm_adv_data[i] = {<< {frm_adv_data[i]}};
                end
		    end
		    crc_check = packer.unpack_field(24);
	    end
        //Data
	    else
	    begin
            pkt_type = DATA;
            llid = packer.unpack_field(2);
            llid = {<< {llid}};
            nesn = packer.unpack_field(1);
            sn = packer.unpack_field(1);
            md = packer.unpack_field(1);
            dummy = packer.unpack_field(3);
            data_pdu_length = packer.unpack_field(8);
            data_pdu_length = {<< {data_pdu_length}};
            //dummy = packer.unpack_field(3);
            
            if(llid == 2'b11)
            begin
            	opcode = packer.unpack_field(8);
            	opcode = {<< {opcode}};
            	if (opcode == 8'h00)                           // LL_CONNECTION_UPDATE_IND  
            	begin
                    frm_winsize = packer.unpack_field(8);
                    frm_winsize = {<< {frm_winsize}};
                    frm_winoffset = packer.unpack_field(16);
                    frm_winoffset = {<< {frm_winoffset}};
                    frm_interval = packer.unpack_field(16);
                    frm_interval = {<< {frm_interval}};
                    frm_latency = packer.unpack_field(16);
                    frm_latency = {<< {frm_latency}};
                    frm_timeout = packer.unpack_field(16);
                    frm_timeout = {<< {frm_timeout}};
                    instant = packer.unpack_field(16);
            	end
            	else if(opcode == 8'h01)                       // LL_CHANNEL_MAP_IND 
            	begin
                    frm_chm = packer.unpack_field(40);
                    frm_chm = {<< {frm_chm}};
                    instant = packer.unpack_field(16);
            	end
            	else if(opcode == 8'h02 || opcode == 8'h0D)    // LL_TERMINATE_IND || LL_REJECT_IND
                    error_code = packer.unpack_field(8);
            	else if(opcode == 8'h03)                       // LL_ENC_REQ 
            	begin
                    enc_rand = packer.unpack_field(64);
                    enc_ediv = packer.unpack_field(16);
                    enc_skd = packer.unpack_field(64);
                    enc_iv = packer.unpack_field(32);
            	end
            	else if(opcode == 8'h04)                       // LL_ENC_RSP
            	begin
                    enc_skd = packer.unpack_field(64);
                    enc_iv = packer.unpack_field(32);
            	end
            	else if(opcode == 8'h08 || opcode == 8'h09 || opcode == 8'h0E)     // LL_FEATURE_REQ || LL_FEATURE_RSP || LL_SLAVE_FEATURE_REQ
                    feature_set_data = packer.unpack_field(64);
            	else if(opcode == 8'h0C)                       // LL_VERSION_IND
            	begin
                    version_vernr = packer.unpack_field(8);
                    version_compid = packer.unpack_field(16);
                    version_sub_vernr = packer.unpack_field(16);
            	end
            	else if(opcode == 8'h0F || opcode == 8'h10)    // LL_CONNECTION_PARAM_REQ || LL_CONNECTION_PARAM_RSP
            	begin
                    frm_interval_min = packer.unpack_field(16);
                    frm_interval_max = packer.unpack_field(16);
                    frm_latency = packer.unpack_field(16);
                    frm_timeout = packer.unpack_field(16);
                    conn_param_offset = packer.unpack_field(120);
            	end
            	else if(opcode == 8'h11)                       // LL_REJECT_EXT_IND
            	begin
                    unknown_reject_opcode = packer.unpack_field(8);
            	    error_code = packer.unpack_field(8);
            	end
            	else if(opcode == 8'h07)                       // LL_UNKNOWN_RSP 
                    unknown_reject_opcode = packer.unpack_field(8);
            	else if(opcode == 8'h16)                       // LL_PHY_REQ
            	begin
                    tx_phys = packer.unpack_field(8);
                    tx_phys = {<< {tx_phys}};
            	    rx_phys = packer.unpack_field(8);
                    rx_phys = {<< {rx_phys}};
            	end
                else if(opcode == 8'h17)                       // LL_PHY_RSP
                begin
                    tx_phys = packer.unpack_field(8);
                    tx_phys = {<< {tx_phys}};
                    rx_phys = packer.unpack_field(8);
                    rx_phys = {<< {rx_phys}};
                end
                else if(opcode == 8'h18)                       // LL_PHY_UPDATE_IND
                begin
                    m_to_s_phy = packer.unpack_field(8);
                    m_to_s_phy = {<< {m_to_s_phy}};
                    s_to_m_phy = packer.unpack_field(8);
                    s_to_m_phy = {<< {s_to_m_phy}};
                    instant = packer.unpack_field(16);
                end
                else if(opcode == 8'h19)                       // LL_MIN_USED_CHANNELS_IND
                begin
                    phys = packer.unpack_field(8);
                    phys = {<< {phys}};
                    minusedchannels = packer.unpack_field(8);
                    minusedchannels = {<< {minusedchannels}};
                end
                else if(opcode == 8'h14)                       // LL_LENGTH_REQ
                begin
                    maxrxoctets = packer.unpack_field(16);
                    maxrxoctets = {<< {maxrxoctets}};
                    maxrxtime = packer.unpack_field(16);
                    maxrxtime = {<< {maxrxtime}};
                    maxtxoctets = packer.unpack_field(16);
                    maxtxoctets = {<< {maxtxoctets}};
                    maxtxtime = packer.unpack_field(16);
                    maxtxtime = {<< {maxtxtime}};
                end
                else if(opcode == 8'h15)                       // LL_LENGTH_RSP
                begin
                    maxrxoctets = packer.unpack_field(16);
                    maxrxoctets = {<< {maxrxoctets}};
                    maxrxtime = packer.unpack_field(16);
                    maxrxtime = {<< {maxrxtime}};
                    maxtxoctets = packer.unpack_field(16);
                    maxtxoctets = {<< {maxtxoctets}};
                    maxtxtime = packer.unpack_field(16);
                    maxtxtime = {<< {maxtxtime}};
                end
                else if((opcode == 8'h05)||(opcode == 8'h06)||(opcode == 8'h0A)||(opcode == 8'h0B)||(opcode == 8'h12)||(opcode == 8'h13))
                    `uvm_warning(get_full_name(),"TB GET UNSUPPORT OPCODE")
	            else
	    	        `uvm_error(get_full_name(),$sformatf("INVALID OPCODE:%h",opcode))
            end
	        else if(llid == 2'b10 && llid == 2'b01)
	        begin
                 if (enc)
	            	data_payload = new [data_pdu_length - 4];
	             else
	             	data_payload = new [data_pdu_length];
	             foreach(data_payload[i])
	             begin
	             	data_payload[i] = packer.unpack_field(8);
	             	data_payload[i] = {<< {data_payload[i]}};
	             end
	        end
	        if (enc)
	        begin
	        	mic = packer.unpack_field(32);
	        	mic = {<< {mic}};
	        	mic = {<< byte{mic}};
	        end
	        crc_check = packer.unpack_field(24);
	    end
        if(crc != crc_check && crc_check_en == 1'b1)
        begin
            `uvm_error(get_type_name(),$sformatf("CRC:CRC mismatch received CRC = %h, Calculated CRC = %h.",crc_check,crc))
            crc = crc_check;
        end
        else
            `uvm_info(get_type_name(),$sformatf("CRC:CRC CHECK OK."),UVM_LOW)


    endfunction

    function void ble_mac_transaction::do_print(uvm_printer printer);
        super.do_print(printer);
    
        printer.print_field("pkt_type", this.pkt_type, 1, UVM_BIN);
        printer.print_field("channel_index", this.channel_index, 6, UVM_HEX);

        //printer.print_field("access_address", this.pkt_type, 32, UVM_HEX);
        if(pkt_type == 0)
        begin
            printer.print_field("adv_pdu_type", this.frm_adv_pdu_type, 4, UVM_BIN);
            printer.print_field("bt_phy_type", this.phy_type, 1, UVM_BIN);
            printer.print_field("txadd", this.frm_adv_pdu_tx_add, 1, UVM_BIN);
            printer.print_field("rxadd", this.frm_adv_pdu_rx_add, 1, UVM_BIN);
            printer.print_field("length", this.frm_adv_pdu_length, 8, UVM_UNSIGNED); 

            if (frm_adv_pdu_type == 4'd1)  printer.print_string("frm_adv_pdu_type", "ADV_DIRECT_IND");
            if ((frm_adv_pdu_type == 4'd3) && (channel_index == 6'd37 || channel_index == 6'd38 || channel_index == 6'd39)) printer.print_string("frm_adv_pdu_type", "SCAN_REQ");
            if ((frm_adv_pdu_type == 4'd3) && (channel_index != 6'd37 && channel_index != 6'd38 && channel_index != 6'd39)) printer.print_string("frm_adv_pdu_type", "AUX_SCAN_REQ");
            if ((frm_adv_pdu_type == 4'd5) && (channel_index == 6'd37 || channel_index == 6'd38 || channel_index == 6'd39)) printer.print_string("frm_adv_pdu_type", "CONNECT_REQ");
            if ((frm_adv_pdu_type == 4'd5) && (channel_index != 6'd37 && channel_index != 6'd38 && channel_index != 6'd39)) printer.print_string("frm_adv_pdu_type", "AUX_CONNECT_REQ");
            if (adv_type    ==  ADV_EXT_IND) printer.print_string("adv_type", "ADV_EXT_IND");
            if (adv_type    ==  AUX_ADV_IND) printer.print_string("adv_type", "AUX_ADV_IND");
            if (adv_type    ==  AUX_SCAN_RSP) printer.print_string("adv_type", "AUX_SCAN_RSP");
            if (adv_type    ==  AUX_SYNC_IND) printer.print_string("adv_type", "AUX_SYNC_IND");
            if (adv_type    ==  AUX_CHAIN_IND) printer.print_string("adv_type", "AUX_CHAIN_IND");


            if (frm_adv_pdu_type != 4'd7)   printer.print_field("source_device_addr", this.source_device_addr, 48, UVM_HEX);
            if ((frm_adv_pdu_type == 4'd1) || (frm_adv_pdu_type == 4'd3))  printer.print_field("target_device_addr", this.target_device_addr, 48, UVM_HEX);    //ADV_DIRECT_IND
          
            if (frm_adv_pdu_type == 4'd5)
            begin
                printer.print_field("conn_access_address", this.frm_conn_acc_add, 32, UVM_HEX);
                printer.print_field("crc_init", this.frm_crc_init, 24, UVM_HEX);
                printer.print_field("winsize", this.frm_winsize, 8, UVM_HEX);
                printer.print_field("winoffset", this.frm_winoffset, 16, UVM_HEX);
                printer.print_field("interval", this.frm_interval, 16, UVM_HEX);
                printer.print_field("latency", this.frm_latency, 16, UVM_HEX);
                printer.print_field("timeout", this.frm_timeout, 16, UVM_HEX);
                printer.print_field("chm", this.frm_chm, 40, UVM_HEX);
                printer.print_field("hop", this.frm_hop, 5, UVM_HEX);
                printer.print_field("sca", this.frm_sca, 3, UVM_HEX);
            end
            if (frm_adv_pdu_type == 4'd7)
            begin
                printer.print_field("frm_extended_header_length", this.frm_extended_header_length, 6, UVM_HEX);
                printer.print_field("frm_advmode", this.frm_advmode, 2, UVM_HEX);
                printer.print_field("frm_extended_header_flags", this.frm_extended_header_flags, 8, UVM_HEX);
                if(frm_extended_header_flags[0] == 1) printer.print_field("frm_adv_addr", this.frm_adv_addr, 48, UVM_HEX);
                if(frm_extended_header_flags[1] == 1) printer.print_field("target_device_addr", this.target_device_addr, 48, UVM_HEX);
                if(frm_extended_header_flags[2] == 1) printer.print_field("frm_ext_rfc", this.frm_ext_rfc, 8, UVM_HEX);
                if(frm_extended_header_flags[3] == 1)
                begin
                    printer.print_field("frm_DID", this.frm_DID, 12, UVM_HEX);
                    printer.print_field("frm_SID", this.frm_SID, 4, UVM_HEX);
                end
                if(frm_extended_header_flags[4] == 1)
                begin
                    printer.print_field("frm_channel_index", this.channel_index, 6, UVM_HEX);
                    printer.print_field("frm_ca", this.frm_ca, 1, UVM_HEX);
                    printer.print_field("frm_aux_offset_units", this.frm_aux_offset_units, 1, UVM_HEX);
                    printer.print_field("frm_aux_offset", this.frm_aux_offset, 13, UVM_HEX);
                    printer.print_field("frm_aux_phy", this.frm_aux_phy, 3, UVM_HEX);
                end
                if(frm_extended_header_flags[5] == 1)
                begin
                    printer.print_field("frm_sync_packet_offset", this.frm_sync_packet_offset, 13, UVM_HEX);
                    printer.print_field("frm_offset_units", this.frm_offset_units, 1, UVM_HEX);
                    printer.print_field("RFC", 0, 2, UVM_HEX);
                    printer.print_field("frm_interval", this.frm_interval, 16, UVM_HEX);
                    printer.print_field("frm_sync_chm", this.frm_sync_chm, 37, UVM_HEX);
                    printer.print_field("frm_sca", this.frm_sca, 3, UVM_HEX);
                    printer.print_field("frm_conn_acc_add", this.frm_conn_acc_add, 32, UVM_HEX);
                    printer.print_field("frm_crc_init", this.frm_crc_init, 24, UVM_HEX);
                    printer.print_field("frm_event_counter", this.frm_event_counter, 16, UVM_HEX);
                end
                if(frm_extended_header_flags[6] == 1)
                begin
                    printer.print_field("frm_txpower", this.frm_txpower, 8, UVM_HEX);
                end
                //if(frm_extended_header_flags[7] == 1)
                //begin
                    foreach (frm_acad[i])
                    printer.print_field($sformatf("frm_acad[%0d]",i), this.frm_acad[i], 8, UVM_HEX);
                //end
                foreach (frm_adv_data[i])
                printer.print_field($sformatf("adv_data[%0d]",i), this.frm_adv_data[i], 8, UVM_HEX);
            end
            
            if ((frm_adv_pdu_type == 4'd0) || (frm_adv_pdu_type == 4'd2) || (frm_adv_pdu_type == 4'd6))
            begin
            	foreach (frm_adv_data[i])
            	printer.print_field($sformatf("adv_data[%0d]",i), this.frm_adv_data[i], 8, UVM_HEX);
            end
            if (frm_adv_pdu_type == 4'd4)
            begin
            	foreach (frm_scan_rsp_data[i])
            	printer.print_field($sformatf("scan_rsp_data[%0d]",i), this.frm_scan_rsp_data[i], 8, UVM_HEX);
            end
        end
        else
        begin
            printer.print_field("preamble", this.preamble, 8, UVM_BIN);
            printer.print_field("access_address", this.access_address, 32, UVM_HEX);
            printer.print_field("llid", this.llid, 2, UVM_BIN);
            printer.print_field("nesn", this.nesn, 1, UVM_BIN);
            printer.print_field("sn", this.sn, 1, UVM_BIN);
            printer.print_field("md", this.md, 1, UVM_BIN);
            printer.print_field("length", this.data_pdu_length, 8, UVM_UNSIGNED);
    
            if (llid == 2'b10 && llid == 2'b01)
            begin
                foreach (data_payload[i])
                    printer.print_field($sformatf("data_payload[%0d]",i), this.data_payload[i], 8, UVM_HEX);
                end
                else if(llid == 2'b11)
                begin
                    printer.print_field("opcode", this.opcode, 8, UVM_HEX);
              	if (opcode == 8'h00)
              	begin
              	    printer.print_field("winsize", this.frm_winsize, 8, UVM_HEX);
              	    printer.print_field("winoffset", this.frm_winoffset, 16, UVM_HEX);
              	    printer.print_field("interval", this.frm_interval, 16, UVM_HEX);
              	    printer.print_field("latency", this.frm_latency, 16, UVM_HEX);
              	    printer.print_field("timeout", this.frm_timeout, 16, UVM_HEX);
              	    printer.print_field("instant", this.instant, 16, UVM_HEX);
              	end
              	if ((opcode == 8'h0f) || (opcode == 8'h10))
              	begin
                    printer.print_field("interval_min", this.frm_interval_min, 16, UVM_HEX);
                    printer.print_field("interval_max", this.frm_interval_max, 16, UVM_HEX);
                    printer.print_field("latency", this.frm_latency, 16, UVM_HEX);
                    printer.print_field("timeout", this.frm_timeout, 16, UVM_HEX);
                    printer.print_field("conn_param_offset", this.conn_param_offset, 120, UVM_HEX);
              	end
                if (opcode == 8'h01)
              	begin
                    printer.print_field("chm", this.frm_chm, 40, UVM_HEX);
                    printer.print_field("instant", this.instant, 16, UVM_HEX);
              	end
              	if ((opcode == 8'h03) || (opcode == 8'h04))
              	begin
                    if (opcode == 8'h03)
                    begin
                    	printer.print_field("rand", this.enc_rand, 64, UVM_HEX);
                    	printer.print_field("ediv", this.enc_ediv, 16, UVM_HEX);
                    end
                    printer.print_field("skd", this.enc_skd, 64, UVM_HEX);
                    printer.print_field("iv", this.enc_iv, 32, UVM_HEX);
              	end
              	if ((opcode == 8'h08) || (opcode == 8'h09) || (opcode == 8'h0e))
              	begin
                    printer.print_field("feature_set", this.feature_set_data, 64, UVM_HEX);
                    printer.print_field("version_no", this.version_vernr, 8, UVM_HEX);
                    printer.print_field("company_id", this.version_compid, 16, UVM_HEX);
                    printer.print_field("sub_version_no", this.version_sub_vernr, 16, UVM_HEX);
              	end
              	if ((opcode == 8'h0d) || (opcode == 8'h11))
              	    printer.print_field("error_code", this.error_code, 8, UVM_HEX);
              	if ((opcode == 8'h07) || (opcode == 8'h11))
              	    printer.print_field("unknown_reject_opcode", this.unknown_reject_opcode, 8, UVM_HEX);
                if (opcode == 8'h16)
              	begin
                    printer.print_string("LL Control PDU", "LL_PHY_REQ");
                    printer.print_field("tx_phys", this.tx_phys, 8, UVM_HEX);
                    printer.print_field("rx_phys", this.rx_phys, 8, UVM_HEX);
              	end
                if (opcode == 8'h17)
              	begin
                    printer.print_string("LL Control PDU", "LL_PHY_RSP");
                    printer.print_field("tx_phys", this.tx_phys, 8, UVM_HEX);
                    printer.print_field("rx_phys", this.rx_phys, 8, UVM_HEX);
              	end
                if (opcode == 8'h18)
              	begin
                    printer.print_string("LL Control PDU", "LL_PHY_UPDATE_IND");
                    printer.print_field("m_to_s_phy", this.m_to_s_phy, 8, UVM_HEX);
                    printer.print_field("s_to_m_phy", this.s_to_m_phy, 8, UVM_HEX);
                    printer.print_field("instant", this.instant, 16, UVM_HEX);
              	end
                if (opcode == 8'h19)
              	begin
                    printer.print_string("LL Control PDU", "LL_MIN_USED_CHANNELS_IND");
                    printer.print_field("phys", this.phys, 8, UVM_HEX);
                    printer.print_field("minusedchannels", this.minusedchannels, 8, UVM_HEX);
              	end
                if (opcode == 8'h14)
              	begin
                    printer.print_string("LL Control PDU", "LL_LENGTH_REQ");
                    printer.print_field("maxrxoctets", this.maxrxoctets, 16, UVM_HEX);
                    printer.print_field("maxrxtime", this.maxrxtime, 16, UVM_HEX);
                    printer.print_field("maxtxoctets", this.maxrxoctets, 16, UVM_HEX);
                    printer.print_field("maxtxtime", this.maxrxtime, 16, UVM_HEX);
              	end
                if (opcode == 8'h15)
              	begin
                    printer.print_string("LL Control PDU", "LL_LENGTH_RSP");
                    printer.print_field("maxrxoctets", this.maxrxoctets, 16, UVM_HEX);
                    printer.print_field("maxrxtime", this.maxrxtime, 16, UVM_HEX);
                    printer.print_field("maxtxoctets", this.maxrxoctets, 16, UVM_HEX);
                    printer.print_field("maxtxtime", this.maxrxtime, 16, UVM_HEX);
              	end
            end
            if (enc)  printer.print_field("mic", this.mic, 32, UVM_HEX);
        end
        printer.print_field("crc", this.crc, 24, UVM_HEX);
    endfunction



`endif              
