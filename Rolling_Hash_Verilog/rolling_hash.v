`timescale 1ns / 1ps
module rolling_hash (
    input wire [31:0] prev_hash,
    input wire [7:0] out_char,
    input wire [7:0] in_char,
    output reg [31:0] new_hash
);
    parameter BASE = 4;
    parameter K = 4;
    localparam BASE_POW = 64; // 4^(K-1)

    reg [1:0] out_val, in_val;

    always @(*) begin
        case (out_char)
            8'd65: out_val = 2'd0;
            8'd84: out_val = 2'd1;
            8'd67: out_val = 2'd2;
            8'd71: out_val = 2'd3;
            default: out_val = 2'd0;
        endcase

        case (in_char)
            8'd65: in_val = 2'd0;
            8'd84: in_val = 2'd1;
            8'd67: in_val = 2'd2;
            8'd71: in_val = 2'd3;
            default: in_val = 2'd0;
        endcase

        new_hash = (prev_hash - (out_val * BASE_POW)) * BASE + in_val;
    end
endmodule
