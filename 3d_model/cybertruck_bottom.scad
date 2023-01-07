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

use <model_cybertruck_bottom.scad>


/**
 * Space needed for the servo to go into the housing.
 */
module servoSpace(servo, sizeOffset) {
    // remove front servo enter box and cable
    translate(SERVO_POSITION[servo])
    rotate(SERVO_ROTATION[servo])
    servoHousing(true, sizeOffset);
}

/**
 * Turning joint to connect on body side.
 */
module turnJoint_atBody() {
    difference() {
        wheelJoint_atBody();

        // make space for turning cable
        translate([7.6, 2, -8])
        cube([10, 20, 10], center=true);

        translate([7, 0, -8])
        rotate([0, 0, 45])
        cube([10, 10, 10], center=true);
    }
}

/**
 * Rear wheel axle extension to match front wheel base width.
 */
module rearWheelAxleExtension() {
    translate([-66, 0, -25])
    cube([7.8, 59, 7.8], center=true);
}

/**
 * Hole for screw tool at the back servo.
 */
module screwToolCut() {
    translate(STOOL_POSITION)
    rotate([-90, 0, 0])
    cylinder(h=STOOL_SIZE, r=STOOL_RADIUS, $fn=16);
}

/**
 * Cybertruck completed bottom part.
 */
module cybertruckBottom() {
    if (PREVIEW_BOT) {
        UTIL_bottom();
    }
    else {
        difference() {
            union() {
                difference() {
                    cybertruck_bottom();

                    // remove front servo enter box
                    servoSpace(0, [0, 0, 10]);

                    // remove back servo enter box
                    union() {
                        translate([0, 0, 10]) {
                            servoSpace(1, [0, 0, 0]);
                            servoSpace(1, [0, 0, 4]);
                        }
                        
                        servoSpace(1, [0, 0, 4]);
                    }

                    // make back servo cable cut
                    translate(SERVO_POSITION[1] + SERVO_CABLE_CUT_POSITION_OFFSET[1]) {   // cable
                        cube(SERVO_CABLE_CUT_SIZE[1], center=true);
                    }

                    screwToolCut();
                }


                // front servo
                translate(SERVO_POSITION[0])
                rotate(SERVO_ROTATION[0]) {
                    servoHousing();

                    translate([-1, -1, 0])
                    difference() {
                        servoHousing(doFill=true, sizeOffset=[2, 2, 4]);
                        translate([1, 1, -1])
                        servoHousing(doFill=true, sizeOffset=[0, 0, 6]);
                    }
                }

                // back servo
                translate(SERVO_POSITION[1]) {
                    rotate(SERVO_ROTATION[1])
                    difference() {
                        servoHousing();
                        translate([0, -4, 0])
                        servoFill();
                    }
                    // fill bottom of back servo
                    translate([0, -5.1, -11])               //TODO
                    cube([33.4, 10.2, 8], center=true);     //TODO
                }


                // trim ttgoBox, servos and their cable exist to fit in cybertruck bottom
                difference() {
                    ttgoBox(TTGO_POSITION, TTGO_ROTATION, true);

                    // remove protruding box at front wheel
                    translate([62.4, 31, -12])
                    rotate([0, 30, 0])
                    cube([20, 30, 40], center=true);

                    // remove protruding box at back wheel
                    translate([-56, 31, -22])
                    rotate([0, -35, 0])
                    cube([20, 30, 30], center=true);

                    // remove front servo enter box and cable
                    translate(SERVO_POSITION[0])
                    rotate(SERVO_ROTATION[0])
                    servoHousing(true, [0, 0, 10]);
                    translate(SERVO_POSITION[0] + SERVO_CABLE_CUT_POSITION_OFFSET[0]) {   // cable
                        cube(SERVO_CABLE_CUT_SIZE[0], center=true);
                    }

                    // remove back servo enter box
                    union() {
                        translate([0, 0, 10]) {
                            servoSpace(1, [0, 0, 0]);
                            servoSpace(1, [0, 0, 4]);
                        }
                        
                        servoSpace(1, [0, 0, 4]);

                        screwToolCut();
                    }
                }

                // front turning joints (left)
                translate([65, 10.8, -25]) {
                    turnJoint_atBody();
                }
                // front turning joints (right)
                mirror([0, 1, 0]) {
                    translate([65, 10.8, -25]) {
                        turnJoint_atBody();
                    }
                }

                // back wheels joints
                rearWheelAxleExtension();

                // LEDs
                headLight_LEDs_housing();
                tailLight_LEDs_housing();
            }

            // cut rear axle
            translate([-66, 0, -25])
            rotate([90, 0, 0])
            cylinder(h=80, r=WHEEL_AXLE_RADIUS, $fn=WHEEL_AXLE_FACES, center=true);


            // remove space for gears
            translate(SERVO_POSITION[1])
            rotate(SERVO_ROTATION[1])
            servoRotationCenterPosition()
            translate([0, 0, -1])  // in "servo space"          //TODO
            rotate([0, 0, 52])     // rotate to max rear axis   //TODO
            gearsSpace();


            screw(SCREW_POSITION[0]);
            screw(SCREW_POSITION[1]);
        }
    }
}

