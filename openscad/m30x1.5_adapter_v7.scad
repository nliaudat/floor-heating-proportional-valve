// Use thread library from http://dkprojects.net/openscad-threads/
include <threads.scad>;

debug = false;
//5.5mm diff / 2 : v16
cap_height = 10.0-2.75; //v16 old 10.0 //v10 //old 15.0
cap_diam = 28.0-0.2;//v7
cap_pitch = 1.5; //v7 (v17)


wrench_size=36.0;
bolt_diameter=30.0;
thread_pitch=1.5;
height=6.0;

//some adjustement (printer precision ?)
bolt_delta = 0.4; //exact fit
//bolt_delta = 0.6; // larger but easy to screw


// When cutting holes using difference(), we
// start this far outside the object to avoid
// OpenSCAD leaving weird surfaces of (nearly)
// zero thickness due to rounding errors.
epsilon=0.01;

// We want the distance between opposite flats of the hexagon to be "wrench_size", but we have to specify the dimensions by the diameter of the circumscribed circle. In other words, we need the distance from the center to the corners of the hexagon. That's given by the following:
radius = wrench_size / sqrt(3.0);



$fn=200;

// simple_nut() is a hexagonal prism with a
// threaded hole through it.
module simple_nut() {
  difference() {
    cylinder(r=radius, h=height, $fn=6);
    translate([0,0,-epsilon])
      metric_thread(bolt_diameter + bolt_delta, thread_pitch, height + 2*epsilon, internal=false);
  }
}


module cap(){
    difference() {
        union(){
    color("blue",0.6)
    cylinder(r=radius, h=1.5, $fn=6);
  color("yellow",0.6)          
  metric_thread (diameter=cap_diam, pitch=cap_pitch, length=cap_height,internal=false);
            // internal -    true = clearances for internal thread (e.g., a nut).
//               false = clearances for external thread (e.g., a bolt).
        }//union
 cylinder(r=cap_diam/2-2, h=cap_height);
}//diff

}


// M30x1.5 nut
if (debug ==false){
intersection() {
  simple_nut();
}
}else{
    difference() {
        cylinder(r=radius, h=height, $fn=6);
        cylinder(r=15, h=height, $fn=36);
    }
    }//M30x1.5


    
translate([0,0,height-epsilon])cap();
