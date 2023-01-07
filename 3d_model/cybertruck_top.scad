/**
* @file     cybertruck_top.scad
* @brief    CyberTruck top model part.
* @version  1.0
* @date     18 Dec 2022
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

use <model_cybertruck_top.scad>


/**
 * Power button housing.
 */
module powerButton_housing() {
    translate(POWER_BTN_POSITION)
    rotate(TTGO_ROTATION)
    translate(TTGO_BTN_POS[0] + [0, -8, 0]) {
        difference() {
            cube(POWER_BTN_HOUSING, center=true);
            
            // remove center, powerButton_housing_cut
            cube(POWER_BTN_HOUSING - [POWER_BTN_HOUSING_MARGIN, -1, POWER_BTN_HOUSING_MARGIN], center=true);

            // remove excess outside
            translate([0, -7.3, 0])
            rotate([2, 0, 0])
            cube(10, center=true);
        }

        /* DEBUG
        rotate([90, 0, 0])
        translate([0, 0, -0.8])
        powerButton();
        */
    }
}

/**
 * Power button cut inside housing.
 */
module powerButton_housing_cut() {
    translate(POWER_BTN_POSITION)
    rotate(TTGO_ROTATION)
    translate(TTGO_BTN_POS[0] + [0, -8, 0])
    cube(POWER_BTN_HOUSING - [POWER_BTN_HOUSING_MARGIN, -1, POWER_BTN_HOUSING_MARGIN], center=true);
}

/**
 * Power button.
 */
module powerButton() {
    rotate([90, 0, 0]) {
        cube(POWER_BTN_HOUSING - [POWER_BTN_MARGIN, 0, POWER_BTN_MARGIN], center=true);

        botSize = 3;
        yTrans = -4.5;
        translate([0, yTrans, 0])
        cube([POWER_BTN_HOUSING.x, botSize, POWER_BTN_HOUSING.z], center=true);
    }
}

/**
 * Cybertruck completed top part.
 */
module cybertruckTop() {
    if (PREVIEW_TOP) {
        UTIL_top();
    }
    else {
        difference() {
            union() {
                difference() {
                    show();

                    // cut front lights at back
                    translate([-4, 0, 0])
                    headLight_placed();

                    // cut back lights at back
                    translate([8, 0, 0])
                    tailLight_placed();

                    // cut front wheels bottom
                    translate([81.9, 0, -9])
                    rotate([0, -32.8, 0])
                    cube([4.7, 54, 20], center=true);

                    // cut front wheels/mid bottom
                    translate([56, 0, -22])
                    cube([42, 54, 46], center=true);

                    // cut mid bottom
                    translate([0, 0, -22])
                    cube([100, 54, 8], center=true);

                    // cut back wheels bottom
                    translate([-65, 0, -22])
                    cube([48, 54, 46], center=true);
                    
                    // cut front excess
                    translate([88, 0, -22])
                    cube([10, 42, 20], center=true);
                    translate([86.4, 20.4, -22])
                    rotate([0, 0, 45])
                    cube([10, 8, 20], center=true);
                        translate([86.4, -20.4, -22])
                        rotate([0, 0, -45])
                        cube([10, 8, 20], center=true);

                    // cut back excess
                    translate([-86.8, 0, -22])
                    cube([20, 52, 20], center=true);

                    powerButton_housing_cut();
                }

                // left screw fill
                difference() {
                    translate(SCREW_FILL_POSITION[0])
                    cube(SCREW_FILL_SIZE[0], center=true);
                    // remove outside excess
                    translate(SCREW_FILL_POSITION[0] + [0, 14.8, 0])
                    rotate([-20, 0, 0])
                    cube([20,20,40], center=true);
                }

                // right screw fill
                difference() {
                    translate(SCREW_FILL_POSITION[1])
                    cube(SCREW_FILL_SIZE[1], center=true);
                    // remove outside excess
                    translate(SCREW_FILL_POSITION[1] + [0, -14.8, 0])
                    rotate([20, 0, 0])
                    cube([20,20,40], center=true);
                }

                difference() {
                    ttgoBox(TTGO_POSITION, TTGO_ROTATION, false);

                    // remove protruding steps at front
                    translate([50, 0, 32])
                    rotate([0, 18.5, 0])
                    cube([50, 70, 40], center=true);
                    translate([50, 30, 19])
                    rotate([16, 0, 0])
                    cube([50, 10, 40], center=true);

                    // remove protruding steps at back
                    translate([-50, 0, 26.5])
                    rotate([0, -8, 0])
                    cube([50, 70, 20], center=true);
                }

                powerButton_housing();
            }

            screw(SCREW_POSITION[0]);
            screw(SCREW_POSITION[1]);

            headLight_cut_LEDs_area();
            tailLight_cut_LEDs_area();
        }
    }
}


