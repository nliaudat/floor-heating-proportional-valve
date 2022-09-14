// Use thread library from http://dkprojects.net/openscad-threads/
include <threads.scad>;



/*
$vpt =[ 2.34, -2.17, 16.93 ];  // set default viewport
$vpr =[ 90, 0, 180 ];  // set default rotation
$vpf = 22.5; // set default fov
$vpd = 155; // shows the camera distance
*/

//reset animation position : T = 0.9, FPS=0; Step = 0
// normal animation : FPS = 2; Step = 10

//use <MCAD/involute_gears.scad>;
//include <MCAD/involute_gears.scad>;

//Todo : check if snap joints is better than threads (https://cults3d.com/fr/mod%C3%A8le-3d/outil/snap-joint-openscad-library)

/*
rack(number_of_teeth=15,
        circular_pitch=false, diametral_pitch=false,
        pressure_angle=28,
        clearance=0.2,
        rim_thickness=8,
        rim_width=5,
        flat=false);
        
  */      

/* [Print] */
//print_trv_half_1 = false;
//print_trv_half_2 = false;
print_slider = false;
cursorV1_enable = true;
cursorV2_enable = false;
print_M30_adapter =false;
//print_cursor = true;

/* [Debug] */
debug = true; //do not render threads
debug_cut = true; //cut half
pcb_enable = false;
//pcb_hole_enable = true;
slider_enable = true;
cover_enable = true;
M30_adapter_enable = false;



/* [Cover Thread] */

bolt_delta = 0.9; // [0.8:Small, 0.9:Medium, 1.0:Large]
thread_height = 5.0;//7.25;
thread_diam = 30.0;
thread_pitch = 1.5; 
top_thread_hang_height = 5.0;

/* [M30x1.5 adapter] */
m30_adapter_wrench_size= 32;//36.0;
m30_adapter_radius = m30_adapter_wrench_size / sqrt(3.0);
m30_adapter_height=10.0;//6.0;
m30_adapter_tot_height=m30_adapter_height+thread_height;
m30_adapter_thread_diam = 30.0;
m30_adapter_thread_pitch = 1.5; 
m30_adapter_bolt_delta = 0.4; // [0.4:Exact, 0.6:Larger]


/* [Sliding cube] */
sliding_tolerance = 0.8;
sliding_cube = [thread_diam/2+1,thread_diam/2+1,15];
sliding_cube_hole = [sliding_cube[0]+sliding_tolerance,sliding_cube[1]+sliding_tolerance,sliding_cube[2]+sliding_tolerance/2];

/* [Motor] */
//look at module pmm_gearmotor_hole
motor = [10.0,12.0,24.5]; //10x12x24.5+solder pin
motor_hole = [motor[0] + sliding_tolerance,motor[1] + sliding_tolerance,motor[2]];


/* [Cursor] */

cursor_plug_sliding_cube = [3,2.5,6]; 
cursor_space = 0.25;
cursor_height = motor_hole[2];//motor_hole[2]+ sliding_cube_hole[2] -12; 


/* [PCB] */
pcb_height = 4;
pcb_diam = 30.25; //31.37 with usb slot | 30.25 without usb nor button
esp_c3_hole =  [15,20.2,7];//[12.5,13.2,3];
pcb_usb_overheight = 0.4;
pcb_button_overheight = 1.01;

/* [Cover] */
cover_tickness = 1.2;
cover_top_radius = pcb_diam/2 + cover_tickness; //old = 17.5
cover_top_height = 16;
cover_mid_radius = 15;
cover_mid_height = 20;
cover_bottom_radius = 15;
cover_bottom_height = 3;
cover_height = motor_hole[2]+ sliding_cube_hole[2] -pcb_height;
cover_reinforcement_enable = false;
cover_usb_hole_enable = true;
cover_button_hole_enable = true;

cyl_height = motor_hole[2]+ sliding_cube_hole[2];

/* [Inner Cylinder] */
inner_cyl_tickness = 4.0;

/* [Hidden] */
//real 4.7mm
animation_move = 5;//mm
//$fn=360;
$fn = $preview ? 25 : 100;

