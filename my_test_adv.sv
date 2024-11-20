`ifndef MY_TEST_SV
`define MY_TEST_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
import my_env_pkg::*;
import ccs_sb_pkg::*;
import ccx_sb_pkg::*;
import cpx_sb_pkg::*;
import mpam_sb_pkg::*;
import event_names_pkg::*;

class my_test extends uvm_test;
  `uvm_component_utils(my_test)

  my_env env;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = my_env::type_id::create("env", this);
  endfunction

  task main_phase(uvm_phase phase);
    uvm_event_pool event_pool;
    if (!uvm_resource_db#(uvm_event_pool)::get_global(null, "global_event_pool", event_pool))
      `uvm_fatal("EVENT_POOL", "Failed to get global event pool");

    fork
      foreach (`EVENT_NAMES[i]) begin
        uvm_event event = event_pool.get(`EVENT_NAMES[i]);
        fork
          event.wait_trigger();
          // Reset the corresponding counters in the scoreboard
          if (`EVENT_NAMES[i] == "CCX0_ERR0") begin
            env.ccx[0].reset_DeCnt();
          end
          else if (`EVENT_NAMES[i] == "CCX0_ERR1") begin
            env.ccx[0].reset_UcCnt();
          end
          else if (`EVENT_NAMES[i] == "CCX0_ERR2") begin
            env.ccx[0].reset_SwCnt();
          end
          else if (`EVENT_NAMES[i] == "CCX1_ERR0") begin
            env.ccx[1].reset_DeCnt();
          end
          else if (`EVENT_NAMES[i] == "CCX1_ERR1") begin
            env.ccx[1].reset_UcCnt();
          end
          else if (`EVENT_NAMES[i] == "CCX1_ERR2") begin
            env.ccx[1].reset_SwCnt();
          end
          else if (`EVENT_NAMES[i] == "CCS_ERR0") begin
            env.ccs.reset_DeCnt();
          end
          else if (`EVENT_NAMES[i] == "CCS_ERR1") begin
            env.ccs.reset_UcCnt();
          end
          else if (`EVENT_NAMES[i] == "CCS_ERR2") begin
            env.ccs.reset_SwCnt();
          end
          else if (`EVENT_NAMES[i] == "CPX_ERR0") begin
            env.cpx.reset_DeCnt();
          end
          else if (`EVENT_NAMES[i] == "CPX_ERR1") begin
            env.cpx.reset_UcCnt();
          end
          else if (`EVENT_NAMES[i] == "CPX_ERR2") begin
            env.cpx.reset_SwCnt();
          end
          else if (`EVENT_NAMES[i] == "MPAM_ERR2") begin
            env.mpam.reset_SwCnt();
          end
          $display("Test: %s event received at time %t", `EVENT_NAMES[i], $time);
        join_none
      end
    join_any
  endtask

  task post_main_phase(uvm_phase phase);
    uvm_event_pool event_pool;
    if (!uvm_resource_db#(uvm_event_pool)::get_global(null, "global_event_pool", event_pool))
      `uvm_fatal("EVENT_POOL", "Failed to get global event pool");

    // Wait for events to be triggered
    fork
      foreach (`EVENT_NAMES[i]) begin
        uvm_event event = event_pool.get(`EVENT_NAMES[i]);
        fork
          event.wait_trigger();
          $display("Test: %s event received at time %t", `EVENT_NAMES[i], $time);
        join_none
      end
    join_any
  endtask
endclass

`endif

