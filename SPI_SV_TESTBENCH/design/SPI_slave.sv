module spi_slave_fsm (
    input  sclk,
    input  cs,       // active-low
    input  mosi,
    output reg miso,
    input  [7:0] data_in,
    output reg [7:0] data_out
);

    reg [2:0] bit_cnt;
    reg [7:0] shift_tx;
    reg [7:0] shift_rx;

    // When CS asserts (low), preload TX and put MSB on MISO BEFORE first rising edge
    always @(negedge cs) begin
        bit_cnt  <= 3'd7;
        shift_tx <= data_in;
        miso     <= data_in[7];    // <-- present first bit early
    end

    // Sample MOSI on rising edge (CPOL=0, CPHA=0)
    always @(posedge sclk) begin
        if (!cs) begin
            shift_rx[bit_cnt] <= mosi;
            if (bit_cnt == 0) begin
                // include the just-sampled LSB
                data_out <= {shift_rx[7:1], mosi};
            end
        end
    end

    // Drive next MISO bit on falling edge so it's stable by next rising edge
    always @(negedge sclk) begin
        if (!cs) begin
            if (bit_cnt != 0) begin
                bit_cnt <= bit_cnt - 1;
                miso    <= shift_tx[bit_cnt-1]; // next bit
            end
        end else begin
            miso <= 1'b0; // idle when CS high (optional)
        end
    end
endmodule
