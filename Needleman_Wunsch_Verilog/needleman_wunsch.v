`timescale 1ns / 1ps
module needleman_wunsch #(
    parameter REF_LEN = 15,
    parameter QUERY_LEN = 10,
    parameter BASE_WIDTH = 2,
    parameter ALIGN_LEN = REF_LEN + QUERY_LEN
)(
    input clk,
    input rst,
    input [REF_LEN*BASE_WIDTH-1:0] ref_seq,
    input [QUERY_LEN*BASE_WIDTH-1:0] query_seq,
    output reg [ALIGN_LEN*BASE_WIDTH-1:0] aligned_ref_seq,
    output reg [ALIGN_LEN*BASE_WIDTH-1:0] aligned_query_seq,
    output reg [7:0] alignment_length
);

    integer H[0:REF_LEN][0:QUERY_LEN];
    integer traceback[0:REF_LEN][0:QUERY_LEN];
    integer i, j, ti, tj;
    integer score_diag, score_up, score_left, score;
    reg [1:0] ref_base, query_base;

    function [1:0] get_base(input [REF_LEN*BASE_WIDTH-1:0] seq, input integer index);
        get_base = seq[(REF_LEN-1-index)*BASE_WIDTH +: BASE_WIDTH];
    endfunction

    function [1:0] get_query_base(input [QUERY_LEN*BASE_WIDTH-1:0] seq, input integer index);
        get_query_base = seq[(QUERY_LEN-1-index)*BASE_WIDTH +: BASE_WIDTH];
    endfunction

    initial begin
        wait(!rst);

        for (i = 0; i <= REF_LEN; i = i + 1) begin
            H[i][0] = i * -2;
            traceback[i][0] = 2;
        end
        for (j = 0; j <= QUERY_LEN; j = j + 1) begin
            H[0][j] = j * -2;
            traceback[0][j] = 3;
        end

        for (i = 1; i <= REF_LEN; i = i + 1) begin
            for (j = 1; j <= QUERY_LEN; j = j + 1) begin
                ref_base = get_base(ref_seq, i-1);
                query_base = get_query_base(query_seq, j-1);

                score_diag = H[i-1][j-1] + ((ref_base == query_base) ? 2 : -1);
                score_up   = H[i-1][j] + -2;
                score_left = H[i][j-1] + -2;

                score = score_diag;
                traceback[i][j] = 1;

                if (score_up > score) begin
                    score = score_up;
                    traceback[i][j] = 2;
                end
                if (score_left > score) begin
                    score = score_left;
                    traceback[i][j] = 3;
                end

                H[i][j] = score;
            end
        end

        ti = REF_LEN;
        tj = QUERY_LEN;
        alignment_length = 0;

        // Zero out entire output vectors before filling
        aligned_ref_seq = {ALIGN_LEN*BASE_WIDTH{1'b0}};
        aligned_query_seq = {ALIGN_LEN*BASE_WIDTH{1'b0}};

        while ((ti > 0 || tj > 0) && alignment_length < ALIGN_LEN) begin
            case (traceback[ti][tj])
                1: begin
                    aligned_ref_seq[alignment_length*BASE_WIDTH +: BASE_WIDTH] = get_base(ref_seq, ti-1);
                    aligned_query_seq[alignment_length*BASE_WIDTH +: BASE_WIDTH] = get_query_base(query_seq, tj-1);
                    ti = ti - 1;
                    tj = tj - 1;
                end
                2: begin
                    aligned_ref_seq[alignment_length*BASE_WIDTH +: BASE_WIDTH] = get_base(ref_seq, ti-1);
                    aligned_query_seq[alignment_length*BASE_WIDTH +: BASE_WIDTH] = 2'b00;
                    ti = ti - 1;
                end
                3: begin
                    aligned_ref_seq[alignment_length*BASE_WIDTH +: BASE_WIDTH] = 2'b00;
                    aligned_query_seq[alignment_length*BASE_WIDTH +: BASE_WIDTH] = get_query_base(query_seq, tj-1);
                    tj = tj - 1;
                end
                default: begin
                    ti = 0;
                    tj = 0;
                end
            endcase
            alignment_length = alignment_length + 1;
        end
    end

endmodule