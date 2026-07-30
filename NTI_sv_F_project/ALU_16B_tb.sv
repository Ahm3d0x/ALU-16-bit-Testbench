`timescale 1ns/1ps

typedef struct packed{
  logic [15:0] a;
  logic [15:0] b;
  logic [3:0]  op;
} in_trans_t;

typedef struct packed {
  logic [15:0] out;
  logic        c_flag, ar_flag, lg_flag, cmp_flag, sh_flag;
} out_trans_t;


//  top module 
module tb_top;

logic clk = 0;
always #5 clk = ~clk;



logic [15:0] a, b, alu_out;
logic [3:0]  alu_fun;
logic        arith_flag, carry_flag, logic_flag, cmp_flag, shift_flag;



in_trans_t  gen_data;
in_trans_t  mon_in_data;
out_trans_t mon_out_data;
out_trans_t exp_data;
logic       drv_en;
string      op_name;

  int num_tests = 20;


  // dut instantiation
ALU_16B dut (
    .CLK (clk),
    .A (a),
    .B (b),
    .ALU_FUN (alu_fun),
    .Arith_Flag (arith_flag),
    .Carry_Flag (carry_flag),
    .Logic_Flag (logic_flag),
    .CMP_Flag (cmp_flag),
    .Shift_Flag (shift_flag),
    .ALU_OUT (alu_out)
);









  // generator task

task generator();
    drv_en = 0;
    repeat (num_tests) begin
      @(posedge clk);
      gen_data.a  = $urandom_range(0, 30);
      gen_data.b  = $urandom_range(1, 10);
      gen_data.op = $urandom_range(0, 14);
      drv_en = 1;
      driver();

      @(posedge clk);
      #1;
      drv_en = 0;
      predictor();


      @(posedge clk);
      #1
      checker_task();


    end
endtask : generator






  //  driver task
  task driver();
    if (drv_en) begin
      a <= gen_data.a;
      b <= gen_data.b;
      alu_fun <= gen_data.op;
    end
  endtask : driver






  //  monitor in task
  task mon_in();
    forever begin
      @(posedge clk);
      #1;
      mon_in_data.a  <= a;
      mon_in_data.b  <= b;
      mon_in_data.op <= alu_fun;
    end
  endtask : mon_in






  //monitor out task
  task mon_out();
    forever begin
      @(posedge clk);
      #1;
      mon_out_data.out <= alu_out;
      mon_out_data.c_flag <= carry_flag;
      mon_out_data.ar_flag <= arith_flag;
      mon_out_data.lg_flag <= logic_flag;
      mon_out_data.cmp_flag <= cmp_flag;
      mon_out_data.sh_flag <= shift_flag;
    end
  endtask : mon_out





// predictor task
task predictor();
    exp_data = '0;
    case (mon_in_data.op)
      // arithmetic operations
      4'b0000: begin {exp_data.c_flag, exp_data.out} = mon_in_data.a + mon_in_data.b; exp_data.ar_flag = 1'b1; op_name = "addition"; end
      4'b0001: begin {exp_data.c_flag, exp_data.out} = mon_in_data.a - mon_in_data.b; exp_data.ar_flag = 1'b1; op_name = "subtraction"; end
      4'b0010: begin exp_data.out = mon_in_data.a * mon_in_data.b; exp_data.ar_flag = 1'b1; op_name = "multiplication"; end
      4'b0011: begin exp_data.out = (mon_in_data.b != 0) ? (mon_in_data.a / mon_in_data.b) : 16'b0; exp_data.ar_flag = 1'b1; op_name = "division"; end

      // logic operations
      4'b0100: begin exp_data.out = mon_in_data.a & mon_in_data.b; exp_data.lg_flag = 1'b1; op_name = "bitwise_and"; end
      4'b0101: begin exp_data.out = mon_in_data.a | mon_in_data.b; exp_data.lg_flag = 1'b1; op_name = "bitwise_or"; end
      4'b0110: begin exp_data.out = ~(mon_in_data.a & mon_in_data.b); exp_data.lg_flag = 1'b1; op_name = "bitwise_nand"; end
      4'b0111: begin exp_data.out = ~(mon_in_data.a | mon_in_data.b); exp_data.lg_flag = 1'b1; op_name = "bitwise_nor"; end
      4'b1000: begin exp_data.out = mon_in_data.a ^ mon_in_data.b; exp_data.lg_flag = 1'b1; op_name = "bitwise_xor"; end
      4'b1001: begin exp_data.out = ~(mon_in_data.a ^ mon_in_data.b); exp_data.lg_flag = 1'b1; op_name = "bitwise_xnor"; end

      // compare operations
      4'b1010: begin exp_data.cmp_flag = 1'b1; exp_data.out = (mon_in_data.a == mon_in_data.b) ? 16'h1 : 16'h0; op_name = "compare_equal"; end
      4'b1011: begin exp_data.cmp_flag = 1'b1; exp_data.out = (mon_in_data.a > mon_in_data.b) ? 16'h2 : 16'h0; op_name = "compare_greater_than"; end
      4'b1100: begin exp_data.cmp_flag = 1'b1; exp_data.out = (mon_in_data.a < mon_in_data.b) ? 16'h3 : 16'h0; op_name = "compare_less_than"; end

      // shift operations
      4'b1101: begin exp_data.sh_flag = 1'b1; exp_data.out = mon_in_data.a >> 1; op_name = "shift_right"; end
      4'b1110: begin exp_data.sh_flag = 1'b1; exp_data.out = mon_in_data.a << 1; op_name = "shift_left"; end
      default: begin exp_data = '0; op_name = "NOP"; end
    endcase
  endtask : predictor



  // checker task
  task checker_task();
      if (mon_out_data.out === exp_data.out && mon_out_data.c_flag === exp_data.c_flag) begin
          $display("[checker @ %0t] pass | op=%s (%0b) | a=%0d = %0b | b=%0d = %0b | -> dut_out=%0d = %0b | (exp=%0d = %0b)", 
                  $time, op_name, mon_in_data.op, mon_in_data.a, mon_in_data.a, mon_in_data.b, mon_in_data.b, mon_out_data.out, mon_out_data.out, exp_data.out, exp_data.out);
        end else begin
          $display("[checker @ %0t] fail | op=%s (%0b) | a=%0d = %0b | b=%0d = %0b | -> dut_out=%0d = %0b | (exp=%0d = %0b)", 
                  $time, op_name, mon_in_data.op, mon_in_data.a, mon_in_data.a, mon_in_data.b, mon_in_data.b, mon_out_data.out, mon_out_data.out, exp_data.out, exp_data.out);
        end

        $display("====================================================================================");
        $display("====================================================================================");
  endtask : checker_task





  // main simulation execution flow
  initial begin
    a = 0; b = 0; alu_fun = 0; //reset
    #10;
    fork
      mon_in();
      mon_out();
    join_none
    generator();

    #50;
    $display("tasks testbench finished successfully");
    $stop;
  end

endmodule : tb_top