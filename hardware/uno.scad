module uno_pcb(h = 1.7)
{
    difference()
    {
        linear_extrude(h) polygon([[0,0],[66,0],[66,2],[68.6,5],[68.6,37],[66,40],[66,53.3],[0,53.3]]);
        translate([14.7, 50.5, -1]) cylinder(d = 3.2, h = h + 2, $fn = 12);
        translate([13.6, 2.3, -1]) cylinder(d = 3.2, h =  h + 2, $fn = 12);
        translate([65.5, 35, -1]) cylinder(d = 3.2, h =  h + 2, $fn = 12);
        translate([65.5, 7, -1]) cylinder(d = 3.2, h =  h + 2, $fn = 12);
    }
}

module header(r,c, h = 8.6)
    color("black") cube([2.54 * c, 2.54 * r, h]);

module uno()
{
    color("royalblue") translate([0, 0, 1.4]) uno_pcb();
    color("lightgray") translate([2, 5, 0]) cube([60, 42, 2]);
    
    color("lightgray") translate([-6.2, 31.7, 3.1]) cube([16.5, 12, 10.9]);
    color("darkslategray") translate([-1.8, 3.3, 3.1]) cube([14.5, 8.5, 11]);
    
    color("royalblue")  translate([18, 10, 3.1]) cube([42, 35, 6]);
           
    translate([25.65, 2.54, 3.1]) header(1, 8);
    translate([48.53, 2.54, 3.1]) header(1, 6);
    translate([17.05, 50.5, 3.1]) header(1, 10);
    translate([43.45, 50.5, 3.1]) header(1, 8);
}

module uno_shield()
{
    color("red") uno_pcb();
    translate([25.65, 2.54, -2.2]) header(1, 8, 2.3);
    translate([48.53, 2.54, -2.2]) header(1, 6, 2.3);
    translate([17.05, 50.5, -2.2]) header(1, 10, 2.3);
    translate([43.45, 50.5, -2.2]) header(1, 8, 2.3);
    
    color("yellow")  translate([18, 4, 1.7]) cube([36, 45, 15]);
    
    color("white")  translate([56, 6, 1.7]) cube([11, 30, 9]);
    color("white")  translate([56, 35, 1.7]) cube([7, 14, 9]);
    
    color("royalblue")  translate([1, 10, 1.7]) cube([15, 41, 10]);
}

module uno_simple()
    color("DarkSlateGray") uno();

module fan(h = 10.4)
{
    difference()
    {
        linear_extrude(height = h) minkowski()
        {
            translate([2.5, 2.5, 0]) square([35, 35]);
            circle(d = 5);
        }
        for (i = [0, 32.5], j = [0, 32.5])
        {
            translate([7.5/2 + i, 7.5/2 + j, -5]) cylinder(d = 3.25, h = h + 10, $fn = 12);
            //translate([7.5/2 + i, 7.5/2 + j, 10.4 - 3.25]) cylinder(d = 5.5, h = 20, $fn = 12);
        }
    }

}


//%color("white", 0.3) uno();
//%color("white", 0.3) translate([0, 0, 14]) uno_shield();

//translate([15, 65, 0]) rotate([0, -90, -90]) fan();

module enclosure()
{
    //mounting tabs
    *difference()
    {
        //tabs
        translate([0, 0, -4]) linear_extrude(height = 4) for (i = [-6, 74], j = [-11, 64]) hull()
        {
            translate([35, 25]) circle(d = 25);
            translate([i, j]) circle(d = 10);
        }
        
        translate([-4, -5, -2]) cube([77, 63, 4]);
        //screwholes for the tabs
        translate([0, 0, -5]) for (i = [-6, 74], j = [-11, 64]) 
        {
            translate([i, j]) cylinder(d = 2.5, h = 5, $fn = 12);
        }
        translate([0, 0, -2]) for (i = [-6, 74], j = [-11, 64]) 
        {
            translate([i, j]) cylinder(d = 5.5, h = 5, $fn = 12);
        }
    }
    
    //base box
    translate([-4, -6, -4]) cube([78, 65, 2]);
    
