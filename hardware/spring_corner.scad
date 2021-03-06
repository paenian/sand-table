use <parametric_pulleys.scad>

in = 25.4;

motor_w = 42.3;
motor_rad = 26.25;
motor_screw_sep = 31;
motor_screw_rad = 3.33/2;
motor_screw_cap_rad = 3.33;
motor_center_rad = 13;

spring_inner_rad = 18/2;
spring_outer_rad = 22/2;
spring_height = 13;

spring_nut_rad = 15/2;
spring_nut_height = 7;
spring_screw_rad = 8.7/2;

idler_screw_rad = 5/2+.2;
idler_screw_cap_rad = 5;
idler_screw_nut_rad = 9/2+.2;
idler_lift = 3;
idler_inner_rad = idler_screw_rad+1.5;

/////These are guesses!
    idler_height = 12;
    idler_rad = 16/2;
    idler_flange_rad = 9.1;
    
belt_thick = 2;
belt_width = 6;

spring = 1;
weight = 2;

//corner_mount(motor=false, tensioner = weight);
//corner_mount(motor=false);
magnet_mount();
//drill_guide();
//spring_roller();
//belt_clamp();
//belt_roller();
//stacked_pulley();
//translate([32,0,0]) string_pulley();


wall = 4;

$fn=36;


//assembly();

//clear pipe to stick it in
pipe_id = 2.067*in/2;
pipe_od = 2.375*in/2;
*difference(){
    cylinder(r=pipe_od, h=50);
    translate([0,0,-.1]) cylinder(r=pipe_id, h=51);
}

module assembly(motor = true){
  corner_mount();  
}

//this is to make the belt into a pully - so we get more distance out of it.
module belt_roller(){
    pulley_rad = 13/2;
    pulley_thick = 6+.2;
    
    axle_rad = 4/2+.2;
    axle_cap_rad = 7.4/2+.2;
    axle_nut_rad = 7*sqrt(2)/2+.2;
    
    pulley_bump_thick=1;
    
    zip_rad = 5;
    
    translate([0,0,(pulley_thick+wall)/2])
    difference(){
        union(){
            //pulley mount
            intersection(){
                rotate([90,0,0]) cylinder(r=pulley_rad+wall, h=pulley_thick+wall*2+pulley_bump_thick*2, center=true);
                translate([wall*2,0,0]) rotate([90,0,0]) cylinder(r=pulley_rad+wall*1.5, h=pulley_thick+wall*2+pulley_bump_thick*2, center=true);
                
            }
            
            //ring for zip tieing to the spring
            translate([pulley_rad+wall+zip_rad/2,0,0])
            rotate([90,0,0]) rotate_extrude(){
                translate([zip_rad,0,0]) circle(r=zip_rad/2);
            }
        }
        
        rotate([90,0,0]){
            //pulley
            %cylinder(r=pulley_rad, h=pulley_thick, center=true);
            difference(){
                cylinder(r=pulley_rad+1, h=pulley_thick+pulley_bump_thick*2, center=true);
                for(i=[0,1]) mirror([0,0,i]) translate([0,0,pulley_thick/2+.05]) {
                    cylinder(r1=axle_rad+1, r2=axle_rad+3, h=pulley_bump_thick+.05);
                }
            }
            
            //axle
            cylinder(r=axle_rad+.1, h=pulley_thick*5, center=true);
            //recess the screwhead
            translate([0,0,(pulley_thick+wall*2+pulley_bump_thick*2)/2]) cylinder(r=axle_cap_rad, h=wall, center=true);
            //recess the nut
            translate([0,0,-(pulley_thick+wall*2+pulley_bump_thick*2)/2]) cylinder(r=axle_nut_rad, h=wall, center=true, $fn=4);
        }
        
        //cut off top and bottom
        for(i=[0,1]) mirror([0,0,i]) translate([0,0,pulley_thick+wall]) cube([100,100,pulley_thick+wall], center=true);
    }
}

