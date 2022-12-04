// Use thread library from http://dkprojects.net/openscad-threads/
include <threads.scad>;

//$vpt =[-5,30,25];//shows translation
//$vpr = [95,0,175];// shows rotation
//$vpd =150;//shows the camera distance


/*
$vpt =[ 2.34, -2.17, 16.93 ];  // set default viewport
$vpr =[ 90, 0, 180 ];  // set default rotation
$vpf = 22.5; // set default fov
$vpd = 155; // shows the camera distance
*/

//reset animation position : T = 0.9, FPS=0; Step = 0
// normal animation : FPS = 2; Step = 10

    

/* [Print] */
print_slider = false;
print_core = false;
print_cover = false;
print_M30_adapter =false;
//cursorV1_enable = false;
//cursorV2_enable = false;

cursorV3_enable = true;

//print_cursor = true;
//print_cover = true;

/* [Debug] */
debug = true; //do not render threads
debug_cut = true; //cut half
debug_cut_half_1 = true; //else the other
pcb_enable = false;
pcb_v2 = true;

slider_enable = true;
cover_enable = false;
M30_adapter_enable = false;
//pcb_hole_enable = true;

/* [Valve] */
valve_pin_height = 5;//4.6;
//pin_height_adjust = 3.75;



/* [M30x1.5 adapter] */
m30_adapter_wrench_size= 32;//36.0;
m30_adapter_radius = m30_adapter_wrench_size / sqrt(3.0);
m30_adapter_height=15.0;//6.0;
//m30_adapter_tot_height=m30_adapter_height+thread_height;
m30_adapter_tot_height = m30_adapter_height+5;
m30_adapter_thread_diam = 30.0;
m30_adapter_thread_pitch = 1.5; 
m30_adapter_bolt_delta = 1.1;//[0.8:Small, 0.9:Medium, 1.1:Large, 1.3:Super large]


/* [Inner cylinder Thread] */

bolt_delta = 0.9; // [0.8:Small, 0.9:Medium, 1.0:Large]
thread_height = 5.0;//7.25;
thread_diam = m30_adapter_thread_diam-bolt_delta;
thread_pitch = 1.5; 
top_thread_hang_height = 5.0;


/* [Sliding cube] */
sliding_tolerance = 0.75;
//cube height will be substracted by valve pin height (min = 2x pin height ...)
sliding_cube_height = 15;
//must be > 12 & < 16
sliding_cube_width = 15; //[12:15]

cursor_plug_sliding_cube = [3.6,2.8,sliding_cube_height/2]; 
cursor_space = 0.25;
cursor_height_adjust = 0.5;//-0.1;
cursor_sliding_cube_L = 5.75;
cursor_sliding_cube_l = 1.75;

//sliding_cube = [sliding_cube_width+5.75,sliding_cube_width+1.75,sliding_cube_height];
sliding_cube = [sliding_cube_width+cursor_sliding_cube_L,sliding_cube_width+cursor_sliding_cube_l,sliding_cube_height];
sliding_cube_hole = [sliding_cube[0]+sliding_tolerance,sliding_cube[1]+sliding_tolerance,sliding_cube[2]+sliding_tolerance/2];

/* [Motor] */
//look at module pmm_gearmotor_hole
motor = [10.0,12.0,24.5]; //10x12x24.5+solder pin
motor_hole = [motor[0] + sliding_tolerance,motor[1] + sliding_tolerance,motor[2]];
motor_gearbox_cutout = false;
motor_gap = 0.3;




/* [PCB] */
pcb_height = 2.5; //with soldering height
pcb_chips_height = 2.5;//1.65;
pcb_diam = 30.25; //31.37 with usb slot | 30.25 without usb nor button
esp_c3_hole =  [18.0,20.2,5.0];//[12.5,13.2,3];
pcb_usb_overheight = 0.4;
pcb_button_overheight = 1.01;
//X: -301mil, Y:+350mil
opto_sensor_placement = [-7.6454,8.89];
opto_sensor_size = [2.794,3.683];

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
cover_usb_hole_enable = false;
cover_button_hole_enable = false;