// When cutting holes using difference(), we
// start this far outside the object to avoid
// OpenSCAD leaving weird surfaces of (nearly)
// zero thickness due to rounding errors.
epsilon=0.01;


/////// PRINT 

if (print_M30_adapter == true){
    M30_adapter();
}

if (print_slider == true){

    //rotate([0,0,0])
    translate([25,25,sliding_cube[2]/2])sliding_cube();
    
       //cursor 
            if (cursorV1_enable ==true){
        translate([-25,-25,cursor_plug_sliding_cube[0]/2+0.25])rotate([0,90,0])cursor();
            }
            if (cursorV2_enable ==true){
        translate([-15,-15,cursor_plug_sliding_cube[0]/2+0.25])rotate([0,90,0])cursor();
            }
}
    

       
/////// DEBUG     
       
if (debug == true){

difference(){ //for debug_cut & pcb_hole
union(){ 

    color("Yellow",0.3)
    inner_cylinder();
    //thread();
    //simple_nut();
    //ext_thread();

    
    if (slider_enable ==true){
        
        rot = cursorV2_enable? 90 : 0; 
        //sliding cube animation
        //if (cursorV2_enable ==true)rotate([0,0,90]) 
        rotate([0,0,rot]) 
        translate([0,0,($t*animation_move)-4]) 
        translate([0,0,thread_height-top_thread_hang_height-0.5+sliding_cube[2]/2])
        sliding_cube();
        
        // cursor
        
                // cursor old
        if (cursorV1_enable ==true){
            //rotate([0,0,90])
            translate([0,0,($t*animation_move)-4]) 
    translate([sliding_cube[2]/2-0.8,-sliding_cube[2]/2+0.8,sliding_cube[2]-3+thread_height-top_thread_hang_height-0.5])rotate([90,0,45+90+90]) cursor();
        }//cursor
        
        if (cursorV2_enable ==true){
            //rotate([0,0,90])
            translate([0,0,($t*animation_move)-4]) 
            translate([sliding_cube[2]/2-0.5,0,sliding_cube[2]/2+1.9])rotate([90,0,270]) cursor();
        }//cursor
        
       

      
        
    }//slider
  
     
       if (cover_enable ==true){ 
    //cover 
      color("White",0.3)
      full_cover();   
       } 
  
       // pcb import
       if (pcb_enable ==true){ 
scale_factor = 0.257;
rotate([0,180,-90])
//translate([0,0,-cyl_height-7])
#translate([0,0,-cover_height-pcb_height-3])
color("Green",0.6)scale([scale_factor,scale_factor,scale_factor])translate([-4070,3397,0])import("./3d_objects/pcb_motor.stl", convexity=3);
           
        }//pcb
        
   /*      //cover 
       if (cover_enable ==true){ 
        full_cover();
       }  
        */
     
     //M30_adapter
       if (M30_adapter_enable ==true){ 
       color("Green",0.1)
        translate([0,0,-m30_adapter_height/2-thread_height-thread_pitch/2+thread_pitch])   
        M30_adapter();
       }     
    

    //}//debug
    
    }//union
    
    if (debug_cut ==true){
        translate([-50,0,-20])
        cube([100,100,100]);
            }
   /*  
     // pcb hole import (not used)
       if (pcb_hole_enable ==true){ 
scale_factor = 0.257+0.008;
rotate([0,180,-90])
translate([0,0,-cover_height-pcb_height-3])
color("Green",0.6)scale([scale_factor,scale_factor,scale_factor])translate([-4070,3397,0])import("./3d_objects/pcb_motor.stl", convexity=3);  
        }//pcb hole       
  */          
            
    }//difference (only for debug_cut)
}


    


//}
       
       

/////////////////// modules ///////////////////


