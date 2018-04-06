include <configuration.scad>

wall = 5;

clamp_width = m5_rad*2 + wall*1.5;
clamp_height = 30;
screw_sep = 13;
screw_drop = 4;
clamp_screw_rad = 1.75;
clamp_screw_cap_rad = 3.6;
clamp_screw_cap_height = 2;

translate([0,0,clamp_width/2]) rotate([0,90,0]) clamp_base();

translate([-8,-7,0]) rotate([0,0,90]) clamp_lever();

$fn=36;

module clamp_base(){
    difference(){
        union(){
            //screw body
            hull(){
                translate([clamp_width/2,0,0]) cylinder(r=clamp_width/2, h=clamp_height);
                translate([-clamp_width/2,0,clamp_height*2/3]) cylinder(r=clamp_width/2, h=clamp_height*1/3);
                
                for(i=[0,1]) mirror([0,i,0]) translate([clamp_width/2,screw_sep,clamp_height-clamp_width/2])
                    rotate([0,-90,0]) cylinder(r=clamp_width/2, h=wall);
            }
        }
        
        //hole for the clamp screw
        cylinder(r=m5_rad, h=clamp_height*3, center=true);
        rotate([0,0,30]) cylinder(r1=m5_nut_rad+.5, r2=m5_nut_rad-.1, h=clamp_height, center=true, $fn=6);
        
        //mount holes to the side
        for(i=[0,1]) mirror([0,i,0]) translate([0,screw_sep,clamp_height-clamp_width/2-screw_drop]) {
            rotate([0,90,0]) translate([0,0,-.1]) cylinder(r=clamp_screw_rad, h=50, center=true);
            translate([clamp_width/2-clamp_screw_cap_height,0,0]) rotate([0,-90,0]) cylinder(r1=clamp_screw_rad, r2=clamp_screw_cap_rad, h=clamp_screw_cap_height+.05);
            translate([clamp_width/2-clamp_screw_cap_height,0,0]) rotate([0,-90,0]) translate([0,0,clamp_screw_cap_height]) cylinder(r=clamp_screw_cap_rad, h=50);
        }
        
        //v-top for aligning
        translate([0,0,clamp_height]) scale([1,2,1]) rotate([0,90,0]) cylinder(r=m5_rad, h=50, center=true, $fn=4);
        
        //flatten
        translate([50+clamp_width/2,0,0]) cube([100,100,100], center=true);
    }
}

module clamp_lever(length = 20){
    wall = 4;
    chamfer = wall/3;
    difference(){
        union(){
            hull(){
                translate([length,0,0]) cylinder(r1=clamp_width/2-chamfer, r2=clamp_width/2, h=chamfer+.01);
                translate([-clamp_width/2,0,0]) cylinder(r1=clamp_width/2-chamfer, r2=clamp_width/2, h=chamfer+.01);
                
                translate([length,0,chamfer]) cylinder(r=clamp_width/2, h=wall-chamfer);
                translate([-clamp_width/2,0,chamfer]) cylinder(r=clamp_width/2, h=wall-chamfer);
            }
            
            intersection(){
                translate([0,0,wall]) scale([1,2,1]) rotate([0,90,0]) cylinder(r=m5_rad, h=50, center=true, $fn=4);
                hull(){
                    translate([-clamp_width/2,0,0]) cylinder(r=clamp_width/2, h=wall*2);
                    translate([0,0,0]) cylinder(r=clamp_width/2, h=wall*2);
                }
            }
        }
        
        //screwhole
        cylinder(r=m5_rad, h=clamp_height*3, center=true);
        
        //glass cutout
        hull(){
            translate([25+clamp_width,0,25+wall/2]) cube([50,50,50], center=true);
            translate([25+clamp_width-wall,0,25+wall/2+wall]) cube([50,50,50], center=true);
        }
    }
}