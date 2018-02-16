include <configuration.scad>
//a simple, lightweight gantry system using two beams.

part = 10;


if(part == 10)
    assembly();

if(part == 0)
    magnet_carriage();

idler_offset = 25.4;

module assembly(){
    //base beam
    translate([0,0,y_beam_height]) rotate([90,0,0]) beam(length = main_beam_length);
    
    //cross beam
    translate([0,0,x_beam_height]) rotate([0,90,0]) beam(length = cross_beam_length);
    
    //magnet carriage
    translate([0,0,magnet_carriage_height]) magnet_carriage();
    
    //beam carriage
    //magnet carriage
    translate([0,0,beam_carriage_height]) beam_carriage();
}

module y_belt_mounts(solid = 1){
    
    
    for(i=[0,1]) mirror([i,0,0]) translate([idler_offset,0, wall+1+idler_height/2]) {
                idler(solid = solid);
                
                //draw in some more idlers for reference :-)
                for(j=[0,1]) mirror([0,j,0]) {
                    //these pulleys attach to the beam carriage
                    translate([-idler_offset+pulley_rad*2+belt_thick,pulley_rad*4+belt_thick*2,0])
                        idler(solid = solid);
                    
                    //these pulleys attach to the ends of the beam
                    translate([-idler_offset+cross_beam_length/2,pulley_rad*2+belt_thick,0])
                        idler(solid = solid);
                }
                
                //these attach to the ends of the main beam
                translate([-idler_offset,main_beam_length/2,0])
                    idler();
                translate([-idler_offset,-main_beam_length/2,0])
                    pulley(solid = solid);
            }
}

//holds the magnet on top of the beam, holds belts
module magnet_carriage(){
    wheel_sep = 51;
    difference(){
        union(){
            translate([0,0,wall/2]) cube([60,30,wall], center=true);
            
            //magnet mount
            translate([0,0,wall-1]) cylinder(r1=magnet_rad+wall, r2=magnet_rad+wall/2, h=magnet_height);
            
            //wheel supports
            for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) mirror([0,j,0]) translate([wheel_sep/2, beam/2+wheel_eff_rad, 0]){
                cylinder(r=wheel_eff_rad, h=wall);
                %translate([0,0,-beam/2]) wheel();
            }
            
            
            
            //idlers
            %y_belt_mounts();
        }
        
        //magnet mount hole
        translate([0,0,wall-1]) cylinder(r1=magnet_rad+.1, r2=magnet_rad+.3, h=magnet_height+1);
        
        //wheel holes
        for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) mirror([0,j,0]) translate([wheel_sep/2, beam/2+wheel_eff_rad, 0]){
            wheel(solid=-1);
        }
        
        //idler holes
        y_belt_mounts(solid = -1);
    }
}

//holds the beams together, routes belts
module beam_carriage(){
    wheel_sep = 71;
    
    difference(){
        union(){
            //wheel supports
            hull() for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) mirror([0,j,0]) translate([beam/2+wheel_eff_rad, wheel_sep/2, 0]){
                cylinder(r=wheel_eff_rad, h=wall);
                %translate([0,0,-beam/2]) wheel();
            }
            
            //support the rail
            difference(){
                translate([0,0,wall]) cube([0,0,0], center=true);
                //cross beam
                translate([0,0,x_beam_height]) rotate([0,90,0]) beam(length = cross_beam_length);
            }
        }
    }
}