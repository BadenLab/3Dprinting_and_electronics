/////////////////////////////////////////////////////////////////////////////////
/// Drug application system v0.01; 2017 04 //
/// Tom Baden /// 
/// t.baden@sussex.ac.uk ///
/// badenlab.org ///
/////////////////////////////////////////////////////////////////////////////////
//// SWITCHES //////////

PartA = 	0; // Main bottom
PartB = 	0; // Main top
PartC = 	0; // Servo Adapter
PartD = 	1; // Valve holder

/////////////////////////////////////////////////////////////////////////////////
///// KEY VARIABLES ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////

sep = 50; // How far apart do pieces "float" in the model
tol = 0.13; // Global gap between all parts that need to slide

nSlots = 1;
Spacing = 50;


/////////////////////////////////////////////////////////////////////////////////
/// MODULE A - Main Bottom   //////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////

A_X = nSlots*Spacing;
A_Y = 7;
A_Z = 40;

A_ServoslotX = 12 + 2*tol;
A_ServoslotZ = 23.5 + tol;
A_ServoCable_R = 4;
A_ServoPositionZ = 20;

A_ValveHolderX = 5;
A_ValveHolderY = 40;
A_ValveHolderZ = 15;
A_ValveHolderPositionZ = A_ServoPositionZ + 5;
A_ValveHolderPositionX = 15;

A_ValveHolderSlotR = 3;
A_ValveHolderSlotPositionY = 32;

A_RotatorholderR = 14;
A_RotatorholderR2 = 11+2*tol;
A_RotatorholderY = 20;



module A(){
    translate([0,A_Y/2,A_Z/2]){cube([A_X, A_Y, A_Z], center = true );} // main plate
    for (nn= [0:1:nSlots-1]) {
    //    %translate([Spacing*nn - Spacing*(nSlots-1)/2+A_ValveHolderPositionX,A_Y+A_ValveHolderY/2,A_ValveHolderPositionZ]){cube([A_ValveHolderX,A_ValveHolderY,A_ValveHolderZ], center = true );} // Valve holder
        translate([Spacing*nn - Spacing*(nSlots-1)/2,A_Y+A_RotatorholderY/2,A_ValveHolderPositionZ]){rotate([90,0,0]){cylinder($fn=100, r=A_RotatorholderR, h=A_RotatorholderY, center = true );}} // Rotator holder
    
    }


}
module A_sub(){
    for (nn= [0:1:nSlots-1]) {
        translate([Spacing*nn - Spacing*(nSlots-1)/2,0,A_ServoPositionZ]){cube([A_ServoslotX, 100, A_ServoslotZ], center = true );} // servo slot
        translate([Spacing*nn - Spacing*(nSlots-1)/2,A_RotatorholderY-A_Y/2+0.5,A_ServoPositionZ+A_ServoslotZ/2]){cube([A_ServoslotX, A_RotatorholderY, A_ServoslotZ], center = true );} // servo slot extension
        translate([Spacing*nn - Spacing*(nSlots-1)/2,0,A_ServoPositionZ+A_ServoslotZ/2]){rotate([90,0,0]){cylinder($fn = 100, r = A_ServoCable_R, h=100, center = true );}} // servo cable
        //%translate([Spacing*nn - Spacing*(nSlots-1)/2+A_ValveHolderPositionX,A_Y+A_ValveHolderSlotPositionY,A_ValveHolderPositionZ]){rotate([0,90,0]){cylinder($fn = 100, r = A_ServoCable_R, h=A_Y+1, center = true );}} // Valveholder slot
        translate([Spacing*nn - Spacing*(nSlots-1)/2,A_Y+A_RotatorholderY/2,A_ValveHolderPositionZ]){rotate([90,0,0]){cylinder($fn=100, r=A_RotatorholderR2, h=A_RotatorholderY, center = true );}} // Rotator holder hole  
    }
}
if (PartA==1){difference(){A();A_sub();}}

/////////////////////////////////////////////////////////////////////////////////
/// MODULE B - Main Top   //////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////

B_X = A_X;
B_Y = 40;
B_Z = 5;

B_PositionZ = 100;

B_SyringeSlotR = 12;

module B(){
    translate([0,B_Y/2,B_Z/2+B_PositionZ]){cube([B_X, B_Y, B_Z], center = true );} // main plate
}
module B_sub(){
    for (nn= [0:1:nSlots-1]) {
        translate([Spacing*nn - Spacing*(nSlots-1)/2,B_Y/2,B_Z/2+B_PositionZ]){rotate([0,0,0]){cylinder($fn = 100, r = B_SyringeSlotR, h=B_Z+1, center = true );}} // Syringe slot
    }
}
if (PartB==1){difference(){B();B_sub();}}

