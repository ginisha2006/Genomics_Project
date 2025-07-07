`timescale 1ns / 1ps

// Testbench
module bwt_tb;
    reg clk;
    reg rst;
    reg start;
    reg [15:0] input_dna;
    wire done;
    wire [17:0] bwt_out;
    wire [3:0] dollar_pos;

    bwt uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .input_dna(input_dna),
        .done(done),
        .bwt_out(bwt_out),
        .dollar_pos(dollar_pos)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        input_dna = 16'b0011011000110110;  // ACGTACGT (A=00, C=01, G=10, T=11)

        #10 rst = 0;
        #10 start = 1;
        #10 start = 0;

        wait(done);

        $display("\nBWT Output (binary): %b", bwt_out);
        $write("BWT Output (decoded): ");
        $write("BWT Output (decoded): ");
        for (integer i = 0; i < 9; i = i + 1) begin
            if (i == dollar_pos)
                $write("$ ");
            else begin
                case (bwt_out[i*2 +: 2])
                    2'b00: $write("A ");
                    2'b01: $write("C ");
                    2'b10: $write("G ");
                    2'b11: $write("T ");
                endcase
          end
        end
        $display("\n");
        $stop;
    end
endmodule
