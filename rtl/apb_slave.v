module apb_slave (
    input  wire sys_clk,
    input  wire sys_rst_n,
    input  wire tim_psel,
    input  wire tim_penable,
    input  wire tim_pwrite,
    input  wire [11:0] tim_paddr,
    input  wire [31:0] tim_pwdata,
    input  wire [31:0] rdata,
    input  wire [3:0] tim_pstrb,
    input  wire error,
    output wire [31:0] tim_prdata,
    output wire tim_pready,
    output wire [31:0] wdata,
    output wire rd_en,
    output wire wr_en,
    output wire [11:0] addr,
    output wire [3:0] strb,
    output wire tim_pslverr
);
    reg pready_wait;

    assign wr_en = tim_psel & tim_penable & tim_pwrite;
    assign rd_en = tim_psel & tim_penable & !tim_pwrite;
    assign tim_prdata = rdata;
    assign wdata = tim_pwdata;
    assign addr  = tim_paddr;
    assign strb  = tim_pstrb;

    assign tim_pslverr =  tim_pready & error;

    always @( posedge sys_clk or negedge sys_rst_n) begin
        if(!sys_rst_n) begin
            pready_wait <= 1'b0;
        end
        else if( tim_penable & tim_psel) begin
                pready_wait <= 1'b1;
            end
            else begin
                pready_wait <= 1'b0;
            end
    end
    assign tim_pready = pready_wait;
endmodule
