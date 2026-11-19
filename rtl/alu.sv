module alu(
// inputs
input logic signed [7:0] opr_A,
input logic signed [7:0] opr_B,
input logic [2:0] op,

// outpus
output logic signed [7:0] result,
output logic zero,
output logic negative,
output logic carry,
output logic overflow
);

logic [8:0] result_ext;


// ALU Logic
always_comb begin
    result = 0; result_ext = 0;
    zero = 0; negative = 0; carry = 0; overflow = 0;

    unique case (op)
        3'b000 : begin
            result_ext = {1'b0, opr_A} + {1'b0, opr_B};
            carry = result_ext[8];
            negative = result_ext[7];
            result = result_ext[7:0];
            if (result == 0) zero = 1;
            if (opr_A[7] == opr_B[7] && result[7] != opr_A[7]) overflow = 1;
            // All Done
        end

        3'b001 : begin
            result_ext = {1'b0, opr_A} - {1'b0, opr_B};
            negative = result_ext[7];
            carry = 0;
            result = result_ext[7:0];
            if (result == 0) zero = 1;
            if (opr_A[7] != opr_B[7] && result[7] != opr_A[7]) overflow = 1;
        end

        3'b010 : begin
            result = opr_A & opr_B;
            negative = result[7];
            if (result == 0) zero = 1;
        end

        3'b011 : begin
            result = opr_A | opr_B;
            negative = result[7];
            if (result == 0) zero = 1;
        end

        3'b100 : begin
            result = opr_A ^ opr_B;
            negative = result[7];
            if (result == 0) zero = 1;
        end

        3'b101 : begin
            result = ~ opr_A;
            negative = result[7];
            if (result == 0) zero = 1;
        end

        3'b110 : begin
            result = opr_A << opr_B[2:0];
            negative = result[7];
            if (result == 0) zero = 1;
        end

        3'b111 : begin
            result = opr_A >> opr_B[2:0];
            negative = result[7];
            if (result == 0) zero = 1;
        end
    endcase
end

endmodule
