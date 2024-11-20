`ifndef MY_ENV_SV
`define MY_ENV_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
import ccs_sb_pkg::*;
import ccx_sb_pkg::*;
import cpx_sb_pkg::*;
import mpam_sb_pkg::*;
import event_names_pkg::*;

class my_env extends uvm_env;
  `uvm_component_utils(my_env)

  uvm_event_pool event_pool;
  ccs_sb ccs;
  ccx_sb ccx[`ACXL_NUM_DEVICE];
  cpx_sb cpx;
  mpam_sb mpam;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    event_pool = new("event_pool");
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Instantiate scoreboards
    ccs = ccs_sb::type_id::create("ccs", this);
    for (int i = 0; i < `ACXL_NUM_DEVICE; i++) begin
      ccx[i] = ccx_sb::type_id::create($sformatf("ccx%d", i), this);
    end
    cpx = cpx_sb::type_id::create("cpx", this);
    mpam = mpam_sb::type_id::create("mpam", this);

    // Initialize events in the event pool with custom names
    foreach (`EVENT_NAMES[i]) begin
      event_pool.get(`EVENT_NAMES[i]);
    end

    // Set the event pool as a global resource
    uvm_resource_db#(uvm_event_pool)::set("", "global_event_pool", event_pool, this);
  endfunction
endclass

`endif

