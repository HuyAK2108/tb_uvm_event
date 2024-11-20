`ifndef CCX_SB_SV
`define CCX_SB_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
import my_env_pkg::*;
import base_sb_pkg::*;
import event_names_pkg::*;

class ccx_sb extends base_sb;
  `uvm_component_utils(ccx_sb)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    SwCnt = 1; // Set SwCnt to 1
    UcCnt = 1; // Set UcCnt to 1
    DeCnt = 1; // Set DeCnt to 1

    string instance_name = get_name();
    for (int i = 0; i < `ACXL_NUM_DEVICE; i++) begin
      if (instance_name == $sformatf("ccx%d", i)) begin
        // Trigger CCX_ERR events based on counters
        trigger_event($sformatf("CCX%d_ERR0", i), DeCnt);
        trigger_event($sformatf("CCX%d_ERR1", i), UcCnt);
        trigger_event($sformatf("CCX%d_ERR2", i), SwCnt);
      end
    end
  endtask

  // Override report_phase
  function void report_phase(uvm_phase phase);
    super.report_phase(phase); // Call base class report_phase
    $display("ccx_sb specific reporting for instance %s: SwCnt=%0d, UcCnt=%0d, DeCnt=%0d", get_name(), SwCnt, UcCnt, DeCnt);
  endfunction
endclass

`endif

