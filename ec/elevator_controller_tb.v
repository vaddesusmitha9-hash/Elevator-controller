`timescale 1ns/1ps

module elevator_controller_tb;

    reg clk;
    reg reset;
    reg [3:0] request;

    wire [1:0] current_floor;
    wire motor_up;
    wire motor_down;
    wire door_open;

    // Instantiate DUT
    elevator_controller #(
        .NUM_FLOORS(4),
        .DOOR_TIME(3)
    ) uut (
        .clk(clk),
        .reset(reset),
        .request(request),

        .current_floor(current_floor),
        .motor_up(motor_up),
        .motor_down(motor_down),
        .door_open(door_open)
    );

    // 10 ns clock period
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // Display controller status
    initial begin
        $monitor(
            "Time=%0t ns | Request=%b | Floor=%0d | UP=%b | DOWN=%b | DOOR=%b",
            $time,
            request,
            current_floor,
            motor_up,
            motor_down,
            door_open
        );
    end

    // Test sequence
    initial begin

        // -----------------------------
        // Initial reset
        // -----------------------------
        reset   = 1'b1;
        request = 4'b0000;

        #20;

        reset = 1'b0;

        // -----------------------------
        // Request Floor 2
        // -----------------------------
        #10;
        request = 4'b0100;

        // Wait until elevator reaches floor 2
        #80;

        // Remove request
        request = 4'b0000;

        // Allow door operation
        #50;

        // -----------------------------
        // Request Floor 0
        // -----------------------------
        request = 4'b0001;

        #100;

        request = 4'b0000;

        #50;

        // -----------------------------
        // Request Floor 3
        // -----------------------------
        request = 4'b1000;

        #100;

        request = 4'b0000;

        #50;

        // Finish simulation
        $display("-----------------------------------------");
        $display("ELEVATOR SIMULATION COMPLETED");
        $display("-----------------------------------------");

        $finish;
    end

endmodule