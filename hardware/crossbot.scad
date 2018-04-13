include <configuration.scad>

motor_screw_sep = 31;
motor_screw_rad = 1.7;
motor_screw_cap_rad = 6/2;
motor_screw_washer_rad = 9/2;
motor_screw_flange_rad = 5.5+1;
motor_w = motor_screw_flange_rad*2+motor_screw_sep;
echo(motor_w);
motor_flange_rad = 29/2;


m5_cap_rad = 11/2;

//a simple, lightweight gantry system using two beams.

part = 10;

$fn = 30;

if(part == -1)
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
        rotate([-116+3,0,0])
        base_beam_mount();
        translate([0,0,-100-19-1.5]) cube([200,200,200], center=true);
    }

if(part == 6)
    difference(){
        rotate([-116+3,0,0]) base_beam_mount(motor=true);
        translate([0,0,-100-19-1.5]) cube([200,200,200], center=true);
    }

//big beam idler end
if(part == 7)
    difference(){
        rotate([-90,0,0])
        base_beam_mount_2();
        //translate([0,0,-100-19-1.5]) cube([200,200,200], center=true);
    }

//big beam motor end
if(part == 8)
    difference(){
        rotate([-90,0,0])
        base_beam_mount_2(motor=true);
        //translate([0,0,-100-19-1.5]) cube([200,200,200], center=true);
    }

//cross beam idler end
if(part == 9){
    slider_end(motor = false);
}

//cross beam motor end
if(part == 10){
    slider_end(motor = true);
}

//three-wheel magnet carriage
if(part == 11){
    magnet_carriage_2();
}

if(part == 12){
    tension_roundel();
}

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

module base_beam_mount(motor = false){
    extra_height = 6;
    height = -beam/2-y_beam_height;
    echo("WALLS");
    echo(wall);
    
