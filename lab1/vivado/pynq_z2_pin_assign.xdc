
#set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS33} [get_ports rst_i]

# Clock signal
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports clk_i]
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 5} [get_ports {clk_i}];

# LEDs
set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports led[0]]
set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports led[1]]
set_property -dict {PACKAGE_PIN N16 IOSTANDARD LVCMOS33} [get_ports led[2]]
set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33} [get_ports led[3]]

# Switches
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33} [get_ports sw[0]]
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS33} [get_ports sw[1]]

# Push buttons
set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS33} [get_ports btn[0]]
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33} [get_ports btn[1]]
set_property -dict {PACKAGE_PIN L20 IOSTANDARD LVCMOS33} [get_ports btn[2]]
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS33} [get_ports btn[3]]



