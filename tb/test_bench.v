module test_bench;
	reg sys_clk;
	reg sys_rst_n;
	reg tim_psel;
	reg tim_penable;
	reg tim_pwrite;
	reg [11:0] tim_paddr;
	reg [31:0] tim_pwdata;
	reg [3:0] tim_pstrb;
	reg dbg_mode;
	reg [31:0] val;
	reg [31:0] read_tmp;
	wire [31:0] tim_prdata;
	wire tim_pready;
	wire tim_pslverr;
	wire tim_int;
	timer_top dut (
	.sys_clk(sys_clk),
	.sys_rst_n(sys_rst_n),
	.tim_psel(tim_psel),
	.tim_penable(tim_penable),
	.tim_pwrite(tim_pwrite),
	.tim_paddr(tim_paddr),
	.tim_pwdata(tim_pwdata),
	.tim_pstrb(tim_pstrb),
	.dbg_mode(dbg_mode),
	.tim_prdata(tim_prdata),
	.tim_pready(tim_pready),
	.tim_pslverr(tim_pslverr),
	.tim_int(tim_int)


    );
	initial begin
		sys_clk =0;
		forever #5 sys_clk = ~sys_clk;
	end
	initial begin
		tim_pwrite  = 1;
		tim_psel    = 0;
		#1;
		tim_penable = 1;

		sys_rst_n = 0;
		@(posedge sys_clk);
		sys_rst_n   = 1;
		dbg_mode = 0;
		@(posedge sys_clk);

