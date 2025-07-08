`timescale 1ns / 1ps
module tb_smith_waterman;

// Parameters
localparam REF_LEN = 15;
localparam QUERY_LEN = 10;
localparam BASE_WIDTH = 2;
localparam ALIGN_LEN = REF_LEN + QUERY_LEN;

// Signals
reg clk;
reg rst;
reg [REF_LEN*BASE_WIDTH-1:0] ref_seq;
reg [QUERY_LEN*BASE_WIDTH-1:0] query_seq;
wire [ALIGN_LEN*BASE_WIDTH-1:0] aligned_ref_seq;
wire [ALIGN_LEN*BASE_WIDTH-1:0] aligned_query_seq;
wire [7:0] alignment_length;

// Instantiate the Smith-Waterman module
smith_waterman #(
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

// Clock generation
always begin
    #5 clk = ~clk;  // 10ns period
end

// Function to decode 2-bit base to character
function [7:0] base_to_char(input [1:0] base);
    case (base)
        2'b00: base_to_char = "A";
        2'b01: base_to_char = "T";
        2'b10: base_to_char = "G";
        2'b11: base_to_char = "C"; 
        2'bxx: base_to_char = "-"; 
        default: base_to_char = "?";
    endcase
endfunction

// Task to print aligned sequences
task print_alignment;
    integer i;
    reg [1:0] ref_b, query_b;
    begin
        $write("Aligned Reference: ");
        for (i = alignment_length-1; i >= 0; i = i - 1) begin
            ref_b = aligned_ref_seq[i*2 +: 2];
            $write("%s", base_to_char(ref_b));
        end
        $write("\n");

        $write("Aligned Query   : ");
        for (i = alignment_length-1; i >= 0; i = i - 1) begin
            query_b = aligned_query_seq[i*2 +: 2];
            $write("%s", base_to_char(query_b));
        end
        $write("\n");
    end
endtask

// Stimulus
initial begin
    // Initialize
    clk = 0;
    rst = 1;
    ref_seq = 0;
    query_seq = 0;

    // Apply reset
    #10;
    rst = 0;

    // Reference and query (ACGTACGTACGTA and ACGTACGTA)
    ref_seq = {2'b10 , 2'b01, 2'b00, 2'b01, 2'b10, 2'b11, 2'b00, 2'b01, 2'b01, 2'b10, 2'b11, 2'b00, 2'b01, 2'b10, 2'b10};
    query_seq = {2'b00, 2'b01, 2'b10, 2'b11, 2'b00, 2'b01, 2'b01, 2'b10,  2'b11,2'b00};

    // Wait for alignment to compute
    #200;

    // Show result
    $display("\n>> Smith-Waterman Local Alignment Result:");
    print_alignment();

    // End simulation
    $finish;
end

endmodule