cyl_height = motor_hole[2]+ sliding_cube_hole[2]-pcb_chips_height;

/* [Inner Cylinder] */
inner_cyl_tickness = 6.0;
inner_cyl_extra_height = 3.8;

/* [Hidden] */
//real 4.7mm
animation_move = 5;//mm

cursor_height = motor_hole[2]+valve_pin_height +cursor_height_adjust;//motor_hole[2]+ sliding_cube_hole[2] -12; 
//echo("Cursor height : " , cursor_height);

//$fn=360;
$fn = $preview ? 25 : 100;
//$fs = 0.15;


// When cutting holes using difference(), we
// start this far outside the object to avoid
// OpenSCAD leaving weird surfaces of (nearly)
// zero thickness due to rounding errors.
epsilon=0.01;


// debug text
//translate($vpt) rotate($vpr)color( "Red", 0.3 ) text(str(" cursor_height=",cursor_height, " | cyl_height=" ,cyl_height),1);

/////// PRINT 

if (print_M30_adapter == true){
    M30_adapter();
}

if (print_slider == true){

    rotate([90,0,0])
    translate([0,sliding_cube_width/2+1,10])sliding_cube();

}
    
if (print_core == true){

    //rotate([90,0,0])
    translate([0,10,0])inner_cylinder();

}
       
/////// DEBUG     
       
if (debug == true){

difference(){ //for debug_cut & pcb_hole
union(){ 

    color("Yellow",0.3)
    inner_cylinder();
   
    if (slider_enable ==true){
        
        translate([0,0,($t*animation_move)-4]) 
        translate([0,0,thread_height-top_thread_hang_height-0.75+sliding_cube[2]/2-inner_cyl_extra_height/2])
        sliding_cube();
        

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
translate([0,0,-cover_height-pcb_height-3])
color("Green",0.6)scale([scale_factor,scale_factor,scale_factor])translate([-4070,3397,0])
    if(pcb_v2 == true){       
           import("./3d_objects/pcb_motor_v2.stl", convexity=3);
    }else{
        import("./3d_objects/pcb_motor.stl", convexity=3);
    }//if v2
           
        }//pcb
        
     
     //M30_adapter
       if (M30_adapter_enable ==true){ 
       color("Green",0.1)
        translate([0,0,-m30_adapter_height/2-thread_height-thread_pitch/2+thread_pitch])   
        M30_adapter();
       }     
    
    
    }//union
    
    if (debug_cut ==true){
        if(debug_cut_half_1 ==true){
        translate([-50,0,-20])
        cube([100,100,100]);}
        if(debug_cut_half_1 ==false){
        translate([-50,-100,-20])
        cube([100,100,100]);}
        
            }
         
            
    }//difference (only for debug_cut)
}


    


//}
       
       

/////////////////// modules ///////////////////
//sliding_cube(expand = 0.5);

