module register_file
(
    input wire clk, rst_n, wr_en, rd_en,
    input wire [11:0] addr,
    input wire [31:0] wdata,
    input wire [3:0]  strb,
    input wire [63:0] cnt,
    input wire halt_ack,
    input wire pready,
    output reg [31:0] rdata,
    output wire tim_int,
    output reg timer_en,
    output reg div_en,
    output reg [3:0] div_val,
    output wire tdr0_wr_sel,
    output wire tdr1_wr_sel,
    output wire [31:0] wdata_cnt,
    output wire halt_request,
    output reg error
);
    wire tcr_wr_sel;
    wire tcmp0_wr_sel;
    wire tcmp1_wr_sel;
    wire tier_wr_sel;
    wire tisr_wr_sel;
    wire thcsr_wr_sel;

    reg int_en;
    reg int_st;
    wire int_set;
    wire int_clr;
    reg [63:0] tcmp;
    reg halt_req;
   // reg int_state;
    //reg [31:0] tier;
    //reg [31:0] tisr;

    localparam TCR   = 12'h00;
    localparam TDR0  = 12'H04;
    localparam TDR1  = 12'H08;
    localparam TCMP0 = 12'h0c;
    localparam TCMP1 = 12'h10;
    localparam TIER  = 12'h14;
    localparam TISR  = 12'h18;
    localparam THCSR = 12'h1c;

    assign tcr_wr_sel   = (addr == TCR   )  & wr_en ;
    assign tdr0_wr_sel  = (addr == TDR0  )  & wr_en ;
    assign tdr1_wr_sel  = (addr == TDR1  )  & wr_en ;
    assign tcmp0_wr_sel = (addr == TCMP0 )  & wr_en ;
    assign tcmp1_wr_sel = (addr == TCMP1 )  & wr_en ;
    assign tier_wr_sel  = (addr == TIER  )  & wr_en ;
    assign tisr_wr_sel  = (addr == TISR  )  & wr_en ;
    assign thcsr_wr_sel = (addr == THCSR )  & wr_en ;

    always @( posedge clk or negedge rst_n) begin
        if ( !rst_n) begin
            tcmp     <= 64'hFFFFFFFFFFFFFFFF;
            halt_req <= 1'b0;
        end
        else if (tcmp0_wr_sel) begin
            tcmp[7:0]   <= (strb[0])? wdata[7:0]   : tcmp[7:0];
            tcmp[15:8]  <= (strb[1])? wdata[15:8]  : tcmp[15:8];
            tcmp[23:16] <= (strb[2])? wdata[23:16] : tcmp[23:16];
            tcmp[31:24] <= (strb[3])? wdata[31:24] : tcmp[31:24];

        end
        else if (tcmp1_wr_sel) begin
            tcmp[39:32] <= (strb[0])? wdata[7:0]   : tcmp[39:32];
            tcmp[47:40] <= (strb[1])? wdata[15:8]  : tcmp[47:40];
            tcmp[55:48] <= (strb[2])? wdata[23:16] : tcmp[55:48];
            tcmp[63:56] <= (strb[3])? wdata[31:24] : tcmp[63:56];
        end
        else if (thcsr_wr_sel) begin
            halt_req  <= (strb[0])? wdata[0] : halt_req ;
        end
    end


    assign int_set = (cnt == tcmp);

   // interupt
    always @( posedge clk or negedge rst_n ) begin
        if ( !rst_n) begin
            int_en <=0;
        end
        else if ( tier_wr_sel) begin
            int_en <= (strb[0])? wdata[0] : int_en ;
        end
    end


    assign int_clr = (strb[0]) && wdata[0] && tisr_wr_sel;

    always @( posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            int_st <= 0;
        end
        else if (int_clr) begin
            int_st <= 0;
        end
        else if (int_set) begin
            int_st <= 1;
        end
        else
            int_st <= int_st;
    end

    assign tim_int = int_st && int_en;


// Error
    always @(*) begin
        if ( tcr_wr_sel) begin
                if ( wdata[11:8] > 4'b1000 ) begin
                    error <= (strb[1])? 1'b1 : 1'b0;
                end
                else if ( timer_en) begin
                    if (    (wdata[11:8] != div_val) && strb[1])begin
                        error <=  1'b1 ;
                    end
                    else if ( (wdata[1] != div_en) && strb[0])begin
                        error <= 1'b1 ;
                    end
                    else begin
                        error <= 1'b0;
                    end

                end
                else begin
                    error <= 1'b0;
                end
        end
        else begin
            error <=1'b0;
        end
    end
    // TCR
    always @( posedge clk or  negedge rst_n ) begin
        if (!rst_n) begin
            timer_en <= 1'b0;
            div_en   <= 1'b0;
            div_val  <= 4'b1;
        end
        else if ( tcr_wr_sel) begin
                if (!error) begin
                    timer_en <= (strb[0])? wdata[0] : timer_en;
                    div_en   <= (strb[0])? wdata[1] : div_en  ;
                    div_val  <= (strb[1])? wdata[11:8] : div_val ;
                end
        end
    end

    always @(*)begin
        if(rd_en & pready) begin
            case (addr)
                TCR  :    rdata = {20'b0, div_val, 6'b0, div_en, timer_en};
                TDR0 :    rdata = cnt[31:0];
                TDR1 :    rdata = cnt[63:32];
                TCMP0:    rdata = tcmp[31:0];
                TCMP1:    rdata = tcmp[63:32];
                TIER :    rdata = { 31'b0, int_en};
                TISR :    rdata = { 31'b0, int_st};
                THCSR:    rdata = { 30'h0, halt_ack , halt_req};
                default:  rdata = 32'b0;
            endcase
        end
        else begin
                rdata <= 32'b0;
        end
    end

    assign wdata_cnt [31:0] = ( tdr0_wr_sel || tdr1_wr_sel)?  wdata [31:0] : wdata_cnt [31:0];
    assign halt_request     = halt_req    ;
endmodule