module belt_clamp(){
    belt_thick = belt_thick - .25;
    length = 20;
    difference(){
        union(){
            //body
            cube([length,wall*2,wall+spring_height], center=true);
        }
        
        //belt clamp up top
        translate([0,0,spring_height/4+wall/2]) difference(){
            cube([length+1, belt_thick, spring_height/2+.1], center=true);
            for(i=[-length-1:2:length]) translate([i,belt_thick/2,0]) cube([1,belt_thick,spring_height/2+.3], center=true);
        }
        
        //spring right next to belt
        translate([0,-belt_thick/2,wall/2]) cube([length+1, .666, spring_height+.1], center=true);
        
        //zip tie through the spring & around the top
        translate([0,0,5+wall/2-.5]) scale([1,1.5,1]) rotate([0,90,0]) rotate_extrude(){
            translate([5,0,0]) square([2,4], center=true);
        }
    }
}

//Pulley for running string.
//default pulley rad is calculated to have a 20mm circumference.
//Uses two M3 square nuts to hold on.
module string_pulley(pulley_rad = 40/(2*3.14159)+.25, pulley_height = 3){
   
    m3_rad = 1.7;
    m3_nut_height = 2.5;
    m3_nut_flat = 6;
    m3_nut_rad = 6*sqrt(2)/2;
    m5_rad = 5/2+.2;
    
    base_height = m3_nut_flat+wall/2;
    base_rad = pulley_rad+wall;
    
    flange_height = 2;
    flange_rad=pulley_rad+flange_height;
    
    difference(){
        union(){
            //thick base
            cylinder(r=base_rad, h=base_height);
            
            //bottom flange
            translate([0,0,base_height-.1]) cylinder(r1=flange_rad, r2=pulley_rad, h=flange_height+.1);
            
            //pulley
            translate([0,0,base_height+flange_height-.1]) cylinder(r=pulley_rad, h=pulley_height+.1);
            
            //top flange
            translate([0,0,base_height+flange_height+pulley_height-.1]) cylinder(r2=flange_rad, r1=pulley_rad, h=flange_height+.1);
            
        }
        
        //axle
        cylinder(r=m5_rad, h=50, center=true);
        
        //secure with screws
        for(i=[0,90]) rotate([0,0,i]){
            //screw
            translate([base_rad/2,0,base_height/2]) rotate([0,90,0]) cylinder(r=m3_rad, h=base_rad+3, center=true);
            
            //nut
            hull(){
                translate([base_rad/2,0,base_height/2]) rotate([0,90,0]) rotate([0,0,180/4]) cylinder(r=m3_nut_rad, h=m3_nut_height, center=true, $fn=4);
                translate([base_rad/2,0,-base_height/2]) rotate([0,90,0]) rotate([0,0,180/4]) cylinder(r=m3_nut_rad+.25, h=m3_nut_height+.5, center=true, $fn=4);
            }
        }
    }
}

//the bottom is a 20 tooth pulley, the top is a roller to
//loosely hold the spring.  Main issue, the spring will
//put significant torque on the motor, so it should be
//as short as possible.
//
//Uses two M3 square nuts to hold on.
module stacked_pulley(num_teeth = 20){
    pulley_rad = spring_inner_rad+wall/2;
    tooth_height = 6;
    bottom_height = 8;
    
    echo(spring_inner_rad);
    echo(pulley_rad);
    
    m3_rad = 1.7;
    m3_nut_height = 2.5;
    m3_nut_flat = 6;
    m3_nut_rad = 6*sqrt(2)/2;
    m5_rad = 5/2+.2;
    
    base_height = m3_nut_flat-.1;
    
    
    
    difference(){
        union(){
            //pulley on the bottom
            pulley ( "GT2 2mm" , tooth_spacing (2,0.254) , 0.764 , 1.494, base_diameter=pulley_rad*2, base_height=bottom_height, toothed_part_length=tooth_height, belt_retainer=1, retainer_height=2);
            
            //angle up to the pulley rad
            translate([0,0,tooth_height+bottom_height]){
                //chamfer
                cylinder(r1=6, r2=pulley_rad, h=wall-1);
                translate([0,0,wall-1.05]) cylinder(r1=pulley_rad, r2=spring_inner_rad, h=1.1);
                translate([0,0,wall]) cylinder(r=spring_inner_rad, h=spring_height+wall*1.5);
                translate([0,0,spring_height+wall*2]) cylinder(r2=pulley_rad, r1=spring_inner_rad, h=wall*.5);
            }
        }
    }
}