    difference()
    {
        union()
        {
            translate([0, 0, -2]) linear_extrude(height = 43) difference()
            {
                translate([-4, -6]) square([78, 65]);
                translate([-1, -3]) square([72, 59]);
            }
            translate([0, 0, -2]) linear_extrude(height = 42) 
            {
                translate([-2.5, -3.5]) polygon([[0, 0], [0, 5], [5, 0]]);
                translate([72, 57]) rotate([0, 0, 180]) polygon([[0, 0], [0, 5], [5, 0]]);
                translate([-2.5, 57]) rotate([0, 0, -90]) polygon([[0, 0], [0, 5], [5, 0]]);
                translate([72, -3.5]) rotate([0, 0, 90]) polygon([[0, 0], [0, 5], [5, 0]]);
            }
        }
        
        //lid screwholes
        for (i = [-1.5, 71], j = [-3, 56]) translate([i, j, 35]) cylinder(d = 3, h = 10, $fn = 12);
        
        translate([-6.2, 30.7, 2.1]) cube([16.5, 14, 12.9]);
        translate([-5, 2.3, 2.1]) cube([14.5, 10.5, 13]);
        
        translate([35, -5, 20]) rotate([0, -90, -90]) cube([38, 38, 10], center = true);
        
        for (i = [-2, -1, 0, 1, 2]) hull()
        {
            translate([35 + 10*i, 55, 5]) rotate([0, -90, -90]) cylinder(d1 = 1, d2=6, h = 10, center = true);
            translate([35 + 10*i, 55, 35]) rotate([0, -90, -90]) cylinder(d1 = 1, d2=6, h = 10, center = true);
        }
        
        for (i = [-2, -1, 0, 1, 2]) hull()
        {
            translate([70, 26 + 10*i, 25]) rotate([0, -90, 0]) cylinder(d2 = 1, d1=6, h = 10, center = true);
            translate([70, 26 + 10*i, 35]) rotate([0, -90, 0]) cylinder(d2 = 1, d1=6, h = 10, center = true);
        }
        
        for (i = [-2, -1, 0, 1, 2]) hull()
        {
            translate([0, 26 + 10*i, 25]) rotate([0, -90, 0]) cylinder(d1 = 1, d2=6, h = 10, center = true);
            translate([0, 26 + 10*i, 35]) rotate([0, -90, 0]) cylinder(d1 = 1, d2=6, h = 10, center = true);
        }
    }
    
    difference()
    {
        translate([15, -6, 0]) rotate([0, -90, -90]) fan(h = 3);
        translate([35, -10, 20]) rotate([0, -90, -90]) cylinder(d = 38, h = 30);
    }
    
    //arduino standoffs
    difference(){
        union()
        {
            translate([14.7, 50.5, -2]) cylinder(d1 = 6, d2=5, h = 3.5, $fn = 36);
            translate([13.6, 2.3, -2]) cylinder(d1 = 6, d2=5, h = 3.5, $fn = 36);
            translate([65.5, 35, -2]) cylinder(d1 = 6, d2=5, h = 3.5, $fn = 36);
            translate([65.5, 7, -2]) cylinder(d1 = 6, d2=5, h = 3.5, $fn = 36);
        }
        //screwholes
        union()
        {
            translate([14.7, 50.5, -3]) cylinder(d1 = 2.5, d2 = 3.125, h = 4.75, $fn = 36);
            translate([13.6, 2.3, -3]) cylinder(d1 = 2.5, d2 = 3.125, h = 4.75, $fn = 36);
            translate([65.5, 35, -3]) cylinder(d1 = 2.5, d2 = 3.125, h = 4.75, $fn = 36);
            translate([65.5, 7, -3]) cylinder(d1 = 2.5, d2 = 3.125, h = 4.75, $fn = 36);
        }
    }
}

module top() 
{
    translate([100, 0, -2]) difference()
    {
        union()
        {
            translate([-1 + 0.2, -3 + 0.2, 4]) cube([72 - 0.4, 59 - 0.4, 1]);
            translate([-4, -6, 2]) cube([78, 65, 2]);
        }
        for (i = [-1.5, 71], j = [-3, 56]) translate([i, j, -1]) cylinder(d = 3.5, h = 10, $fn = 12);
        
        for (i = [-2, -1, 0, 1, 2]) hull()
        {
            translate([35 + 10*i, 6, 5]) rotate([0, 0, -90]) cylinder(d = 4, h = 10, center = true);
            translate([35 + 10*i, 47, 5]) rotate([0, 0, -90]) cylinder(d = 4, h = 10, center = true);
        }
    }
}

translate([0, 0, 4]) enclosure();

top();
