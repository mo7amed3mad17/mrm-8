`timescale 1ns/1ps
module alu_tb;

//inputs
logic signed [7:0] opr_A;
logic signed [7:0] opr_B;
logic [2:0] op;

// outpus
logic signed [7:0] result;
logic zero;
logic negative;
logic carry;
logic overflow;
int pass, fail;
logic signed [7:0] expected;
string status, message = "Test status: %0d %b %0d = %0d , should be %0d    (%s)";

alu dut(
.opr_A(opr_A), .opr_B(opr_B), .op(op),
.result(result),
.zero(zero), .negative(negative), .carry(carry), .overflow(overflow)
);


task automatic set_input(input logic signed [7:0] t_opr_A, input logic signed [7:0] t_opr_B,
input logic [2:0] t_op);
    opr_A = t_opr_A;
    opr_B = t_opr_B;
    op = t_op; #2;
endtask


task automatic check(
    input logic signed [7:0] t_opr_A,
    input logic signed [7:0] t_opr_B,
    input logic [2:0] t_op,
    input logic t_zero,
    input logic t_negative,
    input logic t_carry,
    input logic t_overflow
);

    unique case(t_op)

        // Addition
        3'b000 : expected = t_opr_A + t_opr_B;

        // Subtraction
        3'b001 : expected = t_opr_A - t_opr_B;

        // AND
        3'b010 : expected = t_opr_A & t_opr_B;

        // OR
        3'b011 : expected = t_opr_A | t_opr_B;

        // XOR
        3'b100 : expected = t_opr_A ^ t_opr_B;

        // NOT
        3'b101 : expected = ~t_opr_A;

        // Left Shift
        3'b110 : expected = t_opr_A << t_opr_B[2:0];

        // Right Shift
        3'b111 : expected = t_opr_A >> t_opr_B[2:0];

    endcase

    if (result === expected &&
        zero === t_zero &&
        negative === t_negative &&
        carry === t_carry &&
        overflow === t_overflow) begin

        pass++;
        status = "PASS";

    end
    else begin

        fail++;
        status = "FAIL";

    end

    $display(message, t_opr_A, t_op, t_opr_B, result, expected, status);

    $display(
        "zero = %b | negative = %b | carry = %b | overflow = %b\n",
        zero, negative, carry, overflow
    );

endtask



initial begin

// Initialize the ports
opr_A = 0;
opr_B = 0;
op = 0;
pass = 0;
fail = 0;

// Test1: Addition Zero
set_input(0, 0, 0);
check(0, 0, 0, 1, 0, 0, 0);

// Test2: Addition No Negstive and No Zero and No carry and No overflow
set_input(8, 5, 0);
check(8, 5, 0, 0, 0, 0, 0);

// Test3: Addition Negative
set_input(-15, 5, 0);
check(-15, 5, 0, 0, 1, 0, 0);

// Test4: Addition carry
set_input(-16, 32, 0);
check(-16, 32, 0, 0, 0, 1, 0);


// Test5: Addition Overflow and No negative
set_input(-128, -1, 0);
check(-128, -1, 0, 0, 0, 1, 1);


// Test6: Addition Overflow and no carry
set_input(127, 1, 0);
check(127, 1, 0, 0, 1, 0, 1);


// Test7: Subtraction
set_input(5, 8, 1);
check(5, 8, 1, 0, 1, 0, 0);

// Test8: Subtraction
set_input(-128, 127, 1);
check(-128, 127, 1, 0, 0, 0, 1);

// Test9: AND - Both operands zero
set_input(0, 0, 2);
check(0, 0, 2, 1, 0, 0, 0);

// Test10: AND - Both operands have common bits
set_input(12, 10, 2);
check(12, 10, 2, 0, 0, 0, 0);

// Test11: AND - Negative result
set_input(-1, 127, 2);
check(-1, 127, 2, 0, 0, 0, 0);

// Test12: AND - Result is zero
set_input(8, 4, 2);
check(8, 4, 2, 1, 0, 0, 0);

// Test13: OR - Both operands zero
set_input(0, 0, 3);
check(0, 0, 3, 1, 0, 0, 0);

// Test14: OR - Positive result
set_input(8, 5, 3);
check(8, 5, 3, 0, 0, 0, 0);

// Test15: OR - Negative result
set_input(-128, 1, 3);
check(-128, 1, 3, 0, 1, 0, 0);

// Test16: OR - All bits set
set_input(-1, 127, 3);
check(-1, 127, 3, 0, 1, 0, 0);

// Test17: XOR - Both operands zero
set_input(0, 0, 4);
check(0, 0, 4, 1, 0, 0, 0);

// Test18: XOR - Identical operands
set_input(25, 25, 4);
check(25, 25, 4, 1, 0, 0, 0);

// Test19: XOR - Positive result
set_input(12, 5, 4);
check(12, 5, 4, 0, 0, 0, 0);

// Test20: XOR - Negative result
set_input(-1, 0, 4);
check(-1, 0, 4, 0, 1, 0, 0);

// Test21: NOT - Zero becomes all ones
set_input(0, 0, 5);
check(0, 0, 5, 0, 1, 0, 0);

// Test22: NOT - All ones become zero
set_input(-1, 0, 5);
check(-1, 0, 5, 1, 0, 0, 0);

// Test23: NOT - Positive input produces negative result
set_input(1, 0, 5);
check(1, 0, 5, 0, 1, 0, 0);

// Test24: NOT - Negative input produces positive result
set_input(-128, 0, 5);
check(-128, 0, 5, 0, 0, 0, 0);

// Test25: Left Shift - Shift by zero
set_input(5, 0, 6);
check(5, 0, 6, 0, 0, 0, 0);

// Test26: Left Shift - Positive result
set_input(3, 2, 6);
check(3, 2, 6, 0, 0, 0, 0);

// Test27: Left Shift - Negative result
set_input(32, 2, 6);
check(32, 2, 6, 0, 1, 0, 0);

// Test28: Left Shift - Produces negative result
set_input(1, 7, 6);
check(1, 7, 6, 0, 1, 0, 0);

// Test29: Left Shift - Discarded bits produce zero
set_input(64, 2, 6);
check(64, 2, 6, 1, 0, 0, 0);

// Test30: Right Shift - Shift by zero
set_input(16, 0, 7);
check(16, 0, 7, 0, 0, 0, 0);

// Test31: Right Shift - Positive result
set_input(32, 2, 7);
check(32, 2, 7, 0, 0, 0, 0);

// Test32: Right Shift - Negative operand produces positive result
set_input(-128, 1, 7);
check(-128, 1, 7, 0, 0, 0, 0);

// Test33: Right Shift - Result becomes zero
set_input(1, 1, 7);
check(1, 1, 7, 1, 0, 0, 0);

// Test34: Right Shift - Maximum shift amount
set_input(-1, 7, 7);
check(-1, 7, 7, 0, 0, 0, 0);

$display("Total PASS = %0d\nTotal FAIL = %0d", pass, fail);
$finish;

end


endmodule
