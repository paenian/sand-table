in = 25.4;
beam = 20;

wall = 6;   //beefy carriages


spacer_height = 6; 

//this is for the big v-wheels
wheel_thick = 10.23;
wheel_rad = 23.9/2;
wheel_eff_rad = 19/2;   //radius sticking out of the v-slot

/*
//this is for the mini v-wheels
wheel_thick = 8.8;
wheel_rad = 15.23/2;
wheel_eff_rad = 11/2;   //radius sticking out of the v-slot
*/

main_beam_length = 500;
cross_beam_length = 500;

//height of the stack!
//the magnet is at zero, so nothing sticks up above the Z plane.
magnet_height = in/2;
magnet_rad = in/4;
carriage_clearance = wall + (wheel_thick/2+spacer_height)-beam/2;
echo(carriage_clearance);
                //magnet         this beam  X carriage             x beam
y_beam_height = -magnet_height - beam/2 -   carriage_clearance -   beam - carriage_clearance;
x_beam_height = -magnet_height - beam/2 - carriage_clearance;
magnet_carriage_height = -magnet_height-wall;
beam_carriage_height = -magnet_height-carriage_clearance-beam-wall;

//idler RANDOM NUMBERS
idler_rad = 9;
idler_flange_rad = 11;
idler_flange_thick = 1.5;
idler_height = 12;

//pulley RANDOM NUMBERS
pulley_rad = 9;
pulley_flange_rad = 11;
pulley_flange_thick = 1.5;
pulley_base_rad = 12;
pulley_base_thick = 10;
pulley_height = 18;


//screws et al
m5_rad = 5/2+.15;
m5_nut_rad = 8.79/2+.25;

belt_thick = 1.5;
belt_height = 6;




module beam(length = 20, center=true){
    beam_wall = 1.8;
    beam_center_rad = 4.2/2+.1;
    
    difference(){
        cube([beam, beam, length], center=center);
        
        //center hole
        translate([0,0,-.1]) cylinder(r=beam_center_rad, h=length+1, center=center, $fs=1);
        
        //inside
        translate([0,0,-.1]) difference(){
            cube([beam-beam_wall*2,beam-beam_wall*2,length+1], center=center);
            
            //center
            cube([7,7,length+2], center=true);
            //cross walls
            for(i=[45:90:179]) rotate([0,0,i]) {
                cube([1.5, 19.75, length+1], center=true);
            }
            
            //corners
            for(i=[0:90:359]) rotate([0,0,i]) translate([beam/2, beam/2,0]) {
                difference(){
                    cube([(1.8+1.07+1.75)*2, (1.8+1.07+1.75)*2, length+1], center=true);
                    cube([(1.8+1.75)*2, (1.8+1.75)*2, length+1], center=true);
                }
            }
        }
        
        //v slot channel
        for(i=[0:90:359]) rotate([0,0,i]) translate([beam/2, 0,0]) {
            rotate([0,0,45]) cube([6.5,6.5,length+2], center=true);
        }
        
        //chamfer the corners
        for(i=[0:90:359]) rotate([0,0,i]) translate([beam/2, beam/2,0]) {
            rotate([0,0,45]) cube([1,1,length+2], center=true);
        }
    }
}

module pulley(solid = 1){
    if(solid == 1){
        difference(){
            union(){
                cylinder(r=pulley_rad, h=pulley_height, center=true);
                translate([0,0,pulley_height/2-pulley_flange_thick/2])
                    cylinder(r=pulley_flange_rad, h=pulley_flange_thick, center=true);
            
                translate([0,0,-pulley_height/2+pulley_base_thick/2]) cylinder(r=pulley_base_rad, h=pulley_base_thick, center=true);
            }
        
            cylinder(r=m5_rad, h=pulley_height+1, center=true);
        }
    }else{
        cylinder(r=m5_rad, h=idler_height*5, center=true);
    }
}

module idler(solid = 1){
    if(solid == 1){
        difference(){
            union(){
                cylinder(r=idler_rad, h=idler_height, center=true);
                for(i=[0,1]) mirror([0,0,i]) translate([0,0,idler_height/2-idler_flange_thick/2]){
                    cylinder(r=idler_flange_rad, h=idler_flange_thick, center=true);
                }
            
                //ghost in some belts
                for(i=[0,1]) mirror([0,i,0]) translate([0,idler_rad+belt_thick/2,0]){
                    %cube([200,belt_thick,belt_height], center=true);
                }
            }
        
            cylinder(r=m5_rad, h=idler_height+1, center=true);
        }
    }else{
        cylinder(r=m5_rad, h=idler_height*5, center=true);
    }
}

module wheel(solid = 1){
    if(solid == 1){
        difference(){
            hull(){
                cylinder(r=wheel_rad, h=wheel_thick/3, center=true);
                cylinder(r=wheel_rad-wheel_thick/3, h=wheel_thick, center=true);
            }
        
            cylinder(r=m5_rad, h=idler_height+1, center=true);
        }
    }else{
        cylinder(r=m5_rad, h=idler_height*3, center=true);
    }
}