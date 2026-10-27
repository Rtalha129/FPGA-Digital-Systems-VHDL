## Clock Signal (100 MHz)
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Push Buttons / Switches
set_property PACKAGE_PIN V17 [get_ports reset_n]					
	set_property IOSTANDARD LVCMOS33 [get_ports reset_n]
set_property PACKAGE_PIN V16 [get_ports sensor_ew]					
	set_property IOSTANDARD LVCMOS33 [get_ports sensor_ew]
set_property PACKAGE_PIN W16 [get_ports emergency]					
	set_property IOSTANDARD LVCMOS33 [get_ports emergency]

## LEDs for Traffic Lights (NS: LD2..LD0, EW: LD5..LD3)
set_property PACKAGE_PIN U16 [get_ports {lights_ns[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {lights_ns[0]}]
set_property PACKAGE_PIN E19 [get_ports {lights_ns[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {lights_ns[1]}]
set_property PACKAGE_PIN U19 [get_ports {lights_ns[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {lights_ns[2]}]
set_property PACKAGE_PIN V19 [get_ports {lights_ew[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {lights_ew[0]}]
set_property PACKAGE_PIN W18 [get_ports {lights_ew[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {lights_ew[1]}]
set_property PACKAGE_PIN U15 [get_ports {lights_ew[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {lights_ew[2]}]