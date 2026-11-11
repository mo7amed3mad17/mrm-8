`timescale 1ns/1ps

module register_file_tb;
    logic clk;
    logic reset;

    logic [1:0] read_addr_1;
    logic [1:0] read_addr_2;

    logic write_enable;
    logic [1:0] write_addr;
    logic [7:0] write_data;

    logic [7:0] out_read_1;
    logic [7:0] out_read_2;
    int i = 0;


    register_file dut (
        .clk(clk),
        .reset(reset),
        .read_addr_1(read_addr_1),
        .read_addr_2(read_addr_2),
        .write_enable(write_enable),
        .write_addr(write_addr),
        .write_data(write_data),
        .out_read_1(out_read_1),
        .out_read_2(out_read_2)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin

    // initiate signals
    clk = 0;
    reset = 0;
    read_addr_1 = 0;
    read_addr_2 = 0;
    write_enable = 0;
    write_addr = 0;
    write_data = 0;
    i = 0;


    // 1- Reset check
    write_enable=1; write_addr=0; write_data=3; #10
    write_enable=1; write_addr=1; write_data=2; #10
    read_addr_1=2'b00; read_addr_2=2'b01; #1
    reset=1; #5.5
    if (out_read_1 !== 0 || out_read_2 !== 0) $display("Case 1: ERROR:\nout_read_1 =%d\nout_read_2 =%d\n"
    , out_read_1, out_read_2);
    else $display("1- Passed !"); reset=0; #5



    // 2- Write check
    write_enable=1; write_addr=0; write_data=10; #10
    write_enable=1; write_addr=1; write_data=15; #10
    read_addr_1=2'b00; read_addr_2=2'b01; #1
    if (out_read_1 !== 10 || out_read_2 !== 15) $display("Case 2: ERROR:\nout_read_1 =%d\nout_read_2 =%d\n"
    , out_read_1, out_read_2);
    else $display("2- passed !"); reset=0; #5

    // 3- All location workness check
    write_enable=1; write_addr=0; write_data=9; #10
    write_addr=1; write_data=14; #10
    write_addr=2'b10; write_data=20; #10
    write_addr=2'b11; write_data=25; #10

    read_addr_1=2'b00; read_addr_2=2'b01; #1
    if (out_read_1 !== 9 || out_read_2 !== 14) begin
        $display("Case 3: ERROR:\nout_read_1 =%d\nout_read_2 =%d\n"
        , out_read_1, out_read_2);
        i++;
    end

    read_addr_1=2'b01; read_addr_2=2'b00; #1
    if (out_read_1 !== 14 || out_read_2 !== 9) begin
        $display("Case 3: ERROR:\nout_read_1 =%d\nout_read_2 =%d\n"
        , out_read_1, out_read_2);
        i++;
    end

    read_addr_1=2'b10; read_addr_2=2'b11; #1
    if (out_read_1 !== 20 || out_read_2 !== 25) begin
        $display("Case 3: ERROR:\nout_read_1 =%d\nout_read_2 =%d\n"
        , out_read_1, out_read_2);
        i++;
    end

    read_addr_1=2'b11; read_addr_2=2'b10; #1
    if (out_read_1 !== 25 || out_read_2 !== 20) begin
        $display("Case 3: ERROR:\nout_read_1 =%d\nout_read_2 =%d\n"
        , out_read_1, out_read_2);
        i++;
    end


    if (i !== 0) $display("Error == %0d\n", i);
    else $display("3- passed !");


    $finish;
    end

endmodule