//basically the same as the stacked pulley, but with two
//bearings in the top/bottom.
module stacked_idler(){
    
}

module spring_roller(roller_height=20){
    roller_rad = spring_inner_rad+wall-2;
    
    spring_inner_rad = spring_inner_rad-.25;    //add a little extra slop
    difference(){
        union(){
            cylinder(r=roller_rad, h=roller_height);
        }
        
        translate([0,0,roller_height/2]) difference(){
            
            %cylinder(r=20, h=spring_height, center=true);
            
            rotate_extrude(){
                translate([spring_inner_rad+wall/2+.1,0,0]) square([wall+.2, spring_height+wall*2], center=true);
            }
            
            //chamfer top and bottom
            for(i=[0,1]) mirror([0,0,i]) translate([0,0,-(spring_height+wall*2)/2-.1]) cylinder(r1=spring_inner_rad+wall, r2=spring_inner_rad, h=wall+.1);
        }
        
        translate([0,0,-.1]) cylinder(r=spring_screw_rad+.2, h=roller_height+.2);
    }
}

module magnet_mount(){
    magnet_len = in*.5+.5;
    magnet_rad = (1/2*in)/2 + .2;
    
    
    
    belt_thick = 2;
    belt_width = 6.5;
    
    belt_offset = 13;
    base_offset = 23;
    belt_lift = 10; //this is specifically to lift the belt up, to counteract gravity pulling the carriage down.  Not sure it's worth the effort, though.
    
    
    //neopixel 16x ring
    led_outer_rad = 31/2;
    led_inner_rad = 29/2;
    led_height = 5;
    
    //cylinder(r=led_rad, h=50);
    
    base_thick=led_height+wall/2;
    
    
    difference(){
        union(){
            //base()
            for(j=[0,90]) rotate([0,0,j]) hull() for(i=[0,1]) mirror([i,0,0]) translate([base_offset,0,0]) scale([.5,1,1]) {
               
                cylinder(r1=magnet_rad+wall*1.5, r2=magnet_rad+wall*2, h=base_thick/3);
                translate([0,0,base_thick/3-.01]) cylinder(r=magnet_rad+wall*2, h=base_thick/3+.01);
                translate([0,0,base_thick*2/3-.01]) cylinder(r1=magnet_rad+wall*2, r2=magnet_rad+wall*1.5, h=base_thick/3+.01);
            }
        
            //magnet
            cylinder(r1=magnet_rad+wall, r2=magnet_rad+wall/2, h=magnet_len+wall);
            
            //belt holder
            for(i=[0,1]) mirror([i,0,0]) translate([belt_offset,0,0]) scale([.5,1,1]) cylinder(r=magnet_rad+wall, h=wall+belt_width+belt_lift);
                
            //brace the belt holder
            hull() for(i=[0,1]) mirror([i,0,0]) translate([belt_offset,0,0]) scale([.5,1,1]) cylinder(r=magnet_rad+wall, h=wall*3);
        }
        
        //magnet
        translate([0,0,-.1]) cylinder(r1=magnet_rad+1, r2=magnet_rad, h=1);
        translate([0,0,-.1]) cylinder(r1=magnet_rad+.2, r2=magnet_rad, h=magnet_len+.5);
        translate([0,0,magnet_len]) cube([magnet_rad*2+wall*1.25,magnet_rad,wall*2+.1], center=true);
        
        //belt cutout
        for(i=[0,1]) mirror([i,0,0]) translate([belt_offset,0,wall]) scale([.5,1,1]) union(){
            //horizontal
            difference(){
                //horizontal
                rotate_extrude(){
                    translate([magnet_rad+wall-belt_thick+.1,0,0]) square([belt_thick,belt_width*2+belt_lift]);
                }
                translate([0,0,-.1]) cylinder(r1=magnet_rad+wall*2, r2=magnet_rad, h=belt_lift+wall);
            }
            
            //zip tie slot
            translate([0,0,belt_lift+2.5]) rotate([90,0,0]) scale([3,1,1]) rotate_extrude(){
                translate([(belt_width+wall)/2,0,0]) square([2,4], center=true);
            }
        }
        
        //led ring underneath
        translate([0,0,-.1]) difference(){
            cylinder(r=led_outer_rad, h=led_height);
            cylinder(r=led_inner_rad, h=led_height*3, center=true);
        }
    }
}
module motor_mount(solid=1, screw_seat=1){
    
