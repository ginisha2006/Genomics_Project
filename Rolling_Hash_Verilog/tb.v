`timescale 1ns / 1ps
module tb();
    reg clk;
    reg rst;
    reg [7:0] char_in;
    wire [31:0] hash_out;
    wire done;

    reg [31:0] prev_hash;
    reg [7:0] out_char;
    reg [7:0] in_char;
    wire [31:0] new_hash;

    dna_base4_hash uut (
        .clk(clk),
        .rst(rst),
        .char_in(char_in),
        .hash_out(hash_out),
        .done(done)
    );

    rolling_hash uut1 (
        .prev_hash(prev_hash),
        .out_char(out_char),
        .in_char(in_char),
        .new_hash(new_hash)
    );

    always #5 clk = ~clk;

    reg [7:0] sequence [0:3];
    integer i;

    initial begin
        clk = 0;
        rst = 1;
        char_in = 0;

        sequence[0] = 8'd65; // A
        sequence[1] = 8'd84; // T
        sequence[2] = 8'd67; // C
        sequence[3] = 8'd71; // G

        #10 rst = 0;

        // Send "A", "T", "C", "G"
        for (i = 0; i < 4; i = i + 1) begin
            @(posedge clk);
            char_in = sequence[i];
        end

        // Wait for done signal on next clock edge
        wait(done);
        @(posedge clk);

        prev_hash = hash_out;
        out_char = 8'd65; // A
        in_char = 8'd71;  // G
        #10;
    end
endmodule