// check wait state
	/*
		tim_psel = 1;
		@(posedge sys_clk);
		tim_penable =1;
		@(posedge sys_clk);
		#1
		if ( tim_pready == 1) begin
			$display ("PASS wait state");
		end else begin
			$display ("FAIL wait state");
		end
		@(posedge sys_clk);
		tim_penable =1;
		tim_psel =0;
		@(posedge sys_clk);

// check initial value

		sys_rst_n = 0;
		@(posedge sys_clk);
		sys_rst_n = 1;

		@(posedge sys_clk);
		apb_read ( 12'h00, read_tmp );
		if ( read_tmp == 32'h00000100) begin
			$display ("PASSED initial value at TCR");
		end else begin
			$display ("FAILED initial value at TCR");
		end

		@(posedge sys_clk);
		apb_read ( 12'h04, read_tmp);
		if ( read_tmp == 32'h00000000) begin
			$display ("PASSED initial value at TDR0");
		end else begin
			$display ("FAILED initial value at TDR0");
		end

		@(posedge sys_clk);
		apb_read ( 12'h08, read_tmp);
		if ( read_tmp == 32'h00000000) begin
			$display ("PASSED initial value at TDR1");
		end else begin
			$display ("FAILED initial value at TDR1");
		end
		@(posedge sys_clk);
		apb_read ( 12'h0c, read_tmp);
		if ( read_tmp == 32'hFFFFFFFF) begin
			$display ("PASSED initial value at TCMP0");
		end else begin
			$display ("FAILED initial value at TCMP0");
		end
		@(posedge sys_clk );
		apb_read ( 12'h10, read_tmp);
		if ( read_tmp== 32'hFFFFFFFF) begin
			$display ("PASSED initial value at TCMP1");
		end else begin
			$display ("FAILED initial value at TCMP1");
		end
		@(posedge sys_clk);
		apb_read ( 12'h14, read_tmp );
		if ( read_tmp == 32'h00000000) begin
			$display ("PASSED initial value at TIER");
		end else begin
			$display ("FAILED initial value at TIER");
		end
		@(posedge sys_clk );
		apb_read ( 12'h18, read_tmp);
		if ( read_tmp == 32'h00000000) begin
			$display ("PASSED initial value at TISR");
		end else begin
			$display ("FAILED initial value at TISR");
		end
		@(posedge sys_clk);
		apb_read ( 12'h1c, read_tmp);

		if ( read_tmp == 32'h00000000) begin
			$display ("PASSED initial value at THCSR");
		end else begin
			$display ("FAILED initial value at THCSR");
		end
		@(posedge sys_clk);
		sys_rst_n = 1;
		@(posedge sys_clk);

// check byte strb ,  write , read data

   // invalid address

		apb_write ( 4'b1111, 12'hfff, 32'h55555555);
		@(posedge sys_clk);
		apb_read  ( 12'hFFF, read_tmp);
		if ( read_tmp == 32'h0) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);

    //TCR

		apb_write (4'b1, 12'h00, 32'hFFFFF5F2);
		@(posedge sys_clk);
		apb_read  (12'h00, read_tmp);
		if ( read_tmp == 32'h00000102) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);

		apb_write (4'b10, 12'h00, 32'hFFFFF5F2);
		@(posedge sys_clk);
		apb_read  (12'h00, read_tmp);
		if ( read_tmp == 32'h00000502) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);

		apb_write (4'b11, 12'h00, 32'hFFFFF4F0);
		@(posedge sys_clk);
		apb_read  (12'h00, read_tmp);
		if ( read_tmp == 32'h00000400) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);

		apb_write (4'b0, 12'h00, 32'h2);
		@(posedge sys_clk);
		apb_read (12'h00, read_tmp);
		if ( read_tmp == 32'h00000400) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);




    //TDR0


		apb_write (4'b1, 12'h04, 32'hFFFFFFFF);
		@(posedge sys_clk);
		apb_read  (12'h04, read_tmp);
		if ( read_tmp == 32'h000000FF) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);

		apb_write (4'b10, 12'h04, 32'hFFFFFFFF);
		@(posedge sys_clk);
		apb_read  (12'h04, read_tmp);
		if ( read_tmp == 32'h0000FFFF) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);

		apb_write (4'b100, 12'h04, 32'hFFFFFFFF);
		@(posedge sys_clk);
		apb_read  (12'h04, read_tmp);
		if ( read_tmp == 32'h00FFFFFF) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);

		apb_write (4'b1000, 12'h04, 32'hFFFFFFFF);
		@(posedge sys_clk);
		apb_read  (12'h04, read_tmp);
		if ( read_tmp == 32'hFFFFFFFF) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);

		apb_write (4'b1111, 12'h04, 32'h00000000);
		@(posedge sys_clk);
		apb_read  (12'h04, read_tmp);
		if ( read_tmp == 32'h00000000) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);


    //TDR1

		apb_write (4'b1, 12'h08, 32'hFFFFFFFF);
		@(posedge sys_clk);
		apb_read  (12'h08, read_tmp);
		if ( read_tmp == 32'h000000FF) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);

		apb_write (4'b10, 12'h08, 32'hFFFFFFFF);
		@(posedge sys_clk);
		apb_read  (12'h08, read_tmp);

		if ( read_tmp == 32'h0000FFFF) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);

		apb_write (4'b100, 12'h08, 32'hFFFFFFFF);
		@(posedge sys_clk);
		apb_read  (12'h08, read_tmp);
		if ( read_tmp == 32'h00FFFFFF) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);

		apb_write (4'b1000, 12'h08, 32'hFFFFFFFF);
		@(posedge sys_clk);
		apb_read  (12'h08, read_tmp);
		if ( read_tmp == 32'hFFFFFFFF) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);

		apb_write (4'b1111, 12'h08, 32'hAAAAAAAA);
		@(posedge sys_clk);
		apb_read  (12'h08, read_tmp);
		if ( read_tmp == 32'hAAAAAAAA) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end

		@(posedge sys_clk);


    //TCMP0

		apb_write (4'b1, 12'h0C, 32'h00000000);
		@(posedge sys_clk);
		apb_read  (12'h0C, read_tmp);
		if ( read_tmp == 32'hFFFFFF00) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end

		@(posedge sys_clk);
		apb_write (4'b10, 12'h0C, 32'h00000000);
		@(posedge sys_clk);
		apb_read  (12'h0C, read_tmp);
		if ( read_tmp == 32'hFFFF0000) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);

		apb_write (4'b100, 12'h0C, 32'h00000000);
		@(posedge sys_clk);
		apb_read  (12'h0C, read_tmp);
		if ( read_tmp == 32'hFF000000) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);

		apb_write (4'b1000, 12'h0C, 32'h00000000);
		@(posedge sys_clk);
		apb_read  (12'h0C, read_tmp);
		if ( read_tmp == 32'h00000000) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end

		@(posedge sys_clk);
		apb_write (4'b1111, 12'h0C, 32'hFFFFFFFF);
		@(posedge sys_clk);
		apb_read  (12'h0C, read_tmp);
		if ( read_tmp == 32'hFFFFFFFF) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end


		@(posedge sys_clk);

		apb_write (4'b1111, 12'h0C, 32'hAAAAAAAA);
		@(posedge sys_clk);
		apb_read  (12'h0C, read_tmp);
		if ( read_tmp == 32'hAAAAAAAA) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end

		@(posedge sys_clk);


    //TCMP1

		apb_write (4'b1, 12'h10, 32'h00000000);
		@(posedge sys_clk);
		apb_read  (12'h10, read_tmp);
		if ( read_tmp == 32'hFFFFFF00) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end

		@(posedge sys_clk);

		apb_write (4'b10, 12'h10, 32'h00000000);
		@(posedge sys_clk);
		apb_read  (12'h10, read_tmp);
		if ( read_tmp == 32'hFFFF0000) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end

		@(posedge sys_clk);

		apb_write (4'b100, 12'h10, 32'h00000000);
		@(posedge sys_clk);
		apb_read  (12'h10, read_tmp);
		if ( read_tmp == 32'hFF000000) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end

		@(posedge sys_clk);

		apb_write (4'b1000, 12'h10, 32'h00000000);
		@(posedge sys_clk);
		apb_read  (12'h10, read_tmp);
		if ( read_tmp == 32'h00000000) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end

		@(posedge sys_clk);

		apb_write (4'b1111, 12'h10, 32'hFFFFFFFF);
		@(posedge sys_clk);
		apb_read  (12'h10, read_tmp);
		if ( read_tmp == 32'hFFFFFFFF) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end

		@(posedge sys_clk);

		apb_write (4'b1111, 12'h10, 32'hAAAAAAAA);
		@(posedge sys_clk);
		apb_read  (12'h10, read_tmp);
		if ( read_tmp == 32'hAAAAAAAA) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end

		@(posedge sys_clk);


    //TIER

		apb_write (4'b1, 12'h14, 32'hFFFFFFFF);
		@(posedge sys_clk);
		apb_read  (12'h14, read_tmp);
		if ( read_tmp == 32'h00000001) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end

		@(posedge sys_clk);

		apb_write (4'b10, 12'h14, 32'hFFFFFFFF);
		@(posedge sys_clk);
		apb_read  (12'h14, read_tmp);
		if ( read_tmp == 32'h00000001) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end

		@(posedge sys_clk);

		apb_write (4'b100, 12'h14, 32'hFFFFFFFF);
		@(posedge sys_clk);
		apb_read  (12'h14, read_tmp);
		if ( read_tmp == 32'h00000001) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end

		@(posedge sys_clk);

		apb_write (4'b1000, 12'h14, 32'hFFFFFFFF);
		@(posedge sys_clk);
		apb_read  (12'h14, read_tmp);
		if ( read_tmp == 32'h00000001) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end

		@(posedge sys_clk);

		apb_write (4'b1111, 12'h14, 32'h88888888);
		@(posedge sys_clk);
		apb_read  (12'h14, read_tmp);
		if ( read_tmp == 32'h00000000) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end

		@(posedge sys_clk);

		apb_write (4'b0, 12'h14, 32'h1);
		@(posedge sys_clk);
		apb_read (12'h14, read_tmp);
		if ( read_tmp == 32'h00000000) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end

		@(posedge sys_clk);

//THCSR

		dbg_mode = 1;
		apb_write (4'b1, 12'h1C, 32'hFFFFFFFF);
		@(posedge sys_clk);
		apb_read  (12'h1C, read_tmp);
		if ( read_tmp == 32'h00000003) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end

		@(posedge sys_clk);

		apb_write (4'b10, 12'h1C, 32'hFFFFFFFF);
		@(posedge sys_clk);
		apb_read  (12'h1C, read_tmp);
		if ( read_tmp == 32'h00000003) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end

		@(posedge sys_clk);

		apb_write (4'b100, 12'h1C, 32'hFFFFFFFF);
		@(posedge sys_clk);
		apb_read  (12'h1C, read_tmp);
		if ( read_tmp == 32'h00000003) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end

		@(posedge sys_clk);

		apb_write (4'b1000, 12'h1C, 32'hFFFFFFFF);
		@(posedge sys_clk);
		apb_read  (12'h1C, read_tmp);
		if ( read_tmp == 32'h00000003) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end

		@(posedge sys_clk);

		apb_write (4'b1111, 12'h1C, 32'h88888888);
		@(posedge sys_clk);
		apb_read  (12'h1C, read_tmp);
		if ( read_tmp == 32'h00000000) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);

		apb_write (4'b0, 12'h1C, 32'h1);
		@(posedge sys_clk);
		apb_read ( 12'h1c, read_tmp);
		if ( read_tmp == 32'h00000000) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);

//check error

    // Write div_val = 4'hb
		apb_write( 4'b10, 12'h00, 32'h00000b00);
		if ( tim_pslverr == 1) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);
		apb_read ( 12'h00, read_tmp);
		@(posedge sys_clk);

    //Write valid data into tcr timer_en, div_en = 1, div_val = 4'h5
		apb_write ( 4'b11, 12'h00, 32'h00000503);
		@(posedge sys_clk);
		apb_read ( 12'h00, read_tmp);
		@(posedge sys_clk);

   // Change div_en = 0 when timer_en = 1
		apb_write ( 4'b1, 12'h00, 32'h00000001);
		if ( tim_pslverr == 1) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end

		@(posedge sys_clk);
		apb_read ( 12'h00, read_tmp);
		if ( read_tmp == 32'h00000503) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);

    //Write

		apb_write ( 4'b0, 12'h00, 32'h00000001);

		@(posedge sys_clk);
		apb_read ( 12'h00, read_tmp);

		@(posedge sys_clk);


   // Change div_val = 3 when timer_en = 1
		apb_write ( 4'b10, 12'h00, 32'h00000300);

		if ( tim_pslverr == 1) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end

		@(posedge sys_clk);
		apb_read ( 12'h00, read_tmp);

		@(posedge sys_clk);

// Interupt

		sys_rst_n =0;
		@(posedge sys_clk);
		sys_rst_n =1;
		@(posedge sys_clk);

    //TH1: check with default_mode

        // Write int_en =1;
		apb_write ( 4'b1, 12'h14, 32'h00000001);
		@(posedge sys_clk);
        // Write tcmp0
		apb_write ( 4'b1111, 12'h0c, 32'h0000000F);
		@(posedge sys_clk);
        // Write tcmp1
		apb_write (4'b1111, 12'h10, 32'h00000000);
		@(posedge sys_clk);
        // Write timer_en =1 , div_en = 0;
		apb_write (4'b1, 12'h00, 32'h00000001);
		repeat(15) @(posedge sys_clk);
		#1;
		if ( tim_int == 1) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
			$finish;
		end

		apb_read ( 12'h18, read_tmp);
		if ( read_tmp == 32'h00000001) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
			$finish;
		end

		@(posedge sys_clk);

        // Write int_en =0 to clear interupt
		apb_write ( 4'b1, 12'h14, 32'h0);
		if ( tim_int == 0) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
			$finish;
		end
		@(posedge sys_clk);

        // Write 1 into TISR to clear interupt
//		apb_write ( 4'b1, 12'h18, 32'h00000001);
//		@(posedge sys_clk);
//		apb_read ( 12'h18, read_tmp);
//		if ( read_tmp == 32'h00000000) begin
//			$display ("PASSED");
//		end else begin
//			$display ("FAILED");
//		end
//
//		@(posedge sys_clk);


   // TH2: check with div_val = 1

        // Write int_en =1;
		apb_write ( 4'b1, 12'h14, 32'h00000001);
		@(posedge sys_clk);

        // Write tcmp0
		apb_write ( 4'b1111, 12'h0c, 32'h0000009);
		@(posedge sys_clk);
        // Write tcmp1
		apb_write (4'b1111, 12'h10, 32'h00000000);
		@(posedge sys_clk);
        // Write timer_en =1 , div_en = 1, div_val =1 ;
		apb_write (4'b1, 12'h00, 32'h00000103);
		repeat(18) @(posedge sys_clk);
		#1;

		if ( tim_int == 1) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
			$finish;
		end

		apb_read ( 12'h18, read_tmp);
		if ( read_tmp == 32'h00000001) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
			$finish;
		end

		@(posedge sys_clk);
        // Write 1 into TISR to clear interupt
		apb_write ( 4'b1, 12'h18, 32'h00000001);
		@(posedge sys_clk);
		apb_read ( 12'h18, read_tmp);
		if ( read_tmp == 32'h00000000) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
			$finish;
		end

		@(posedge sys_clk);

// check counter control, timer_en H --> L ( cnt = 0)
        // default_mode
		sys_rst_n =0;
		@(posedge sys_clk);
		sys_rst_n =1;
		@(posedge sys_clk);

		apb_write(4'b1, 12'h00, 32'h00000001);
		@(posedge sys_clk);
		apb_read ( 12'h04, read_tmp);

		if ( read_tmp == 32'h4) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED counter default");
		end
		@(posedge sys_clk);
		apb_read ( 12'h04, read_tmp);
		#1;
		if ( read_tmp == 32'h8) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED counter default");
		end

		repeat (10) @(posedge sys_clk);

        // timer_en H --> L
		apb_write(4'b1,12'h00,32'h00000000);
		@(posedge sys_clk);
		apb_read( 12'h04, read_tmp);
		if ( read_tmp == 32'h0) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end

        // control_mode, div_val =0;
		@(posedge sys_clk);
		apb_write(4'b11, 12'h00, 32'h00000003);
		@(posedge sys_clk);
		apb_read ( 12'h04, read_tmp);
		#1;
		if ( read_tmp == 32'h4) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);
		@(posedge sys_clk);
		apb_read ( 12'h4, read_tmp);
		#1;
		if ( read_tmp == 32'h9) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end

		repeat(10) @(posedge sys_clk);

        // control_mode, div_val = 1

		apb_write(4'b1,12'h00,32'h00000002);
		@(posedge sys_clk);
		apb_read( 12'h04, read_tmp);
		if ( read_tmp == 32'h0) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);

		apb_write(4'b11, 12'h00, 32'h00000103);
		@(posedge sys_clk);
		apb_read ( 12'h04, read_tmp);
		#1;
		if ( read_tmp == 32'h2) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		repeat(1) @(posedge sys_clk);
		apb_read ( 12'h04, read_tmp);
		#1;
		if ( read_tmp == 32'h4) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);

        // control_mode, div_val = 2;

		apb_write(4'b1,12'h00,32'h00000002);
		@(posedge sys_clk);
		apb_read( 12'h04, read_tmp);
		if ( read_tmp == 32'h0) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);

		apb_write(4'b11, 12'h00, 32'h00000203);
		@(posedge sys_clk);
		apb_read ( 12'h04, read_tmp);
		#1;
		if ( read_tmp == 32'h1) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		repeat(1) @(posedge sys_clk);
		apb_read ( 12'h04, read_tmp);
		#1;
		if ( read_tmp == 32'h2) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		repeat (10) @(posedge sys_clk);

        // control_mode, div_val = 3;

		apb_write(4'b1,12'h00,32'h00000002);
		@(posedge sys_clk);
		apb_read( 12'h04, read_tmp);
		if ( read_tmp == 32'h0) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);

		apb_write(4'b11, 12'h00, 32'h00000303);
		repeat(13) @(posedge sys_clk);
		apb_read ( 12'h04, read_tmp);
		#1;
		if ( read_tmp == 32'h2) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		repeat(5) @(posedge sys_clk);
		apb_read ( 12'h04, read_tmp);
		#1;
		if ( read_tmp == 32'h3) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		repeat(20) @(posedge sys_clk);

        // control_mode, div_val = 4;

		apb_write(4'b1,12'h00,32'h00000002);
		@(posedge sys_clk);
		apb_read( 12'h04, read_tmp);
		if ( read_tmp == 32'h0) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);

		apb_write(4'b11, 12'h00, 32'h00000403);
		repeat(13) @(posedge sys_clk);
		apb_read ( 12'h04, read_tmp);
		#1;
		if ( read_tmp == 32'h1) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		repeat(13) @(posedge sys_clk);
		apb_read ( 12'h04, read_tmp);
		#1;
		if ( read_tmp == 32'h2) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		repeat (10) @(posedge sys_clk);

        // control_mode, div_val = 5;

		apb_write(4'b1,12'h00,32'h00000002);
		@(posedge sys_clk);
		apb_read( 12'h04, read_tmp);
		if ( read_tmp == 32'h0) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);

		apb_write(4'b11, 12'h00, 32'h00000503);
		repeat(29) @(posedge sys_clk);
		apb_read ( 12'h04, read_tmp);
		#1;
		if ( read_tmp == 32'h1) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		repeat(29) @(posedge sys_clk);
		apb_read ( 12'h04, read_tmp);
		#1;
		if ( read_tmp == 32'h2) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		repeat(10) @(posedge sys_clk);

        // control_mode, div_val = 6;

		apb_write(4'b1,12'h00,32'h00000002);
		@(posedge sys_clk);
		apb_read( 12'h04, read_tmp);
		if ( read_tmp == 32'h0) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);

		apb_write(4'b11, 12'h00, 32'h00000603);
		repeat(61) @(posedge sys_clk);
		apb_read ( 12'h04, read_tmp);
		#1;
		if ( read_tmp == 32'h1) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		repeat(61) @(posedge sys_clk);
		apb_read ( 12'h04, read_tmp);
		#1;
		if ( read_tmp == 32'h2) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		repeat(10) @(posedge sys_clk);

        // control_mode, div_val = 7;

		apb_write(4'b1,12'h00,32'h00000002);
		@(posedge sys_clk);
		apb_read( 12'h04, read_tmp);
		if ( read_tmp == 32'h0) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);

		apb_write(4'b11, 12'h00, 32'h00000703);
		repeat(125) @(posedge sys_clk);
		apb_read ( 12'h04, read_tmp);
		#1;
		if ( read_tmp == 32'h1) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		repeat(125) @(posedge sys_clk);
		apb_read ( 12'h04, read_tmp);
		#1;
		if ( read_tmp == 32'h2) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		repeat(10) @(posedge sys_clk);

        // control_mode, div_val = 8;

		apb_write(4'b1,12'h00,32'h00000002);
		@(posedge sys_clk);
		apb_read( 12'h04, read_tmp);
		if ( read_tmp == 32'h0) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);

		apb_write(4'b11, 12'h00, 32'h00000803);
		repeat(253) @(posedge sys_clk);
		apb_read ( 12'h04, read_tmp);
		#1;
		if ( read_tmp == 32'h1) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		repeat(253) @(posedge sys_clk);
		apb_read ( 12'h04, read_tmp);
		#1;
		if ( read_tmp == 32'h2) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		repeat(10) @(posedge sys_clk);



// check 64 bit cnt
		sys_rst_n = 0;
		@(posedge sys_clk);
		sys_rst_n = 1;
		@(posedge sys_clk);

		apb_write ( 4'b1111, 12'h04, 32'hFFFFFFF0);
		@(posedge sys_clk);
		apb_write ( 4'b1, 12'h00, 32'h00000001);
		repeat (13) @(posedge sys_clk);
		apb_read ( 12'h08, read_tmp);
		#1;
		if ( read_tmp == 32'h1) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end

		repeat (10) @(posedge sys_clk);
	*/