module sliding_cube(){
    difference(){
color("Violet",0.5)
cube([sliding_cube[0],sliding_cube[1],sliding_cube[2]], center=true);
        //m3 hole
       translate([0,0,-sliding_cube[2]/2+1])    
    cylinder(r=1.5, h=sliding_cube[2]);
    //M3 square nut : M3x7x2 metal 
        translate([0,5,sliding_cube[2]/2-3]) 
        cube([8,20,2.5], center=true);
        
   if (cursorV1_enable ==true){ 
    //cursor hole
    translate([sliding_cube[2]/2-3.8,-sliding_cube[2]/2+3.8,sliding_cube[2]/2-3])
     rotate([90,0,45+90+90])  
       cube([cursor_plug_sliding_cube[0]+cursor_space,cursor_plug_sliding_cube[1]+cursor_space,cursor_plug_sliding_cube[2]*2+cursor_space], center=true);
    }//cursor
    
    if (cursorV2_enable ==true){ 
    //cursor hole
   translate([0,-sliding_cube[2]/2+3.8,0])
     rotate([90,0,180])  
       cube([cursor_plug_sliding_cube[0]+cursor_space,cursor_plug_sliding_cube[1]+cursor_space,cursor_plug_sliding_cube[2]*2+cursor_space], center=true);
    }//cursor
    }//diff
}

/*
//old version
module sliding_cube(){
    difference(){
color("Violet",0.5)
cube([sliding_cube[0],sliding_cube[1],sliding_cube[2]], center=true);
        //m3 hole
       translate([0,0,-sliding_cube[2]/2+1])    
    cylinder(r=1.5, h=sliding_cube[2]);
    //M3 square nut : M3x7x2 metal 
        translate([0,5,sliding_cube[2]/2-3]) 
        cube([8,20,2.5], center=true);
       
    if (cursor_enable ==true){ 
    //cursor hole
    translate([sliding_cube[2]/2-3.8,-sliding_cube[2]/2+3.8,sliding_cube[2]/2-3])
     rotate([90,0,45+90+90])  
       cube([cursor_plug_sliding_cube[0]+cursor_space,cursor_plug_sliding_cube[1]+cursor_space,cursor_plug_sliding_cube[2]*2+cursor_space], center=true);
    }//cursor
    }//diff
}

*/

module cursor(){ 
    
    //bottom plug
    color("Magenta",0.5)
    cube([cursor_plug_sliding_cube[0],cursor_plug_sliding_cube[1],cursor_plug_sliding_cube[2]], center=true);
    
    //middle
    color("Magenta",0.5)
rotate([90,0,0])
    translate([0,-cursor_plug_sliding_cube[1]+0.25,-cursor_height/2+top_thread_hang_height-1])
   cube([cursor_plug_sliding_cube[0],cursor_plug_sliding_cube[1]/2,cursor_height-top_thread_hang_height], center=true);
    
    //top end
    color("Magenta",0.5)
    rotate([90,0,0])
    translate([0,-cursor_plug_sliding_cube[1]+0.25,-cursor_height+top_thread_hang_height+1])
    cube([cursor_plug_sliding_cube[0],cursor_plug_sliding_cube[1],cursor_plug_sliding_cube[2]], center=true);
}


