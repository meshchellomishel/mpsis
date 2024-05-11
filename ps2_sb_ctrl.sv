module ps2_sb_ctrl(
  input  logic         clk_i,
  input  logic         rst_i,
  input  logic [31:0]  addr_i,
  input  logic         req_i,
  input  logic [31:0]  write_data_i,
  input  logic         write_enable_i,
  output logic [31:0]  read_data_o,


  output logic        interrupt_request_o,
  input  logic        interrupt_return_i,

  input  logic kclk_i,
  input  logic kdata_i
);

logic [7:0] scan_code;
logic       scan_code_is_unread;

logic [7:0] keycode;
logic       keycode_valid;

PS2Receiver ps2receiver(
    .clk_i              (clk_i),
    .kclk_i             (kclk_i),
    
    .kdata_i            (kdata_i),
    .keycodeout_o       (keycode),
    .keycode_valid_o    (keycode_valid)
);

assign interrupt_request_o = scan_code_is_unread;

always_ff @(posedge clk_i) begin
    if (keycode_valid == 'd1) begin
        scan_code <= keycode;
        scan_code_is_unread <= 1'b1;
    end
end

always_ff @(posedge clk_i) begin
    if (req_i && !write_enable_i) begin
        case (addr_i[23:0])
        'h0: begin
            read_data_o <= scan_code;
            scan_code_is_unread <= keycode_valid ? 1'b1 : 1'b0;
        end
        'h4: begin
            read_data_o <= scan_code_is_unread;
        end
        endcase
    end
end

always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) scan_code_is_unread <= 'b0;
    if (req_i && write_enable_i) begin
        case (addr_i)
        'h24: begin
            if (write_data_i == 'd1) begin
                scan_code <= 'd0;
                scan_code_is_unread <= 1'b0;
            end
        end
        endcase
    end
end

always_comb begin
    if (interrupt_return_i) begin
        scan_code_is_unread = keycode_valid ? 1'b1 : 1'b0;
    end
end

endmodule