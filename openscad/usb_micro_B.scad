//https://www.thingiverse.com/thing:3539959

 $fn=50;
fudge=0.1;


//translate([-30,0,0]) XH(2);
//translate([-15,0,0]) 
mUSB();


module mUSB(){
  //usb.org CabConn20.pdf
  
  M= 6.9;   //Rece inside width
  N= 1.85;  //Rece inside Height -left/right
  
  C= 3.5;   //Plastic width
  X= 0.6;   //plastic height
  U= 0.22;  //plastic from shell
  P= 0.48;  //Conntacst from plastic
  
  Q= 5.4;   //shell inside bevel width
  R= 1.1;   //shell inside bevel height -left/right
  
  S= 4.75;  //Latch separation 
  T= 0.6;   //Latch width -left/right
  V= 1.05;  //Latch recess
  W= 2.55;  //Latch recess
  Y= 0.56;  //Latch Height
  Z= 60;    //Latch Angle
  
  H= 2.6;   //Pin1-5 separation
  I= 1.3;   //Pin2-4 separation
  conWdth= 0.37; //# contact width
  
  
  conThck= 0.1; //contact thickness
  
  //JAE DX4R005J91
  r=0.25; //corner radius
  t=0.25; //sheet thickness
  
  //flaps
  flpLngth=0.6;
  flpDimTop=[6.2,flpLngth,t];
  flpDimBot=[5.2,flpLngth,t];
  flpDimSide=[0.75,flpLngth,t];
  
  flpAng=40;
  
  
  THT_OZ=-(5-1.8);
  legDim=[0.9,0.65-r/2,t];


hull()shell();


 module shell(){
    translate([0,0,N-R/2+t])
      rotate([90,0,0]){
          difference(){ //2D
            shape(radius=r+t,length=5);
            translate([0,0,-fudge/2]) shape(radius=r,length=5+fudge);
          }
    }
  }

  //the usb shape
  module shape(radius=r,length=5){
    hull(){
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*(M/2-r),iy*(R/2-r),0]) cylinder(r=radius,h=length);
      for (ix=[-1,1])
        translate([ix*(Q/2-r/2),-N+(R/2+r),0]) cylinder(r=radius,h=length);
    }
  }
  }