module counter (
    input wire clk,
    input wire rst_n,
    input wire cnt_en,
    input wire timer_en,
    input wire tdr0_wr_sel,
    input wire tdr1_wr_sel,
    input wire [3:0] strb,
    input wire [31:0] wdata,
    output reg [63:0] cnt
);
    reg [31:0] tdr0;
    reg [31:0] tdr1;

    reg pre_timer_en;
    wire pulse_n;

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pre_timer_en <= 1'b0;
        end
        else begin
            pre_timer_en  <= timer_en;
        end
    end

    assign pulse_n = ~timer_en  & pre_timer_en;

    always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt    <= 64'b0;
    end
    else if (pulse_n) begin
        cnt <= 64'b0;
    end
    else if (tdr0_wr_sel) begin
//        tdr0       <= wdata;
        cnt[7:0]   <= (strb[0])? wdata[7:0]   : cnt [7:0]   ;
        cnt[15:8]  <= (strb[1])? wdata[15:8]  : cnt [15:8]  ;
        cnt[23:16] <= (strb[2])? wdata[23:16] : cnt [23:16] ;
        cnt[31:24] <= (strb[3])? wdata[31:24] : cnt [31:24] ;
    end
    else if ( tdr1_wr_sel) begin
//        tdr1 <= wdata;
        cnt[39:32] <= (strb[0])? wdata[7:0] : cnt [39:32] ;
        cnt[47:40] <= (strb[1])? wdata[15:8] : cnt [47:40] ;
        cnt[55:48] <= (strb[2])? wdata[23:16] : cnt [55:48] ;
        cnt[63:56] <= (strb[3])? wdata[31:24] : cnt [63:56] ;
    end
    else if (cnt_en) begin
        cnt <= cnt + 1'b1;
    end
    else begin
        cnt <= cnt;
    end
    end

endmodule