/////////////////////////////////////////////////////////////////////////////////
/// MODULE C - Servo Adapter   //////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////

C_R1 = A_RotatorholderR2-tol*2;
C_R2 = 6.5;
C_Z = 12;
C_ServoGrooveX = 5+tol;
C_ServoGrooveZ = 4;

C_ValveGrooveX = 4+tol;
C_ValveGrooveZ = 7;


C_ValvePositionZ = A_ValveHolderPositionZ;
C_ValvePositionY = 12;

module C(){
	translate([0,0,C_Z/2]){cylinder($fn = 100, r = C_R1, h=C_Z, center = true );} // main disc
}
module C_sub(){
	translate([0,0,C_Z/2]){cylinder($fn = 100, r = C_R2, h=C_Z, center = true );} // central hole
    translate([0,0,C_ServoGrooveZ/2]){cube([C_R1*2,C_ServoGrooveX,C_ServoGrooveZ], center = true );} // servo groove1
    translate([0,0,C_ServoGrooveZ/2]){cube([C_ServoGrooveX,C_R1*2,C_ServoGrooveZ], center = true );} // servo groove2
    
    translate([0,0,C_Z-C_ValveGrooveZ/2]){rotate([0,0,45]){cube([C_R1*2,C_ValveGrooveX,C_ValveGrooveZ], center = true );}} // Valve groove1
    translate([0,0,C_Z-C_ValveGrooveZ/2]){rotate([0,0,45]){cube([C_ValveGrooveX,C_R1*2,C_ValveGrooveZ], center = true );}} // Valve groove2
    
}
if (PartC==1)translate([0,C_ValvePositionY+A_Y,C_ValvePositionZ]){ rotate([270,0,0]){{difference(){C();C_sub();}}}}

/////////////////////////////////////////////////////////////////////////////////
/// MODULE D - Valve Holder   //////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////

D_ValveholderTopZ = 14;
D_ValveholderTopR = A_RotatorholderR-2;
D_ValveholderTopR2 = 5.5+tol;

D_ValveholderMiddleZ = 5;
D_ValveholderMiddleR = A_RotatorholderR2;
D_ValveholderMiddleZextra = 1;

D_ValveholderBottomR = A_RotatorholderR+2;
D_ValveholderBottomZ = 10;
D_ValveholderBottomZextra = 1;

D_ValveGrooveR = 3.3+tol;
D_ValveGrooveZ = D_ValveholderTopZ+D_ValveholderMiddleZ+D_ValveholderBottomZ;
D_ValveGrooveZminus = 6;

D_inwardbitX = 8;
D_inwardbitY = D_ValveholderBottomZ;
D_inwardbitZ = A_ServoslotX;

D_SlantZ=2;

module D(){
        
    translate([0,D_ValveholderBottomZ+D_ValveholderMiddleZ+D_ValveholderTopZ/2+sep,A_ValveHolderPositionZ]){rotate([90,0,0]){cylinder($fn=100, r=D_ValveholderTopR, h=D_ValveholderTopZ, center = true );}} // Top
    translate([0,D_ValveholderBottomZ+D_ValveholderMiddleZ/2+sep+D_ValveholderMiddleZextra/2,A_ValveHolderPositionZ]){rotate([90,0,0]){cylinder($fn=100, r=A_RotatorholderR, h=D_ValveholderMiddleZ+D_ValveholderMiddleZextra, center = true );}} // Middle
    translate([0,D_ValveholderBottomZ/2+sep+D_ValveholderBottomZextra/2,A_ValveHolderPositionZ]){rotate([90,0,0]){cylinder($fn=100, r=D_ValveholderBottomR, h=D_ValveholderBottomZ+D_ValveholderBottomZextra, center = true );}} // Bottom wrap

    translate([0,D_ValveholderBottomZ+D_SlantZ+sep,A_ValveHolderPositionZ]){rotate([90,0,0]){cylinder($fn=100, r1=A_RotatorholderR, r2=D_ValveholderBottomR, h=D_SlantZ, center = true );}} // Bottom slant
    
