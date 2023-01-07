/**
* @file     cybertruck_wheel.scad
* @brief    CyberTruck RC wheel
* @version  1.0
* @date     23 Nov 2022
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

_WHEEL_FIX_Z_FIGHT = 0.01;

WHEEL_DEPTH = 11;
WHEEL_RADIUS = 16;
WHEEL_FACES = 64;

WHEEL_AXLE_RADIUS = 1.5;
WHEEL_AXLE_FACES = 16;

WHEEL_BACK_CUT_RADIUS = 12;
WHEEL_BACK_CUT_HEIGHT = WHEEL_DEPTH/2 + _WHEEL_FIX_Z_FIGHT;


RIM_DEPTH = 4.5;
RIM_RADIUS = 12;
RIM_FACES = 32;

RIM_CENTER_RADIUS = 4;

RIM_MIDDLE_DEPTH = 2;
RIM_MIDDLE_RADIUS_1 = 6;
RIM_MIDDLE_RADIUS_2 = 3;
RIM_MIDDLE_OFFSET_Z = 1.5;
RIM_MIDDLE_FACES = 16;

RIM_DETAIL_ANGLE = 30;
RIM_DETAIL_WIDTH = 3;
RIM_DETAIL_SIZE = 8;
RIM_DETAIL_DEPTH = 3;
RIM_DETAIL_HEIGHT_OFFSET = 2;

RIM_DETAIL_CENTER_OFFSET = 8;
RIM_DETAIL_EXTRUDE_OFFSET = 0.4;
RIM_DETAIL_REPEAT_EVERY = 60;

RIM_DETAIL_ANGLE_CUT_OUT_OFFSET = 4;
RIM_DETAIL_ANGLE_CUT_HEIGHT_OFFSET = -0.8;
RIM_DETAIL_ANGLE_CUT = 50;


RUBBER_CUT_RELATIVE_SIZE = 29.6;


WHEEL_SUPPORT_EVERY = 60;
WHEEL_SUPPORT_RADIUS_BASE = 1;
WHEEL_SUPPORT_RADIUS_TOP  = 0.5;
WHEEL_SUPPORT_DISTANCE_INNER = 2;
WHEEL_SUPPORT_DISTANCE_OUTER = 8;



WHEEL_JOINT_RADIUS = 10;
WHEEL_JOINT_THICKNESS = 2;

WHEEL_JOINT_TURN_HEIGHT = 2;
WHEEL_JOINT_TURN_OFFSET = 4;
WHEEL_JOINT_TURN_POS = 8;
WHEEL_JOINT_TURN_RADIUS_OUT = 2.6;
WHEEL_JOINT_TURN_RADIUS_IN = 0.8;
WHEEL_JOINT_TURN_FACES = 32;
WHEEL_JOINT_DEPTH = 2.7;


WHEEL_JOINT_VALLEY_SIZE  = 16;
WHEEL_JOINT_VALLEY_DEPTH = 4.3;
WHEEL_JOINT_VALLEY_FACES = 32;

WHEEL_JOINT_BODY_TRI_SIZE_SIDE = 14;
WHEEL_JOINT_BODY_TRI_SIZE_TALL = 12;
WHEEL_JOINT_BODY_TRI_CORNER_RADIUS = 1;
WHEEL_JOINT_BODY_TRI_CORNER_FACES = 16;
WHEEL_JOINT_BODY_TRI_THICKNESS = WHEEL_JOINT_TURN_HEIGHT;
WHEEL_JOINT_BODY_TRI_OFFSET = 1;
WHEEL_JOINT_BODY_TRI_SUPPORT_HEIGHT = 12;
WHEEL_JOINT_BODY_TRI_SUPPORT_OFFSET = -0.8;


/**
 * Add rim details aroudn the center of the wheel.
 */