module full_cover(){
        //cover 
    difference(){
     translate([0,0,thread_height])cover();  
           //inner hole
    translate([0,0,thread_height])cover(cover_tickness);  
    
    //cursor hole
    if (cursorV1_enable ==true){
translate([sliding_cube[2]/2+0.8,-sliding_cube[2]/2-0.8,sliding_cube[2]-3+thread_height-top_thread_hang_height-0.5])         rotate([0,0,45+90+90])   
    cube([cursor_plug_sliding_cube[0]+1,cursor_plug_sliding_cube[1]+1,cursor_plug_sliding_cube[2]+thread_height*2], center=true);
         }  //cursor
         
    if (cursorV2_enable ==true){
       translate([sliding_cube_hole[0]/2,0,cover_height/2]) cube([cursor_plug_sliding_cube[0]+1,cursor_plug_sliding_cube[1]+2,cursor_plug_sliding_cube[2]+cover_height], center=true);
    }//cursor
    
    
    //usb hole
   if (cover_usb_hole_enable ==true){
    scale_hole = 1.1;
      rotate([180,0,270])translate([0,-cover_top_radius+cover_tickness*2,-cover_height-pcb_height-pcb_usb_overheight])
    //translate([0,18,2.6]) 
       scale([scale_hole,scale_hole,scale_hole])
    import("./3d_objects/usb_micro_B.stl", convexity=3);
    }//usb hole
    
        //button hole
   if (cover_button_hole_enable ==true){
  rotate([0,0,135])translate([0,cover_top_radius-cover_tickness,cover_height+pcb_height-pcb_button_overheight])
        cube([2,2,1.5]);
    }//usb hole
        
           }//diff      

// bottom thread
difference(){ // slider
difference(){ //thread /cyl
           //external thread  
         metric_thread(thread_diam + bolt_delta, thread_pitch, thread_height + 0.002, internal=false);
         
        //cyl hole
    translate([0,0,-top_thread_hang_height])
cylinder(r=thread_diam/2-cover_tickness, h=thread_height);
    
        //cursor hole
    if (cursorV1_enable ==true){
translate([sliding_cube[2]/2+0.8,-sliding_cube[2]/2-0.8,0])         rotate([0,0,45+90+90])   
    cube([cursor_plug_sliding_cube[0]+1,cursor_plug_sliding_cube[1]+1,cursor_plug_sliding_cube[2]+thread_height*2], center=true);
         }  //cursor
         
         if (cursorV2_enable ==true){
       translate([sliding_cube_hole[0]/2,0,cover_height/2]) cube([cursor_plug_sliding_cube[0]+1,cursor_plug_sliding_cube[1]+2,cursor_plug_sliding_cube[2]+cover_height], center=true);
    }//cursor
         
        //cylinder(r=thread_diam/2-2, h=cyl_height); 
}//1st diff  
   translate([-sliding_cube_hole[0]/2,-sliding_cube_hole[1]/2,0])
    cube([sliding_cube_hole[0],sliding_cube_hole[1],sliding_cube_hole[2]], center=false);  
}        

    
}

module cover(reduce = 0){  //many cylinders 

    //cover_top_radius
    //pcb thread cylinder
    color("White",0.1)
    rotate([180,0,0])
    translate([0,0,-cover_height-pcb_height+reduce])
    cylinder(h = pcb_height, r1 = cover_top_radius-reduce, r2 = cover_top_radius-reduce, center = false);

    //top cylinder
    color("White",0.1)
    rotate([180,0,0])
    translate([0,0,-cover_height])
    cylinder(h = cover_top_height, r1 = cover_top_radius-reduce, r2 = cover_top_radius-reduce, center = false);
    
    //mid cylinder
    color("White",0.1)
    rotate([180,0,0])
    translate([0,0,-cover_height+cover_top_height])
    cylinder(h = cover_mid_height, r1 = cover_top_radius-reduce, r2 = cover_mid_radius-reduce, center = false);
    
    //bottom cylinder
    color("White",0.1)
    //translate([0,0,-cover_bottom_height/2])
    //thread_height
    cylinder(h = cover_bottom_height, r1 = cover_bottom_radius-reduce, r2 = cover_mid_radius-reduce, center = false);
}


/*
module cover_small(){ //v14
    //v_slices = 360;

    color("White",0.5)
    rotate([180,0,0])
    linear_extrude(height = 7+1.25, center = false, convexity = 0, twist = 0, slices = 10, scale = [0.51,0.51], $fn = 160) {
     //   circle(r=thread_diam/2+4, $fn=8);
        circle(r=radius, $fn=6);//v16 (same as M30x1.5)

    }
}
*/


module inner_cylinder(){
    