    //%cube([motor_w, motor_w, .1], center=true);
    
    motor_wall = (motor_w-motor_screw_sep)/2;
    
    if(solid == 1){
        //body
        intersection(){
            hull() for(i=[0:1]) for(j=[0:1]) mirror([i,0,0]) mirror([0,j,0])
                translate([motor_screw_sep/2,motor_screw_sep/2,0]) cylinder(r=motor_wall, h=wall);
            cylinder(r=motor_rad, h=wall);
        }
        
        //raised area for screws
        for(i=[0:1]) for(j=[0:1]) mirror([i,0,0]) mirror([0,j,0])
                translate([motor_screw_sep/2,motor_screw_sep/2,0]) cylinder(r=motor_screw_cap_rad, h=wall+screw_seat);
    }else{
        //center hole
        translate([0,0,-.1]) cylinder(r=motor_center_rad, h=wall+.2);
        
        //screw holes
        for(i=[0:1]) for(j=[0:1]) mirror([i,0,0]) mirror([0,j,0]){
            translate([motor_screw_sep/2,motor_screw_sep/2,-.1]) cylinder(r=motor_screw_rad, h=wall+screw_seat+.2);
            translate([motor_screw_sep/2,motor_screw_sep/2,wall+screw_seat]) cylinder(r=motor_screw_cap_rad, h=wall+screw_seat+.2);
        }
    }
}

module drill_guide(){
    difference(){
        union(){
            hull(){
                motor_mount();
                for(i=[0,90]) rotate([0,0,i]) translate([0,-motor_w/2-wall/2-.1,wall/2]) cube([motor_w, wall, wall], center=true);
            }
            
            for(i=[0,90]) rotate([0,0,i]) translate([0,-motor_w/2-wall/2-.1,wall]) cube([motor_w-1, wall, wall*2], center=true);
        }
        difference(){
            scale([1,1,2]) motor_mount(solid=-1);
            for(i=[0:120:359]) rotate([0,0,i]) translate([motor_center_rad/2, 0, 0]) cube([motor_center_rad*1.1, wall*2, wall*3], center=true);
        }
        
        cylinder(r=idler_screw_rad, h=wall*3, center=true);
    }
}

module weighted_tensioner(solid=1){
    if(solid==1){
        for(i=[0:1]) mirror([0,i,0]) translate([0,idler_height/2,idler_flange_rad+.5]){
            hull(){
                rotate([-90,0,0]) cylinder(r=idler_rad, h=wall);
                translate([0,wall/2,-idler_rad/2]) cube([idler_rad*2,wall,wall], center=true);
            }
            hull(){
                translate([0,wall/2,-idler_rad+wall/2]) cube([idler_rad*2,wall,wall], center=true);
                translate([0,wall,-idler_rad]) cube([idler_rad*2,wall+3,.1], center=true);
            }
        }
    }
    
    if(solid<=0){
        //axle cutout
        translate([0,0,idler_flange_rad+.5]) rotate([-90,0,0]) cylinder(r=idler_screw_rad, h=idler_height*3, center=true);
        mirror([0,1,0]) translate([0,idler_height/2+wall-1,idler_flange_rad+.5]) rotate([-90,0,0]) cylinder(r1=idler_screw_cap_rad, r2=idler_screw_cap_rad+1, h=wall);
        translate([0,idler_height/2+wall-1,idler_flange_rad+.5]) rotate([-90,0,0]) rotate([0,0,30]) cylinder(r1=idler_screw_nut_rad, r2=idler_screw_nut_rad+1, h=wall, $fn=6);
        
        //pulley cutout
        hull(){
            translate([0,0,idler_flange_rad+.5]) rotate([-90,0,0]) cylinder(r=idler_flange_rad+.6, h=idler_height, center=true);
            translate([10,0,idler_flange_rad+.5]) rotate([-90,0,0]) cylinder(r=idler_flange_rad+.6, h=idler_height, center=true);
        }
    }
}

//modified motor mount - one corner is a belt guide
module corner_mount(motor=true, belt_guide=false, belt_retainer=true, tensioner = spring){
    screw_seat = 1;
    
