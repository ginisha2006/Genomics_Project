`timescale 1ns / 1ps
module tb_needleman_wunsch;

    localparam REF_LEN = 15;
    localparam QUERY_LEN = 10;
    localparam BASE_WIDTH = 2;
    localparam ALIGN_LEN = REF_LEN + QUERY_LEN;

    reg clk;
    reg rst;
    reg [REF_LEN*BASE_WIDTH-1:0] ref_seq;
    reg [QUERY_LEN*BASE_WIDTH-1:0] query_seq;
    wire [ALIGN_LEN*BASE_WIDTH-1:0] aligned_ref_seq;
    wire [ALIGN_LEN*BASE_WIDTH-1:0] aligned_query_seq;
    wire [7:0] alignment_length;

    needleman_wunsch #(
        .REF_LEN(REF_LEN),
        .QUERY_LEN(QUERY_LEN),
        .BASE_WIDTH(BASE_WIDTH),
        .ALIGN_LEN(ALIGN_LEN)
    ) uut (
        .clk(clk),
        .rst(rst),
        .ref_seq(ref_seq),
        .query_seq(query_seq),
        .aligned_ref_seq(aligned_ref_seq),
        .aligned_query_seq(aligned_query_seq),
        .alignment_length(alignment_length)
    );

    always begin
        #5 clk = ~clk;
    end

    function [7:0] base_to_char(input [1:0] base);
        case (base)
            2'b00: base_to_char = "A";
            2'b01: base_to_char = "T";
            2'b10: base_to_char = "G";
            2'b11: base_to_char = "C";
            default: base_to_char = "-";
        endcase
    endfunction

    task print_alignment;
        integer i;
        reg [1:0] ref_b, query_b;
        begin
            $write("Aligned Reference: ");
            for (i = alignment_length - 1; i >= 0; i = i - 1) begin
                ref_b = aligned_ref_seq[i*2 +: 2];
                $write("%s", base_to_char(ref_b));
            end
            $write("\n");

            $write("Aligned Query   : ");
            for (i = alignment_length - 1; i >= 0; i = i - 1) begin
                query_b = aligned_query_seq[i*2 +: 2];
                $write("%s", base_to_char(query_b));
            end
            $write("\n");
        end
    endtask

    initial begin
        clk = 0;
        rst = 1;
        ref_seq = 0;
        query_seq = 0;
        #10;
        rst = 0;

        ref_seq = {2'b10, 2'b01, 2'b00, 2'b01, 2'b10, 2'b11, 2'b00, 2'b01, 2'b01, 2'b10, 2'b11, 2'b00, 2'b01, 2'b10, 2'b10};
        query_seq = {2'b00, 2'b01, 2'b10, 2'b11, 2'b00, 2'b01, 2'b01, 2'b10, 2'b11, 2'b00};
        #500;

        $display("\n>> Needleman-Wunsch Global Alignment Result:");
        print_alignment();
        $finish;
    end

endmodule