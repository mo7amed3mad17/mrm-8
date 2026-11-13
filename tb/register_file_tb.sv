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
    int fail;
    int pass;
    int count_3;


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

    task automatic wait_cycles (int cycles_num);
        repeat (cycles_num) @(posedge clk);
    endtask

    task automatic set_input (input logic twrite_enable, input logic [1:0] twrite_addr,
    input logic [7:0] twrite_data);
        write_enable = twrite_enable;
        write_addr = twrite_addr;
        write_data = twrite_data;
        wait_cycles(1); #2;
        write_enable = 0;
    endtask

    task automatic read_out (input logic [1:0] tread_addr_1, input logic [1:0] tread_addr_2//,
    /*output logic [7:0] out_read_1, output logic [7:0] out_read_2 */);
        read_addr_1 = tread_addr_1;
        read_addr_2 = tread_addr_2; #2;
        $display("out_read_1 = %0d, out_read_2 = %0d", out_read_1, out_read_2 );
    endtask

    initial begin

    // initiate signals
    clk = 0;
    reset = 0;
    read_addr_1 = 0;
    read_addr_2 = 0;
    write_enable = 0;
    write_addr = 0;
    write_data = 0;
    fail = 0;
    pass = 0;
    count_3 = 0;


    // 1- Reset check
    set_input(1, 0, 3);
    set_input(1, 1, 2);
    read_out(0, 1);
    //$display("Before Reset: out_read_1 = %0d, out_read_2 = %0d", out_read_1, out_read_2 );
    reset = 1; wait_cycles(2); #1;
    $display("After Reset: out_read_1 = %0d, out_read_2 = %0d", out_read_1, out_read_2 );
    reset = 0;
    if (out_read_1 !== 0 || out_read_2 !== 0) begin
        $display("Case 1: ERROR:\nout_read_1 =%d\nout_read_2 =%d\n", out_read_1, out_read_2);
        fail++;
    end
    else begin
        $display("1- Passed !\n");
        pass++;
    end


    // 2- Write check
    set_input(1, 0, 10);
    set_input(1, 2, 15);
    read_out(0, 2);
    //$display("out_read_1 = %0d, out_read_2 = %0d", out_read_1, out_read_2 );
    if (out_read_1 !== 10 || out_read_2 !== 15) begin
        $display("Case 2: ERROR:\nout_read_1 =%d\nout_read_2 =%d\n", out_read_1, out_read_2);
        fail++;
    end
    else begin
        $display("2- passed !\n");
        pass++;
    end

    // 3- All location workness check
    set_input(1, 0, 9);
    set_input(1, 1, 14);
    set_input(1, 2, 20);
    set_input(1, 3, 25);

    read_out(0, 1);
    if (out_read_1 !== 9 || out_read_2 !== 14) begin
        $display("Case 3: ERROR:\nout_read_1 =%d\nout_read_2 =%d\n"
        , out_read_1, out_read_2);
        count_3++;
    end

    read_out(1, 0);
    if (out_read_1 !== 14 || out_read_2 !== 9) begin
        $display("Case 3: ERROR:\nout_read_1 =%d\nout_read_2 =%d\n"
        , out_read_1, out_read_2);
        count_3++;
    end

    read_out(2, 3);
    if (out_read_1 !== 20 || out_read_2 !== 25) begin
        $display("Case 3: ERROR:\nout_read_1 =%d\nout_read_2 =%d\n"
        , out_read_1, out_read_2);
        count_3++;
    end

    read_out(3, 2);
    if (out_read_1 !== 25 || out_read_2 !== 20) begin
        $display("Case 3: ERROR:\nout_read_1 =%d\nout_read_2 =%d\n"
        , out_read_1, out_read_2);
        count_3++;
    end


    if (count_3 != 0) begin
         $display("In Case 3: Errors == %0d\n", count_3);
         fail++;
    end
    else begin
        $display("3- passed !\n");
        pass++;
    end

    // 4- Gating Behaviour
    set_input(1, 0, 5);
    set_input(1, 1, 10);
    set_input(0, 0, 45);
    set_input(0, 1, 30);
    read_out(0, 1);
    if (out_read_1 !== 5  || out_read_2 !== 10) begin
        $display("Case 4: ERROR:\nout_read_1 =%d\nout_read_2 =%d\n"
        , out_read_1, out_read_2);
        fail++;
    end
    else begin
        $display("4- passed !\n");
        pass++;
    end

    $display("Total passed: %0d\nTotal errors: %0d\nTime = %0dns", pass, fail, $time);


    $finish;
    end

    initial begin
        wait_cycles(16);
        $display("TIMEOUT");
    end

endmodule