module _rimDetails() {
    translate([0, 0, RIM_DETAIL_HEIGHT_OFFSET])
    rotate([RIM_DETAIL_ANGLE, 0, -90])
    difference() {
        cube([RIM_DETAIL_WIDTH, RIM_DETAIL_SIZE, RIM_DETAIL_DEPTH], center=true);

        translate([0, RIM_DETAIL_SIZE/2+RIM_DETAIL_ANGLE_CUT_HEIGHT_OFFSET, RIM_DETAIL_ANGLE_CUT_OUT_OFFSET])
        rotate([0, -RIM_DETAIL_ANGLE_CUT, -90])
        cube([RIM_DETAIL_WIDTH*4, RIM_DETAIL_WIDTH*4, RIM_DETAIL_DEPTH], center=true);
    }
}

/**
 * Wheel axle hole.
 */
module _wheelAxle() {
    cylinder(h=WHEEL_DEPTH+1, r1=WHEEL_AXLE_RADIUS, r2=WHEEL_AXLE_RADIUS, $fn=WHEEL_AXLE_FACES, center=true);
}

/**
 * Most of the wheel is created in this function.
 */
module _wheelBase() {
    difference() {
        union() {
            difference() {
                minkowskiEasy_cylinder(WHEEL_DEPTH, WHEEL_RADIUS, 2, WHEEL_FACES);
                
                translate([0, 0, (WHEEL_DEPTH-RIM_DEPTH)/2 +_WHEEL_FIX_Z_FIGHT])
                cylinder(h=RIM_DEPTH, r1=RIM_CENTER_RADIUS, r2=RIM_RADIUS, $fn=RIM_FACES, center=true);
                
                translate([0, 0, -WHEEL_DEPTH/1.5])
                difference() {
                    cylinder(h=WHEEL_DEPTH, r1=WHEEL_RADIUS+1, r2=WHEEL_RADIUS+1, $fn=WHEEL_FACES, center=true);
                    cylinder(h=WHEEL_DEPTH+_WHEEL_FIX_Z_FIGHT, r1=WHEEL_RADIUS/2+1, r2=WHEEL_RADIUS+1, $fn=WHEEL_FACES, center=true);
                }
            }

            translate([0, 0, RIM_MIDDLE_OFFSET_Z])
            cylinder(h=RIM_MIDDLE_DEPTH, r1=RIM_MIDDLE_RADIUS_1, r2=RIM_MIDDLE_RADIUS_2, $fn=RIM_MIDDLE_FACES, center=true);
        }

        _wheelAxle();
    }

    for(a = [0:RIM_DETAIL_REPEAT_EVERY:359]) {
        rotate([0, 0, a]) translate([RIM_DETAIL_CENTER_OFFSET, 0, RIM_DETAIL_EXTRUDE_OFFSET]) 
        _rimDetails();
    }
}

/**
 * Small cut around the outer of the wheel for a rubber band, in case it is needed for more traction..
 */
module _wheelRubberCut() {
    difference() {
        // center cylinder
        cylinder(h=RUBBER_CUT_RELATIVE_SIZE-_WHEEL_FIX_Z_FIGHT, r1=RUBBER_CUT_RELATIVE_SIZE, r2=RUBBER_CUT_RELATIVE_SIZE, $fn=WHEEL_FACES, center=true);

        // top cylinder
        rotate([0, 180, 0])
        cylinder(h=RUBBER_CUT_RELATIVE_SIZE, r1=RUBBER_CUT_RELATIVE_SIZE, $fn=WHEEL_FACES, center=true);

        // bottom cylinder
        cylinder(h=RUBBER_CUT_RELATIVE_SIZE, r1=RUBBER_CUT_RELATIVE_SIZE, $fn=WHEEL_FACES, center=true);
    }
}

/**
 * Remove part of the back side of the wheel to make sure the turning popint is as close to the center of it as possible.
 */
module _wheelBackCut() {
    translate([0, 0, -WHEEL_BACK_CUT_HEIGHT])
    cylinder(h=WHEEL_BACK_CUT_HEIGHT, r1=WHEEL_BACK_CUT_RADIUS, r2=WHEEL_BACK_CUT_RADIUS, $fn=WHEEL_FACES);
}