module cybertruckTop_supports() {
    difference() {
        // vertical supports
        for (i=[5 : 8 : 48]) {
            translate([-110, i-25.5, -23.9])
            cube([210, 1, 50]);
        }
        
        // top front
        translate([50, 0, 65])
        rotate([0, 18, 0])
        translate([20, 0, -2.4])
        cube([200, 100, 100], center=true);
          translate([50, 0, 65])
          rotate([0, 18, 0])
          translate([12, 0, -2.8])
          cube([50, 100, 100], center=true);

        // top back
        translate([-50, 0, 70])
        rotate([0, -8, 0])
        translate([20, 0, -4.0])
        cube([200, 100, 100], center=true);
          translate([-50, 0, 70])
          rotate([0, -8, 0])
          translate([-31, 0, -4.6])
          cube([75, 100, 100], center=true);

        // top left
        translate([0, 37, 0])
        rotate([20, 0, 0])
        cube([200, 10, 100], center=true);

        // top right
        translate([0, -37, 0])
        rotate([-20, 0, 0])
        cube([200, 10, 100], center=true);

        // screw left
        translate([0, 25, -19.8])
        rotate([0, 0, 0])
        cube([8.8, 8.8, 10.4], center=true);

        // screw right
        translate([0, -25, -19.8])
        rotate([0, 0, 0])
        cube([8.8, 8.8, 10.4], center=true);

        // back back
        translate([-206, 0, 24])
        rotate([0, -7, 0])
        cube([200, 100, 100], center=true);

        // lower back
        translate([-202, 0, -60])
        rotate([0, 0, 0])
        cube([200, 100, 100], center=true);

        // lower back a bit inside
        translate([-102, 0, -13.2])
        rotate([0, 5, 0])
        cube([10, 100, 2], center=true);

        // lower vetical back a bit inside
        translate([-97.8, 0, -15.2])
        rotate([0, 0, 0])
        cube([1.8, 100, 3.4], center=true);

        // lower vetical back a bit inside
        translate([-98, 0, -15.2])
        rotate([0, 0, 0])
        cube([1.6, 100, 3.4], center=true);

        // tailight
        translate([-105, 0, 6.2])
        cube([12, 58, 6], center=true);

        // headight
        translate([99.5, 0, -5.3])
        cube([12, 58, 6], center=true);

        // front front
        translate([195, 0, -19])
        rotate([0, 8, 0])
        cube([200, 100, 20], center=true);

        // front front lower
        translate([196, 0, -25])
        cube([200, 100, 20], center=true);

        // front lower
        translate([192.8, 0, -15.7])
        rotate([0, 0, 0])
        cube([200, 100, 1.4], center=true);

        // front left
        translate([95, 24, -6.4])
        rotate([0, 0, 45])
        cube([10, 40, 20], center=true);
        // front right
        mirror([0,1,0])
        translate([95, 24, -6.4])
        rotate([0, 0, 45])
        cube([10, 40, 20], center=true);

        // TTGO supports margin cut only for left side
        //// back left
        translate([-58.4, 18, -1])
        cube([10, 8.4, 23.2]);
          translate([-58.4, 18, -1])
          rotate([0, -45, 0])
          cube([10, 8.4, 23.2]);

        //// front left
        translate([42.4, 18, -1])
        cube([10, 8.4, 23.2]);
          translate([42.4, 18, 3.4])
          rotate([0, 45, 0])
          cube([10, 8.4, 23.2]);
    }

