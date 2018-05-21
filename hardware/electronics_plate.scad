include <configuration.scad>
mil = .001*25.4;

center_gap = 67;
gap_scale=1.02;
wall = 2;

screw_rad = 1.35;

electronics_platform();

$fn=32;


module electronics_platform(){
    difference(){
        union(){
    
            //arduino
            translate([0,center_gap/2+wall,0]) difference(){
                arduino_mount();
                arduino_mount(solid = false);
            }

            //pi
            translate([0,-center_gap/2-58.5,0]) difference(){
                pi_mount();
                pi_mount(solid = false);
            }
            
            //power converter
            translate([73.5,center_gap/2+wall,0]) difference(){
                pc_mount();
                pc_mount(solid = false);
            }
    
            //rail mount
            difference(){
                translate([35,0,wall]) cube([60.25,beam+wall*2, wall*2], center=true);
                //rail cutout
                translate([0,0,beam/2+wall*1.25]) rotate([0,90,0]) scale([gap_scale,gap_scale,gap_scale]) beam(length=200);
            }
    
            //connect up the sides
            for(i=[-30,0,30])
            difference(){
                union(){
                    hull(){
                        translate([i+35,0,wall/2+.5]) cube([7,center_gap+wall, wall+1], center=true);
                        translate([35,0,wall]) cube([60,beam+wall*2, wall*2], center=true);
                    }
                }
        
                hull(){
                    translate([i+35,0,wall/2]) cube([.1,center_gap+wall, wall*3], center=true);
                    translate([35,0,wall]) cube([50,beam+wall*2, wall*5], center=true);
                }
            }
        }
        
        //rail cutout
        translate([0,0,beam/2+wall*1.25]) rotate([0,90,0]) scale([gap_scale,gap_scale,gap_scale]) beam(length=200);
        
        //mounting holes
        for(i=[-27,0,27]) translate([i+35,0,0])
            cylinder(r=m5_rad+.2, h=50, center=true);
    }
}

module pc_outline(){
    width = 34;
    length = 47;
    corner_rad = 1;
    screw_sep = 52;
    
    screw_inset = (length - screw_sep)/2;
    
    hull(){
        
        for(i=[corner_rad, width-corner_rad]) for(j=[corner_rad,length-corner_rad]) translate([i,j,0]){
            cylinder(r=corner_rad, h=1);
        }
        
        pc_screwholes(height=1);
    }
        
        
}

module pc_screwholes(screw_rad=2.1, height = wall){
    width = 34;
    length = 47;
    screw_sep = 52;
    
    screw_inset = (length - screw_sep)/2;
    
    for(i=[screw_inset,screw_sep+screw_inset]) translate([width/2, i, 0])
        cylinder(r=screw_rad, h=height);
   
}

module pc_mount(solid = true, base_thick = 2, height = 2, peg_height = 3){
    
    if(solid == true){
        minkowski(){
            scale([gap_scale, gap_scale, base_thick+height]) pc_outline();
            cylinder(r=wall, h=.1);            
        }
        
        translate([.2,.2,1]) pc_screwholes(height = peg_height+base_thick, screw_rad = 4, taper = .75);
        translate([.2,.2,3]) pc_screwholes(height = peg_height+base_thick, screw_rad = 1.9, taper = .75);
    }else{
        translate([0,0,base_thick]) difference(){
            scale([gap_scale, gap_scale, base_thick+height]) pc_outline();
            //screwholes
            translate([.2,.2,-1]) pc_screwholes(height = peg_height+base_thick, screw_rad = 4, taper = .75);
            translate([.2,.2,3]) pc_screwholes(height = peg_height+base_thick, screw_rad = 1.9, taper = .75);
        }
        
        //screwholes
        translate([.2,.2,-.1]) pc_screwholes(height = peg_height+base_thick+3.2, screw_rad = screw_rad, taper = .75);
    }
}

module pi_outline(){
    corner_rad = 2.8;
    hull() for(i=[corner_rad,85-corner_rad*2]) for(j=[corner_rad,58.5-corner_rad*2]) translate([i,j,0]) cylinder(r=corner_rad, h=1, $fn=12);
}

