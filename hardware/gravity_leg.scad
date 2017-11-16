in = 25.4;

fs = .3;

$fa = 3;    //sets the angle low enough that $fs is dominant
$fs = fs;    //the smallest edge is this long - with a .4mm nozzle, the facets should be undetectable for printing, but we keep it high for modeling faster.

motor_w = 42;
motor_h = 30;
motor_rad = 50/2;
motor_bump_rad = 22/2+.25;
motor_bump_height = 2;
motor_shaft_rad = 4/2+.25;
motor_shaft_len = 22;
motor_screw_sep = 31;
motor_screw_rad = 3.3/2;
motor_screw_cap_rad = 8/2;
motor_screw_len = 10;

pulley_inner_rad = 13;
pulley_outer_rad = 17;
pulley_height = 19;
pulley_base_height = 7;
pulley_base_rad = 11-.25;
pulley_nut_rad = 7;
pulley_nut_thick = 3;

hairpin_base_width = 50;
hairpin_base_height = 127;
hairpin_base_thick = 3;
hairpin_leg_rad = 3/8*in/2;
hairpin_x_offset = 88;
hairpin_y_offset = 18;
hairpin_leg_extend = hairpin_base_width;
hairpin_hole_inset = 9;
hairpin_hole_1 = in*1.75;
hairpin_hole_2 = hairpin_base_height-hairpin_hole_inset;
hairpin_hole_rad = 5/2;
hairpin_hole_cap_rad = 11/2;

v_pulley_thick = 6;
v_pulley_rad = 9/2;
v_pulley_center_rad = 7/2;
v_pulley_flange_rad = 13/2;
v_pulley_edge_thick = 1;

screw_rad = 4/2+.25;
screw_cap_rad = 8/2+.25;
screw_len = 16;
nut_rad = 10/2;
nut_height = 3.25;

spacer_len = 5;
spacer_rad = 6/2+.25;
spacer_wall = 1.125;

string_height = pulley_base_height+(pulley_height-pulley_base_height)/2+1+motor_bump_height/2;


wall = 4;
motor_offset = -hairpin_base_width/2+hairpin_hole_1;
leg_lift = 25;

%motor();
%translate([-motor_offset,-motor_offset,leg_lift+hairpin_base_thick]) hairpin_leg();


*gravity_leg();
*gravity_leg(motor=false);
*string_pulley();
weight_claw(pulley=true);

module weight_claw(h=14, angle = 30, pulley=true){
    weight_rad = in*2/2+.25;
    belt_rad = 11;
    
    difference(){
        union(){
            rotate_extrude(){
                translate([weight_rad,0,0]) circle(r=belt_rad);
            }
            
            if(pulley == true){
                hull(){
                    translate([-weight_rad-belt_rad*0,0,0]) rotate([90,0,0]) cylinder(r=belt_rad, h=screw_len, center=true);
                    translate([-weight_rad-belt_rad*1,0,0]) scale([1,1,1.4]) rotate([90,0,0]) cylinder(r=v_pulley_rad+1, h=screw_len, center=true);
                }
            }
        }
        
        
        sphere(r=weight_rad);
        
        //cut out a chunk
        difference(){
            for(i=[angle/2,-angle/2]) rotate([0,0,i-45]) translate([0,0,-50]) cube([100,100,100]);
            
            for(i=[angle/2,-90-angle/2]) rotate([0,0,i-45+90]) translate([weight_rad,0,0]) sphere(r=belt_rad);
        }
        
        //add the pulley
        if(pulley == true){
            translate([-weight_rad-belt_rad*1,0,0]) rotate([90,0,0]) {
                screw_pack(extend = 11);
                v_pulley(solid=-1);
                %v_pulley(solid=1);
                
            }
        }
        
        //flatten top/bottom
        for(i=[0,1]) mirror([0,0,i]) translate([0,0,100+h/2]) cube([200,200,200], center=true);
    }
}

