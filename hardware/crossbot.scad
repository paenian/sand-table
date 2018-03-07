include <configuration.scad>

m5_cap_rad = 11/2;

//a simple, lightweight gantry system using two beams.

part = 5;

$fn = 30;

if(part == 10)
    assembly();

if(part == 0)
    magnet_carriage();

if(part == 1)
    double_idler();

if(part == 2)
    beam_carriage();

if(part == 3)
    motor_mount();

if(part == 4)
    offset_motor_mount();

if(part == 5)
    difference(){
        rotate([-116,0,0]) base_beam_mount();
        translate([0,0,-100-19]) cube([200,200,200], center=true);
    }

if(part == 6)
    base_beam_mount();

idler_offset = 26;

module assembly(){
    //base beam
    translate([0,0,y_beam_height]) rotate([90,0,0]) beam(length = main_beam_length);
    
    //cross beam
    translate([0,0,x_beam_height]) rotate([0,90,0]) beam(length = cross_beam_length);
    
    //magnet carriage
    translate([0,0,magnet_carriage_height]) magnet_carriage();
    
    //double idler - on the cross beam
    translate([0,0,magnet_carriage_height-carriage_clearance+wall]) double_idler();
    
    //beam carriage
    //magnet carriage
    translate([0,0,beam_carriage_height]) beam_carriage();
    
    //single idler - on the base beam
    //actually has two idlers, one for the cross beam and one for the base beam
    
    //motor mounts - on the base beam
    //needs to mount one motor to move the cross beam, and one to move the gantry along it.
    translate([0,0,y_beam_height]) motor_mount();
    
    translate([0,150,y_beam_height/2+beam/4]) base_beam_mount();
}

module base_beam_mount(){
    height = -beam/2-y_beam_height;
    length_beam = beam*2;
    length_table = beam*5;
    echo(height);
    difference(){
        union(){
            hull(){
                translate([0,10,-height/2+wall/2]) cube([beam,length_beam,wall], center=true);
                translate([0,0,height/2-wall/2]) cube([length_table,beam,wall], center=true);
            }
        }
        
        //attach to extrusion
        translate([0,10,0]) for(i=[0,1]) mirror([0,i,0]) translate([0,length_beam/2-beam/2,-height/2-.1]){
            cylinder(r=m5_rad+.25, h=50);
            translate([0,0,wall]) cylinder(r=m5_cap_rad+.25, h=50);
        }
        
        //attach to table
        for(i=[0,1]) mirror([i,0,0]) translate([length_table/2-beam/2,0,height/2+.1]) mirror([0,0,1]) {
            cylinder(r=m5_rad+.25, h=50);
            translate([0,0,wall]) cylinder(r=m5_cap_rad+.25, h=50);
        }
        
        //slots for the belts to pass through
        for(i=[0:1]) mirror([i,0,0]) translate([pulley_rad,0,-7]) cube([4,100,11], center=true);
    }
}

module motor_mount(){
    motor_screw_sep = 31;
    motor_screw_rad = 1.7;
    motor_screw_cap_rad = 6/2;
    motor_screw_flange_rad = 5.5+1;
    motor_w = motor_screw_flange_rad*2+motor_screw_sep;
    echo(motor_w);
    motor_flange_rad = 29/2;
    
    slot =2;
    
    extra = wall/2;
    
    translate([0,main_beam_length/2,beam/2+wall/2]) difference(){
        union(){
            hull(){
                translate([0,0,extra/2]) cube([beam+wall,beam*3,wall+extra], center=true);
            
                translate([0,motor_w/2+pulley_flange_rad*2+1,extra/2])hull()
                for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) mirror([0,j,0]){
                    translate([motor_w/2-motor_screw_cap_rad, motor_w/2-motor_screw_cap_rad, 0]) cylinder(r=motor_screw_cap_rad+wall/2, h=wall+wall/2, center=true);
                }
            }
            
            //hole for idler pulley
            for(i=[0,1]) mirror([i,0,0]) translate([pulley_rad,pulley_flange_rad+.5,0]){
                idler_bump();
            }
            
        }
        