    difference(){
    union(){
translate([0,0,thread_height-5])color("Yellow",0.3)
        //inner top cylinder
cylinder(r=motor[1]/2+inner_cyl_tickness, h=cyl_height-0.45);
        
     if (cursorV2_enable ==true){
        //sliding cube perimeter
    translate([-sliding_cube_hole[0]/2-inner_cyl_tickness/2,-sliding_cube_hole[1]/2-inner_cyl_tickness/2,thread_height-top_thread_hang_height])cube([sliding_cube_hole[0]+inner_cyl_tickness,sliding_cube_hole[1]+inner_cyl_tickness,sliding_cube_hole[2]], center=false);
     }
     
      if (cover_reinforcement_enable ==true){
     //link 1 (bottom/mid) to external cover
     translate([0,0,cover_top_height])
   cylinder(h = inner_cyl_tickness/2, r=cover_mid_radius, center = false);
     
     //link 2  (top/mid) to external cover
     translate([0,0,cover_height-cover_mid_height/2-1.5])   cylinder(h = inner_cyl_tickness/2, r=cover_top_radius-1, center = false);
     
     //link 2  (top/mid) to external cover
     translate([0,0,cover_height])cylinder(h = inner_cyl_tickness/2, r=cover_top_radius, center = false);
     // translate([0,0,cyl_height]) cylinder(h = inner_cyl_tickness/2, r=cover_top_radius, center = false);
      }//cover_reinforcement_enable
        
     }//union
  
    //bottom cut
    //cylinder(r=thread_diam/2, h=thread_height-top_thread_hang_height);
    
    //sliding cube hole
    translate([-sliding_cube_hole[0]/2,-sliding_cube_hole[1]/2,thread_height-top_thread_hang_height-0.5-inner_cyl_tickness])cube([sliding_cube_hole[0],sliding_cube_hole[1],sliding_cube_hole[2]+inner_cyl_tickness], center=false);
     
     //cursor hole
    if (cursorV2_enable ==true){
       translate([sliding_cube_hole[0]/2,0,cover_height/2]) cube([cursor_plug_sliding_cube[0]+1,cursor_plug_sliding_cube[1]+2,cursor_plug_sliding_cube[2]+cover_height], center=true);
    }//cursor
    
    //esp c3 cut
    translate([-10,0,cyl_height-top_thread_hang_height])rotate([0,90,0])
    cube([esp_c3_hole[0],esp_c3_hole[1],esp_c3_hole[2]], center=true);
   
     //motor hole
    //translate([-motor_hole[0]/2,-motor_hole[1]/2,thread_height-top_thread_hang_height+sliding_cube_hole[2]-1])cube([motor_hole[0],motor_hole[1],motor_hole[2]+2], center=false);
    
    //new motor + gearbox hole
    translate([-motor_hole[0]/2,-motor_hole[1]/8,thread_height-top_thread_hang_height+sliding_cube_hole[2]-0.35])rotate([90,0,90])pmm_gearmotor_hole();
   
    }//diff
    
}

/*
module thread(){

difference(){
    //union(){    
    color("blue",0.6)
        //cylinder(r=cover_bottom_radius+thread_pitch, h=thread_height, $fn=6);//(same as M30x1.5)
    cylinder(r=wrench_size/ sqrt(3.0), h=thread_height, $fn=6);
    
    
    metric_thread (diameter=thread_diam + bolt_delta, pitch=thread_pitch, length=thread_height-top_thread_hang_height +0.002,internal=false);

}//diff
    
}
*/


module M30_adapter() {
  difference() {
    cylinder(r=m30_adapter_radius+m30_adapter_thread_pitch, h=m30_adapter_tot_height, $fn=6);
    translate([0,0,-epsilon])
     
      metric_thread(m30_adapter_thread_diam + m30_adapter_bolt_delta, m30_adapter_thread_pitch, m30_adapter_tot_height+ 2*epsilon, internal=false);
  }
}

//------------------------------------------------------------------------------------
// https://forum.pololu.com/t/openscad-file-for-micrometal-gear-motor-bracket/8706/2

module pmm_cutout(diameter, width, depth, height, offset, gap, fn) {
    
    difference() {
        translate([-width, 0, -height])
            cube([width + gap, depth, height + gap]);
        
        x_center = -offset - diameter / 2;
        y_center = -offset - diameter / 2;
        depth2 = depth + 2 * gap;
        
        translate([x_center, -gap, y_center])
            rotate([-90, 0, 0])
            cylinder(d = diameter, h = depth2, $fn = fn);

        translate([-width-gap, -gap, -height-gap])
            cube([width - offset + gap, depth2, height - offset - diameter/2 + gap]);

        translate([-width-gap, -gap, -height-gap])
            cube([width - offset - diameter/2 + gap, depth2, height - offset + gap]);
    }
}


// Creates hole for gearmotor:

module pmm_gearmotor_hole(
    gap=0.2, // the extra tolerance all around the hole.  Also used as an overhang for any part that will be subtracted with difference().
    fn=100   // accuracy of cylinders
    ) {

    frame_width       = 11.9  + 2 * gap;
    frame_height      =  9.9  + 2 * gap;
    frame_depth       =  9.0  + 2 * gap;
    frame_thickness   =  0.75 + 2 * gap;     // thickness of brass plates
    frame_void_depth1 =  4.2  - 2 * gap;     // depth of wider void with gears, closer to shaft
    frame_void_depth2 = frame_depth - frame_void_depth1 - (3 * frame_thickness); // depth of narrower void with gears, closer to motor

    spacer_diameter1  = 3.0 + 2 * gap;       // diameter of narrower brass spacers, closer to shaft
    spacer_diameter2  = 3.2 + 2 * gap;       // diameter of wider brass spacers, closer to motor
    spacer_offset1    = 0.6;                 // distance from edge to narrower brass spacers, closer to shaft
    spacer_offset2    = 0.5;                 // distance from edge to wider brass spacers, closer to 
    spacer_width      = 4.0;                 // width of cutout around spacers
    spacer_height     = 3.5;                 // height of cutout around spacers

    motor_depth = 15.25;                     // depth of motor casing 
    motor_curvature_diameter = 5.0 + 2 * gap;

    render()    
        translate([0, -gap, -gap])
        difference() {

            //--------------------------------------------
            // solid block we start with:
            
            translate([-frame_width/2, 0, 0])
                cube([frame_width, frame_depth + motor_depth, frame_height]);

            //--------------------------------------------
            // carve away four cutouts for the gear section:
    
            for (corner = [0 : 1]) {
                side = corner == 0 ? 1 : -1;
                up   = corner == 0 ? 1 : 0;
                
                translate([side * frame_width/2, frame_thickness, up * frame_height])
                    rotate([0, corner * 180, 0])
                    pmm_cutout(spacer_diameter1, spacer_width, frame_void_depth1, spacer_height, spacer_offset1, gap, fn);

                translate([side * frame_width/2, frame_thickness * 2 + frame_void_depth1, up * frame_height])
                    rotate([0, corner * 180, 0])
                    pmm_cutout(spacer_diameter2, spacer_width, frame_void_depth2, spacer_height, spacer_offset2, gap, fn);
            }
            
            //--------------------------------------------
            // carve away four cutouts for the motor body:

            for (corner = [0 : 3]) {
                side = corner <= 1 ? 1 : -1;
                up   = (corner == 0 || corner == 3) ? 1 : 0;

                translate([side * frame_width/2, frame_depth, up * frame_height])
                    rotate([0, corner * 90, 0]) 
                    pmm_cutout(motor_curvature_diameter, motor_curvature_diameter/2, motor_depth + gap, motor_curvature_diameter/2, 0, gap, fn);
        }    
    }
}





/*
// not used
//https://www.thingiverse.com/thing:3539959

module mUSB(){
  //usb.org CabConn20.pdf
  fudge=0.1;
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
  }//end usb module
  
  
*/  

/*
module ext_thread() {
    
    color("blue",0.3)
  difference() {
    //cylinder(r=cover_bottom_radius+thread_pitch, h=thread_height, $fn=6);
    //translate([0,0,-0.01])
      metric_thread(thread_diam + bolt_delta, thread_pitch, thread_height + 0.002, internal=false);
  }
}
*/

/*
module simple_nut() {
  difference() {
    cylinder(r=cover_bottom_radius+thread_pitch, h=thread_height, $fn=6);
    translate([0,0,-0.01])
      metric_thread(thread_diam + bolt_delta, thread_pitch, thread_height + 0.002, internal=false);
  }
}
*/

/*
//////////////////////////////////////////////////////////////////////////////////
//// pcb
/////////
difference(){
//main cylinder
color("blue",0.1)cylinder(d=32, h=50, $fn=360);
cylinder(d=30, h=50, $fn=360);

//usb hole
scale_hole = 1.1;
translate([0,18,2.6]) scale([scale_hole,scale_hole,scale_hole])
import("./3d_objects/usb_micro_B.stl", convexity=3);
}


scale_factor = 0.257;
color("Green",0.6)scale([scale_factor,scale_factor,scale_factor])translate([-4070,3397,0])import("./3d_objects/pcb_motor.stl", convexity=3);

*/