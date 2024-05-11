module hex_sb_ctrl(
  input  logic        clk_i,
  input  logic [31:0] addr_i,
  input  logic        req_i,
  input  logic [31:0] write_data_i,
  input  logic        write_enable_i,
  output logic [31:0] read_data_o,

  output logic [6:0] hex_led,
  output logic [7:0] hex_sel
);

logic [3:0] hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7;
localparam HEX0 = 'h00;
localparam HEX1 = 'h04;
localparam HEX2 = 'h08;
localparam HEX3 = 'h0c;
localparam HEX4 = 'h10;
localparam HEX5 = 'h14;
localparam HEX6 = 'h18;
localparam HEX7 = 'h1c;
localparam BITM = 'h20;
localparam RST  = 'h24;

logic [7:0] bitmask;
logic [23:0] hex_addr;

assign hex_addr = addr_i[23:0];

hex_digits hex_digits(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    
    .hex0_i     (hex0),
    .hex1_i     (hex1),
    .hex2_i     (hex2),
    .hex3_i     (hex3),
    .hex4_i     (hex4),
    .hex5_i     (hex5),
    .hex6_i     (hex6),
    .hex7_i     (hex7),
    
    .bitmask_i  (bitmask),
    .hex_led_o  (hex_led),
    .hex_sel_o  (hex_sel)
);

always_ff @(posedge clk_i) begin
    if (write_enable_i && req_i) begin
        case (addr_i[23:0])
        HEX0: hex0 <= write_data_i;
        HEX1: hex1 <= write_data_i;
        HEX2: hex2 <= write_data_i;
        HEX3: hex3 <= write_data_i;
        HEX4: hex4 <= write_data_i;
        HEX5: hex5 <= write_data_i;
        HEX6: hex6 <= write_data_i;
        HEX7: hex7 <= write_data_i;
        BITM: bitmask <= write_data_i;
        RST:  begin
            if (write_data_i == 'd1) begin
                hex0 <= 'd0;
                hex1 <= 'd0;
                hex2 <= 'd0;
                hex3 <= 'd0;
                hex4 <= 'd0;
                hex5 <= 'd0;
                hex6 <= 'd0;
                hex7 <= 'd0;
                bitmask <= 'hFF;
            end
        end
        endcase
    end
end

endmodule