        //motor holes
        translate([0,motor_w/2+pulley_flange_rad*2+1,0]) {
                for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) mirror([0,j,0]) hull(){
                    translate([motor_screw_sep/2-slot/2, motor_screw_sep/2-slot/2, 0]) cylinder(r=motor_screw_rad, h=wall+1, center=true);
                    translate([motor_screw_sep/2+slot/2, motor_screw_sep/2+slot/2, 0]) cylinder(r=motor_screw_rad, h=wall+1, center=true);
                }
                hull() for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) mirror([0,j,0]){
                    translate([motor_w/2-motor_screw_cap_rad, motor_w/2-motor_screw_cap_rad, wall/2]) cylinder(r=motor_screw_cap_rad, h=wall+wall/2);
                }
                
                cylinder(r=motor_flange_rad, h=wall+1, center=true);
            }
        
        //hole for idler pulley
        for(i=[0,1]) mirror([i,0,0]) translate([pulley_rad,pulley_flange_rad+.5,0]){
            cylinder(r=m5_rad, h = 30, center=true);
            //translate([0,0,wall/2]) cylinder(r=m5_rad+4, h = 30);
        }
            
        difference(){
            translate([0,-beam,beam/2+wall/2]) rotate([90,0,0]) hull() scale([1.01,1.01,1.01]) beam(length = beam*2.1);
             difference(){
                intersection(){
                    translate([0,0,wall/2]) cube([beam/2,100,2.5], center=true);
                    translate([0,-beam*.75,0]) hull() for(i=[0,1]) mirror([0,i,0]) translate([0,beam/3.1, 0])
                        cylinder(r=m5_rad+wall, h=wall*3);
                }
                //cross beam
                translate([0,0,beam/2+wall/2]) rotate([90,0,0]) beam(length = cross_beam_length);
            }
            
        }
        
        //beam holes
        translate([0,0,0]) for(i=[0,1]) translate([0,-pulley_rad-i*13,0])
            cylinder(r=m5_rad, h=wall*3, center=true);
    }
}

module offset_motor_mount(){
    motor_screw_sep = 31;
    motor_screw_rad = 1.7;
    motor_screw_flange_rad = 5.5;
    motor_w = motor_screw_flange_rad*2+motor_screw_sep;
    motor_flange_rad = 29/2;
    
    motor_offset = pulley_rad/2;
    
    slot =2;
    
    extra = wall/2;
    
    translate([0,main_beam_length/2,beam/2+wall/2]) difference(){
        union(){
            hull(){
                cube([beam,beam*3,wall], center=true);
            
                translate([motor_offset,motor_w/2+(m5_rad+wall/2)*2,0]) {
                    for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) mirror([0,j,0]) translate([motor_screw_sep/2, motor_screw_sep/2, 0]) cylinder(r=motor_screw_flange_rad, h=wall, center=true);
                        }
                        
                for(i=[0,1]) mirror([i,0,0]) translate([beam/2+m5_rad+wall/2,m5_rad+wall/2,0]){
                    cylinder(r=m5_rad+wall, h = wall, center=true);
                }
            }
            
            //align the carriage
            translate([]) difference(){
                intersection(){
                    translate([0,0,wall/2]) cube([beam/2,100,2.5], center=true);
                    translate([0,-beam*.75,0]) hull() for(i=[0,1]) mirror([0,i,0]) translate([0,beam/3.1, 0])
                        cylinder(r=m5_rad+wall, h=wall*3);
                }
                //cross beam
                translate([0,0,beam/2+wall/2]) rotate([90,0,0]) beam(length = cross_beam_length);
            }
        }
        
        //motor holes
        translate([motor_offset,motor_w/2+(m5_rad+wall/2)*2,0]) {
                for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) mirror([0,j,0]) hull(){
                    translate([motor_screw_sep/2-slot/2, motor_screw_sep/2-slot/2, 0]) cylinder(r=motor_screw_rad, h=wall+1, center=true);
                    translate([motor_screw_sep/2+slot/2, motor_screw_sep/2+slot/2, 0]) cylinder(r=motor_screw_rad, h=wall+1, center=true);
                }
                
                cylinder(r=motor_flange_rad, h=wall+1, center=true);
            }
            
        //hole for idler pulley
        for(i=[0,1]) mirror([i,0,0]) translate([beam/2+m5_rad+wall/2,m5_rad+wall/2,0]){
            cylinder(r=m5_rad, h = 30, center=true);
        }
        
        //beam holes
        translate([0,0,0]) for(i=[0,1]) translate([0,-pulley_rad-i*13,0])
            cylinder(r=m5_rad, h=wall*3, center=true);
    }
}

module y_belt_mounts(solid = 1){
    for(i=[0,1]) mirror([i,0,0]) translate([0,0, wall+1+idler_height/2]) {
                translate([idler_offset,0,0]) idler(solid = solid);
                
                //draw in some more idlers for reference :-)
                for(j=[0,1]) mirror([0,j,0]) {
                    //these pulleys attach to the beam carriage
                    translate([pulley_rad*2+belt_thick,pulley_rad*4+belt_thick*2+5,-beam-wall])
                        idler(solid = solid);
                    
                    //these pulleys attach to the ends of the cross beam
                    translate([cross_beam_length/2+pulley_rad,pulley_rad*2+belt_thick,0])
                        idler(solid = solid);
                }
                
                //these attach to the ends of the main beam
                translate([0,main_beam_length/2,-beam-wall])
                    rotate([0,0,90]) idler(solid = solid);
                translate([0,-main_beam_length/2,-beam-wall])
                    pulley(solid = solid);
            }
}

