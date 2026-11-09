// 4 8-bit registers
module register_file (
    // Inputs
    input logic clk,
    input logic reset,

    input logic [1:0] read_addr_1,
    input logic [1:0] read_addr_2,

    input logic write_enable,
    input logic [1:0] write_addr,
    input logic [7:0] write_data,

    // Outputs
    output logic [7:0] out_read_1,
    output logic [7:0] out_read_2
);

    logic [7:0] register_file [4];

    always_ff @ (posedge clk)  begin
        // Reset case
        if (reset) begin
            for (int i = 0; i < 4; i++) begin
                register_file[i] <= 8'd0;
            end
        end

        // Write case
        else begin
            if (write_enable == 1) begin
                register_file[write_addr] <= write_data;
            end
        end
    end

    always_comb begin
        // Read case
        out_read_1 = register_file[read_addr_1];
        out_read_2 = register_file[read_addr_2];
    end

endmodule
