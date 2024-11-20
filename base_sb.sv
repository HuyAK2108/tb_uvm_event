`ifndef BASE_SB_SV
`define BASE_SB_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
import my_env_pkg::*;

class base_sb extends uvm_scoreboard;
  `uvm_component_utils(base_sb)

  uvm_event_pool event_pool;
  int SwCnt;
  int UcCnt;
  int DeCnt;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task trigger_event(string event_name, int cnt_value);
    if (event_pool == null) begin
      if (!uvm_resource_db#(uvm_event_pool)::get_global(null, "global_event_pool", event_pool))
        `uvm_fatal("EVENT_POOL", "Failed to get global event pool");
    end

    uvm_event event = event_pool.get(event_name);

    fork
      while (1) begin
        if (cnt_value == 1) begin
          event.trigger();
          $display("Scoreboard: %s event triggered at time %t", event_name, $time);
        end
        #10ns; // Delay between checks
      end
    join_none
  endtask

  virtual function void report_phase(uvm_phase phase);
    $display("%s: SwCnt=%0d, UcCnt=%0d, DeCnt=%0d", get_name(), SwCnt, UcCnt, DeCnt);
  endfunction
endclass

`endif

