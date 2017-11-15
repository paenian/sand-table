in = 25.4;

motor_w = 42;
motor_h = 30;
motor_rad = 50/2;
motor_bump_rad = 10;
motor_bump_height = 2;
motor_shaft_rad = 5/2;
motor_shaft_len = 22;
motor_screw_sep = 31;
motor_screw_rad = 3.3/2;
motor_screw_len = 10;

pulley_inner_rad = 13;
pulley_outer_rad = 17;
pulley_height = 19;
pulley_base_height = 7;
pulley_nut_rad = 7;
pulley_nut_thick = 3;

hairpin_base_width = 40;
hairpin_base_height = 100;
hairpin_base_thick = 3;
hairpin_leg_rad = 3/8*in/2;
hairpin_leg_offset = hairpin_base_width/2;

wall = 4;
motor_offset = 20;
leg_lift = 25;

%motor();
%translate([-motor_offset,-motor_offset,leg_lift]) hairpin_leg();


gravity_leg();


module gravity_leg(){
    difference(){
        union(){
            //baseplate - everything mounts here
            translate([0,0,wall/2]) motor_body(motor_h=wall);
            
            //use the rear screwhole to mount a thread locker
            //make a pulley with a spring center in TPU
            //have to alter the size of the main pulley, probably... or just 
            
            //mount the weight pulley and attachment 
        }
        
        //attach the motor
        motor_holes();
    }
}

module hairpin_leg_holes(){
}

module hairpin_leg(length = in*21){
    difference(){
        union(){
            //base
            for(i=[180,90]) rotate([0,0,i]) translate([0,-hairpin_base_height/2+hairpin_base_width/2,-hairpin_base_thick/2])
                cube([hairpin_base_width,hairpin_base_height,hairpin_base_thick], center=true);
            
            //leg
            for(i=[0,1])  
                hull(){
                    rotate([0,0,i*90+90]) translate([-hairpin_base_width/2+hairpin_leg_rad*1.5+(hairpin_base_width-hairpin_leg_rad*1.5*2)*i,-hairpin_base_height/2+hairpin_base_width/2,-hairpin_base_thick/2])
                        cylinder(r=hairpin_leg_rad, h=hairpin_base_thick, center=true);
                    translate([-hairpin_leg_offset,-hairpin_leg_offset,-length]) cylinder(r=hairpin_leg_rad, h=hairpin_base_thick);
                }
        }
        
        hairpin_leg_holes();
    }
}

module motor_holes(screws=true, shaft=true, bump=true){
    if(screws == true){
        for(i=[0,1]) for(j=[0,1]) mirror([0,i,0]) mirror([j,0,0]) translate([motor_screw_sep/2, motor_screw_sep/2,0]) {
            cylinder(r=motor_screw_rad, h=motor_screw_len*2, center=true);
        }
    }
    
    if(shaft == true){
        cylinder(r=motor_shaft_rad, h=(motor_shaft_len+motor_bump_height)*2, center=true);
    }
    
    if(bump == true){
        cylinder(r=motor_bump_rad, h=motor_bump_height*2, center=true);
    }
}

module motor_body(){
    intersection(){
        cube([motor_w, motor_w, motor_h], center=true);
        cylinder(r=motor_rad, h=motor_h, center=true);
    }
}

module motor(pulley=true){
    translate([0,0,-motor_h/2])
    difference(){
        union(){
            //body
            motor_body();
            
            //center bump
            translate([0,0,motor_h/2-.1]) cylinder(r=motor_bump_rad, h=motor_bump_height+.1);
            
            //shaft
            translate([0,0,motor_h/2-.1]) cylinder(r=motor_shaft_rad, h=motor_shaft_len+motor_bump_height+.1);
            
            //pulley on top
            if(pulley == true){
                translate([0,0,motor_h/2+motor_bump_height+1]) string_pulley();
            }
        }
        
        //holes
        translate([0,0,motor_h/2-.1]) motor_holes(screws=true, shaft=false, bump=false);
    }
}

//Pulley for running string.
//default pulley rad is calculated to have a 20mm circumference.
//Uses two M3 square nuts to hold on.
module string_pulley(pulley_rad = 40/(2*3.14159)+.25, pulley_height = 3, wall=3){
   
    m3_rad = 1.7;
    m3_nut_height = 2.5;
    m3_nut_flat = 6;
    m3_nut_rad = 6*sqrt(2)/2;
    m5_rad = 5/2+.2;
    
    base_height = m3_nut_flat+3;
    base_rad = 22/2-1;
    
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
            
            //little cap top, make it less pointy
            translate([0,0,base_height+flange_height+pulley_height+flange_height-.1]) cylinder(r1=flange_rad, r2=flange_rad-1, h=1.1);
            
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