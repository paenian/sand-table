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
idler_lift = 3;
idler_inner_rad = idler_screw_rad+1.5;
    
    
belt_thick = 2;
belt_width = 6;

//corner_mount(motor=true);
//corner_mount(motor=false);
//magnet_mount();
//drill_guide();
//spring_roller();
belt_clamp();

wall = 4;

$fn=36;

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
        translate([0,-belt_thick/2,wall/2]) cube([length+1, .75, spring_height+.1], center=true);
        
        //zip tie through the spring & around the top
        translate([0,0,6-1.5]) rotate([0,90,0]) rotate_extrude(){
            translate([6,0,0]) square([2,4], center=true);
        }
    }
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
    magnet_len = in*.5;
    magnet_rad = (5/16*in)/2 + .2;
    
    
    
    belt_thick = 2;
    belt_width = 6.5;
    
    belt_offset = 11;
    base_offset = 19;
    belt_lift = 10; //this is specifically to lift the belt up, to counteract gravity pulling the carriage down.  Not sure it's worth the effort, though.
    
    
    //neopixel 16x ring
    led_rad = 32/2;
    led_thick = 7;
    led_width = (44.5-31.7)/2+.25;
    
    //cylinder(r=led_rad, h=50);
    
    //led ring?
    %translate([0,0,wall]) 
    rotate_extrude(){
        translate([led_rad,0,0]) square([led_width,led_thick]);
    }
    
    
    difference(){
        union(){
            //base()
            for(j=[0,90]) rotate([0,0,j]) hull() for(i=[0,1]) mirror([i,0,0]) translate([base_offset,0,0]) scale([.5,1,1]) {
               
                cylinder(r1=magnet_rad+wall*1.5, r2=magnet_rad+wall*2, h=wall/3);
                translate([0,0,wall/3-.01]) cylinder(r=magnet_rad+wall*2, h=wall/3+.01);
                translate([0,0,wall*2/3-.01]) cylinder(r1=magnet_rad+wall*2, r2=magnet_rad+wall*1.5, h=wall/3+.01);
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
        translate([0,0,-.1]) cylinder(r1=magnet_rad+.2, r2=magnet_rad, h=magnet_len+.2);
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
            translate([0,0,belt_lift]) rotate([90,0,0]) rotate_extrude(){
                translate([magnet_len/2+1.5,0,0]) square([2,4], center=true);
            }
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
        for(i=[0:1]) for(j=[0:1]) mirror([i,0,0]) mirror([0,j,0])
                translate([motor_screw_sep/2,motor_screw_sep/2,-.1]) cylinder(r=motor_screw_rad, h=wall+screw_seat+.2);
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

//modified motor mount - one corner is a belt guide
module corner_mount(motor=true){
    screw_seat = 1;
    spring_offset = motor_w;

    
    belt_guide_offset = motor_screw_sep/(sqrt(2));
    
    difference(){
        union(){
            //base
            hull(){
                motor_mount(solid=1, screw_seat=0);
                
                //base for the spring mount
                translate([spring_offset,0,0]) cylinder(r=spring_outer_rad+wall, h=wall);
            }
            hull(){
                motor_mount(solid=1, screw_seat=0);
                
                //base for the belt guide
                rotate([0,0,-45]) translate([belt_guide_offset,0,0]) cylinder(r=belt_thick+wall, h=wall);
            }
            motor_mount(solid=1, screw_seat=screw_seat);
            
            //belt guide
            rotate([0,0,-45]) translate([belt_guide_offset,0,wall-.1]) cylinder(r=belt_thick+wall, h=belt_width+wall+.1);
            rotate([0,0,-45]) translate([belt_guide_offset,0,wall+belt_width+wall]) sphere(r=belt_thick+wall);
            
            //idler mount lift
            if(motor == false){
                translate([0,0,wall-.1]) cylinder(r1=idler_inner_rad+wall, r2=idler_inner_rad, h=idler_lift+.1);
            }
            
            //spring mount peg
            translate([spring_offset,0,wall-.1]) cylinder(r1=spring_outer_rad+wall, r2=spring_outer_rad, h=spring_nut_height+.1);
        }
        
        //motor holes
        if(motor == true){
            motor_mount(solid=0, screw_seat=screw_seat);
        }else{
            motor_mount(solid=0, screw_seat=screw_seat, motor_center_rad = idler_screw_rad);
            translate([0,0,-.1]) cylinder(r=idler_screw_rad, h=wall*4);
        }
        
        //belt hole
        rotate([0,0,-45]) translate([belt_guide_offset,0,wall+(belt_width+wall)/2]) cube([(belt_thick+wall+.1)*2,belt_thick+.5,belt_width+wall/2], center=true);
        
        //spring holes
        translate([spring_offset,0,-.2]) cylinder(r1=spring_nut_rad+.125, r2=spring_nut_rad, h=spring_nut_height, $fn=6);
        translate([spring_offset,0,spring_nut_height]) cylinder(r=spring_screw_rad, h=wall*2);
    }
}

module corner_mount_spring(){
}

module corner_mount_weight(){
}