module stepperv1 (
    input clk,           // 50 MHz clock (PIN_Y2)
    input enable_switch, // SW[0] (PIN_AB28) - Active HIGH to enable motor
    input dir_switch,    // SW[1] (PIN_AC28) - 0=CW, 1=CCW
    output reg step,     // STEP to DRV8825 (PIN_AC15)
    output reg dir,      // DIR to DRV8825 (PIN_AD15)
    output reg enable,   // ENABLE to DRV8825 (PIN_AD14) - Active LOW
    output reg enable_LED,      // DIR to DRV8825 (PIN_AD15)
    output reg dir_LED    // ENABLE to DRV8825 (PIN_AD14) - Active LOW
);

    reg [31:0] counter;
    parameter STEP_DELAY = 10000; // Fixed speed (~300 RPM for 200-step motor)

    always @(posedge clk) begin
        // Set direction and enable outputs
        dir <= dir_switch;
        enable <= ~enable_switch; // DRV8825 enable
        enable_LED <= ~enable_switch; // LED enable
        dir_LED <= dir_switch; // LED direction
        if (enable_switch) begin // Motor enabled
            if (counter >= STEP_DELAY) begin
                counter <= 0;
                step <= ~step; // Continuous step pulses when enabled
            end else begin
                counter <= counter + 1;
            end
        end else begin // Motor disabled
            step <= 0;
            counter <= 0;
        end
    end
endmodule