module sliding_cube(expand = 0){
    union(){//union all
    difference(){
color("Violet",0.5)
//union(){//cube and cursor    
cube([sliding_cube[0],sliding_cube[1]+expand,sliding_cube[2]], center=true);
//roundedcube([sliding_cube[0],sliding_cube[1],sliding_cube[2]], true, 0.5, "all");
 //cursor   

//}//union
        
 //valve pin height  
  if(expand == 0){ //print|hole mode
        //translate([0,0,-top_thread_hang_height-valve_pin_height/2-0.3])cylinder(r=thread_diam/2-cover_tickness, h=thread_height-expand);   
      
      translate([0,0,-top_thread_hang_height-valve_pin_height/2-0.3])cylinder(r=thread_diam/2-cover_tickness, h=valve_pin_height-inner_cyl_extra_height/2);   
      
              //m3 hole
       translate([0,0,-sliding_cube[2]/2+1])    
    cylinder(r=1.5+0.1, h=sliding_cube[2]);

    //M3 square nut : M3x7x2 metal 
        translate([0,5,sliding_cube[2]/2-3]) 
        cube([8,20,2.5], center=true);
  }  //expand = 0
        


//M3 square bottom nut : M3x7x2 metal 
  //      translate([0,0,-sliding_cube[1]/2+valve_pin_height+1]) cube([7,7,2], center=true);

  //cut some part for strenghtness of inner cylinder

//cut top       
translate([0,sliding_cube[1]/2+expand,1])
cube([sliding_cube[0],5,sliding_cube[2]], center=true);


//cut bottom
//translate([0,-sliding_cube[1]/2,0])cube([sliding_cube[0],5,sliding_cube[2]/2-3+thread_height-top_thread_hang_height], center=true);
  

//cut left
rotate([0,0,90]) translate([0,sliding_cube[1]/2+expand+5,0])cube([sliding_cube[0],10,sliding_cube[2]+1], center=true);

//cut right
rotate([0,0,90]) translate([opto_sensor_size[0]+opto_sensor_size[0]/2-0.4,-sliding_cube[1]/2-expand-5,1])cube([sliding_cube[0],10,sliding_cube[2]+5], center=true);

//cut left diag
rotate([0,0,45-90]) translate([0,-sliding_cube[1]/2-4-expand,0])cube([sliding_cube[0],10,sliding_cube[2]+2], center=true);


   
    }//diff
    
    //square reinforcmeent
    translate([0,0,-sliding_cube[1]/2-expand+valve_pin_height+1+0.6-inner_cyl_extra_height/2]) cube([7,7,2], center=true);
    
    //cursor
     if (cursorV3_enable ==true){
   
translate([-opto_sensor_placement[0]+opto_sensor_size[0]/2,-opto_sensor_placement[1]+opto_sensor_size[0]/2,sliding_cube[2]/2-3+thread_height-top_thread_hang_height])rotate([90,0,45+90+90])//cursor_V3();
     rotate([90,45,0])
    translate([0,0,-cursor_height/2+top_thread_hang_height-1])
   cube([opto_sensor_size[0]-1+expand*3,opto_sensor_size[1]-1+expand*3,cursor_height+expand*100], center=true);
        }//cursor 
 
//add bottom expand #todo : not hardcode values
translate([4,-sliding_cube[1]/2-expand+0.258,0])cube([sliding_cube[0]-7,expand-0.25,sliding_cube[2]], center=true);        
    
}//union all
}



module full_cover(){
        //cover 
    difference(){
     // union(){  
     translate([0,0,thread_height])cover();
    // translate([0,0,-top_thread_hang_height])
//cylinder(r=thread_diam/2-cover_tickness, h=thread_height);  } 
        
           //inner hole
    translate([0,0,thread_height])cover(cover_tickness);  
        
        
 /*   
    //cursor hole
    if (cursorV1_enable ==true){
translate([sliding_cube[2]/2+0.8,-sliding_cube[2]/2-0.8,sliding_cube[2]-3+thread_height-top_thread_hang_height-0.5])         rotate([0,0,45+90+90])   
    cube([cursor_plug_sliding_cube[0]+1,cursor_plug_sliding_cube[1]+1,cursor_plug_sliding_cube[2]+thread_height*2], center=true);
         }  //cursor
         
    if (cursorV2_enable ==true){
       translate([sliding_cube_hole[0]/2,0,cover_height/2]) cube([cursor_plug_sliding_cube[0]+1,cursor_plug_sliding_cube[1]+2,cursor_plug_sliding_cube[2]+cover_height], center=true);
    }//cursor
  */  
    
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
       
  rotate([0,0,45])translate([0,cover_top_radius-cover_tickness,cover_height+pcb_height-pcb_button_overheight])
        cube([2,2,1.5]);    
       
    }//usb hole
        
           }//diff      

// bottom thread
difference(){ // slider
  /* 
difference(){ //thread /cyl
           //external thread  
         metric_thread(thread_diam + bolt_delta, thread_pitch, thread_height + 0.002, internal=false);
         

}//thread 
*/
    //sliding cube hole
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
    translate([0,0,-cover_bottom_height/2])
    //thread_height
    cylinder(h = cover_bottom_height, r1 = cover_bottom_radius-reduce, r2 = cover_mid_radius-reduce, center = false);
}





