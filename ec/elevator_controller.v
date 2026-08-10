`timescale 1ns/1ps

module elevator_controller #(
    parameter integer NUM_FLOORS = 4,
    parameter integer DOOR_TIME  = 3
)(
    input  wire        clk,
    input  wire        reset,
    input  wire [3:0]  request,

    output reg [1:0]   current_floor,
    output reg         motor_up,
    output reg         motor_down,
    output reg         door_open
);

    // FSM states
    localparam IDLE      = 2'd0;
    localparam UP        = 2'd1;
    localparam DOWN      = 2'd2;
    localparam DOOR_OPEN = 2'd3;

    reg [1:0] state;
    reg [1:0] target_floor;

    reg [2:0] door_counter;

    // Find the next requested floor.
    // Priority is given to the lowest-numbered requested floor.
    always @(*) begin
        if (request[0])
            target_floor = 2'd0;
        else if (request[1])
            target_floor = 2'd1;
        else if (request[2])
            target_floor = 2'd2;
        else if (request[3])
            target_floor = 2'd3;
        else
            target_floor = current_floor;
    end

    // Elevator FSM
    always @(posedge clk or posedge reset) begin

        if (reset) begin
            current_floor <= 2'd0;
            state         <= IDLE;
            door_counter  <= 3'd0;
            motor_up      <= 1'b0;
            motor_down    <= 1'b0;
            door_open     <= 1'b0;
        end

        else begin

            // Default outputs
            motor_up   <= 1'b0;
            motor_down <= 1'b0;

            case (state)

                // -------------------------
                // IDLE STATE
                // -------------------------
                IDLE: begin
                    door_open    <= 1'b0;
                    door_counter <= 3'd0;

                    if (request != 4'b0000) begin

                        if (target_floor > current_floor) begin
                            state <= UP;
                        end

                        else if (target_floor < current_floor) begin
                            state <= DOWN;
                        end

                        else begin
                            state <= DOOR_OPEN;
                        end
                    end
                end

                // -------------------------
                // UP STATE
                // -------------------------
                UP: begin
                    door_open <= 1'b0;
                    motor_up  <= 1'b1;

                    if (current_floor < target_floor) begin
                        current_floor <= current_floor + 1'b1;
                    end
                    else begin
                        state        <= DOOR_OPEN;
                        motor_up     <= 1'b0;
                        door_counter <= 3'd0;
                    end
                end

                // -------------------------
                // DOWN STATE
                // -------------------------
                DOWN: begin
                    door_open   <= 1'b0;
                    motor_down  <= 1'b1;

                    if (current_floor > target_floor) begin
                        current_floor <= current_floor - 1'b1;
                    end
                    else begin
                        state         <= DOOR_OPEN;
                        motor_down    <= 1'b0;
                        door_counter  <= 3'd0;
                    end
                end

                // -------------------------
                // DOOR OPEN STATE
                // -------------------------
                DOOR_OPEN: begin
                    motor_up   <= 1'b0;
                    motor_down <= 1'b0;
                    door_open  <= 1'b1;

                    if (door_counter < DOOR_TIME - 1) begin
                        door_counter <= door_counter + 1'b1;
                    end
                    else begin
                        door_counter <= 3'd0;
                        door_open    <= 1'b0;
                        state        <= IDLE;
                    end
                end

                default: begin
                    state        <= IDLE;
                    current_floor <= 2'd0;
                    motor_up     <= 1'b0;
                    motor_down   <= 1'b0;
                    door_open    <= 1'b0;
                end

            endcase
        end
    end

endmodule