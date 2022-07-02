`timescale 1ns / 1ps



module debouncer
    (
    input logic clk, reset, sw,
    output logic db
    );
    
    localparam N=20;
    
    typedef enum {
    zero, wait1_1, wait1_2, wait1_3,
    one, wait0_1, wait0_2, wait0_3
    } state_type;
    
    state_type state_reg, state_next;
    logic [N-1:0] q_reg;
    logic [N-1:0] q_next;
    logic m_tick;
    
    always_ff @(posedge clk)
        q_reg <= q_next;
        
    assign q_next = q_reg + 1;
    assign m_tick = (q_reg==0) ? 1'b1 : 1'b0;
    
    always_ff @(posedge clk, posedge reset)
        if (reset)
            state_reg <= zero;
        else
            state_reg <= state_next;
    
    always_comb
    begin
        state_next = state_reg;
        db = 1'b0;
        case (state_reg)
            zero:
                if (sw)
                    state_next = wait1_1;
            wait1_1:
                if (~sw)
                    state_next = zero;
                else
                    if (m_tick)
                        state_next = wait1_2;
            wait1_2:
                if (~sw)
                    state_next = zero;
                else
                    if (m_tick)
                        state_next = wait1_3;
            wait1_3:
                if (~sw)
                    state_next = zero;
                else
                    if (m_tick)
                        state_next = one;
            one:
                begin
                    db = 1'b1;
                    if (~sw)
                        state_next = wait0_1;
                end
            wait0_1:
                begin
                    db = 1'b1;
                    if (sw)
                        state_next = one;
                    else
                        if (m_tick)
                            state_next = wait0_2;
                end
            wait0_2:
                begin
                    db = 1'b1;
                    if (sw)
                        state_next = one;
                    else
                        if (m_tick)
                            state_next = wait0_3;
                end
            wait0_3:
                begin
                    db = 1'b1;
                    if (sw)
                        state_next = one;
                    else
                        if (m_tick)
                            state_next = zero;
                end
            default: state_next = zero;
        endcase
    end
endmodule
