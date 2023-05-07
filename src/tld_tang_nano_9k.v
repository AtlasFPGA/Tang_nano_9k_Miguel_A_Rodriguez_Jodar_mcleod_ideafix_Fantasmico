`timescale 1ns / 1ns
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:55:26 06/21/2018 
// Design Name: 
// Module Name:    tld_zxuno 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module tld_tang_nano_9k (
    input wire clk27M,

    output wire reset, 

	input wire [1:0] 	BTN,	// BTN[1]=reset

// HDMI
	output wire      tmds_clk_n,
	output wire      tmds_clk_p,
	output wire [2:0] tmds_d_n,
	output wire [2:0] tmds_d_p

  );

  wire [7:0] r8b,g8b,b8b;
  reg clk125m;
  wire clk252m;
  wire hsync;
  wire vsync;
  wire hblank;
  
  wire pll_lock2;

  wire breset = ~BTN[1];

 // assign r = r8b[7:2]; // como solo tenemos 6 bits por componente de color, asignamos de los 8 bits 
 // assign g = g8b[7:2]; // originales de cada color solo los 6 bits mas significativos 
 // assign b = b8b[7:2]; // (esto en ZX-UNO cambiaria a los 3 bits mas significativos)
	 
  wire clkvga;
  // cambiar el contenido de este modulo (reloj_bwin) si hay que cambiar la frecuencia del reloj
  // si es que hemos cambiado el ModeLine en videosyncs.v para generar otra frecuencia distinta

  wire clk_p, clk_p5;	// p5:125.875  p:25.175
  Gowin_rPLL2 u_pll (.clkin(clk27M), .clkout(clk_p5), .lock(pll_lock2)); //, .lock(pll_lock2) );
  Gowin_CLKDIV u_div_5 ( .clkout(clk_p), .hclkin(clk_p5), .resetn(pll_lock2)); //, .resetn(pll_lock2) );

 svo_hdmi_out u_hdmi (
	//.clk(clk_p),
	.resetn(~breset),//(sys_resetn),
	// video clocks
	.clk_pixel(clk_p),
	.clk_5x_pixel(clk_p5),
	.locked(pll_lock2),
	// input VGA
	.rout(r8b[7:2]),
	.gout(g8b[7:2]),
	.bout(b8b[7:2]),
	.hsync_n(hsync),
	.vsync_n(vsync),
	.hblnk_n(~hblank),
	// output signals
	.tmds_clk_n(tmds_clk_n),
	.tmds_clk_p(tmds_clk_p),
	.tmds_d_n(tmds_d_n),
	.tmds_d_p(tmds_d_p),
	.tmds_ts()
);

  fantasma_rebotando el_ejemplo (
    .clk(clk_p),
    .r(r8b),
    .g(g8b),
    .b(b8b),
	.hblank(hblank),
    .hsync(hsync),
    .vsync(vsync)
    );  


 
	 	 
endmodule

`default_nettype wire