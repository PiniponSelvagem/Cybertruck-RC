/**
* @file     cybertruck_lights.scad
* @brief    CyberTruck RC lights
* @version  1.0
* @date     24 Nov 2022
* @author   PiniponSelvagem
*
* Copyright(C) 2022-2023, PiniponSelvagem
* All rights reserved.
*
***********************************************************************
* Software that is described here, is for illustrative purposes only
* which provides customers with programming information regarding the
* products. This software is supplied "AS IS" without any warranties.
**********************************************************************/

TAILLIGHT_DEPTH  = 4;
TAILLIGHT_WIDTH  = 60 - 0.4/*margin*/;
TAILLIGHT_HEIGHT = 3 - 0.4/*margin*/;

module _tailLight_placement() {
    translate([-(100.15 + TAILLIGHT_PLACED_OFFSET), 0, 6])
    children();
}

module _headLight_placement() {
    translate([94.6+HEADLIGHT_PLACED_OFFSET, 0, -6])
    children();
}

module tailLight() {
    difference() {
        cube([TAILLIGHT_DEPTH, TAILLIGHT_WIDTH, TAILLIGHT_HEIGHT], center=true);
        
        // cut back angle
        translate([-(TAILLIGHT_DEPTH/2 +0.78), 0, 0])
        rotate([0, -8, 0])
        cube([2, TAILLIGHT_WIDTH+1, TAILLIGHT_HEIGHT+1], center=true);
    }
}

TAILLIGHT_PLACED_OFFSET = 3;
module tailLight_placed() {
    _tailLight_placement()
    tailLight();
}




module _headLight_side_or_trim_wPlacement(isLightElseTrim) {
    translate([-4.77, 24, 1.1])
    rotate([10, 0, 42.5])

    translate([0.2, -0.5, 0])
    rotate([0, -7, 0])

    if (isLightElseTrim) {
        cube([HEADLIGHT_SIDE_DEPTH, HEADLIGHT_SIDE_WIDTH, HEADLIGHT_SIDE_HEIGHT], center=true);
    }
    else {
        translate([3.8, 0, 0])
        rotate([0, 7, -0.5])
        translate([-HEADLIGHT_SIDE_DEPTH/2 +HEADLIGHT_SIDE_DEPTH_OFFSET, 0, 0])
        cube([2, HEADLIGHT_SIDE_WIDTH+1, HEADLIGHT_SIDE_HEIGHT+1], center=true);
    }
}


HEADLIGHT_DEPTH = 4;
HEADLIGHT_WIDTH = 40.8;
HEADLIGHT_HEIGHT = 2 -0.3;     // prev was 0.4
HEADLIGHT_SIDE_DEPTH = 4;
HEADLIGHT_SIDE_WIDTH = 16 -0.3;     // prev was 0.4
HEADLIGHT_SIDE_HEIGHT = 2 -0.3;     // prev was 0.4
module headLight_side() {
    _headLight_side_or_trim_wPlacement(true);
}

HEADLIGHT_DEPTH_OFFSET = 0.83;
HEADLIGHT_SIDE_DEPTH_OFFSET = 1;
module headLight() {
    difference() {
        union() {
            // front
            cube([HEADLIGHT_DEPTH, HEADLIGHT_WIDTH, HEADLIGHT_HEIGHT], center=true);

            // side left
            headLight_side();

            // side right
            mirror([0, 1, 0])
            headLight_side();
        }

        // trim bellow main head light
        translate([0, 0, -HEADLIGHT_HEIGHT])
        cube([HEADLIGHT_DEPTH+HEADLIGHT_SIDE_DEPTH, HEADLIGHT_WIDTH, HEADLIGHT_HEIGHT], center=true);

        // cut front angle
        translate([(HEADLIGHT_DEPTH/2 + HEADLIGHT_DEPTH_OFFSET), 0, 0])
        rotate([0, 7.5, 0])
        cube([2, HEADLIGHT_WIDTH+1, HEADLIGHT_HEIGHT+1], center=true);

        // cut side angle
        _headLight_side_or_trim_wPlacement(false);

        // cut side angle
        mirror([0, 1, 0])
        union() {
            _headLight_side_or_trim_wPlacement(false);
        }
    }
}