module cybertruckBottom_supports() {
    translate([0, 0, -33])
    difference() {
        union() {
            // middle
            for (i=[0 : 10 : 60]) {
                translate([-46.4, -30.4+i, 0])
                cube([92.4, 1, 3.9]);
            }

            // back middle
            for (i=[14 : 10 : 50]) {
                translate([-85, -30.4+i, 0])
                cube([39, 1, 3.9]);
            }
            translate([-85, 15.4, 0])
            cube([39, 1, 3.9]);

            // back wheel left
            translate([-74, 17, 0])
            rotate([0, 0, 90])
            cube([20, 1, 28]);
            translate([-58, 17, 0])
            rotate([0, 0, 90])
            cube([20, 1, 28]);
              translate([-75, 28.4, 0])
              cube([16, 1, 3.9]);
              translate([-75, 22, 0])
              cube([16, 1, 3.9]);

            // back wheel right
            difference() {
                mirror([0, 1, 0]) {
                    translate([-74, 17, 0])
                    rotate([0, 0, 90])
                    cube([20, 1, 28]);
                    translate([-58, 17, 0])
                    rotate([0, 0, 90])
                    cube([20, 1, 28]);
                    translate([-55, 17, 0])
                    rotate([0, 0, 90])
                    cube([20, 1, 16]);
                      translate([-75, 28.4, 0])
                      cube([16, 1, 3.9]);
                      translate([-75, 22, 0])
                      cube([16, 1, 3.9]);
                }

                translate([-80, -24, 15.4])
                cube(30);
            }

            // front wheel left
            translate([74, 17, 0])
            rotate([0, 0, 90])
            cube([20, 1, 27.4]);
            translate([58, 17, 0])
            rotate([0, 0, 90])
            cube([20, 1, 28]);
              translate([58, 17, 11.8])
              rotate([0, 0, 40])
              cube([20.4, 1, 2]);
              translate([57.4, 29.4, 11.8])
              rotate([0, 0, -40])
              cube([20.4, 1, 2]);
              translate([57.4, 27.8, 11.8])
              cube([16, 1, 2]);
            
            // front wheel right
            mirror([0, 1, 0]) {
                translate([74, 17, 0])
                rotate([0, 0, 90])
                cube([20, 1, 27.4]);
                translate([58, 17, 0])
                rotate([0, 0, 90])
                cube([20, 1, 28]);
                translate([58, 17, 11.8])
                rotate([0, 0, 40])
                cube([20.4, 1, 2]);
                translate([57.4, 29.4, 11.8])
                rotate([0, 0, -40])
                cube([20.4, 1, 2]);
                translate([57.4, 27.8, 11.8])
                cube([16, 1, 2]);
            }

            // front servo
            translate([73.8, -7, 0])
            rotate([0, 0, 90])
            cube([14, 1, 12.6]);
            translate([49.4, -7, 0])
            rotate([0, 0, 90])
            cube([14, 1, 12.6]);

            // back
            difference() {
                for (i=[1.4 : 9.5 : 60]) {
                    translate([-104, -30.4+i, 0])
                    cube([20, 1, 12]);
                }

                translate([-83, -12, 3.4])
                rotate([7, -18, 180])
                cube([40, 40, 10]);

                mirror([0, 1, 0]) {
                    translate([-83, -12, 3.4])
                    rotate([7, -18, 180])
                    cube([40, 40, 10]);
                }

                translate([-83, 15, 3.4])
                rotate([0, -19, 180])
                cube([40, 30, 10]);
            }

            // front
            //color("red")
            difference() {
                union() {
                    translate([46, -16, 0])
                    cube([38, 1, 8]);
                    translate([46, -8.4, 0])
                    cube([38, 1, 8]);

                    mirror([0, 1, 0]) {
                        translate([46, -16, 0])
                        cube([38, 1, 8]);
                        translate([46, -8.4, 0])
                        cube([38, 1, 8]);
                    }
                }

                translate([65, 0, 11])
                rotate([0, -6, 0])
                cube([50, 50, 10], center=true);
                translate([63, 15, 0])
                cube([9, 10, 20], center=true);
                translate([63, -15, 0])
                cube([9, 10, 20], center=true);
            }

            // front front
            difference() {
                union() {
                    for (i=[1 : 8.6 : 44]) {
                        translate([83, -23+i, 0])
                        cube([12, 1, 11]);
                    }

                    translate([83, -32.4, 0])
                    rotate([0, 0, 43])
                    cube([16, 1, 11]);

                    mirror([0, 1, 0]) {
                        translate([83, -32.4, 0])
                        rotate([0, 0, 43])
                        cube([16, 1, 11]);
                    }
                }

                translate([90, 0, 14])
                rotate([0, 10, 180])
                cube([20, 70, 10], center=true);
            }
        }
    }
}