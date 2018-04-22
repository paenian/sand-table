in=25.4;

screen();

module screen(){
    //the screen proper
    cube([7.65*in, 4.35*in, .1], center=true);
    
    //mounting plate
    translate([0,-.075*in/2,5/2]) cube([6.575*in, 4*in, 5], center=true);
    
    //screw nubs
    translate([0,-.075*in/2,5/2-.1]) for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) mirror([0,j,0]) translate([126/2, 66/2,0]) {
    }
}