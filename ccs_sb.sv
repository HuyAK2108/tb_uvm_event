`ifndef CCS_SB_SV
`define CCS_SB_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
import my_env_pkg::*;
import base_sb_pkg::*;

class ccs_sb extends base_sb;
  `uvm_component_utils(ccs_sb)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    // Set SwCnt, UcCnt, and DeCnt values
    SwCnt = 1;
    UcCnt = 1;
    DeCnt = 1;

    // Trigger CCS_ERR events based on counters
    trigger_event("CCS_ERR0", DeCnt);
    trigger_event("CCS_ERR1", UcCnt);
    trigger_event("CCS_ERR2", SwCnt);
  endtask
endclass

`endif