module pi_screwholes(height = 5, screw_rad = screw_rad, taper = -.25){
    translate([85-58-3.5-3.5-wall,0,0]){
        translate([3.5,3.5,0]) cylinder(r1=screw_rad, r2=screw_rad-taper, h=height, $fn=24);
        translate([3.5,3.5+49,0]) cylinder(r1=screw_rad, r2=screw_rad-taper, h=height, $fn=24);
        translate([3.5+58,3.5,0]) cylinder(r1=screw_rad, r2=screw_rad-taper, h=height, $fn=24);
        translate([3.5+58,3.5+49,0]) cylinder(r1=screw_rad, r2=screw_rad-taper, h=height, $fn=24);
    }
 
}

module pi_mount(solid = true, sled = true, pegs = true, base_thick = 2, height = 2, peg_height = 3){
     
    if(solid == true){
         if(sled == true){
            minkowski(){
                scale([gap_scale, gap_scale, base_thick+height]) pi_outline();
                cylinder(r=wall, h=.1);
            }
            translate([.2,.2,1]) pi_screwholes(height = peg_height+base_thick, screw_rad = 3, taper = .75);
        }
    }else{
        //sled cutout
        translate([0,0,base_thick]) difference(){
            scale([gap_scale, gap_scale, base_thick+height]) pi_outline();
            translate([.2,.2,-base_thick+1]) pi_screwholes(height = peg_height+base_thick, screw_rad = 3, taper = .75);
        }
        
        //cutout for the power and usb
        pi_portholes(lift = base_thick+peg_height);
        
        //screwholes
        translate([.2,.2,-.1]) pi_screwholes(height = peg_height+base_thick+1.2);
    }
}

module arduino_outline(){
    polygon( points = [[0, 0],
                        [2600*mil, 0],
                        [2600*mil, 100*mil],
                        [2700*mil, 200*mil],
                        [2700*mil, 1490*mil],
                        [2600*mil, 1590*mil],
                        [2600*mil, 2040*mil],
                        [2540*mil, 2100*mil],

                        [0, 2100*mil],     //upper left corner
                        [0, 1725*mil],    //usb jack
                        [-250*mil, 1725*mil],
                        [-250*mil, 1275*mil],
                        [0*mil, 1275*mil],
                        [0*mil, 475*mil],    //power jack
                        [-75*mil, 475*mil],
                        [-75*mil, 125*mil],
                        [0*mil, 125*mil],
    ],
              paths =  [[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]],
              convexity = 3);
}

module arduino_portholes(lift = 0){
    //barrel jack
    scale([gap_scale, gap_scale, 1]) translate([0,300*mil,lift+8.25]) rotate([0,90,0]) cylinder(r=5, h=10, center=true);
    
    //usb
    scale([gap_scale, gap_scale, 1]) translate([0,(1275+(1725-1275)/2)*mil,lift+7]) cube([25, 12, 11], center=true);
}

module arduino_screwholes(height = 5, screw_rad = screw_rad, taper = -.25){
    translate([550*mil,100*mil,0]) cylinder(r1=screw_rad, r2=screw_rad-taper, h=height, $fn=24);
    translate([600*mil,2000*mil,0]) cylinder(r1=screw_rad, r2=screw_rad-taper, h=height, $fn=24);
    translate([2600*mil,300*mil,0]) cylinder(r1=screw_rad, r2=screw_rad-taper, h=height, $fn=24);
    translate([2600*mil,1400*mil,0]) cylinder(r1=screw_rad, r2=screw_rad-taper, h=height, $fn=24);
}

module arduino_mount(solid = true, sled = true, pegs = true, base_thick = 2, height = 10, peg_height = 3){
   
    
     if(solid == true){
         if(sled == true){
            minkowski(){
                linear_extrude(height = base_thick+height) scale([gap_scale, gap_scale, 1]) arduino_outline();
                cylinder(r=wall, h=.1);
            }
        }
    }else{
        //sled cutout
        translate([0,0,base_thick]) difference(){
            linear_extrude(height = base_thick+height) scale([gap_scale, gap_scale, 1]) arduino_outline();
            translate([.2,.2,-base_thick+1]) arduino_screwholes(height = peg_height+base_thick-1, screw_rad = 3, taper = .75);
        }
        
        //cutout for the power and usb
        arduino_portholes(lift = base_thick+peg_height);
        
        //screwholes
        translate([.2,.2,-.1]) arduino_screwholes(height = peg_height+base_thick+.2);
    }
    
}