/**
 * Add wheel printing supports.
 */
module _wheelSupports() {
    for(a = [0:WHEEL_SUPPORT_EVERY:359]) {
        rotate([0, 0, a]) translate([WHEEL_SUPPORT_DISTANCE_INNER, 0, 0]) 
        translate([0, 0, -WHEEL_BACK_CUT_HEIGHT])
        cylinder(h=WHEEL_BACK_CUT_HEIGHT, r1=WHEEL_SUPPORT_RADIUS_BASE, r2=WHEEL_SUPPORT_RADIUS_TOP);
    }

    for(a = [0:WHEEL_SUPPORT_EVERY:359]) {
        rotate([0, 0, a]) translate([WHEEL_SUPPORT_DISTANCE_OUTER, 0, 0]) 
        translate([0, 0, -WHEEL_BACK_CUT_HEIGHT])
        cylinder(h=WHEEL_BACK_CUT_HEIGHT, r1=WHEEL_SUPPORT_RADIUS_BASE, r2=WHEEL_SUPPORT_RADIUS_TOP);
    }
}

/**
 * Wheel ready to print.
 * @param doSupports Create supports at the back cut for printing.
 */
module wheel(doSupports=true) {
    difference() {
        _wheelBase();

        _wheelRubberCut();
        _wheelBackCut();
    }

    if (doSupports) {
        _wheelSupports();
    }
}




/**
 * Wheel joint that the servo will connect to.
 */
module _wheelJointTurnLoop() {
    difference() {
        cylinder(h=WHEEL_JOINT_TURN_HEIGHT, r=WHEEL_JOINT_TURN_RADIUS_OUT, $fn=WHEEL_JOINT_TURN_FACES);

        translate([0, 0, -_WHEEL_FIX_Z_FIGHT])
        cylinder(h=WHEEL_JOINT_TURN_HEIGHT+_WHEEL_FIX_Z_FIGHT*2, r=WHEEL_JOINT_TURN_RADIUS_IN, $fn=WHEEL_JOINT_TURN_FACES);
    }
}

/**
 * Wheel joint interaction point.
 */
module _wheelJointPoints() {
    translate([WHEEL_JOINT_TURN_OFFSET, 0, WHEEL_JOINT_DEPTH]) {
        rotate([0, 90, 0])
        _wheelJointTurnLoop();

        translate([WHEEL_JOINT_TURN_HEIGHT*2, 0, 0])
        rotate([0, 90, 0])
        _wheelJointTurnLoop();
    }
}

/**
 * Wheel joint used for wheel support.
 */
module _wheelJoint() {
    cylinder(h=WHEEL_JOINT_THICKNESS, r1=WHEEL_JOINT_RADIUS, r2=WHEEL_JOINT_RADIUS, $fn=WHEEL_FACES);

    _wheelJointPoints();

    rotate([0, 0, 180])
    _wheelJointPoints();


    translate([-WHEEL_JOINT_TURN_HEIGHT/2, WHEEL_JOINT_TURN_POS, WHEEL_JOINT_DEPTH])
    rotate([0, 90, 0])
    _wheelJointTurnLoop();
}

/**
 * Wheel joint interaction point cut.
 */
module _wheelJointPointCut() {
    translate([WHEEL_JOINT_TURN_OFFSET+WHEEL_JOINT_TURN_HEIGHT, 0, WHEEL_JOINT_DEPTH + WHEEL_JOINT_VALLEY_DEPTH/2])
    rotate([90, 180, 90])
    triangle(WHEEL_JOINT_VALLEY_SIZE, WHEEL_JOINT_VALLEY_DEPTH, 1, WHEEL_JOINT_VALLEY_FACES, WHEEL_JOINT_TURN_HEIGHT);
}

/**
 * Wheel support connection between body of the car and wheel joint.
 */
