`ifndef EVENT_NAMES_PKG_SV
`define EVENT_NAMES_PKG_SV

package event_names_pkg;

  `define EVENT_NAMES { \
      "CCS_ERR0", "CCS_ERR1", "CCS_ERR2", \
      "CCX0_ERR0", "CCX0_ERR1", "CCX0_ERR2", \
      "CCX1_ERR0", "CCX1_ERR1", "CCX1_ERR2", \
      "CPX_ERR0", "CPX_ERR1", "CPX_ERR2", \
      "MPAM_ERR2" }
  `define ACXL_NUM_DEVICE 2
 
endpackage

`endif

