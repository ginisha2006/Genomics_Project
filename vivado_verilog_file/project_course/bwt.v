`timescale 1ns / 1ps

// BWT module with 2-bit encoding and handling $ properly
module bwt (
    input clk,
    input rst,
    input start,
    input [15:0] input_dna,  // 8 bases: 2 bits * 8 = 16 bits
    output reg done,
    output reg [17:0] bwt_out, // 9 symbols: 2 bits * 9 = 18 bits
    output reg [3:0] dollar_pos // Index where the row ends with $
);

    reg [17:0] extended_dna;  // 9 bases including $ (2 bits each)
    reg [17:0] rotations [0:8];
    reg [3:0] indices [0:8];
    integer i, j;

    reg [17:0] temp;
    reg [3:0] temp_index;

    reg [3:0] state;
    parameter IDLE = 0, LOAD = 1, ROTATE = 2, SORT = 3, OUTPUT = 4, DONE = 5;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            done <= 0;
            state <= IDLE;
        end else begin
            case(state)
                IDLE: begin
                    if (start) state <= LOAD;
                end

                LOAD: begin
                    extended_dna <= {input_dna, 2'b00};  // Append $ (00)
                    state <= ROTATE;
                end

                ROTATE: begin
                    for (i = 0; i < 9; i = i + 1) begin
                        rotations[i] = ({input_dna, 2'b00} << (2*i)) | ({input_dna, 2'b00} >> (18 - 2*i));
                        indices[i] = i;
                    end
                    state <= SORT;
                end

                SORT: begin
                    for (i = 0; i < 9; i = i + 1) begin
                        for (j = 0; j < 8 - i; j = j + 1) begin
                            if (rotations[j] > rotations[j+1]) begin
                                temp = rotations[j];
                                rotations[j] = rotations[j+1];
                                rotations[j+1] = temp;

                                temp_index = indices[j];
                                indices[j] = indices[j+1];
                                indices[j+1] = temp_index;
                            end
                        end
                    end
                    state <= OUTPUT;
                end

                OUTPUT: begin
                    for (i = 0; i < 9; i = i + 1) begin
                        bwt_out[i*2 +: 2] = rotations[i][1:0];
                        if (indices[i] == 0)  // The row where $ was at end before rotation
                            dollar_pos <= i;
                    end
                    state <= DONE;
                end

                DONE: begin
                    done <= 1;
                end
            endcase
        end
    end
endmodule