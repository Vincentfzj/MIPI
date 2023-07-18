set_property PACKAGE_PIN AE10 [get_ports mipi_gpio]
set_property IOSTANDARD LVCMOS33 [get_ports mipi_gpio]

set_property PACKAGE_PIN Y9 [get_ports mipi_scl]
set_property PACKAGE_PIN AA8 [get_ports mipi_sda]

set_property IOSTANDARD LVCMOS33 [get_ports mipi_scl]
set_property IOSTANDARD LVCMOS33 [get_ports mipi_sda]


set_property PULLUP true [get_ports mipi_scl]
set_property PULLUP true [get_ports mipi_sda]

set_property PACKAGE_PIN W8 [get_ports mipi_clk_p]
##set_property PACKAGE_PIN Y8 [get_ports mipi_clk_n]
##set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_clk_n]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_clk_p]


set_property PACKAGE_PIN U8 [get_ports {mipi_data_p[1]}]
set_property PACKAGE_PIN U9 [get_ports {mipi_data_p[0]}]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports {mipi_data_p[1]}]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports {mipi_data_n[1]}]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports {mipi_data_p[0]}]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports {mipi_data_n[0]}]


####################### user add  MIPI_DPHY_DCI################
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets mipi_top_inst/mipi_phy_inst/IBUFDS_DPHY_inst_uclk/HSRX_O]
set_property UNAVAILABLE_DURING_CALIBRATION TRUE [get_ports mipi_clk_p]





set_property DIFF_TERM_ADV TERM_100 [get_ports {mipi_data_p[1]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {mipi_data_n[1]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {mipi_data_p[0]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {mipi_data_n[0]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_clk_p]
##set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_clk_n]
set_property PULLUP true [get_ports mipi_gpio]