    // front left angle support
    translate([96, 18, -23.9])
    rotate([0, 0, 45])
    cube([2, 16, 7.4]);
    // front right angle support
    translate([85, -29, -23.9])
    rotate([0, 0, -45])
    cube([2, 16, 7.4]);

    // back thick left support
    translate([-88, 27, -23.9])
    rotate([0, 0, 90])
    difference() {
        translate([0.8, 0, 0])
        cube([3.4, 16, 10.2]);

        translate([-2.1, -0.1, 6.3])
        rotate([6, 0, 0])
        cube([5, 11, 4]);

        translate([2, -0.1, 8.7])
        rotate([5, 0, 0])
        cube([5, 17, 4]);
    }
    // back thick right support
    translate([85, -29, -23.9])
    rotate([0, 0, -45])
    cube([2, 16, 7.5]);
    mirror([0,1,0])
    translate([-88, 27, -23.9])
    rotate([0, 0, 90])
    difference() {
        translate([0.8, 0, 0])
        cube([3.4, 16, 10.2]);

        translate([-2.1, -0.1, 6.3])
        rotate([6, 0, 0])
        cube([5, 11, 4]);

        translate([2, -0.1, 8.7])
        rotate([5, 0, 0])
        cube([5, 17, 4]);
    }

    // left front wheel
    translate([54, 28, -23.9])
    difference() {
        cube([24.8, 4, 22]);

        translate([-1.1, -0.1, 21.9])
        rotate([0, 2.3, 0])
        cube([30, 6, 6]);
    }
    // right front wheel
    mirror([0,1,0])
    translate([54, 28, -23.9])
    difference() {
        cube([24.8, 4, 22]);

        translate([-1.1, -0.1, 21.9])
        rotate([0, 2.3, 0])
        cube([30, 6, 6]);
    }

    // left back wheel
    translate([-78.6, 28, -23.9])
    difference() {
        cube([24.2, 4, 22]);

        translate([-1.1, 0.1, 21.9])
        rotate([0, 0.4, 0])
        cube([30, 6, 6]);
    }
    // right back wheel
    mirror([0,1,0])
    translate([-78.6, 28, -23.9])
    difference() {
        cube([24.2, 4, 22]);

        translate([-1.1, 0.1, 21.9])
        rotate([0, 0.4, 0])
        cube([30, 6, 6]);
    }

    // support button housing
    translate([-11.5, 24, -8.8])
    rotate([-30, 0, 0])
    difference() {
        cube([10, 2, 18], center=true);

        translate([0, 0, 8.6])
        rotate([30, 0, 0])
        cube([12, 4, 2], center=true);
    }

    // horizontal support of suppports
    translate([65, -40, -23.9])
    cube([1, 80, 10]);
    translate([-68, -40, -23.9])
    cube([1, 80, 10]);

    // TTGO
    //// back right
    translate([-58.4, -15.8, -23.9])
    cube([10, 10, 23.2]);

    //// front right
    translate([42.4, -15.8, -23.9])
    cube([10, 10, 23.2]);

    //// back left
    translate([-58.4, 18, -23.9])
    cube([10, 8.4, 23.2]);

    //// front left
    translate([42.4, 18, -23.9])
    cube([10, 8.4, 23.2]);

}



/***********************************/
/********* ERODE FUNCTIONS *********/
/***********************************/

module model(l=1){
    cybertruck_top();
}

/* If error occurs, use the command line. */
module erode(r){
    difference() {
        children();
        minkowski(convexity=3) {
            difference() {
                cube(300, center=true);
                children();
            }
            sphere(r);
        }
    }
}

module show() {
    difference() { 
        model();
        erode(1.2, $fn=12)
        model();
    }
}

module eroted() {
    erode(1.2,$fn=4)
    model();
}

/***********************************/