module gravity_leg(height = leg_lift, motor=true, leg=true){
    difference(){
        union(){
            //baseplate - everything mounts here
            translate([0,0,wall/2+2]) motor_body(motor_h=wall+4, motor_bump_height = wall*5, bump=motor);
            
            if(motor == false){
                //add a bump for the pulley to sit on
                cylinder(r1=v_pulley_center_rad+wall, r2=v_pulley_center_rad, h=string_height-v_pulley_thick/2);
            }
            
            //mount it to the leg
            if(leg == true){
                leg_mount(solid=1, h=height, offset = hairpin_hole_1-hairpin_hole_inset);
            }else{
                //todo: spring mount
            }
            
            //mount the weight pulley and attachment
            weight_mount();
            
            //guide for the string - zip tie in a spacer
            guide_spacer(solid=1);
        }
        
        //attach the motor
        motor_holes(motor_h=wall, motor_bump_height = wall*5, bump=motor, shaft=motor);
        
        if(motor == false){
            //mount the pulley
            translate([0,0,8]){
                translate([0,0,-v_pulley_thick+nut_height+.2]) cylinder(r=screw_rad, h=screw_len);
                hull(){
                    translate([0,0,-v_pulley_thick]) cylinder(r1=nut_rad+.25, r2=nut_rad, h=nut_height, $fn=4);
                    translate([0,0,-v_pulley_thick-8]) cylinder(r1=nut_rad+1, r2=nut_rad+.25, h=8.1, $fn=4);
                }
            }
        }
        
        //mount the weight pulley and attachment
        weight_mount(solid=-1);
        
        //screwholes for the leg mount
        leg_mount(solid=0, h=height, offset = hairpin_hole_1-hairpin_hole_inset);
        
        //guide for the string - zip tie in a spacer
        guide_spacer(solid=0);
    }
}

module weight_mount(solid=1){
    off = motor_screw_sep/2+6;
    
    
    for(i=[0,1]) rotate([0,0,45]) mirror([0,i,0]) rotate([0,0,-45]) if(solid==1){
        union(){
            hull(){
                translate([off-5,-off+5,0]) cylinder(r=10, h=wall+1);
                translate([off,-off,string_height-v_pulley_rad]) rotate([0,0,45]) rotate([0,90,0]) 
                    cylinder(r=6, h=screw_len, center=true);
            }
        }
    }else{
        translate([off,-off,string_height-v_pulley_rad]) rotate([0,0,45]) rotate([0,90,0]) {
            screw_pack(extend_nut=true);
            v_pulley(solid=-1);
            %v_pulley(solid=1);
        }
    }
}

module v_pulley(solid=-1, edge=1){
    if(solid == 1){
        for(i=[0,1]) mirror([0,0,i]) {
            cylinder(r1=v_pulley_rad, r2=v_pulley_flange_rad, h=v_pulley_thick/2-v_pulley_edge_thick);
            translate([0,0,v_pulley_thick/2-v_pulley_edge_thick]) cylinder(r=v_pulley_flange_rad, h=v_pulley_edge_thick);
        }
    }else{
        difference(){
            cylinder(r=v_pulley_flange_rad+1, h=v_pulley_thick+edge*2.1, center=true);
            for(i=[0,1]) mirror([0,0,i]) translate([0,0,-v_pulley_thick/2-edge*1.1])
                cylinder(r1=v_pulley_center_rad+2, r2=v_pulley_center_rad, h=edge);
        }
    }
    
    
}

module screw_pack(extend = 0, extend_nut=false){
    screw_cap_len = 4;
    cylinder(r=screw_rad, h=screw_len+screw_cap_len, center=true);
    translate([0,0,screw_len/2+extend/2]) cylinder(r=screw_cap_rad, h=screw_cap_len+extend, center=true);
    hull(){
        translate([0,0,-screw_len/2-extend/2]) cylinder(r1=nut_rad+.125, r2=nut_rad, h=screw_cap_len+extend, center=true, $fn=4);
        if(extend_nut == true){
            translate([-5,-5,-screw_len/2-extend/2]) cylinder(r1=nut_rad+.125, r2=nut_rad, h=screw_cap_len+extend, center=true, $fn=4);
        }
    }
}

