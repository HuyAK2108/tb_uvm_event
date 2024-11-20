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

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task post_main_phase(uvm_phase phase);
    uvm_event_pool event_pool;
    if (!uvm_resource_db#(uvm_event_pool)::get_global(null, "global_event_pool", event_pool))
      `uvm_fatal("EVENT_POOL", "Failed to get global event pool");

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

