module trafficSignalController(
    input rst,              //Reset
    input s,                //Side Vehicles
    input clk,              //Clock
    input ped,              //Pedestrians
    input em,               //Main street emergency
    input es,               //Side street emergency
    output reg MG=0,        //Main Green
    output reg MY=0,        //Main Yellow
    output reg MR=0,        //Main Red
    output reg SG=0,        //Side Green
    output reg SY=0,        //Side Yellow
    output reg SR=0         //Side Red
    );

    reg[2:0] presentState;  //Present State
    reg[4:0] counter;       //Common Timer for TL,TS,Tt,TP
    reg[2:0] nextState;     //Next State
    initial counter = 5'b00000;

    parameter S0=3'b000,S1=3'b001,S2=3'b010,S3=3'b011,S4=3'b100,S5=3'b101;
    initial presentState=S0;

    always @(negedge clk)
    
        if(rst==1)presentState<=S0;
        else
        begin
        if(em)presentState<=S0;
        else if(es)presentState<=S3;
        else begin 
        case(presentState)
        S0: begin
                counter <= counter+5'b0001;
                if((s==1)&&(counter>=5'b11001))
                begin
                presentState<=S1;
                counter<=5'b00000;
                end
                else
                presentState<=S0;
                end
                
        S1:begin
                counter <= counter+5'b0001;
                if(counter>=5'b00100)begin 
                presentState<=S2;
                counter<=5'b00000;
                end
                else presentState<=S1;
                end
                
        S2:begin
                counter <= counter+5'b0001;
                if(ped==1)
                begin
                if(counter>=5'b01010)begin 
                presentState<=S3;
                counter<=5'b00000;
                end
                else presentState<=S2;
                end
                else if(counter>=5'b00010)begin 
                presentState<=S3;
                counter<=5'b00000;
                end
                else presentState<=S2;
                end
                
        S3:begin
                counter <= counter+5'b0001;
                if((s==0)||(counter>=5'b11001))
                begin 
                presentState<=S4;
                counter<=5'b00000;
                end
                else presentState<=S3;
                end
                
        S4:begin
                counter <= counter+5'b0001;
                if(counter>=5'b00100)begin 
                presentState<=S5;
                counter<=5'b00000;
                end
                else presentState<=S4;
                end
                
        S5:begin
                counter = counter+5'b0001;
                if(ped==1)
                begin
                if(counter>=5'b01010)begin 
                presentState<=S0;
                counter<=5'b00000;
                end
                else presentState<=S5;
                end
                else if(counter>=5'b00010)begin 
                presentState<=S0;
                counter<=5'b00000;
                end
                else presentState<=S5;
                end 
                      
        
        endcase 
        end
    end
    
    always @(presentState)
    begin
    case(presentState)
    S0:begin
           MG=1;MY=0;MR=0;
           SG=0;SY=0;SR=1;
           end
    S1:begin
           MG=0;MY=1;MR=0;
           SG=0;SY=0;SR=1;
           end
    S2:begin
           MG=0;MY=0;MR=1;
           SG=0;SY=0;SR=1;
           end       
    S3:begin
           MG=0;MY=0;MR=1;
           SG=1;SY=0;SR=0;
           end
    S4:begin
           MG=0;MY=0;MR=1;
           SG=0;SY=1;SR=0;
           end 
    S5:begin
           MG=0;MY=0;MR=1;
           SG=0;SY=0;SR=1;
           end             
    endcase
    end
    
endmodule