// check halt
        // default_mode;
		sys_rst_n = 0;
		@(posedge sys_clk);
		sys_rst_n = 1;
		@(posedge sys_clk);

		dbg_mode =1;
		apb_write ( 4'b1, 12'h00, 32'h00000001);
		@(posedge sys_clk);
		apb_write ( 4'b1, 12'h1c, 32'h00000001);
		@(posedge sys_clk);
		apb_read ( 12'h04, read_tmp);
		val = read_tmp;

		repeat (4) @(posedge sys_clk);
		apb_read ( 12'h04, read_tmp);
		#1;
		if ( read_tmp == val) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);

		apb_write ( 4'b1, 12'h1c, 32'h00000000);
		@(posedge sys_clk);
		apb_read ( 12'h04, read_tmp);
		#1;
		if ( read_tmp > val) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end

		repeat (4) @(posedge sys_clk);


        // control_mode , div_val = 2;

		dbg_mode =1;
		apb_write ( 4'b11, 12'h00, 32'h00000203);
		@(posedge sys_clk);
		apb_write ( 4'b1, 12'h1c, 32'h00000001);
		@(posedge sys_clk);
		apb_read ( 12'h04, read_tmp);
		#1;
		val = read_tmp;
		repeat (10) @(posedge sys_clk);
		apb_read (  12'h04, read_tmp);
		#1;
		if ( read_tmp == val) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end
		@(posedge sys_clk);

		apb_write ( 4'b1, 12'h1c, 32'h00000000);
		repeat (10) @(posedge sys_clk);
		apb_read ( 12'h04, read_tmp);
		#1;
		if ( read_tmp > val) begin
			$display ("PASSED");
		end else begin
			$display ("FAILED");
		end

		repeat (4) @(posedge sys_clk);

		$finish;
	end


	task apb_write (

		input [3:0] strb,
		input [11:0] address,
		input [31:0] data
);
	  begin
		tim_psel = 1 ;
		tim_pwrite = 1;
		tim_pstrb = strb;
		tim_paddr = address;
		tim_pwdata = data;
		@(posedge sys_clk);
		tim_penable = 1;
		@(posedge sys_clk);
		@(posedge sys_clk);
		tim_psel = 0;

		tim_penable =0;


	  end
	endtask

	task apb_read(
		input [11:0] address,
		output reg [31:0] read_data
);
	  begin
		tim_psel = 1;
		tim_pwrite = 0;
		tim_paddr = address;
		@(posedge sys_clk);
		#1;
		tim_penable = 1;
		@(posedge sys_clk);
		#1;
		read_data = tim_prdata;
		@(posedge sys_clk);
		tim_psel = 0;
		#1;
		tim_penable =0;
	  end
	endtask

endmodule