module _wheelJoint_atBody() {
    translate([0, WHEEL_JOINT_BODY_TRI_OFFSET, 0]) {
        triangle(
            WHEEL_JOINT_BODY_TRI_SIZE_SIDE, WHEEL_JOINT_BODY_TRI_SIZE_TALL,
            WHEEL_JOINT_BODY_TRI_CORNER_RADIUS, WHEEL_JOINT_BODY_TRI_CORNER_FACES,
            WHEEL_JOINT_BODY_TRI_THICKNESS, true
        );
    }
    difference() {
        hull() {
            translate([0, WHEEL_JOINT_BODY_TRI_OFFSET + WHEEL_JOINT_TURN_RADIUS_OUT, 0])
            cylinder(h=WHEEL_JOINT_TURN_HEIGHT, r=WHEEL_JOINT_TURN_RADIUS_OUT, $fn=WHEEL_JOINT_TURN_FACES, center=true);

            translate([0, 16, 0])
            cylinder(h=WHEEL_JOINT_TURN_HEIGHT, r=WHEEL_JOINT_TURN_RADIUS_OUT, $fn=WHEEL_JOINT_TURN_FACES, center=true);
        }

        translate([0, 16, -_WHEEL_FIX_Z_FIGHT/2])
        cylinder(h=WHEEL_JOINT_TURN_HEIGHT + _WHEEL_FIX_Z_FIGHT*2, r=WHEEL_JOINT_TURN_RADIUS_IN, $fn=WHEEL_JOINT_TURN_FACES, center=true);
    }
}

/**
 * Wheel joint that sits between wheel and the wheel support at body.
 */
module wheelJoint_atWheel() {
    difference() {
        _wheelJoint();

        _wheelJointPointCut();

        rotate([0, 0, 180])
        _wheelJointPointCut();

        _wheelAxle();
    }

    /*
    translate([0, 0, 2])
    %cylinder(h=4, r=3);
    */
}

/**
 * Wheel support connection between body of the car and wheel joint, with both supports.
 */
module wheelJoint_atBody() {
    translate([0, 0, WHEEL_JOINT_TURN_OFFSET + WHEEL_JOINT_TURN_HEIGHT*1.5])
    _wheelJoint_atBody();

    translate([0, 0, - (WHEEL_JOINT_TURN_OFFSET + WHEEL_JOINT_TURN_HEIGHT*1.5)])
    _wheelJoint_atBody();

    hull() {
        // center front
        translate([0, WHEEL_JOINT_BODY_TRI_SIZE_TALL - WHEEL_JOINT_BODY_TRI_CORNER_RADIUS + WHEEL_JOINT_BODY_TRI_SUPPORT_OFFSET, 0])
        cylinder(h=WHEEL_JOINT_BODY_TRI_SUPPORT_HEIGHT, r=WHEEL_JOINT_BODY_TRI_CORNER_RADIUS, $fn=WHEEL_JOINT_BODY_TRI_CORNER_FACES, center=true);

        // center back
        translate([0, WHEEL_JOINT_BODY_TRI_CORNER_RADIUS*2, 0])
        cylinder(h=WHEEL_JOINT_BODY_TRI_SUPPORT_HEIGHT, r=WHEEL_JOINT_BODY_TRI_CORNER_RADIUS, $fn=WHEEL_JOINT_BODY_TRI_CORNER_FACES, center=true);

        // center side
        translate([-WHEEL_JOINT_BODY_TRI_SIZE_SIDE/2 + WHEEL_JOINT_BODY_TRI_CORNER_RADIUS, WHEEL_JOINT_BODY_TRI_CORNER_RADIUS*2, 0])
        cylinder(h=WHEEL_JOINT_BODY_TRI_SUPPORT_HEIGHT, r=WHEEL_JOINT_BODY_TRI_CORNER_RADIUS, $fn=WHEEL_JOINT_BODY_TRI_CORNER_FACES, center=true);
    }
}