    length_beam = beam*2;
    length_table = beam*5;
    echo(height);
    difference(){
        union(){
            hull(){
                translate([0,10,-height/2+wall/2]) cube([beam,length_beam,wall], center=true);
                translate([0,0,height/2-wall/2+extra_height]) cube([length_table,beam,wall], center=true);
            }
        }
        
        //attach to extrusion
        if(motor == false) {
            translate([0,10,0]) for(i=[0,1]) mirror([0,i,0]) translate([0,length_beam/2-beam/2,-height/2-.1]){
                cylinder(r=m5_rad+.25, h=50);
                translate([0,0,wall]) cylinder(r=m5_cap_rad+.25, h=50);
            }
        }else{
            translate([0,10,0]) for(i=[1,-12]) translate([0,i,-height/2-.1]){
                cylinder(r=m5_rad+.25, h=50);
                translate([0,0,wall*2]) cylinder(r=m5_cap_rad+.25, h=50);
            }
            
            //remove the motor mount
            scale([1.02, 1.02, 1]) translate([0,-main_beam_length/2+beam-.1,beam/2+wall/2-height-wall*.5]) hull() motor_mount(idlers = false);
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

module tension_roundel(rad = wheel_eff_rad-1, thick=5, flange=0){
    difference(){
        union(){
            for(i=[0,1]) mirror([0,0,i]) translate([0,0,wall/2])
                cylinder(r1=rad, r2=rad+flange, h=flange);
            cylinder(r=rad, h=thick, center=true);
            translate([rad,0,0]) cube([rad,rad*1.5,thick+flange*2], center=true);
        }
        
        //belt grabber
        translate([rad+rad/6,2,0]) difference(){
            cube([2,rad*1.5,thick*2], center=true);
            for(i=[0:2:10]) translate([1,i-6,0]){
                cube([2,1,thick*3], center=true);
            }
        }
        
        //screwhole
        cylinder(r=m5_rad+.25, h=thick*3, center=true);
        
        //zip tie slot
        translate([rad*1.25,0,0]) scale([1,1,1.25]) rotate([90,0,0]) rotate_extrude(){
            translate([5,0,0]) square([2,4], center=true); 
        }
    }
}

module base_beam_mount_2(motor = false){
    extra_height = 6;
    height = -beam/2-y_beam_height;
    echo("WALLS");
    echo(wall);
    
    axle_drop = -y_beam_height-beam/2-3-beam;
    axle_offset = 13;
    
    length_beam = 11;
    length_table = beam*5;
    
    idler_thick = 10;
    
    motor_mount_thick = 7;
    
    echo(height);
    difference(){
        union(){
            hull(){
                translate([0,beam/2-length_beam/2,-height/2-beam-wall/2]) cube([beam,length_beam,beam], center=true);
                translate([0,0,height/2-wall/2+extra_height]) cube([length_table,beam,wall], center=true);
            }
            
            //motor/idler mount bracket
            hull(){
                if(motor == true){
                    translate([axle_offset,-motor_w/2,-axle_drop]) rotate([0,90,0]) motor(thick=motor_mount_thick);
                }else{
                    translate([axle_offset,-motor_w/2,-axle_drop]) rotate([0,90,0]) cylinder(r=m5_rad+wall*2, h=motor_mount_thick, center=true);
                }
                translate([axle_offset,0,0]) cube([motor_mount_thick,motor_mount_thick,motor_w], center=true);
            }
            //pulley bump
            if(motor == false){
                height = axle_offset-motor_mount_thick/2-2.5;
                translate([axle_offset-motor_mount_thick/2,-motor_w/2,-axle_drop]) rotate([0,90,0]) cylinder(r2=m5_rad+8, r1=m5_rad+2, h=height, center=true);
            }
        }
        
        //mounting holes for the motor or idler
        if(motor == true){
            translate([axle_offset,-motor_w/2,-axle_drop]) rotate([0,90,0]) motor(solid=false);
        }else{
            translate([axle_offset,-motor_w/2,-axle_drop]) rotate([0,90,0]) {
                cylinder(r=m5_rad+.25, h=50, center=true);
                cylinder(r1=m5_nut_rad, r2=m5_nut_rad+2.5, h=50, $fn=6);
            }
        }
        
        //attach to the beam
        translate([0,0,-height+beam/2]) for(i=[0:1]) mirror([0,0,i]) translate([0,0,beam/2]) rotate([90,0,0]) {
            cylinder(r=m5_rad+.25, h=50, center=true);
            translate([0,0,0]) cylinder(r=m5_cap_rad+.25, h=50);
            
            %cube([20,20,20], center=true);
        }
        
        //slots for the belts to pass through
        translate([0,0,-axle_drop]) rotate([0,90,0]) for(i=[0:1]) mirror([i,0,0]) translate([pulley_rad,0,0]) cube([4,100,11], center=true);
            
        //endstop hole
        translate([-beam/2-wheel_rad+3,0,-height+beam+5]) endstop_hole();

        //attach to table
        for(i=[0,1]) mirror([i,0,0]) translate([length_table/2-beam/2,0,height/2+.1]) mirror([0,0,1]) {
            cylinder(r=m5_rad+.25, h=100, center=true);
            translate([0,0,wall]) cylinder(r1=m5_cap_rad+.25, r2=m5_cap_rad+1.75, h=50);
        }
    }
}

module endstop_hole(){
    width=22;
    thick = 7;
    wire = 5;
    switch_height=8;
    
    rotate([-90,0,0]) difference(){
        union(){
            //endstop
            translate([0,0,wall]) cube([thick, width,switch_height+wall], center=true);
            //wire pass
            translate([-(thick-wire)/2,0,-.1]) cube([wire, width,switch_height+5], center=true);
        }
        
        //retainer bump
        for(i=[0,1]) mirror([0,i,0]) translate([thick*.9,width/4,switch_height*3/4]) scale([1.1,1,2]) sphere(r=wall/2);
    }
}

module motor(solid = true, thick=7){

    
    slot =2;
    
    extra = wall/2;
    
    if(solid == true){
        //translate([0,motor_w/2+pulley_flange_rad*2+1,extra/2])
        
        hull()
        for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) mirror([0,j,0]){
            translate([motor_w/2-motor_screw_cap_rad, motor_w/2-motor_screw_cap_rad, 0]) cylinder(r=motor_screw_cap_rad+wall/2, h=thick, center=true);
        }
    }else{
        //screwholes
         for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) mirror([0,j,0]) hull() for(k=[-slot/2, slot/2]){
            translate([motor_screw_sep/2+k, motor_screw_sep/2+k, 0]) cylinder(r=motor_screw_rad, h=thick*5, center=true); 
        }
        
        for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) mirror([0,j,0]) hull() for(k=[-slot/2, slot/2]){
            translate([motor_screw_sep/2+k, motor_screw_sep/2+k, -wall/4-100]) cylinder(r2=motor_screw_washer_rad, r1=motor_screw_washer_rad+2.5, h=100); 
        }
        
        //center hole
        cylinder(r=motor_flange_rad, h=thick*3, center=true);
        
        //the motor itself
        translate([0,0,thick*3-.1]) hull()
        for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) mirror([0,j,0]){
            translate([motor_w/2-motor_screw_cap_rad, motor_w/2-motor_screw_cap_rad, 0]) cylinder(r=motor_screw_cap_rad+wall/2, h=thick*5, center=true);
        }
    }
}

