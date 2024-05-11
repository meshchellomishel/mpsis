module riscv_unit(
    input logic clk_i,
    input logic resetn_i,
    
    input logic kclk_i,
    input logic kdata_i,
    
    // Входы и выходы периферии
    input  logic [15:0] sw_i,       // Переключатели
    
    output logic [15:0] led_o,      // Светодиоды

    output logic [ 6:0] hex_led_o,  // Вывод семисегментных индикаторов
    output logic [ 7:0] hex_sel_o,  // Селектор семисегментных индикаторов
    
    input  logic        rx_i,       // Линия приема по UART
    output logic        tx_o       // Линия передачи по UART
    
);

logic stall;
logic [31:0] im_instr;
logic [31:0] im_instr_addr;

logic [31:0] dm_mem_rd;
logic [31:0] dm_mem_wd;
logic [31:0] dm_mem_addr;
logic [ 3:0] dm_mem_be;
logic [ 2:0] dm_mem_size;
logic dm_ready;
logic dm_mem_req;
logic dm_mem_we;

logic [31:0] core_mem_rd;
logic [31:0] core_mem_wd;
logic [31:0] core_mem_addr;
logic [ 2:0] core_mem_size;
logic core_mem_req;
logic core_mem_we;

logic irq_req;
logic irq_ret;

logic [7:0] device_code;
assign device_code = core_mem_addr[31:24];

logic lsu_req;
logic ps2_req;
logic hex_req;

always_comb begin
    lsu_req = 'b0;
    ps2_req = 'b0;
    hex_req = 'b0;
    if (core_mem_req) begin
        case (device_code)
        'h4: hex_req = 'b1;
        'h3: ps2_req = 'b1;
        'h0: lsu_req = 'b1;
        endcase
    end
end

logic [ 31:0] lsu_mem_rd;
logic [ 31:0] hex_mem_rd;
logic [ 31:0] ps2_mem_rd;

always_comb begin
    if (ps2_req) core_mem_rd = ps2_mem_rd;
    else if (hex_req) core_mem_rd = hex_mem_rd;
    else core_mem_rd = lsu_mem_rd;
end

logic sysclk, rst;
sys_clk_rst_gen divider(
    .ex_clk_i(clk_i),
    .ex_areset_n_i(resetn_i),
    .div_i(5),
    .sys_clk_o(sysclk),
    .sys_reset_o(rst)
);

instr_mem instr_mem(
    .addr_i         (im_instr_addr),
    .read_data_o    (im_instr)
);

ext_mem data_mem(
    .clk_i              (sysclk),

    .addr_i             (dm_mem_addr),
    .mem_req_i          (dm_mem_req),
    .write_enable_i     (dm_mem_we),
    .write_data_i       (dm_mem_wd),
    .read_data_o        (dm_mem_rd),
    .ready_o            (dm_ready),
    .byte_enable_i      (dm_mem_be)
    
);

hex_sb_ctrl hex_sb_ctrl(
    .clk_i              (sysclk),
    .addr_i             (core_mem_addr),
    .req_i              (hex_req),
    .write_data_i       (core_mem_wd),
    .write_enable_i     (core_mem_we),
    .read_data_o        (hex_mem_rd),
    
    .hex_led            (hex_led_o),
    .hex_sel            (hex_sel_o)
);

ps2_sb_ctrl ps2_sb_ctrl(
    .clk_i              (sysclk),
    .rst_i              (rst),
  
    .addr_i             (core_mem_addr),
    .req_i              (ps2_req),
    .write_data_i       (core_mem_wd),
    .write_enable_i     (core_mem_we),
    .read_data_o        (ps2_mem_rd),
    
    .interrupt_return_i (irq_ret),
    .interrupt_request_o (irq_req),
    
    .kclk_i             (kclk_i),
    .kdata_i            (kdata_i)
);

riscv_lsu lsu(
    .clk_i          (sysclk),
    .rst_i          (rst),
 
    .core_req_i     (lsu_req),
    .core_we_i      (core_mem_we),
    .core_size_i    (core_mem_size),
    .core_addr_i    (core_mem_addr),
    .core_wd_i      (core_mem_wd),
    .core_rd_o      (lsu_mem_rd),
    .core_stall_o   (stall),
    
    .mem_req_o      (dm_mem_req),
    .mem_we_o       (dm_mem_we),
    .mem_be_o       (dm_mem_be),
    .mem_addr_o     (dm_mem_addr),
    .mem_wd_o       (dm_mem_wd),
    .mem_rd_i       (dm_mem_rd),
    .mem_ready_i    (dm_ready)
);

riscv_core core(
    .clk_i          (sysclk),
    .rst_i          (rst),

    .stall_i        (stall),
    .instr_i        (im_instr),
    .mem_rd_i       (core_mem_rd),
    .irq_req_i      (irq_req),

    .instr_addr_o   (im_instr_addr),
    .mem_addr_o     (core_mem_addr),
    .mem_size_o     (core_mem_size),
    .mem_req_o      (core_mem_req),
    .mem_we_o       (core_mem_we),
    .mem_wd_o       (core_mem_wd),
    .irq_ret_o      (irq_ret)
);

endmodule;