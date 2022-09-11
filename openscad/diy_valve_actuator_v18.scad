
// Use thread library from http://dkprojects.net/openscad-threads/
include <threads.scad>;

//some adjustement (printer precision ?)
//nut_delta = 0.8; //exact fit
nut_delta = 0.9; //v10 // larger but easy to screw

print = true;
print_slider = true;
print_actuator = true;
debug = false; //do not render threads

//course normale 4.7mm
$fn=360;

//5.5mm diff / 2 : v16
cap_height = 10.0-2.75;//v16 old 10 //v10 //old 15.0
cap_diam = 28.0+nut_delta;
cap_pitch = 1.5; //v17
//pine_move = 15;//4.7;
top_cover_size = 2.0;
sliding_tolerance = 0.8;//v10  old 0.35 with 1st cube;
motor = [10.0,12.0,26.25];
motor_hole = [motor[0] + sliding_tolerance,motor[1] + sliding_tolerance,motor[2]];

sliding_cube = [cap_diam/2+1,cap_diam/2+1,15];
sliding_cube_hole = [sliding_cube[0]+sliding_tolerance,sliding_cube[1]+sliding_tolerance,sliding_cube[2]+sliding_tolerance/2];//v10 sliding_tolerance/2
motor_spacer = [5.0,12.0,5.0];

//v14
cursor_enable = false;
cursor_plug_sliding_cube = [3,2.5,6]; //v11
cursor_space = 0.25; //v11
cursor_height = motor_hole[2]+ sliding_cube_hole[2] -0.5; //v12


cover_enable = false;
pcb_enable = false;
cover_height = motor_hole[2]+ sliding_cube_hole[2] -0.5+motor_spacer[2]+cap_height-10;
cover_slices = 20;//360;  

wrench_size=36.0; //v16 (same as M30x1.5)
radius = wrench_size / sqrt(3.0);//v16 (same as M30x1.5)

cyl_height = motor_hole[2]+ sliding_cube_hole[2] -0.5+motor_spacer[2];

//tot_height = motor_hole[2]+ sliding_cube_hole[2] -0.5+motor_spacer[2]+cap_height;

//echo("tot_height" ,tot_height);

//echo("motor_hole" ,motor_hole);



if (print_actuator == true){

difference(){
    union(){
translate([0,0,cap_height])color("Green",0.5)
        //inner top cylinder
cylinder(r=motor[1]/2+3.5, h=cyl_height);
  //octogon      
color("blue",0.6)
        //cylinder(r=cap_diam/2+4, h=cap_height, $fn=8);
        cylinder(r=radius, h=cap_height, $fn=6);//v16 (same as M30x1.5)
        
     //cover small   
    translate([0,0,cap_height])cover_small();
    }//union
    if (debug ==false){
metric_thread (diameter=cap_diam, pitch=cap_pitch, length=cap_height-top_cover_size,internal=true);
        // internal -    true = clearances for internal thread (e.g., a nut).
//               false = clearances for external thread (e.g., a bolt).
    }else{
    cylinder(r=cap_diam/2, h=cap_height-top_cover_size);
    }
    
    //inner_motor_hole();
    //sliding cube hole
    translate([-sliding_cube_hole[0]/2,-sliding_cube_hole[1]/2,cap_height-top_cover_size-0.5])cube([sliding_cube_hole[0],sliding_cube_hole[1],sliding_cube_hole[2]], center=false);
    
   
    //motor hole
    translate([-motor_hole[0]/2,-motor_hole[1]/2,cap_height-top_cover_size+sliding_cube_hole[2]-0.5])cube([motor_hole[0],motor_hole[1],motor_hole[2]], center=false);
    
    //top cables
    //translate([0,0,sliding_cube[2]+motor[2]+cap_height-5])cylinder(r=2.0, h=10);
    //motor spacer
    translate([0,0,sliding_cube[2]+motor[2]+cap_height-5+motor_spacer[2]])cube([motor_spacer[0],motor_spacer[1],motor_spacer[2]],center=true);
    //translate([cap_diam/2-2,3,cap_height/4])rotate([0,0,22.5])    cube([5,3,6.5]);    
}

    
    if (debug ==true){
        //sliding cube //v10
        translate([0,0,cap_height-top_cover_size-0.5+sliding_cube[2]/2])
        sliding_cube();
        
        //v11 cursor
        if (cursor_enable ==true){
    translate([sliding_cube[2]/2-0.8,-sliding_cube[2]/2+0.8,sliding_cube[2]-3+cap_height-top_cover_size-0.5])         rotate([90,0,45+90+90])    cursor();
        }
        
       if (cover_enable ==true){ 
    //cover v13
     translate([0,0,cap_height])cover();  
       } 
       
       // pcb import
       if (pcb_enable ==true){ 
scale_factor = 0.257;
rotate([0,180,0])translate([0,0,-cyl_height-10])
color("Green",0.6)scale([scale_factor,scale_factor,scale_factor])translate([-4070,3397,0])import("./3d_objects/pcb.stl", convexity=3);
        }

    }
}


