# Timing Constraints - GoWIN EDA
# Board ACG525 - Clock 50MHz tai pin T9
create_clock -name clk -period 20 -waveform {0 10} [get_ports {clk}]
