`timescale 1ns / 1ps

module traffic_tb(
    );
    reg rst;
    reg clk;
    reg SideVehicles;
    reg ped;
    reg em;
    reg es;
    wire MR,MY,MG,SR,SY,SG;
 
    trafficSignalController tl(rst,SideVehicles,clk,ped,em,es,MG,MY,MR,SG,SY,SR);
    initial rst = 0;
    initial clk =0;
    initial SideVehicles = 0;
    initial ped=0;
    initial em=0;
    initial es=0;

    always #5 clk=~clk;

    initial
    begin
    $monitor($time,"rst = %b, em=%b, es=%b, ped=%b, sideVehicles = %b, MR=%d, MY=%d, 
    MG=%d,SR=%d, SY=%d, SG=%d",rst,em,es,ped,SideVehicles,MR,MY,MG,SR,SY,SG);

    #3 SideVehicles = 1;
    #13 SideVehicles =0; ped=1;
    #18 SideVehicles =1;
    #33 ped=0;
    #13 em=1;
    #14 em=0;
    #3 rst =1;
    #12 rst =0;
    #103 es=1;#13 es=0;
    #1000 $finish;
    end 
    
endmodule