module motor_mount(idlers = true){
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
            if(idlers == true){
                for(i=[0,1]) mirror([i,0,0]) translate([pulley_rad,pulley_flange_rad+.5,0]){
                    idler_bump();
                }
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

module slider_end(motor = true){
    
    motor_screw_sep = 31;
    motor_screw_rad = 1.7;
    motor_screw_cap_rad = 6/2;
    motor_screw_flange_rad = 5.5+1;
    motor_w = motor_screw_flange_rad*2+motor_screw_sep;
    echo(motor_w);
    motor_flange_rad = 29/2;
    
    slot =2;
    
    extra = wall/2;
    
    beam_base = wall*2;
    beam_width = 51;
    beam_height = 27;
    
    motor_extend = motor_w/2+beam_base;
    
    difference(){
        union(){
            //main body
            hull(){
                translate([0,0,extra/2]) cube([beam+wall,beam*3,wall+extra], center=true);
            
                if(motor == true){
                    translate([0,motor_extend,extra/2])hull()
                    for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) mirror([0,j,0]){
                        translate([motor_w/2-motor_screw_cap_rad, motor_w/2-motor_screw_cap_rad, 0]) cylinder(r=motor_screw_cap_rad+wall/2, h=wall+extra, center=true);
                    }
                }else{
                    translate([0,motor_extend,extra/2])
                    cylinder(r=m5_rad+wall, h=wall+extra, center=true);
                }
                
                translate([0,beam_base/2,0]) cube([beam_width,beam_base,wall], center=true);
            }
            
            //idler bump
            if(motor == false){
                translate([0,motor_extend,wall])
                    cylinder(r1=m5_rad+wall/2, r2=m5_rad+1.5, h=3, center=true);
            }
            
            //vertical beam for mounting a level slider, and the endstop
            translate([0,beam_base/2,beam_base/2]) hull(){
                cube([beam_width,beam_base,beam_base], center=true);
                translate([0,0,beam_height - wall/2]) cylinder(r=beam_base/2, h=wall);
            }
        }
        
        //guide hole for top mount
        translate([0,beam_base/2,0]){
            cylinder(r=m5_rad+.25, h=200, center=true);
            
            translate([0,0,beam]) hull(){
                rotate([0,0,30]) cylinder(r1=m5_nut_rad+.5, r2=m5_nut_rad, h=wall*1.5, $fn=6);
                translate([0,wall,0]) rotate([0,0,30]) cylinder(r1=m5_nut_rad+.5, r2=m5_nut_rad, h=wall, $fn=6);
            }
        }
        
        //slots for the belts to pass through
        translate([0,0,extra+beam/2]) rotate([0,0,0]) for(i=[0:1]) mirror([i,0,0]) translate([pulley_rad,0,0]) cube([4,100,11], center=true);
            
        //endstop hole
        translate([-beam/2-wheel_rad+2,beam_base*.73,extra+beam/2+3]) mirror([0,1,0]) endstop_hole();
        
        
        //motor holes
        if(motor == true){
            translate([0,motor_extend,0]) {
                for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) mirror([0,j,0]) hull(){
                    translate([motor_screw_sep/2-slot/2, motor_screw_sep/2-slot/2, 0]) cylinder(r=motor_screw_rad, h=wall+1, center=true);
                    translate([motor_screw_sep/2+slot/2, motor_screw_sep/2+slot/2, 0]) cylinder(r=motor_screw_rad, h=wall+1, center=true);
                }
                hull() for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) mirror([0,j,0]){
                    translate([motor_w/2-motor_screw_cap_rad, motor_w/2-motor_screw_cap_rad, wall/2]) cylinder(r=motor_screw_cap_rad, h=wall+wall/2);
                }
                
                cylinder(r=motor_flange_rad, h=wall+1, center=true);
            }
        }else{
            translate([0,motor_extend,0]) cylinder(r=m5_rad+.25, h=wall*10, center=true);
        }
        
        //lock in the beam    
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

//holds the magnet on top of the beam, holds belts
module magnet_carriage_2(){
    wheel_sep = 43;
    difference(){
        union(){
            translate([0,0,wall/2]) cube([60,30,wall], center=true);
            
            //magnet mount
            translate([0,0,wall/2]) cylinder(r1=magnet_rad+wall*1.25, r2=magnet_rad+wall/2, h=magnet_height);
            
            //wheel supports
            for(i=[0,1]) mirror([i,0,0]) translate([wheel_sep/2, beam/2+wheel_eff_rad, 0]){
                cylinder(r=wheel_eff_rad, h=wall);
                %translate([0,0,-beam/2]) wheel();
            }
            translate([0, -beam/2-wheel_eff_rad, 0]){
                cylinder(r=wheel_eff_rad, h=wall);
                %translate([0,0,-beam/2]) wheel();
            }
            
            //idlers
            for(i=[0,1]) mirror([i,0,0]) translate([wheel_sep/2, -beam/2-m5_rad-1, 0]){
                cylinder(r=wheel_eff_rad, h=wall);
            }
        }
        
        //magnet mount hole
        translate([0,0,wall/2]) cylinder(r1=magnet_rad+.25, r2=magnet_rad+.5, h=magnet_height+1);
        
        //wheel holes
        for(i=[0,1]) mirror([i,0,0]) translate([wheel_sep/2, beam/2+wheel_eff_rad, 0]){
            wheel(solid=-1);
        }
        translate([0, -beam/2-wheel_eff_rad, 0]){
            wheel(solid=-1);
        }
        
        //slots for wheel flex
        for(i=[0,1]) mirror([i,0,0]) translate([wheel_sep/2+wheel_eff_rad, beam/2+wheel_eff_rad/2, 0]){
            rotate([0,0,19]) cube([wheel_rad*4-3,1.5,wall*3], center=true);
        }
        
        //idler holes
        for(i=[0,1]) mirror([i,0,0]) translate([wheel_sep/2, -beam/2-m5_rad-1, 0]){
            cylinder(r=m5_rad, h=wall*3, center=true);
        }
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