module double_idler(){
    idler_sep = pulley_rad*2+belt_thick;
    difference(){
        translate([cross_beam_length/2,0,0]) union(){
            hull(){
                for(i=[0,1]) mirror([0,i,0]) translate([pulley_rad,pulley_rad*2+belt_thick,0]){
                    cylinder(r=m5_rad+wall, h=wall);
                }
            }
            for(i=[0,1]) mirror([0,i,0]) translate([pulley_rad,pulley_rad*2+belt_thick,0])
                idler_bump();
            
            //attach to the beam
            hull(){
                for(i=[-1,0]) translate([-pulley_rad-i*13,0,0])
                    cylinder(r=m5_rad+wall, h=wall);
            }
        }
        //attach to the beam
        translate([cross_beam_length/2,0,0]) for(i=[0,-1]) translate([-pulley_rad-i*18,0,0])
            cylinder(r=m5_rad, h=wall*3, center=true);
        
        //idlers
        y_belt_mounts(solid = -1);
    }
}

module idler_bump(){
    cylinder(r2=m5_rad+.75, r1=m5_rad*2.5, h=wall+1);
}

//holds the magnet on top of the beam, holds belts
module magnet_carriage(){
    wheel_sep = 43;
    difference(){
        union(){
            translate([0,0,wall/2]) cube([60,30,wall], center=true);
            
            //magnet mount
            translate([0,0,wall-1]) cylinder(r1=magnet_rad+wall+1, r2=magnet_rad+wall/2, h=magnet_height);
            
            //wheel supports
            for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) mirror([0,j,0]) translate([wheel_sep/2, beam/2+wheel_eff_rad, 0]){
                cylinder(r=wheel_eff_rad, h=wall);
                %translate([0,0,-beam/2]) wheel();
            }
            
            
            
            //idlers
            %y_belt_mounts();
            for(i=[0,1]) mirror([i,0,0]) translate([idler_offset,0,0])
                idler_bump();
        }
        
        //magnet mount hole
        translate([0,0,wall-1]) cylinder(r1=magnet_rad+.1, r2=magnet_rad+.3, h=magnet_height+1);
        
        //wheel holes
        for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) mirror([0,j,0]) translate([wheel_sep/2, beam/2+wheel_eff_rad, 0]){
            wheel(solid=-1);
        }
        
        //slots for wheel flex
        for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) mirror([0,j,0]) translate([wheel_sep/2+wheel_eff_rad, beam/2+wheel_eff_rad/2, 0]){
            rotate([0,0,19]) cube([wheel_rad*4-3,1.5,wall*3], center=true);
        }
        
        //idler holes
        y_belt_mounts(solid = -1);
    }
}

//holds the beams together, routes belts
module beam_carriage(){
    wheel_sep = (pulley_rad*4+belt_thick*2+5)*2;
    center_wheel_sep = 59;
    
    difference(){
        union(){
            //wheel supports
            hull() for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) mirror([0,j,0]) translate([beam/2+wheel_eff_rad, wheel_sep/2, 0]){
                cylinder(r=.1, h=wall);
                %translate([0,0,-beam/2]) wheel();
            }
            
            //wheel plate
            for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) mirror([0,j,0]) translate([beam/2+wheel_eff_rad, wheel_sep/2, 0]){
                cylinder(r=wheel_eff_rad, h=wall);
                scale([1,1,(wall+6)/(wall+1)]) idler_bump();
                %translate([0,0,-beam/2]) wheel();
                
            }
            
            //attach to the rail
            for(i=[0,1]) mirror([i,0,0]) hull() {
                translate([center_wheel_sep/2, 0, 0]) cylinder(r=wheel_eff_rad, h=wall);
                for(j=[0,1]) mirror([0,j,0]) translate([-beam/2-wheel_eff_rad, wheel_sep/2, 0])
                cylinder(r=.1, h=wall);
            }
            
            //support the rail
            difference(){
                intersection(){
                    translate([0,0,wall]) cube([100,beam/2,2.5], center=true);
                    hull() for(i=[0,1]) mirror([i,0,0]) translate([center_wheel_sep/2, 0, 0])
                        cylinder(r=wheel_eff_rad, h=wall*3);
                }
                //cross beam
                translate([0,0,-x_beam_height+magnet_carriage_height+wall*2-carriage_clearance-.15]) rotate([0,90,0]) beam(length = cross_beam_length);
            }
        }
        
        //slots for wheel flex
        for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) mirror([0,j,0]) translate([beam/2+wheel_eff_rad/2-1, wheel_sep/2+wheel_eff_rad, 0]){
            rotate([0,0,180-19]) cube([2, wheel_rad*4-3,wall*3], center=true);
        }
        
        //idler holes
        y_belt_mounts(solid = -1);
    }
}