module inner_cylinder(){
    
    difference(){
    union(){
        
        //echo("inner_cyl_height=",cyl_height);
translate([0,0,thread_height-pcb_height-pcb_chips_height-inner_cyl_extra_height])color("Yellow",0.3)
        //inner top cylinder
cylinder(r=motor[1]/2+inner_cyl_tickness, h=cyl_height+inner_cyl_extra_height);

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
  
     //Holes
    //bottom cut
    //cylinder(r=thread_diam/2, h=thread_height-top_thread_hang_height);
  
    //sliding cube hole top
     translate([0,0,top_thread_hang_height+valve_pin_height-valve_pin_height/2])sliding_cube(sliding_tolerance);
     
     //sliding cube hole bottom
     translate([0,0,top_thread_hang_height+valve_pin_height-valve_pin_height/2-inner_cyl_extra_height])sliding_cube(sliding_tolerance);
 
    //esp c3 cut
    translate([-10,0,cyl_height-top_thread_hang_height])rotate([0,90,0])
    cube([esp_c3_hole[0],esp_c3_hole[1],esp_c3_hole[2]], center=true);
   
    
    //new motor + gearbox hole
    translate([-motor_hole[0]/2 + motor_gap,0,thread_height-top_thread_hang_height+sliding_cube_hole[2]-0.35])rotate([90,0,90])pmm_gearmotor_hole();
       
    }//diff
    
// thread
difference(){ //thread /cyl
           //external thread 
   
    
    translate([0,0,-inner_cyl_extra_height])
         metric_thread(thread_diam + bolt_delta, thread_pitch, thread_height + 0.002, internal=false);
         

    translate([0,0,top_thread_hang_height+valve_pin_height-valve_pin_height/2-sliding_cube_hole[2]/2-inner_cyl_extra_height])sliding_cube(sliding_tolerance);
    
    
           } //end thread
         
   
}//end inner_cylinder



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
    gap= motor_gap,//0.2 // the extra tolerance all around the hole.  Also used as an overhang for any part that will be subtracted with difference().
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
    if(motor_gearbox_cutout == true){        
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
  conWdth= 0.37; // contact width
  
  
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


/*

module roundedcube(size = [1, 1, 1], center = false, radius = 0.5, apply_to = "all") {
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;

	translate_min = radius;
	translate_xmax = size[0] - radius;
	translate_ymax = size[1] - radius;
	translate_zmax = size[2] - radius;

	diameter = radius * 2;

	obj_translate = (center == false) ?
		[0, 0, 0] : [
			-(size[0] / 2),
			-(size[1] / 2),
			-(size[2] / 2)
		];

	translate(v = obj_translate) {
		hull() {
			for (translate_x = [translate_min, translate_xmax]) {
				x_at = (translate_x == translate_min) ? "min" : "max";
				for (translate_y = [translate_min, translate_ymax]) {
					y_at = (translate_y == translate_min) ? "min" : "max";
					for (translate_z = [translate_min, translate_zmax]) {
						z_at = (translate_z == translate_min) ? "min" : "max";

						translate(v = [translate_x, translate_y, translate_z])
						if (
							(apply_to == "all") ||
							(apply_to == "xmin" && x_at == "min") || (apply_to == "xmax" && x_at == "max") ||
							(apply_to == "ymin" && y_at == "min") || (apply_to == "ymax" && y_at == "max") ||
							(apply_to == "zmin" && z_at == "min") || (apply_to == "zmax" && z_at == "max")
						) {
							sphere(r = radius);
						} else {
							rotate = 
								(apply_to == "xmin" || apply_to == "xmax" || apply_to == "x") ? [0, 90, 0] : (
								(apply_to == "ymin" || apply_to == "ymax" || apply_to == "y") ? [90, 90, 0] :
								[0, 0, 0]
							);
							rotate(a = rotate)
							cylinder(h = diameter, r = radius, center = true);
						}
					}
				}
			}
		}
	}
}
*/ //roundedcube