    pulley_rad = 12/2;
    pulley_height = 18;
    pulley_base_height = 7.5;
    %cylinder(r=pulley_rad, h=pulley_height);
    %cylinder(r=pulley_rad+wall/2, h=pulley_base_height);
    
    //for the spring tensioner
    spring_offset = 29;
    spring_offset_y = motor_w/2-spring_outer_rad-wall/2;
    
    //for the weight tensioner
    weight_offset = 23;
    weight_y_offset = pulley_rad/2;
    
    belt_guide_offset = motor_screw_sep/(sqrt(2));

    
    difference(){
        union(){
            //baseplate
            hull(){
                motor_mount(solid=1, screw_seat=0);
                
                if(tensioner == spring){
                    //base for the spring mount
                    translate([spring_offset,spring_offset_y,0]) cylinder(r=spring_outer_rad+wall/2, h=wall);
                }
                
                //weighted tensioner base
                if(tensioner == weight){
                    linear_extrude(height=wall)
                    projection(cut=false){
                        translate([weight_offset,weight_y_offset,0]) weighted_tensioner();
                    }
                }
            }
            
            if(belt_guide == true){
                hull(){
                    motor_mount(solid=1, screw_seat=0);
                
                    //base for the belt guide
                    rotate([0,0,-45]) translate([belt_guide_offset,0,0]) cylinder(r=belt_thick+wall, h=wall);
                }
            }
            
            motor_mount(solid=1, screw_seat=screw_seat);
            
            //belt guide
            if(belt_guide == true){
                rotate([0,0,-45]) translate([belt_guide_offset,0,wall-.1]) cylinder(r=belt_thick+wall, h=belt_width+wall+.1);
                rotate([0,0,-45]) translate([belt_guide_offset,0,wall+belt_width+wall]) sphere(r=belt_thick+wall);
            }
            
            //idler mount lift
            if(motor == false){
                translate([0,0,wall-.1]) cylinder(r1=idler_inner_rad+wall, r2=idler_inner_rad, h=idler_lift+.1);
            }
            
            //spring mount peg
            if(tensioner == spring){
                translate([spring_offset,spring_offset_y,wall-.1]) cylinder(r1=spring_outer_rad+wall/2, r2=spring_outer_rad, h=spring_nut_height-wall/2);
            }
            
            //weighted tensioner
            if(tensioner == weight){
                translate([weight_offset,weight_y_offset,0]) weighted_tensioner();
                
                //belt attach on the other side
                translate([-motor_screw_sep/2,weight_y_offset,0]) difference(){
                    hull(){
                        #translate([0,0,wall]) rotate([90,0,0]) cylinder(r=belt_thick+1, h=belt_width+wall*3, center=true);
                        translate([0,0,wall+belt_thick*3]) rotate([90,0,0]) cylinder(r=belt_thick, h=belt_width+wall*2, center=true);
                    }
                    translate([0,0,wall+belt_thick]) cube([10,belt_width+1,belt_thick*2], center=true);
                }
            }
        }
        
        //motor holes
        if(motor == true){
            motor_mount(solid=0, screw_seat=screw_seat);
        }else{
            motor_mount(solid=0, screw_seat=screw_seat, motor_center_rad = idler_screw_rad);
            translate([0,0,-.1]) cylinder(r=idler_screw_rad, h=wall*4);
        }
        
        //belt hole
        if(belt_guide == true){
            rotate([0,0,-45]) translate([belt_guide_offset,0,wall+(belt_width+wall)/2]) cube([(belt_thick+wall+.1)*2,belt_thick+.5,belt_width+wall/2], center=true);
        }
        
        //spring holes
        if(tensioner == spring){
            translate([spring_offset,spring_offset_y,-.2]) cylinder(r1=spring_nut_rad+.125, r2=spring_nut_rad, h=spring_nut_height, $fn=6);
            translate([spring_offset,spring_offset_y,spring_nut_height]) cylinder(r=spring_screw_rad, h=wall*2);
        }
        
        //weighted tensioner
        if(tensioner == weight){
            translate([weight_offset,weight_y_offset,0]) weighted_tensioner(solid = -1);
        }
    }
}

module corner_mount_spring(){
}

module corner_mount_weight(){
}
