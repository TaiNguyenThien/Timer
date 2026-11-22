module timer_top(
    input wire sys_clk,
    input wire sys_rst_n,
    input wire tim_psel,
    input wire tim_penable,
    input wire tim_pwrite,
    input wire [11:0] tim_paddr,
    input wire [31:0] tim_pwdata,
    input wire [3:0] tim_pstrb,
    input wire dbg_mode,
    output wire [31:0] tim_prdata,
    output wire tim_pready,
    output wire tim_pslverr,
    output wire tim_int
);

    wire wr_en1;
    wire rd_en1;
    wire [11:0] addr1;
    wire [31:0] wdata1;
    wire [31:0] rdata1;
    wire [3:0]  strb1;

    wire [3:0] div_val1;
    wire div_en1;
    wire cnt_en1;
    wire timer_en1;
    wire error1;

    wire tdr0_wr_sel1;
    wire tdr1_wr_sel1;
    wire [31:0] wdata_cnt1;
    wire [63:0] cnt1;
    wire halt_req1;
    wire halt_ack1;

    apb_slave  u_apb_slave (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .tim_psel(tim_psel),
        .tim_penable(tim_penable),
        .tim_pwrite(tim_pwrite),
        .tim_paddr(tim_paddr),
        .tim_pwdata(tim_pwdata),
        .rdata(rdata1),
        .tim_pstrb(tim_pstrb),
        .error(error1),
        .tim_prdata(tim_prdata),
        .tim_pready(tim_pready),
        .wdata(wdata1),
        .wr_en(wr_en1),
        .rd_en(rd_en1),
        .addr(addr1),
        .strb(strb1),
        .tim_pslverr(tim_pslverr)
    );

    cnt_ctrl  u_cnt_ctrl (
        .clk(sys_clk),
        .rst_n(sys_rst_n),
        .timer_en(timer_en1),
        .div_val(div_val1),
        .div_en(div_en1),
        .dbg_mode(dbg_mode),
        .halt_req(halt_req1),
        .halt_ack(halt_ack1),
        .cnt_en(cnt_en1)
    );


    counter  u_counter (
        .clk(sys_clk),
        .rst_n(sys_rst_n),
        .cnt_en(cnt_en1),
        .timer_en(timer_en1),
        .tdr0_wr_sel(tdr0_wr_sel1),
        .tdr1_wr_sel(tdr1_wr_sel1),
        .strb(strb1),
        .wdata(wdata_cnt1),
        .cnt(cnt1)
    );

    register_file u_register_file (
            .clk(sys_clk),
            .rst_n(sys_rst_n),
            .wr_en(wr_en1),
            .rd_en(rd_en1),
            .addr(addr1),
            .wdata(wdata1),
            .strb(strb1),
            .cnt(cnt1),
            .halt_ack(halt_ack1),
            .pready(tim_pready),
            .rdata(rdata1),
            .tim_int(tim_int),
            .timer_en(timer_en1),
            .div_en(div_en1),
            .div_val(div_val1),
            .tdr0_wr_sel(tdr0_wr_sel1),
            .tdr1_wr_sel(tdr1_wr_sel1),
            .wdata_cnt(wdata_cnt1),
            .halt_request(halt_req1),
            .error(error1)

    );
endmodule
