module cnt_ctrl (
    input wire clk,
    input wire rst_n,
    input wire timer_en,
    input wire div_en,
    input wire [3:0] div_val,
    input wire dbg_mode,
    input wire halt_req,
    output wire halt_ack,
    output wire cnt_en
);
    wire cnt_rst;
    reg [7:0] int_cnt;
    reg [7:0] limit;
    wire cnt1;
    wire cnt2;
    wire cnt3;

    assign cnt_rst = (~timer_en) || (~div_en) || ( int_cnt == limit );

    always @(*) begin
        case ( div_val)
        4'b0000: limit = 8'd0;
        4'b0010: limit = 8'd3;
        4'b0011: limit = 8'd7;
        4'b0100: limit = 8'd15;
        4'b0101: limit = 8'd31;
        4'b0110: limit = 8'd63;
        4'b0111: limit = 8'd127;
        4'b1000: limit = 8'd255;
        default: limit = 8'd1;
        endcase
    end


    always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        int_cnt <= 8'b0;
    end
    else if (cnt_rst && !halt_ack) begin
            int_cnt <= 8'b0;
        end else if (timer_en && !halt_ack ) begin
            int_cnt <= int_cnt + 8'b1;
        end else
            int_cnt <= int_cnt;
    end

    assign cnt1     = timer_en && !div_en;
    assign cnt2     = timer_en && div_en && (div_val == 0);
    assign cnt3     = timer_en && div_en && (limit == int_cnt) && (div_val !=0);
    assign halt_ack = dbg_mode && halt_req;
    assign cnt_en   = ( cnt1 || cnt2 || cnt3 ) && !halt_ack;

endmodule