if(print == true){
    if (print_slider == true){
    
    //sliding cube //v15
    //if(debug == true){
    translate([25,25,sliding_cube[2]/2])sliding_cube();
    //}else{
 //translate([0,0,sliding_cube[2]/2])sliding_cube();
    //}
    

    
   //cursor v11     
    if (cursor_enable ==true){
translate([-25,-25,0])rotate([0,90,0])cursor();
    }
    
    
    //cover v13
    if (cover_enable ==true){
    translate([35,-25,0])cover(); 
    }
}
}




module sliding_cube(){
    difference(){
color("Violet",0.5)
cube([sliding_cube[0],sliding_cube[1],sliding_cube[2]], center=true);
        //m3 hole
       translate([0,0,-sliding_cube[2]/2+1])    
    cylinder(r=1.5, h=sliding_cube[2]); //v15
    //M3 square nut : M3x7x2 metal 
        translate([0,5,sliding_cube[2]/2-3]) 
        cube([8,20,2.5], center=true);
       
    if (cursor_enable ==true){ 
    //v10 cursor hole
    translate([sliding_cube[2]/2-4,-sliding_cube[2]/2+4,sliding_cube[2]/2-3])
     rotate([90,0,45+90+90])  
       cube([cursor_plug_sliding_cube[0]+cursor_space,cursor_plug_sliding_cube[1]+cursor_space,cursor_plug_sliding_cube[2]*2+cursor_space], center=true); //v11
    //cylinder(r=1.5, h=15);
    }//cursor
    }//diff
}


module cursor(){ //v11
    color("Magenta",0.5)
    cube([cursor_plug_sliding_cube[0],cursor_plug_sliding_cube[1],cursor_plug_sliding_cube[2]], center=true);
    
    //v12
    color("Magenta",0.5)
rotate([90,0,0])
    translate([0,-1,-cursor_height/2-3.5])
   cube([cursor_plug_sliding_cube[0],cursor_plug_sliding_cube[1]/2,cursor_height], center=true);
    
    color("Magenta",0.5)
rotate([90,0,0])
    translate([0,-cursor_plug_sliding_cube[1]+0.25,-5])
   cube([cursor_plug_sliding_cube[0],cursor_plug_sliding_cube[1]/2,10], center=true);
}

/*
module cover(){ //v13
    //v_slices = 360;

    color("White",0.1)
        linear_extrude(height = cover_height, center = false, convexity = 10, twist = 0, slices = cover_slices, scale = [0.6,0.6], $fn = 16) {
      circle(r=radius, $fn=8);//v16 (same as M30x1.5)
                    //circle(r=cap_diam/2+4, $fn=8);
    }
}
*/

module cover_small(){ //v14
    //v_slices = 360;

    color("White",0.5)
    linear_extrude(height = 7+1.25, center = false, convexity = 0, twist = 0, slices = 10, scale = [0.51,0.51], $fn = 160) {
     //   circle(r=cap_diam/2+4, $fn=8);
        circle(r=radius, $fn=6);//v16 (same as M30x1.5)

    }
}

/*
module motor(){
color("Magenta",1) rotate([180,0,0])   
union(){
 translate(-[motor[0]/2,motor[1]/2,motor[2]])
 cube(motor, center=false);
 translate([-inner_cube/2,-inner_cube/2,0])
 cube([inner_cube,inner_cube,inner_cube_height], center=false);
 //cylinder(r=1.5, h=30,$fn=180);
}//diff

}
*/
