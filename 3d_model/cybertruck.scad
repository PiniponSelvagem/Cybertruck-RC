/**
* @file     cybertruck.scad
* @brief    CyberTruck RC using TTGO T-Beam v1.1
* @version  1.2
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

include <pini_lib.scad>

include <cybertruck_params.scad>
include <cybertruck_utils.scad>

include <cybertruck_top.scad>
include <cybertruck_bottom.scad>
include <cybertruck_wheel.scad>
include <cybertruck_lights.scad>
include <cybertruck_gear.scad>

include <cybertruck_servos.scad>
include <cybertruck_ttgo.scad>

include <cybertruck_supports.scad>



/**
 * Debug view, set active views using parameters with prefix 'DEBUG'.
 */
module DEBUG() {
    if (DEBUG_TTGO) {
        translate(TTGO_POSITION) {
            rotate(TTGO_ROTATION)
            ttgo(0.5);
        }
    }

    if (DEBUG_SERVO[0]) {
        translate(SERVO_POSITION[0])
        rotate(SERVO_ROTATION[0])
        servoDebug(0, 0.8, 0, DEBUG_SERVO_CENTER[0]);
    }
    if (DEBUG_SERVO[1]) {
        translate(SERVO_POSITION[1])
        rotate(SERVO_ROTATION[1])
        servoDebug(0, 1, 1, DEBUG_SERVO_CENTER[1]);
    }

    if (DEBUG_AXLE_REAR) {
        color("red", 0.5)
        translate([-66, 0, -25])
        rotate([90, 0, 0])
        cylinder(h=65, r1=1.5, r2=1.5, $fn=16, center=true);
    }

    if (DEBUG_WHEEL_TURN[0]) {
        // front left
        translate([65, 29.5, -25]) {
            rotate([0, 0, DEBUG_WHEEL_ANGLE[0]])
            rotate([90, 90, 0])
            color("cyan", alpha=0.5)
            wheelJoint_atWheel();
        }
    }
    if (DEBUG_WHEEL_TURN[1]) {
        // front right
        translate([65, -29.5, -25]) {
            rotate([0, 0, DEBUG_WHEEL_ANGLE[1]])
            rotate([-90, -90, 0])
            color("cyan", alpha=0.5)
            wheelJoint_atWheel();
        }
    }

    if (DEBUG_WHEELS[0]) {
        // front left
        translate([65, 29.5, -25]) {
            rotate([0, 0, DEBUG_WHEEL_ANGLE[0]])
            rotate([90, 0, 180])
            color("grey", alpha=0.5)
            UTIL_wheel();
        }
    }
    if (DEBUG_WHEELS[1]) {
        // front right
        translate([65, -29.5, -25]) {
            rotate([0, 0, DEBUG_WHEEL_ANGLE[1]])
            rotate([90, 0, 0])
            color("grey", alpha=0.5)
            UTIL_wheel();
        }
    }
    if (DEBUG_WHEELS[2]) {
        // back left
        translate([-66, 29.5, -25])
        rotate([90, 0, 180])
        color("grey", alpha=0.5)
        UTIL_wheel();
    }
    if (DEBUG_WHEELS[3]) {
        // back right
        translate([-66, -29.5, -25])
        rotate([90, 0, 0])
        color("grey", alpha=0.5)
        UTIL_wheel();
    }

    if (DEBUG_CYBERTRUCK) {
        color("cyan", 0.2)
        UTIL_cybertruck_3Dmodel();
    }

    if (DEBUG_GEARS) {
        GEAR_DISTANCE_FROM_SERVO = 7;
        GEAR_ANGLE = 52;

        translate(SERVO_POSITION[1])
        rotate(SERVO_ROTATION[1])
        servoRotationCenterPosition()
        translate([0, 0, GEAR_DISTANCE_FROM_SERVO]) // max rotation height in "servo space"
        rotate([0, 0, GEAR_ANGLE]) {                // rotate to match rear axis
            rotate([0, 180, 8.5])
            gearAtServo();
            gearAtAxle();
        }
    }
}

DEBUG();



/* -------------- PRINT -------------- */
/*
union() {   // TOP
    cybertruckTop();
    cybertruckTop_supports();
    support_tailLight_inside();
    support_headLight_inside();
}
*/


union() {   // BOTTOM
    cybertruckBottom();
    cybertruckBottom_supports();
}


//powerButton();


//wheel();

//wheelJoint_atWheel();

//servoAttachTurning();

//gearAtAxle();
//gearAtServo();




//powerButton();

//headLight();
//tailLight();














/*
servoAttach_flip()
servoAttach_round();

translate([-30, 0, 0])
servoAttach_flip()
servoAttach_simple();



//wheelJoint_atWheel();
//translate([65, 10, -22])
//wheelJoint_atBody();
*/

/*
color("orange", 0.8)
difference() {
    cybertruckBottom();

    /* LEDS test
    translate([200, 0, 0])
    cube(580, center=true);
    
    translate([-196, 0, 0])
    cube(200, center=true);

    translate([-100, 0, -100])
    cube(200, center=true);

    translate([-100, 100, 0])
    cube(200, center=true);
    */

    /* FRONT SERVO test
    translate([178, 0, 0])
    cube(200, center=true);

    translate([-55, 0, 0])
    cube(200, center=true);

    translate([0, -210, 0])
    cube(400, center=true);

    translate([0, 210, 0])
    cube(400, center=true);
    *
}


// DEBUG gears, need a bit of work to use gearAtServo



// TODO: WHEEL_AXLE_RADIUS should be different than AXLE_RADIUS
// create AXLE_RADIUS to give margin only in axle 






// TEST
//attachAtTurningServo();

//cybertruckTop();




/*
//color("grey", 1)
difference() {
    union() {
        cybertruckTop();
        cybertruckTop_supports();
    }
    
    translate([0, -180, 0])
    cube(400, center=true);

    translate([200, 0, 0])
    cube(400, center=true);
}





//tailLight_placed();
//headLight_placed();
*/





