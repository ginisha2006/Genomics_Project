`timescale 1ns / 1ps
module smith_waterman #(
    parameter REF_LEN = 15,
    parameter QUERY_LEN = 10,
    parameter BASE_WIDTH = 2,
    parameter ALIGN_LEN = REF_LEN + QUERY_LEN // max possible alignment length
)(
    input clk,
    input rst,
    input [REF_LEN*BASE_WIDTH-1:0] ref_seq,
    input [QUERY_LEN*BASE_WIDTH-1:0] query_seq,
    output reg [ALIGN_LEN*BASE_WIDTH-1:0] aligned_ref_seq,
    output reg [ALIGN_LEN*BASE_WIDTH-1:0] aligned_query_seq,
    output reg [7:0] alignment_length  // number of valid aligned pairs
);

// ... contents remain unchanged (omitted here for brevity in this comment)
    localparam MATCH_SCORE    =  2;
    localparam MISMATCH_SCORE = -1;
    localparam GAP_SCORE      = -2;

    integer H[0:REF_LEN][0:QUERY_LEN];
    integer traceback[0:REF_LEN][0:QUERY_LEN];

    integer i, j, ti, tj;
    integer score_diag, score_up, score_left, score;
    integer max_score, max_i, max_j;
    reg [1:0] ref_base, query_base;

    // Helpers to extract bases
    function [1:0] get_base(input [REF_LEN*BASE_WIDTH-1:0] seq, input integer index);
        get_base = seq[(REF_LEN-1-index)*BASE_WIDTH +: BASE_WIDTH];
    endfunction

    function [1:0] get_query_base(input [QUERY_LEN*BASE_WIDTH-1:0] seq, input integer index);
        get_query_base = seq[(QUERY_LEN-1-index)*BASE_WIDTH +: BASE_WIDTH];
    endfunction

    // Main logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset everything
            for (i = 0; i <= REF_LEN; i = i + 1)
                for (j = 0; j <= QUERY_LEN; j = j + 1) begin
                    H[i][j] = 0;
                    traceback[i][j] = 0;
                end
            max_score = 0;
            max_i = 0;
            max_j = 0;
            aligned_ref_seq = 0;
            aligned_query_seq = 0;
            alignment_length = 0;
        end else begin
            // Fill score and traceback matrices
            for (i = 1; i <= REF_LEN; i = i + 1) begin
                for (j = 1; j <= QUERY_LEN; j = j + 1) begin
                    ref_base = get_base(ref_seq, i-1);
                    query_base = get_query_base(query_seq, j-1);

                    if (ref_base == query_base)
                        score_diag = H[i-1][j-1] + MATCH_SCORE;
                    else
                        score_diag = H[i-1][j-1] + MISMATCH_SCORE;

                    score_up   = H[i-1][j] + GAP_SCORE;
                    score_left = H[i][j-1] + GAP_SCORE;

                    score = score_diag;
                    traceback[i][j] = 1; // diagonal

                    if (score_up > score) begin
                        score = score_up;
                        traceback[i][j] = 2; // up
                    end
                    if (score_left > score) begin
                        score = score_left;
                        traceback[i][j] = 3; // left
                    end
                    if (score < 0) begin
                        score = 0;
                        traceback[i][j] = 0;
                    end

                    H[i][j] = score;

                    if (score > max_score) begin
                        max_score = score;
                        max_i = i;
                        max_j = j;
                    end
                end
            end

            // Traceback
            ti = max_i;
            tj = max_j;
            alignment_length = 0;
            aligned_ref_seq = 0;
            aligned_query_seq = 0;

            while (ti > 0 && tj > 0 && H[ti][tj] > 0 && alignment_length < ALIGN_LEN) begin
                case (traceback[ti][tj])
                    1: begin // diagonal (match/mismatch)
                        aligned_ref_seq[alignment_length*BASE_WIDTH +: BASE_WIDTH] = get_base(ref_seq, ti-1);
                        aligned_query_seq[alignment_length*BASE_WIDTH +: BASE_WIDTH] = get_query_base(query_seq, tj-1);
                        ti = ti - 1;
                        tj = tj - 1;
                    end
                    2: begin // up (gap in query)
                        aligned_ref_seq[alignment_length*BASE_WIDTH +: BASE_WIDTH] = get_base(ref_seq, ti-1);
                        aligned_query_seq[alignment_length*BASE_WIDTH +: BASE_WIDTH] = 2'bxx; // GAP
                        ti = ti - 1;
                    end
                    3: begin // left (gap in ref)
                        aligned_ref_seq[alignment_length*BASE_WIDTH +: BASE_WIDTH] = 2'bxx; // GAP
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
    end
endmodule
