`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Company: 		Microporcessor & Hardware Lab, TUC
// Engineer: 		ansotiropoulos
//
// Design Name: 	FPGA-based Stream Microbench
// Module Name:    	vmemctrl
//
// Target Devices: 	XC6VLX760
// Tool versions: 	ISE 12.4
//
//////////////////////////////////////////////////////////////////////////////////

module CNV_AGU (

    input           clk,
    input           reset,
    input           start,
    output          finish,

    // Params
    input	[47:0]	addr_rd,
    input	[47:0]	addr_wr,
    input	[5:0]	init,

    input 	[1:0] 	ae_id,

    input	[31:0]	st_psize,
    input 	[63:0]	ae_reg,

    input 	[15:0]	stream_stall_wr_rq,
    input 	[15:0]	stream_stall_rd_rq,

    output 	[15:0]	stream_pop,

    // Port 0
    input			mc_rd_rq_stall_0,
    input			mc_wr_rq_stall_0,
    input	[31:0]	mc_rsp_rdctl_0,
//  input	[63:0]	mc_rsp_data_0,
//  input			mc_rsp_push_0,
    input 			mc_rsp_flush_cmplt_0,

    output			mc_req_ld_0,
    output			mc_req_st_0,
    output	[47:0]	mc_req_vadr_0,
    output	[1:0]	mc_req_size_0,
    output			mc_req_flush_0,
//  output	[63:0]	mc_req_wrd_rdctl_0,
//  output			mc_rsp_stall_0,

    // Port 1
    input			mc_rd_rq_stall_1,
    input			mc_wr_rq_stall_1,
    input	[31:0]	mc_rsp_rdctl_1,
//  input	[63:0]	mc_rsp_data_1,
//  input			mc_rsp_push_1,
    input 			mc_rsp_flush_cmplt_1,

    output			mc_req_ld_1,
    output			mc_req_st_1,
    output	[47:0]	mc_req_vadr_1,
    output	[1:0]	mc_req_size_1,
    output			mc_req_flush_1,
//  output	[63:0]	mc_req_wrd_rdctl_1,
//  output			mc_rsp_stall_1,

    // Port 2
    input			mc_rd_rq_stall_2,
    input			mc_wr_rq_stall_2,
    input	[31:0]	mc_rsp_rdctl_2,
//  input	[63:0]	mc_rsp_data_2,
//  input			mc_rsp_push_2,
    input 			mc_rsp_flush_cmplt_2,

    output			mc_req_ld_2,
    output			mc_req_st_2,
    output	[47:0]	mc_req_vadr_2,
    output	[1:0]	mc_req_size_2,
    output			mc_req_flush_2,
//  output	[63:0]	mc_req_wrd_rdctl_2,
//  output			mc_rsp_stall_2,

    // Port 3
    input			mc_rd_rq_stall_3,
    input			mc_wr_rq_stall_3,
    input	[31:0]	mc_rsp_rdctl_3,
//  input	[63:0]	mc_rsp_data_3,
//  input			mc_rsp_push_3,
    input 			mc_rsp_flush_cmplt_3,

    output			mc_req_ld_3,
    output			mc_req_st_3,
    output	[47:0]	mc_req_vadr_3,
    output	[1:0]	mc_req_size_3,
    output			mc_req_flush_3,
//  output	[63:0]	mc_req_wrd_rdctl_3,
//  output			mc_rsp_stall_3,

    // Port 4
    input			mc_rd_rq_stall_4,
    input			mc_wr_rq_stall_4,
    input	[31:0]	mc_rsp_rdctl_4,
//  input	[63:0]	mc_rsp_data_4,
//  input			mc_rsp_push_4,
    input 			mc_rsp_flush_cmplt_4,

    output			mc_req_ld_4,
    output			mc_req_st_4,
    output	[47:0]	mc_req_vadr_4,
    output	[1:0]	mc_req_size_4,
    output			mc_req_flush_4,
//  output	[63:0]	mc_req_wrd_rdctl_4,
//  output			mc_rsp_stall_4,

    // Port 5
    input			mc_rd_rq_stall_5,
    input			mc_wr_rq_stall_5,
    input	[31:0]	mc_rsp_rdctl_5,
//  input	[63:0]	mc_rsp_data_5,
//  input			mc_rsp_push_5,
    input 			mc_rsp_flush_cmplt_5,

    output			mc_req_ld_5,
    output			mc_req_st_5,
    output	[47:0]	mc_req_vadr_5,
    output	[1:0]	mc_req_size_5,
    output			mc_req_flush_5,
//  output	[63:0]	mc_req_wrd_rdctl_5,
//  output			mc_rsp_stall_5,

    // Port 6
    input			mc_rd_rq_stall_6,
    input			mc_wr_rq_stall_6,
    input	[31:0]	mc_rsp_rdctl_6,
//  input	[63:0]	mc_rsp_data_6,
//  input			mc_rsp_push_6,
    input 			mc_rsp_flush_cmplt_6,

    output			mc_req_ld_6,
    output			mc_req_st_6,
    output	[47:0]	mc_req_vadr_6,
    output	[1:0]	mc_req_size_6,
    output			mc_req_flush_6,
//  output	[63:0]	mc_req_wrd_rdctl_6,
//  output			mc_rsp_stall_6,

    // Port 7
    input			mc_rd_rq_stall_7,
    input			mc_wr_rq_stall_7,
    input	[31:0]	mc_rsp_rdctl_7,
//  input	[63:0]	mc_rsp_data_7,
//  input			mc_rsp_push_7,
    input 			mc_rsp_flush_cmplt_7,

    output			mc_req_ld_7,
    output			mc_req_st_7,
    output	[47:0]	mc_req_vadr_7,
    output	[1:0]	mc_req_size_7,
    output			mc_req_flush_7,
//  output	[63:0]	mc_req_wrd_rdctl_7,
//  output			mc_rsp_stall_7,

    // Port 8
    input			mc_rd_rq_stall_8,
    input			mc_wr_rq_stall_8,
    input	[31:0]	mc_rsp_rdctl_8,
//  input	[63:0]	mc_rsp_data_8,
//  input			mc_rsp_push_8,
    input 			mc_rsp_flush_cmplt_8,

    output			mc_req_ld_8,
    output			mc_req_st_8,
    output	[47:0]	mc_req_vadr_8,
    output	[1:0]	mc_req_size_8,
    output			mc_req_flush_8,
//  output	[63:0]	mc_req_wrd_rdctl_8,
//  output			mc_rsp_stall_8,

    // Port 9
    input			mc_rd_rq_stall_9,
    input			mc_wr_rq_stall_9,
    input	[31:0]	mc_rsp_rdctl_9,
//  input	[63:0]	mc_rsp_data_9,
//  input			mc_rsp_push_9,
    input 			mc_rsp_flush_cmplt_9,

    output			mc_req_ld_9,
    output			mc_req_st_9,
    output	[47:0]	mc_req_vadr_9,
    output	[1:0]	mc_req_size_9,
    output			mc_req_flush_9,
//  output	[63:0]	mc_req_wrd_rdctl_9,
//  output			mc_rsp_stall_9,

    // Port 10
    input			mc_rd_rq_stall_10,
    input			mc_wr_rq_stall_10,
    input	[31:0]	mc_rsp_rdctl_10,
//  input	[63:0]	mc_rsp_data_10,
//  input			mc_rsp_push_10,
    input 			mc_rsp_flush_cmplt_10,

    output			mc_req_ld_10,
    output			mc_req_st_10,
    output	[47:0]	mc_req_vadr_10,
    output	[1:0]	mc_req_size_10,
    output			mc_req_flush_10,
//  output	[63:0]	mc_req_wrd_rdctl_10,
//  output			mc_rsp_stall_10,

    // Port 11
    input			mc_rd_rq_stall_11,
    input			mc_wr_rq_stall_11,
    input	[31:0]	mc_rsp_rdctl_11,
//  input	[63:0]	mc_rsp_data_11,
//  input			mc_rsp_push_11,
    input 			mc_rsp_flush_cmplt_11,

    output			mc_req_ld_11,
    output			mc_req_st_11,
    output	[47:0]	mc_req_vadr_11,
    output	[1:0]	mc_req_size_11,
    output			mc_req_flush_11,
//  output	[63:0]	mc_req_wrd_rdctl_11,
//  output			mc_rsp_stall_11,


    // Port 12
    input			mc_rd_rq_stall_12,
    input			mc_wr_rq_stall_12,
    input	[31:0]	mc_rsp_rdctl_12,
//  input	[63:0]	mc_rsp_data_12,
//  input			mc_rsp_push_12,
    input 			mc_rsp_flush_cmplt_12,

    output			mc_req_ld_12,
    output			mc_req_st_12,
    output	[47:0]	mc_req_vadr_12,
    output	[1:0]	mc_req_size_12,
    output			mc_req_flush_12,
//  output	[63:0]	mc_req_wrd_rdctl_12,
//  output			mc_rsp_stall_12,

    // Port 13
    input			mc_rd_rq_stall_13,
    input			mc_wr_rq_stall_13,
    input	[31:0]	mc_rsp_rdctl_13,
//  input	[63:0]	mc_rsp_data_13,
//  input			mc_rsp_push_13,
    input 			mc_rsp_flush_cmplt_13,

    output			mc_req_ld_13,
    output			mc_req_st_13,
    output	[47:0]	mc_req_vadr_13,
    output	[1:0]	mc_req_size_13,
    output			mc_req_flush_13,
//  output	[63:0]	mc_req_wrd_rdctl_13,
//  output			mc_rsp_stall_13,

    // Port 14
    input			mc_rd_rq_stall_14,
    input			mc_wr_rq_stall_14,
    input	[31:0]	mc_rsp_rdctl_14,
//  input	[63:0]	mc_rsp_data_14,
//  input			mc_rsp_push_14,
    input 			mc_rsp_flush_cmplt_14,

    output			mc_req_ld_14,
    output			mc_req_st_14,
    output	[47:0]	mc_req_vadr_14,
    output	[1:0]	mc_req_size_14,
    output			mc_req_flush_14,
//  output	[63:0]	mc_req_wrd_rdctl_14,
//  output			mc_rsp_stall_14,

    // Port 15
    input			mc_rd_rq_stall_15,
    input			mc_wr_rq_stall_15,
    input	[31:0]	mc_rsp_rdctl_15,
//  input	[63:0]	mc_rsp_data_15,
//  input			mc_rsp_push_15,
    input 			mc_rsp_flush_cmplt_15,

    output			mc_req_ld_15,
    output			mc_req_st_15,
    output	[47:0]	mc_req_vadr_15,
    output	[1:0]	mc_req_size_15,
    output			mc_req_flush_15
//  output	[63:0]	mc_req_wrd_rdctl_15,
//  output			mc_rsp_stall_15
);

genvar i;
integer k;

wire [15:0] mc_finish, fin;
wire [15:0] fifo_rd_en;
wire [15:0] fifo_full;
wire [15:0] fifo_empty;
wire [47:0] req_vadr[15:0];
wire [16:0] mc_req_ld;
wire [15:0] mc_req_st;
wire [16:0] mc_rd_rq_stall;
wire [15:0] mc_wr_rq_stall;

reg [47:0] mc_req_vadr_reg[15:0];
reg [15:0] mc_req_ld_reg;
reg [15:0] mc_req_st_reg;
reg [31:0] psize;
reg [15:0] odd_even = 16'b1010101010101010;

initial
begin
    for (k=0; k<16; k=k+1) begin
        mc_req_vadr_reg[k] = {38'd0,k[0],k[3:1],6'd0};
    end
end


// 	Hook up
assign mc_req_size_0        = 2'd3;
assign mc_req_size_1        = 2'd3;
assign mc_req_size_2        = 2'd3;
assign mc_req_size_3        = 2'd3;
assign mc_req_size_4        = 2'd3;
assign mc_req_size_5        = 2'd3;
assign mc_req_size_6        = 2'd3;
assign mc_req_size_7        = 2'd3;
assign mc_req_size_8        = 2'd3;
assign mc_req_size_9        = 2'd3;
assign mc_req_size_10       = 2'd3;
assign mc_req_size_11       = 2'd3;
assign mc_req_size_12       = 2'd3;
assign mc_req_size_13       = 2'd3;
assign mc_req_size_14       = 2'd3;
assign mc_req_size_15       = 2'd3;

assign mc_req_flush_0       = 1'b0;
assign mc_req_flush_1       = 1'b0;
assign mc_req_flush_2       = 1'b0;
assign mc_req_flush_3       = 1'b0;
assign mc_req_flush_4       = 1'b0;
assign mc_req_flush_5       = 1'b0;
assign mc_req_flush_6       = 1'b0;
assign mc_req_flush_7       = 1'b0;
assign mc_req_flush_8       = 1'b0;
assign mc_req_flush_9       = 1'b0;
assign mc_req_flush_10      = 1'b0;
assign mc_req_flush_11      = 1'b0;
assign mc_req_flush_12      = 1'b0;
assign mc_req_flush_13      = 1'b0;
assign mc_req_flush_14      = 1'b0;
assign mc_req_flush_15      = 1'b0;

assign mc_rd_rq_stall[0]    = mc_rd_rq_stall_0;
assign mc_rd_rq_stall[1]    = mc_rd_rq_stall_1;
assign mc_rd_rq_stall[2]    = mc_rd_rq_stall_2;
assign mc_rd_rq_stall[3]    = mc_rd_rq_stall_3;
assign mc_rd_rq_stall[4]    = mc_rd_rq_stall_4;
assign mc_rd_rq_stall[5]    = mc_rd_rq_stall_5;
assign mc_rd_rq_stall[6]    = mc_rd_rq_stall_6;
assign mc_rd_rq_stall[7]    = mc_rd_rq_stall_7;
assign mc_rd_rq_stall[8]    = mc_rd_rq_stall_8;
assign mc_rd_rq_stall[9]    = mc_rd_rq_stall_9;
assign mc_rd_rq_stall[10]   = mc_rd_rq_stall_10;
assign mc_rd_rq_stall[11]   = mc_rd_rq_stall_11;
assign mc_rd_rq_stall[12]   = mc_rd_rq_stall_12;
assign mc_rd_rq_stall[13]   = mc_rd_rq_stall_13;
assign mc_rd_rq_stall[14]   = mc_rd_rq_stall_14;
assign mc_rd_rq_stall[15]   = mc_rd_rq_stall_15;

assign mc_wr_rq_stall[0]    = mc_wr_rq_stall_0;
assign mc_wr_rq_stall[1]    = mc_wr_rq_stall_1;
assign mc_wr_rq_stall[2]    = mc_wr_rq_stall_2;
assign mc_wr_rq_stall[3]    = mc_wr_rq_stall_3;
assign mc_wr_rq_stall[4]    = mc_wr_rq_stall_4;
assign mc_wr_rq_stall[5]    = mc_wr_rq_stall_5;
assign mc_wr_rq_stall[6]    = mc_wr_rq_stall_6;
assign mc_wr_rq_stall[7]    = mc_wr_rq_stall_7;
assign mc_wr_rq_stall[8]    = mc_wr_rq_stall_8;
assign mc_wr_rq_stall[9]    = mc_wr_rq_stall_9;
assign mc_wr_rq_stall[10]   = mc_wr_rq_stall_10;
assign mc_wr_rq_stall[11]   = mc_wr_rq_stall_11;
assign mc_wr_rq_stall[12]   = mc_wr_rq_stall_12;
assign mc_wr_rq_stall[13]   = mc_wr_rq_stall_13;
assign mc_wr_rq_stall[14]   = mc_wr_rq_stall_14;
assign mc_wr_rq_stall[15]   = mc_wr_rq_stall_15;

assign mc_req_vadr_0    = mc_req_vadr_reg[0];
assign mc_req_vadr_1    = mc_req_vadr_reg[1];
assign mc_req_vadr_2    = mc_req_vadr_reg[2];
assign mc_req_vadr_3    = mc_req_vadr_reg[3];
assign mc_req_vadr_4    = mc_req_vadr_reg[4];
assign mc_req_vadr_5    = mc_req_vadr_reg[5];
assign mc_req_vadr_6    = mc_req_vadr_reg[6];
assign mc_req_vadr_7    = mc_req_vadr_reg[7];
assign mc_req_vadr_8    = mc_req_vadr_reg[8];
assign mc_req_vadr_9    = mc_req_vadr_reg[9];
assign mc_req_vadr_10   = mc_req_vadr_reg[10];
assign mc_req_vadr_11   = mc_req_vadr_reg[11];
assign mc_req_vadr_12   = mc_req_vadr_reg[12];
assign mc_req_vadr_13   = mc_req_vadr_reg[13];
assign mc_req_vadr_14   = mc_req_vadr_reg[14];
assign mc_req_vadr_15   = mc_req_vadr_reg[15];

assign mc_req_ld_0      = mc_req_ld_reg[0];
assign mc_req_ld_1      = mc_req_ld_reg[1];
assign mc_req_ld_2      = mc_req_ld_reg[2];
assign mc_req_ld_3      = mc_req_ld_reg[3];
assign mc_req_ld_4      = mc_req_ld_reg[4];
assign mc_req_ld_5      = mc_req_ld_reg[5];
assign mc_req_ld_6      = mc_req_ld_reg[6];
assign mc_req_ld_7      = mc_req_ld_reg[7];
assign mc_req_ld_8      = mc_req_ld_reg[8];
assign mc_req_ld_9      = mc_req_ld_reg[9];
assign mc_req_ld_10     = mc_req_ld_reg[10];
assign mc_req_ld_11     = mc_req_ld_reg[11];
assign mc_req_ld_12     = mc_req_ld_reg[12];
assign mc_req_ld_13     = mc_req_ld_reg[13];
assign mc_req_ld_14     = mc_req_ld_reg[14];
assign mc_req_ld_15     = mc_req_ld_reg[15];

assign mc_req_st_0      = mc_req_st_reg[0];
assign mc_req_st_1      = mc_req_st_reg[1];
assign mc_req_st_2      = mc_req_st_reg[2];
assign mc_req_st_3      = mc_req_st_reg[3];
assign mc_req_st_4      = mc_req_st_reg[4];
assign mc_req_st_5      = mc_req_st_reg[5];
assign mc_req_st_6      = mc_req_st_reg[6];
assign mc_req_st_7      = mc_req_st_reg[7];
assign mc_req_st_8      = mc_req_st_reg[8];
assign mc_req_st_9      = mc_req_st_reg[9];
assign mc_req_st_10     = mc_req_st_reg[10];
assign mc_req_st_11     = mc_req_st_reg[11];
assign mc_req_st_12     = mc_req_st_reg[12];
assign mc_req_st_13     = mc_req_st_reg[13];
assign mc_req_st_14     = mc_req_st_reg[14];
assign mc_req_st_15     = mc_req_st_reg[15];

assign finish = mc_finish[1] && mc_finish[3] && mc_finish[5] && mc_finish[7] && mc_finish[9] && mc_finish[11] && mc_finish[13] && mc_finish[15];

always @(posedge clk) begin
    psize <= st_psize;
end

generate for (i=0; i<16; i=i+1) begin : ADDRADD

always @(posedge clk) begin
    if (reset) begin
        mc_req_vadr_reg[i]  <= {38'd0,i[0],i[3:1],6'd0};
    end
    else begin
        mc_req_vadr_reg[i]  <= addr_rd + req_vadr[i];
    end
end

always @(posedge clk) begin
    mc_req_st_reg[i] <= mc_req_st[i];
end

always @(posedge clk) begin
    mc_req_ld_reg[i] <= mc_req_ld[i];
end

assign fifo_full[i] = stream_stall_rd_rq[i];
assign fifo_empty[i] = stream_stall_wr_rq[i];
assign stream_pop[i] = fifo_rd_en[i];

if (i%2==0) begin

    AGU MEM_CTRL
    (
        .CLK 			(clk),
        .RST 			(reset),
        .START 			(start),
        .PSIZE 			(psize),
        .AEID			(ae_id),
        .PEID			(i[3:1]),
        .ODDEVEN		(odd_even[i]),
        .AEREG			(ae_reg),
        .INIT			(init),
        .MC_RQ_STALL	(mc_rd_rq_stall[i]),
        .FIFO_STALL 	(fifo_full[i]),
        .MC_RQ_ADDR 	(req_vadr[i]),
        .MC_RQ_EN 		(mc_req_ld[i]),
        .FIFO_POP 		(fifo_rd_en[i]),
        .FINISH 		(mc_finish[i])
    );

    assign mc_req_st[i] = 1'b0;

end
else begin

    AGU MEM_CTRL
    (
        .CLK 			(clk),
        .RST 			(reset),
        .START 			(start),
        .PSIZE 			(psize),
        .AEID			(ae_id),
        .PEID			(i[3:1]),
        .ODDEVEN		(odd_even[i]),
        .AEREG			(ae_reg),
        .INIT			(init),
        .MC_RQ_STALL	(mc_wr_rq_stall[i]),
        .FIFO_STALL 	(fifo_empty[i]),
        .MC_RQ_ADDR 	(req_vadr[i]),
        .MC_RQ_EN 		(mc_req_st[i]),
        .FIFO_POP 		(fifo_rd_en[i]),
        .FINISH 		(mc_finish[i])
    );

    assign mc_req_ld[i] = 1'b0;

end

end endgenerate

// generate for (i=0; i<16; i=i+2) begin : MC_RD
//
// MC_CTRL_PROG MEM_CTRL
// (
//     .CLK 			(clk),
//     .RST 			(reset),
//     .START 			(start),
//     .PSIZE 			(psize),
//     .AEID			(ae_id),
//     .PEID			(i[3:1]),
//     .ODDEVEN		(odd_even[i]),
//     .AEREG			(ae_reg),
//     .INIT			(init),
//     .MC_RQ_STALL	(mc_rd_rq_stall[i]),
//     .FIFO_STALL 	(fifo_full[i]),
//     .MC_RQ_ADDR 	(req_vadr[i]),
//     .MC_RQ_EN 		(mc_req_ld[i]),
//     .FIFO_POP 		(fifo_rd_en[i]),
//     .FINISH 		(mc_finish[i])
// );
//
// assign mc_req_st[i] = 1'b0;
//
// end endgenerate

// generate for (i=1; i<16; i=i+2) begin : MC_WR
//
// MC_CTRL_PROG MEM_CTRL
// (
//     .CLK 			(clk),
//     .RST 			(reset),
//     .START 			(start),
//     .PSIZE 			(psize),
//     .AEID			(ae_id),
//     .PEID			(i[3:1]),
//     .ODDEVEN		(odd_even[i]),
//     .AEREG			(ae_reg),
//     .INIT			(init),
//     .MC_RQ_STALL	(mc_wr_rq_stall[i]),
//     .FIFO_STALL 	(fifo_empty[i]),
//     .MC_RQ_ADDR 	(req_vadr[i]),
//     .MC_RQ_EN 		(mc_req_st[i]),
//     .FIFO_POP 		(fifo_rd_en[i]),
//     .FINISH 		(mc_finish[i])
// );
//
// assign mc_req_ld[i] = 1'b0;
//
// end endgenerate

endmodule