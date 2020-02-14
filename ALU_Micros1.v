module ALU_Micros1(
input [7:0] iA,
input [7:0] iB,  // ALU 8-bit Inputs A y B                 
input [4:0] ALU_Sel,// ALU Selector de 5-bits
input iClk,
output [7:0] oRESALU,
output [4:0] oBanderas// ALU 8-bit Output
 ); 
 
   reg [8:0] ALU_Resultadomedio;
	reg [7:0] ALU_D;
	reg [7:0] ALU_Q;
	reg [4:0] Banderas_D;
	reg [4:0] Banderas_Q;
	reg ALU_Carry;
	
	assign oRESALU = ALU_Q [7:0];
	assign oBanderas = Banderas_Q [4:0];
	assign par = ~^ALU_Q;
	
	
 
/////////////////////////////////////////Parte Secuencial//////////////////////////////////////////
 always @(posedge iClk) 
 begin 
     ALU_Q = ALU_D;
	  
	  Banderas_Q = Banderas_D;
 end 
///////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////Parte combinacional////////////////////////////////////////
    always @(*)
    begin
        case(ALU_Sel)
		  5'b00000: begin // Multiplicacion 
           ALU_Resultadomedio [8:0] = iA * iB;
			  ALU_D [7:0] = ALU_Resultadomedio [7:0];
			  ALU_Carry = ALU_Resultadomedio [8:7];
			        end 
		  5'b00001: begin // Division
           ALU_Resultadomedio [8:0] = iA / iB;
			  ALU_D [7:0] = ALU_Resultadomedio [7:0];
			  ALU_Carry = ALU_Resultadomedio [8:7];
			        end
        5'b00010: begin // Incremento
           ALU_Resultadomedio [8:0] = iA + 1'b1;
			  ALU_D [7:0] = ALU_Resultadomedio [7:0];
			  ALU_Carry = ALU_Resultadomedio [8:7];
			        end
        5'b00011: begin // Decremento
           ALU_Resultadomedio [8:0] = iA - 1'b1;
			  ALU_D [7:0] = ALU_Resultadomedio [7:0];
			  ALU_Carry = ALU_Resultadomedio [8:7];
			        end
        5'b00100: begin // AND
           ALU_Resultadomedio [8:0] = iA & iB;
			  ALU_D [7:0] = ALU_Resultadomedio [7:0];
			  ALU_Carry = ALU_Resultadomedio [8:7];
			        end
        5'b00101: begin // OR
           ALU_Resultadomedio [8:0] = iA | iB;
			  ALU_D [7:0] = ALU_Resultadomedio [7:0];
			  ALU_Carry = ALU_Resultadomedio [8:7];
			        end
        5'b00110: begin // NOT
           ALU_D [7:0]  = ~iA;
			        end
        5'b00111: begin // XOR
           ALU_Resultadomedio [8:0] = iA^iB;
			  ALU_D [7:0] = ALU_Resultadomedio [7:0];
			  ALU_Carry = ALU_Resultadomedio [8:7];
			        end
        5'b01000: begin // COMPLEMENTO A1
           ALU_D [7:0]  = ~iA;
			         end
        5'b01001: begin // CORRIMIENTO ARITMÉTICO IZQUIERDO.
           ALU_D [6:0] = iA [6:0] <<<iB [6:0];
			  ALU_D [7] = iA[7];
			        end
        5'b01010: begin // CORRIMIENTO ARITMÉTICO DERECHO.
           ALU_D [6:0] = iA [6:0] >>>iB [6:0];
			  ALU_D [7] = iA[7];
			         end
        5'b01011: begin // CORRIMIENTO LOGICO IZQUIERDO.
           ALU_Resultadomedio [8:0] = iA<<iB;
			  ALU_D [7:0] = ALU_Resultadomedio [7:0];
			  ALU_Carry = ALU_Resultadomedio [8:7];
			         end
        5'b01100: begin // CORRIMIENTO LOGICO DERECHO.
           ALU_Resultadomedio [8:0] = iA>>iB;
			  ALU_D [7:0] = ALU_Resultadomedio [7:0];
			  ALU_Carry = ALU_Resultadomedio [8:7];
			         end
        5'b01101: begin // ROTACION IZQUIERDA.
           ALU_Resultadomedio [8:0] = {iA[7:0],iA[7]};
			  ALU_D [7:0] = ALU_Resultadomedio [7:0];
			  ALU_Carry = ALU_Resultadomedio [8:7];
			        end
        5'b01110: begin // ROTACION DERECHA.
           ALU_Resultadomedio [8:0] = {iA[0],iA[7:1]};
			  ALU_D [7:0] = ALU_Resultadomedio [7:0];
			  ALU_Carry = ALU_Resultadomedio [8:7];
			        end
        5'b01111: begin // SUMA.
           ALU_Resultadomedio [8:0] = iA+iB;
			  ALU_D [7:0] = ALU_Resultadomedio [7:0];
			  ALU_Carry = ALU_Resultadomedio [8:7];
			        end
        5'b10000: begin // RESTA.
           ALU_Resultadomedio [8:0] = iA - iB;
			  ALU_D [7:0] = ALU_Resultadomedio [7:0];
			  ALU_Carry = ALU_Resultadomedio [8:7];
			        end
					  default: ALU_D = ALU_Q;
		  endcase
		  
    
//////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////Declaración de Banderas//////////////////////////////////////////

       if(ALU_Q==8'b00000000) //Bandera de 0
         begin
			Banderas_D [0] =1'b1;
         end
		  else
			begin
	      Banderas_D [0] =1'b0;	
			end
			
		 if(ALU_Q [7]==1'b1 && ALU_Q > 8'b01111111 ) //Bandera de signo
         begin
			Banderas_D [1] =1'b1;
         end
		  else
			begin
	      Banderas_D [1] =1'b0;	
			end
			
		 if(ALU_Carry==1'b1) //Bandera de carry
         begin
			Banderas_D [2] =1'b1;
         end
		  else
			begin
	      Banderas_D [2] =1'b0;	
			end
			
	    if(ALU_Resultadomedio > 9'b011111111) //Bandera de overflow
         begin
			Banderas_D [3] =1'b1;
         end
		  else
			begin
	       Banderas_D [3] =1'b0;	
			end

	    if(par==1'b1) //Bandera de Paridad
         begin
			Banderas_D [4] =1'b1;
         end
		  else
			begin
	      Banderas_D [4] =1'b0;	
			end
			
end
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////