module guide_spacer(solid=1){
    h = string_height;
    off = motor_screw_sep/2+5;
    translate([off, off, 0])
    if(solid == 1){
        hull(){
            cylinder(r1=spacer_len+2, r2=spacer_len, h=h);
        }
    }else{
        //spacer
        translate([0,0,h]) rotate([0,0,45]) rotate([0,90,0]) {
            cylinder(r=spacer_rad, h=spacer_len+.5, center=true);
            cylinder(r=spacer_rad-spacer_wall, h=spacer_len*3, center=true);
        }
        
        //zip tie it in
        translate([0,0,h]) rotate([0,0,45]) rotate([0,90,0]) rotate_extrude(){
            translate([7,0,0]) square([2,4], center=true);
        }
    }
}

module leg_mount(solid=1, h=10, offset = hairpin_hole_1-hairpin_hole_inset, wall=7){
    
    base_inset = 5;
    
    for(i=[0,1]) rotate([0,0,45]) mirror([0,i,0]) rotate([0,0,-45]) translate([-offset,0,0]){
        if(solid == 1){
            hull(){
                translate([base_inset, base_inset,0]) cylinder(r=hairpin_hole_cap_rad+wall, h=wall);
                translate([0, 0, h-wall]) cylinder(r=hairpin_hole_inset-.25,h=wall);
            }
        }else{
            translate([0,0,-.1]) {
                cylinder(r=hairpin_hole_rad+.5, h=h+1);
                *cylinder(r=hairpin_hole_cap_rad+.5, h=2+.1);
            }
        }
    }
    
    //connect up the bases
    if(solid ==1)
        hull() for(i=[0,1]) rotate([0,0,45]) mirror([0,i,0]) rotate([0,0,-45]) translate([-offset,0,0]){
            translate([base_inset, base_inset,0]) intersection(){
                sphere(r=hairpin_hole_cap_rad+wall);
                translate([0,0,15]) cube([30,30,30], center=true);
            }
        }
}

module hairpin_leg_holes(){
    for(i=[0,1]) rotate([0,0,45]) mirror([0,i,0]) rotate([0,0,-45]){
        translate([-hairpin_base_width/2+hairpin_hole_inset, -hairpin_base_width/2+hairpin_hole_1, 0]) cylinder(r=hairpin_hole_rad, h=20, center=true);
        translate([-hairpin_base_width/2+hairpin_hole_inset, -hairpin_base_width/2+hairpin_hole_2, 0]) cylinder(r=hairpin_hole_rad, h=20, center=true);
    }
}

module hairpin_leg(length = in*21){
    difference(){
        union(){
            //base
            for(i=[180,90]) rotate([0,0,i]) translate([0,-hairpin_base_height/2+hairpin_base_width/2,-hairpin_base_thick/2])
                cube([hairpin_base_width,hairpin_base_height,hairpin_base_thick], center=true);
            
            //leg
            for(i=[-1,1])  
                hull(){
                    rotate([0,0,i*45+135]) translate([(hairpin_base_width/2-hairpin_y_offset)*i,hairpin_base_width/2-hairpin_x_offset,-hairpin_base_thick/2])
                        cylinder(r=hairpin_leg_rad, h=hairpin_base_thick, center=true);
                    #translate([-hairpin_leg_extend,-hairpin_leg_extend,-length]) cylinder(r=hairpin_leg_rad, h=hairpin_base_thick);
                }
        }
        
        hairpin_leg_holes();
    }
}

module motor_holes(screws=true, shaft=true, bump=true){
    if(screws == true){
        for(i=[0,1]) for(j=[0,1]) mirror([0,i,0]) mirror([j,0,0]) translate([motor_screw_sep/2, motor_screw_sep/2,0]) {
            cylinder(r=motor_screw_rad, h=motor_screw_len*2, center=true);
            translate([0,0,wall]) cylinder(r=motor_screw_cap_rad, h=motor_screw_len*2);
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
    base_rad = pulley_base_rad;
    
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