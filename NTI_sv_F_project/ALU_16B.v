
module ALU_16B (

  input wire [15:0] A, B,
  input wire [3:0]  ALU_FUN,
  input wire        CLK,
  output reg        Arith_Flag,
  output reg        Carry_Flag,   
  output reg        Logic_Flag, 
  output reg        CMP_Flag, 
  output reg        Shift_Flag,
  output reg [15:0] ALU_OUT
 
);
  
//internal_signals  
  reg [15:0] ALU_OUT_Comb;
  
always @(posedge CLK)
 begin
   ALU_OUT <= ALU_OUT_Comb;
 end  
  
always @(*)
  begin
    Arith_Flag = 1'b0 ;
    Logic_Flag = 1'b0 ; 
    CMP_Flag   = 1'b0 ;
    Shift_Flag = 1'b0 ;
	  Carry_Flag = 1'b0 ;
	  ALU_OUT_Comb = 1'b0 ;
    case (ALU_FUN) 
    4'b0000: begin
               {Carry_Flag,ALU_OUT_Comb} = A+B;
			   Arith_Flag = 1'b1 ;
              end
    4'b0001: begin
               {Carry_Flag,ALU_OUT_Comb} = A-B;
			   Arith_Flag = 1'b1 ;
              end
    4'b0010: begin
               ALU_OUT_Comb = A*B;
			   Arith_Flag = 1'b1 ;
              end
    4'b0011: begin
              ALU_OUT_Comb = A/B;
			        Arith_Flag = 1'b1 ;
              end
    4'b0100: begin
              ALU_OUT_Comb = A & B;
			        Logic_Flag = 1'b1 ;
              end
    4'b0101: begin
              ALU_OUT_Comb = A | B;
			        Logic_Flag = 1'b1 ;
              end
    4'b0110: begin
              ALU_OUT_Comb = ~ (A & B);
			        Logic_Flag = 1'b1 ;
              end
    4'b0111: begin
              ALU_OUT_Comb = ~ (A | B);
			        Logic_Flag = 1'b1 ;
              end     
    4'b1000: begin
            ALU_OUT_Comb =  (A ^ B);
			      Logic_Flag = 1'b1 ;
              end
    4'b1001: begin
            ALU_OUT_Comb = ~ (A ^ B);
			      Logic_Flag = 1'b1 ;
              end           
    4'b1010: begin
	          CMP_Flag = 1'b1 ;
              if (A==B)                                   //  ALU_OUT_Comb = (A==B) ? 16'b1 : 16'b0 ;
                ALU_OUT_Comb = 16'b1;
              else
                ALU_OUT_Comb = 16'b0;
              end
    4'b1011: begin
	          CMP_Flag = 1'b1 ;
              if (A>B)
                ALU_OUT_Comb = 16'b10;                   //  ALU_OUT_Comb = (A==B) ? 16'b10 : 16'b0 ;
              else
                ALU_OUT_Comb = 16'b0;
              end 
    4'b1100: begin
	           CMP_Flag = 1'b1 ;
              if (A<B)                                   //  ALU_OUT_Comb = (A==B) ? 16'b11 : 16'b0 ;
                ALU_OUT_Comb = 16'b11;
              else
                ALU_OUT_Comb = 16'b0;
              end      
    4'b1101: begin
	          Shift_Flag = 1'b1 ;
            ALU_OUT_Comb = A>>1;
             end
    4'b1110: begin 
	          Shift_Flag = 1'b1 ;
            ALU_OUT_Comb = A<<1;
             end
    default: begin
			   Carry_Flag = 1'b0 ;
	        Arith_Flag = 1'b0 ;
          Logic_Flag = 1'b0 ; 
          CMP_Flag   = 1'b0 ;
          Shift_Flag = 1'b0 ;
          ALU_OUT_Comb = 16'b0;
        end
    endcase
  end
  
  

endmodule