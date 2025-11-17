module spi_master_fsm #(
    parameter int CLK_DIV = 2  
)(
    input  logic       clk,
    input  logic       rst,        
    input  logic       start,      
    input  logic [7:0] data_in,
    output logic [7:0] data_out,
    output logic       mosi,
    input  logic       miso,
    output logic       sclk,
    output logic       cs,         
    output logic       done
);

    typedef enum logic [1:0] { IDLE, LOAD, TRANSFER, DONE } state_t;
    state_t state, nstate;

    logic [$clog2(CLK_DIV)-1:0] div_cnt;
    logic tick;     
    logic sclk_int;
    logic [2:0] bit_cnt;
    logic [7:0] sh_tx, sh_rx;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            div_cnt <= '0;
            tick    <= 1'b0;
        end else begin
            if (state == TRANSFER) begin
                if (div_cnt == CLK_DIV - 1) begin
                    div_cnt <= '0;
                    tick    <= 1'b1;
                end else begin
                    div_cnt <= div_cnt + 1'b1;
                    tick    <= 1'b0;
                end
            end else begin
                div_cnt <= '0;
                tick    <= 1'b0;
            end
        end
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            sclk_int <= 1'b0;
        else if (state == TRANSFER && tick)
            sclk_int <= ~sclk_int;
        else if (state != TRANSFER)
            sclk_int <= 1'b0;
    end

    assign sclk = sclk_int;


    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= nstate;
    end

 
    always_comb begin
        nstate = state;
        unique case (state)
            IDLE     : if (start) nstate = LOAD;
            LOAD     :            nstate = TRANSFER;
            TRANSFER : if (bit_cnt == 3'd0 && tick && sclk_int == 1'b1)
                           nstate = DONE;
            DONE     :            nstate = IDLE;
        endcase
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            cs       <= 1'b1;
            done     <= 1'b0;
            bit_cnt  <= 3'd7;
            sh_tx    <= 8'h00;
            sh_rx    <= 8'h00;
            mosi     <= 1'b0;
            data_out <= 8'h00;
        end else begin
            done <= 1'b0;

            case (state)
               
                IDLE: begin
                    cs      <= 1'b1;
                    mosi    <= 1'b0;
                    bit_cnt <= 3'd7;
                end

                LOAD: begin
                    cs      <= 1'b0;
                    sh_tx   <= data_in;
                    sh_rx   <= '0;
                    bit_cnt <= 3'd7;
                    mosi    <= data_in[7];
                end
               
                TRANSFER: begin
                    if (tick) begin
                        if (sclk_int == 1'b0) begin
                            
                            mosi <= sh_tx[bit_cnt];
                        end else begin
                           
                            sh_rx[bit_cnt] <= miso;
                            if (bit_cnt != 3'd0)
                                bit_cnt <= bit_cnt - 1'b1;
                        end
                    end
                end

                DONE: begin
                    cs       <= 1'b1;
                    data_out <= sh_rx;
                    done     <= 1'b1;
                end
            endcase
        end
    end

endmodule