    translate([0,D_ValveholderBottomZ+D_ValveholderMiddleZ+D_SlantZ+sep,A_ValveHolderPositionZ]){rotate([90,0,0]){cylinder($fn=100, r2=A_RotatorholderR, r1=D_ValveholderTopR, h=D_SlantZ, center = true );}} // Middle slant

}
module D_sub(){
    translate([0,D_ValveholderBottomZ+D_ValveholderMiddleZ+D_ValveholderTopZ/2+sep,A_ValveHolderPositionZ]){rotate([90,0,0]){cylinder($fn=100, r=D_ValveholderTopR2, h=D_ValveholderTopZ, center = true );}} // Top    
    translate([0,D_ValveholderBottomZ+D_ValveholderMiddleZ/2+sep+D_ValveholderBottomZextra/2,A_ValveHolderPositionZ]){rotate([90,0,0]){cylinder($fn=100, r=D_ValveholderMiddleR, h=D_ValveholderMiddleZ+D_ValveholderBottomZextra, center = true );}} // Middle
      translate([0,D_ValveholderBottomZ/2+sep,A_ValveHolderPositionZ]){rotate([90,0,0]){cylinder($fn=100, r=A_RotatorholderR+tol/2, h=D_ValveholderBottomZ, center = true );}} // Bottom wrap	
     
    translate([0,D_ValveGrooveZ/2-D_ValveGrooveZminus+sep,A_ValveHolderPositionZ]){rotate([0,0,0]){cube([D_ValveGrooveR*2,D_ValveGrooveZ,D_ValveholderBottomR*2], center = true );}} // Valve groove1
    
    translate([0,-D_ValveGrooveR+D_ValveGrooveZ/2-D_ValveGrooveZminus+sep,D_ValveholderBottomR+A_ValveHolderPositionZ]){rotate([0,0,0]){cube([D_ValveGrooveR*2+4,D_ValveGrooveZ,D_ValveholderBottomR], center = true );}} // Valve groove1 widening
    
    
    translate([D_ValveholderBottomR/2,D_ValveGrooveZ/2-D_ValveGrooveZminus+sep,A_ValveHolderPositionZ]){rotate([0,0,0]){cube([D_ValveholderBottomR,D_ValveGrooveZ,D_ValveGrooveR*2], center = true );}} // Valve groove2    
      translate([0,D_ValveGrooveZ-D_ValveGrooveZminus+sep,A_ValveHolderPositionZ]){rotate([0,0,0]){cylinder($fn=100, r=D_ValveGrooveR, h=D_ValveholderBottomR*2, center = true );}} // groove rounding 1
      translate([D_ValveholderBottomR/2,D_ValveGrooveZ-D_ValveGrooveZminus+sep,A_ValveHolderPositionZ]){rotate([0,90,0]){cylinder($fn=100, r=D_ValveGrooveR, h=D_ValveholderBottomR, center = true );}} // groove rounding 2      
        
      
}

module D2(){
    translate([-A_RotatorholderR,+D_inwardbitY/2+sep,A_ValveHolderPositionZ]){rotate([0,0,0]){cube([D_inwardbitX,D_inwardbitY,D_inwardbitZ], center = true );}} // Backwall inward bit 
    translate([A_RotatorholderR,+D_inwardbitY/2+sep,A_ValveHolderPositionZ]){rotate([0,0,0]){cube([D_inwardbitX,D_inwardbitY,D_inwardbitZ], center = true );}} // Frontwall inward bit     
}
module D2_sub(){
    translate([0,sep+D_inwardbitY/2,A_ValveHolderPositionZ]){rotate([90,0,0]){cylinder($fn=100, r=D_ValveholderMiddleR, h=D_inwardbitY, center = true );}} // inner cut
    difference(){D3();D3_sub();}
    translate([D_ValveholderBottomR/2,D_ValveGrooveZ/2-D_ValveGrooveZminus+sep,A_ValveHolderPositionZ]){rotate([0,0,0]){cube([D_ValveholderBottomR,D_ValveGrooveZ,D_ValveGrooveR*2], center = true );}} // Valve groove2      
}
module D3(){
       translate([0,D_ValveholderBottomZ/2+sep+D_ValveholderBottomZextra/2,A_ValveHolderPositionZ]){rotate([90,0,0]){cylinder($fn=100, r=D_ValveholderBottomR+5, h=D_ValveholderBottomZ+D_ValveholderBottomZextra, center = true );}} // outer cut
   }
   
   module D3_sub(){
      translate([0,D_ValveholderBottomZ/2+sep+D_ValveholderBottomZextra/2,A_ValveHolderPositionZ]){rotate([90,0,0]){cylinder($fn=100, r=D_ValveholderBottomR, h=D_ValveholderBottomZ+D_ValveholderBottomZextra, center = true );}} // Inner 
}

if (PartD==1){
    difference(){D();D_sub();}
    difference(){D2();D2_sub();}
    }

