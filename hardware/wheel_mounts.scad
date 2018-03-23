in = 25.4;

axle_rad = 5/16*in/2+.5;
axle_lift = 4*in;
length = 3*in;

wall = 8;
lip_inset = 2;


rotate([90,0,0]) boat_wheels();
//rotate([90,0,0]) mirror([1,0,0]) boat_wheels();


module boat_wheels(){
    difference(){
        union(){
            //axle
            translate([0,0,axle_lift]){
                rotate([90,0,0]) cylinder(r=axle_rad+wall, h=wall, center=true);
                rotate([90,0,0]) translate([0,0,wall-.1]) cylinder(r1=axle_rad+wall, r2=axle_rad+wall/2, h=wall+.1, center=true);
            }
            
            //attach bar
            hull(){
                rotate([90,0,0]) cylinder(r=axle_rad+wall, h=wall, center=true);
                rotate([90,0,0]) translate([0,0,wall-.1]) cylinder(r1=axle_rad+wall, r2=axle_rad+wall/2, h=wall+.1, center=true);
                
                translate([length,0,0]){
                    rotate([90,0,0]) cylinder(r=axle_rad+wall, h=wall, center=true);
                    rotate([90,0,0]) translate([0,0,wall-.1]) cylinder(r1=axle_rad+wall, r2=axle_rad+wall/2, h=wall+.1, center=true);
                }
            }
            
            //connect up the axle
            hull(){
                translate([0,0,axle_lift]){
                    rotate([90,0,0]) cylinder(r=axle_rad+wall, h=wall, center=true);
                    rotate([90,0,0]) translate([0,0,wall-.1]) cylinder(r1=axle_rad+wall, r2=axle_rad+wall/2, h=wall+.1, center=true);
                }
                
                rotate([90,0,0]) cylinder(r=axle_rad+wall, h=wall, center=true);
                rotate([90,0,0]) translate([0,0,wall-.1]) cylinder(r1=axle_rad+wall, r2=axle_rad+wall/2, h=wall+.1, center=true);
            }
            
            hull(){
                translate([0,0,axle_lift]){
                    rotate([90,0,0]) cylinder(r=axle_rad+wall, h=wall, center=true);
                    rotate([90,0,0]) translate([0,0,wall-.1]) cylinder(r1=axle_rad+wall, r2=axle_rad+wall/2, h=wall+.1, center=true);
                }
                
                translate([length,0,0]) {
                    rotate([90,0,0]) cylinder(r=axle_rad+wall, h=wall, center=true);
                    rotate([90,0,0]) translate([0,0,wall-.1]) cylinder(r1=axle_rad+wall, r2=axle_rad+wall/2, h=wall+.1, center=true);
                }
            }
        }
        
        //axle holder
        translate([0,0,axle_lift]){
            rotate([90,0,0]) cylinder(r=axle_rad, h=50, center=true);
            rotate([90,0,0]) translate([0,0,-wall*1.5]) cylinder(r2=10, r1=20, h=10, $fn=29);
        }
        
        //cut out to attach
        translate([0,wall/2+wall-lip_inset,0]) cube([500,wall*2,(axle_rad+wall*2)*2], center=true);
        
        //some screwholes
        for(i=[0:length/2:length]) translate([i,0,0]) {
            rotate([-90,0,0]) cylinder(r=2.6, h=50, center=true, $fn=29);
            rotate([90,0,0]) translate([0,0,wall/2]) cylinder(r1=2.6, r2=9/2, h=4.1, $fn=29);
            rotate([90,0,0]) translate([0,0,wall/2+4]) cylinder(r=9/2, h=10, $fn=29);
        }
    }
}