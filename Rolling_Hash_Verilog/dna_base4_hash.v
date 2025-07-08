`timescale 1ns / 1ps
module dna_base4_hash (
    input clk,
    input rst,
    input [7:0] char_in,
    output reg [31:0] hash_out,
    output reg done
);
    parameter K = 4;
    parameter BASE = 4;

    reg [3:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            hash_out <= 0;
            count <= 0;
            done <= 0;
        end else begin
            if (count < K) begin
                case (char_in)
                    8'd65: hash_out <= hash_out * BASE + 2'd0; // A
                    8'd84: hash_out <= hash_out * BASE + 2'd1; // T
                    8'd67: hash_out <= hash_out * BASE + 2'd2; // C
                    8'd71: hash_out <= hash_out * BASE + 2'd3; // G
                    default: hash_out <= hash_out * BASE;
                endcase
                count <= count + 1;
                done <= 0;
            end else begin
                done <= 1;
            end
        end
    end
endmodule