HEADLIGHT_PLACED_OFFSET = 1;
module headLight_placed() {
    _headLight_placement()
    headLight();
}


module headLight_cut_LEDs_area() {
    _headLight_placement() {
        translate([-6, 0, 0])
        cube([8, 38, 4.4], center=true);

        translate([-9.4, 22, 0.8])
        rotate([10, 0, 42])
        cube([6, 14.5, 4.8], center=true);

        translate([-9.4, -22, 0.8])
        rotate([-10, 0, -42])
        cube([6, 14.5, 4.8], center=true);
    }
}

module tailLight_cut_LEDs_area() {
    _tailLight_placement() {
        translate([8, 0, 0])
        cube([8, 61.8, 5.4], center=true);
    }
}


module headLight_LEDs_housing() {
    translate([-14, 0, 3])
    _headLight_placement() {
        rotate([0, 15, 0])
        difference() {
            translate([2, 0, -8])
            cube([10, 52, 16], center=true);

            //right
            translate([8, -22.4, -8])
            cube([10, 13, 20], center=true);

            //left
            translate([8, 22.4, -8])
            cube([10, 13, 20], center=true);

            //back vertical cut
            rotate([0, -15, 0])
            translate([-8.8, 0, -8])
            cube([12, 54, 24], center=true);

            //right wheel
            translate([-3, -22.4, -10])
            rotate([0, -45, 0])
            cube([10, 13, 20], center=true);

            //left wheel
            translate([-3, 22.4, -10])
            rotate([0, -45, 0])
            cube([10, 13, 20], center=true);

            // LEDs
            translate([5, 0, 0]) {
                rotate([0, 0, 180]) {
                    translate([0, 22, 0])
                    _led();

                    translate([-4, 11, 0])
                    _led();

                    translate([-4, 0, 0])
                    _led();

                    translate([-4, -11, 0])
                    _led();

                    translate([0, -22, 0])
                    _led();
                }
            }
        }
        
        // connection to body
        /*
        _headLight_LEDs_support(22);
        _headLight_LEDs_support(11);
        _headLight_LEDs_support(0);
        _headLight_LEDs_support(-11);
        _headLight_LEDs_support(-22);
        */
    }
}

module tailLight_LEDs_housing() {
    translate([10.4, 0, 0])
    _tailLight_placement() {
        difference() {
            translate([0, 0, -1.4])
            cube([6, 48, 3], center=true);

            translate([-5, 0, 0]) {
                translate([0, 20, 0])
                _led();

                translate([0, 10, 0])
                _led();

                translate([0, 0, 0])
                _led();

                translate([0, -10, 0])
                _led();

                translate([0, -20, 0])
                _led();
            }
        }
        
        // connection to body
        _tailLight_LEDs_support(22);
        _tailLight_LEDs_support(11);
        _tailLight_LEDs_support(0);
        _tailLight_LEDs_support(-11);
        _tailLight_LEDs_support(-22);
    }
}

module _tailLight_LEDs_support(yOffset) {
    translate([0, yOffset, -2])
    rotate([0, 180, 180])
    translate([-3, -2, 0])   // center horizontally
    cube([6, 4, 22], center=false);
}

module _led() {
    // head
    rotate([0, 90, 0])
    cylinder(h=6, r=1.8, $fn=64);

    // wire1
    translate([5, 1, 0])
    rotate([0, 90, 0])
    cylinder(h=8, r=0.8, $fn=64);

    // wire2
    translate([5, -1, 0])
    rotate([0, 90, 0])
    cylinder(h=8, r=0.8, $fn=64);
}