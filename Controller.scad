// Controller + Indicator to display measurements and receive inputs
// 
// by Les Hall
// started Wed Jul 11 2018
// 
// 
// todo list:
//      minkowski to round reticules
//      sink gear trough and servo mount
//      make arduino module
//      finish assembly module
// 



// parameters
selection = 0;  // selects what to draw on screen
    // 0 for assembly drawing
    // 1 for servo_mount
    // 2 for gauge plate
    // 3 for gauge housing.
gaugeNumber = 1;  // number of gauges in panel
$fn = 128;  // number of facets on round primitives
$vpd = 200;

// thickness of enclosure
thickness = 2.0;  // thickness of shape primitives
width = 4;  // width of shape boundaries
height = 8;  // height of shape boundaries
play = 0.25;  // extra room for fitting parts together

// hardware parameters
machineScrewHoleDiameter = 3.5;  // size of mounting holes

// servo drawing measurements
servoMoountingHoleSpacing = 30.0;  // distance between mounting holes
servoMoutingTabLength = 32.5;  // distance between outer edges of servo tabs
servoTatalHeight = 18.8;  // distance between top of axle and bottom of servo body
servoBodyLength = 22.6;  // distance between small sides of body
servoBodyWidth = 12;  // distance between long sides of body
servoBodyHeight = 21;  // distance between top and bottom of servo body
servoTabWidth = 11;  // distance between left and right side of servo tabs
servoBodyPlateSize = [servoBodyWidth, servoBodyLength, thickness];  // size of servo body plate

// gauge parameters
gaugeOutsideDiameter = 70;  // ooutside diameter of gauge
gaugeInsideDiameter = gaugeOutsideDiameter - 2*thickness;  // inside diameter of gauge
gaugeFrontPanelSpacing = 8;  // room in front for panel
gaugeHeight = 11 + gaugeFrontPanelSpacing;  // distance from front to back of gauge
gaugeAxleOffset = 16;  // offset from long end to axle of geared motor
gaugeThickness = thickness;  // thickness of gauges
assemblyScaleFactor = [1.25, 0.5, 1];  // scale of chassis connecting gauges  

// assembly parameters
gaugeSpacing = 4;  // spacing between gauges (not including diameter of gauge)



// instantiaton of thing
thing(selection);



// make the thing
module thing(sel) {
    if (sel == 0) {  // assembly diagram
        assembly();
    } else if (sel == 1) {  // one servo mount
        servo_mount();
    } else if (sel == 2) {  // one gauge
        gauge_panel();
    } else if (sel == 3) {  // one gauge
        gauge_housing();
    }
}



// make the full assembled thing
module assembly() {
    
    translate([0, 0, gaugeHeight - gaugeFrontPanelSpacing-thickness])
    gauge_panel();
    
    translate([0, 0, gaugeHeight])
    rotate([0, 180, 0])
    gauge_housing();
}



// make the gauge housing
module gauge_housing() {
    
    // tube for main shell
    gauge_enclosure(H = gaugeHeight, 
        OD = gaugeOutsideDiameter, 
        ID = gaugeInsideDiameter);
    
    // tube for internal shell
    gauge_enclosure(H = gaugeFrontPanelSpacing, 
        OD = gaugeOutsideDiameter, 
        ID = gaugeInsideDiameter - 2*gaugeThickness);
    
    // tube for external shell
    gauge_enclosure(H = gaugeFrontPanelSpacing, 
        OD = gaugeOutsideDiameter + 2*gaugeThickness, 
        ID = gaugeInsideDiameter);
    
    // and round rim detail on top of shells
    for(side = [0:1]) {
        translate([0, 0, side*gaugeFrontPanelSpacing])
        rotate_extrude()
        translate([gaugeOutsideDiameter/2 - thickness/2, 0, 0])
        scale([1.5, 1])
        circle(thickness);
    }
}



// make a cylindrical gauge from wervo mount, complete with edge rounds and other features
module gauge_panel() {
    
        
    // raise panel above z=0 plane
    translate([0, 0, servoBodyPlateSize[2]/2])
    
    // front panel of gauge
    difference() {
        
        // front panel flat cylinder
        rotate(180/$fn)
        cylinder(h = gaugeThickness, d = gaugeInsideDiameter, center = true);
        
        // make hole for servo mount
        translate([0, -(servoBodyLength - gaugeAxleOffset)/2, 0])
        cube(servoBodyPlateSize + [2*width, 2*height, 1], center = true);
    }
    
    // add servo mount
    translate([0, -(servoBodyLength - gaugeAxleOffset)/2, 0])
    scale([1, 1, 2])
    servo_mount();
    
    // add tic marks from 0 to 11
    // because this one goes to eleven
    for (rot = [0:11]) {
        
        // make the tic marks
        rotate(225-rot*(360-90)/11)
        translate([gaugeInsideDiameter/2 - 3*thickness, 0, 0])
        scale([1.5, 0.5, 1.0])
        rotate(45)
        cylinder(h = 2*thickness, d = gaugeInsideDiameter/8, $fn = 4);
    }
}



// make a panel to hold one servo
module servo_mount() {
    
    // raise panel above z=0 plane
    translate([0, 0, servoBodyPlateSize[2]/2])
    
    // servo mount rectangle with drill holes
    difference() {
        
        // outside of servo mount rectangle
        cube(servoBodyPlateSize + [2*width, 2*height, 0], 
            center = true);
        
        // inside of servo mount rectangle
        translate([0, 0, -1])
        cube(servoBodyPlateSize + [2*play, 2*play, 3], 
            center = true);
        
        // machine screw hardware mounting holes
        for (side = [-1:2:1]) {
            translate([0, servoMoountingHoleSpacing/2*side, 0]) {
                
                // the holes
                cylinder(h = thickness+1, d = machineScrewHoleDiameter, 
                    center = true);
                
                // the gaps
                translate([0, -machineScrewHoleDiameter/2*side, 0])
                cube([machineScrewHoleDiameter, machineScrewHoleDiameter, thickness+1], 
                    center = true);
            }
        }
    }
}



// tube shape
module gauge_enclosure(H = 20, OD = 70, ID = 60) {
    
    // local parameters
    thickness = OD - ID;  // calculate thickness
    
    // rotate half of one facet to flatten top and bottom
    rotate(180/$fn)

    union() {
        
        // make the outer ring
        difference() {
            
            // outside diameter of shape
            cylinder(h = H, d = OD);
            
            // inside diameter of shape
            translate([0, 0, -1])
            cylinder(h = H + 2, d = ID);
        }

    }
}


