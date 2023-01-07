/**
* @file     cybertruck_servos.scad
* @brief    CyberTruck RC servos
* @version  1.0
* @date     25 Nov 2022
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

_SERVO_FIX_Z_FIGHT = 0.01;

/* SERVO TURNIGY: TGY-R5180MG */
SERVO = [23.4, 12.6, 21.6];
SERVO_SCREW_PLANE = [32.6, 12.4, 1.8];
SERVO_SCREW_PLANE_HEIGHT = 16.6;    // at bottom of the plane
SERVO_ROTOR_HEIGHT = 4.4;
SERVO_HEAD_TOTAL_THICKNESS = 4.4;


/* SERVO ATTACH */
SERVO_ATTACH_BORDER = 1;
SERVO_ATTACH_HEIGHT = 4;              // total attach height
SERVO_ATTACH_SIMPLE_FACES = [12, 8];  // [bigger side, smaller side]
SERVO_ATTACH_ROUND_FACES = 16;
SERVO_ATTACH_SIMPLE_HOLDER_POSITION = [8, 2.6, 0];
SERVO_ATTACH_SIMPLE_HOLDER_ROTATION = [0, 45, 87];
SERVO_ATTACH_SIMPLE_HOLDER_SIZE = [1, 6, 1];

SERVO_HEAD_SIMPLE_TRANSLATION = 16;
SERVO_HEAD_SIMPLE_TRANSLATION_FILLED = [20, 2];   // translation/distance between the 2 cylinders from their respective center
SERVO_HEAD_SIMPLE_THICKNESS   = 1;         // thickness of the head piece plane
SERVO_HEAD_SIMPLE_RADIUS      = [3, 2];    // [bigger side, smaller side]
SERVO_HEAD_ROUND_RADIUS = 9.2;

SERVO_SCREW_RADIUS_SIMPLE = 2.4;
SERVO_SCREW_RADIUS_ROUND  = 3;
SERVO_SCREW_HEIGHT = 2;


/* SERVO HOUSING */
SERVO_HOUSING = [SERVO.x + 10, SERVO.y + 2, SERVO_SCREW_PLANE_HEIGHT];
SERVO_HOUSING_SCREW_OFFSET = 14;
SERVO_HOUSING_SCREW_HEIGHT = 10;
SERVO_HOUSING_SCREW_RADIUS = 1;
SERVO_HOUSING_SCREW_FACES  = 4;


/**
 * Servo head piece plane.
 * @param h Thickness of the plane.
 */
module _servoHead_simple(h=SERVO_HEAD_SIMPLE_THICKNESS) {
    hull() {
        cylinder(h=h, r=SERVO_HEAD_SIMPLE_RADIUS.x, $fn=SERVO_ATTACH_BORDER+SERVO_ATTACH_SIMPLE_FACES.x);
        
        translate([SERVO_HEAD_SIMPLE_TRANSLATION, 0, 0])
        cylinder(h=h, r=SERVO_HEAD_SIMPLE_RADIUS.y, $fn=SERVO_ATTACH_BORDER+SERVO_ATTACH_SIMPLE_FACES.y);
    }
}

/**
 * Servo head round piece plane.
 * @param h Thickness of the plane.
 */
module _servoHead_round(h=SERVO_HEAD_SIMPLE_THICKNESS) {
    cylinder(h=h, r=SERVO_HEAD_ROUND_RADIUS, $fn=SERVO_ATTACH_ROUND_FACES);
}

/**
 * Servo screw hole.
 * @param xOffset Offset in the X axis.
 */
module _servoHousingScrew(xOffset) {
    translate([SERVO_HOUSING.x/2 + xOffset, SERVO_HOUSING.y/2 + 0, SERVO_SCREW_PLANE_HEIGHT - SERVO_HOUSING_SCREW_HEIGHT +_SERVO_FIX_Z_FIGHT])
    cylinder(h=SERVO_HOUSING_SCREW_HEIGHT, r1=SERVO_HOUSING_SCREW_RADIUS, r2=SERVO_HOUSING_SCREW_RADIUS, $fn=SERVO_HOUSING_SCREW_FACES);
}

/**
 * Debug servo visualization.
 * @param rotation Rotation in degrees.
 * @param alpha Alpha channel for the debug object.
 * @param type type of the head: 0->simple, 1->round
 */
module servoDebug(rotation=0, alpha=1, type=0, showCenter=false) {
    translate([-SERVO.x/2, -SERVO.y/2, -SERVO_SCREW_PLANE_HEIGHT]) {
        color("grey", alpha=alpha)
        cube(SERVO, center=false);

        color("grey", alpha=alpha)
        translate([-(SERVO_SCREW_PLANE.x/2 - SERVO.x/2), 0, SERVO_SCREW_PLANE_HEIGHT])
        cube(SERVO_SCREW_PLANE, center=false);

        color("grey", alpha=alpha)
        translate([SERVO.y/2, SERVO.y/2, SERVO.z])
        cylinder(h=SERVO_ROTOR_HEIGHT, r1=SERVO.y/2, r2=SERVO.y/2, center=false);

        color("white", alpha=alpha)
        translate([SERVO.y/2, SERVO.y/2, SERVO.z+SERVO_ROTOR_HEIGHT])
        rotate([0, 0, rotation])
        if (type == 0) {
            _servoHead_simple(SERVO_HEAD_TOTAL_THICKNESS);
        }
        else if (type == 1) {
            _servoHead_round(SERVO_HEAD_TOTAL_THICKNESS);
        }

        if (showCenter) {
            color("red", alpha=alpha)
            translate([SERVO.y/2, SERVO.y/2, SERVO.z+SERVO_ROTOR_HEIGHT])
            cylinder(h=16, r=1, $fn=16, center=false);
        }
    }
}

/**
 * Center children at servo rotation point.
 */
module servoRotationCenterPosition() {
    translate([-SERVO.x/2, -SERVO.y/2, -SERVO_SCREW_PLANE_HEIGHT])
    translate([SERVO.y/2, SERVO.y/2, SERVO.z+SERVO_ROTOR_HEIGHT])
    children();
}

/**
 * Flip servo attach, with the insert hole up.
 */
module servoAttach_flip() {
    translate([0, 0, SERVO_ATTACH_HEIGHT])
    rotate([0, 180, 0])
    children();
}

/**
 * Servo head attach filled.
 */
module servoAttach_simple_filled() {
    hull() {
        cylinder(h=SERVO_ATTACH_HEIGHT, r=SERVO_ATTACH_BORDER+SERVO_HEAD_SIMPLE_RADIUS.x, $fn=SERVO_ATTACH_SIMPLE_FACES.x);
        
        translate([SERVO_HEAD_SIMPLE_TRANSLATION_FILLED.x, SERVO_HEAD_SIMPLE_TRANSLATION_FILLED.y, 0])
        cylinder(h=SERVO_ATTACH_HEIGHT, r=SERVO_ATTACH_BORDER+SERVO_HEAD_SIMPLE_RADIUS.y, $fn=SERVO_ATTACH_SIMPLE_FACES.y);

        translate([SERVO_HEAD_SIMPLE_TRANSLATION_FILLED.x, -SERVO_HEAD_SIMPLE_TRANSLATION_FILLED.y, 0])
        cylinder(h=SERVO_ATTACH_HEIGHT, r=SERVO_ATTACH_BORDER+SERVO_HEAD_SIMPLE_RADIUS.y, $fn=SERVO_ATTACH_SIMPLE_FACES.y);
    }

    /*
    hull() {
        cylinder(h=SERVO_ATTACH_HEIGHT, r=SERVO_ATTACH_BORDER+SERVO_HEAD_SIMPLE_RADIUS.x, $fn=SERVO_ATTACH_SIMPLE_FACES.x);
        
        translate([SERVO_HEAD_SIMPLE_TRANSLATION, 0, 0])
        cylinder(h=SERVO_ATTACH_HEIGHT, r=SERVO_ATTACH_BORDER+SERVO_HEAD_SIMPLE_RADIUS.y, $fn=SERVO_ATTACH_SIMPLE_FACES.y);
    }
    */
}

/**
 * Hole for wire to control surfaces.
 */
module servoWireHole(zSizeOffset=0) {
    translate([0, 0, -_SERVO_FIX_Z_FIGHT])
    cylinder(h=SERVO_ATTACH_HEIGHT+_SERVO_FIX_Z_FIGHT*2+zSizeOffset, r=0.8, $fn=SERVO_ATTACH_SIMPLE_FACES.y);
}

/**
 * Servo head attach filled.
 */
module servoAttach_round_filled() {
    cylinder(h=SERVO_ATTACH_HEIGHT, r=SERVO_ATTACH_BORDER+SERVO_HEAD_ROUND_RADIUS, $fn=SERVO_ATTACH_ROUND_FACES);
}

module _servoAttach_simple_holder(isLeft) {
    if (isLeft) {
        intersection() {
            servoAttach_simple_filled();

            translate(SERVO_ATTACH_SIMPLE_HOLDER_POSITION)
            rotate(SERVO_ATTACH_SIMPLE_HOLDER_ROTATION)
            cube(SERVO_ATTACH_SIMPLE_HOLDER_SIZE, center=true);
        }
    }
    else {
        intersection() {
            servoAttach_simple_filled();

            translate([
                 SERVO_ATTACH_SIMPLE_HOLDER_POSITION.x,
                -SERVO_ATTACH_SIMPLE_HOLDER_POSITION.y,
                 SERVO_ATTACH_SIMPLE_HOLDER_POSITION.z
            ])
            rotate([
                 SERVO_ATTACH_SIMPLE_HOLDER_ROTATION.x,
                 SERVO_ATTACH_SIMPLE_HOLDER_ROTATION.y,
                -SERVO_ATTACH_SIMPLE_HOLDER_ROTATION.z
            ])
            cube(SERVO_ATTACH_SIMPLE_HOLDER_SIZE, center=true);
        }
    }
}

/**
 * Servo head attach, complete.
 */
module servoAttach_simple() {
    difference() {
        servoAttach_simple_filled();

        translate([0, 0, -_SERVO_FIX_Z_FIGHT])
        _servoHead_simple(SERVO_HEAD_SIMPLE_THICKNESS*2);

        translate([0, 0, SERVO_HEAD_SIMPLE_THICKNESS*2-_SERVO_FIX_Z_FIGHT*2])
        cylinder(h=SERVO_SCREW_HEIGHT+_SERVO_FIX_Z_FIGHT*4, r=SERVO_SCREW_RADIUS_SIMPLE, $fn=SERVO_ATTACH_BORDER+SERVO_ATTACH_SIMPLE_FACES.x);
    }

    _servoAttach_simple_holder(true);
    _servoAttach_simple_holder(false);
}

/**
 * Servo head attach, complete.
 */
module servoAttach_round() {
    difference() {
        servoAttach_round_filled();

        translate([0, 0, -_SERVO_FIX_Z_FIGHT])
        _servoHead_round(SERVO_HEAD_SIMPLE_THICKNESS*2);

        translate([0, 0, SERVO_HEAD_SIMPLE_THICKNESS*2-_SERVO_FIX_Z_FIGHT*2])
        cylinder(h=SERVO_SCREW_HEIGHT+_SERVO_FIX_Z_FIGHT*4, r=SERVO_SCREW_RADIUS_ROUND, $fn=SERVO_ATTACH_BORDER+SERVO_ATTACH_SIMPLE_FACES.x);
    }
}

/**
 * Servo body filled.
 */
module servoFill() {
    translate([-SERVO_HOUSING.x/2, -SERVO_HOUSING.y/2, -SERVO_SCREW_PLANE_HEIGHT])
    translate([SERVO_HOUSING.x/2-SERVO.x/2, SERVO_HOUSING.y/2-SERVO.y/2, -_SERVO_FIX_Z_FIGHT])
    cube(SERVO);
}

/**
 * Servo body housing, including screw holes.
 * @param doFill True to do basic cube, usefull to use for difference on other objects. False normal housing.
 * @param sizeOffset Adjust the housing dimensions, note that center must be done using translation to accommodate the offset if desired. Ignored if doFill is false.
 */
module servoHousing(doFill=false, sizeOffset=[0, 0, 0]) {
    translate([-SERVO_HOUSING.x/2, -SERVO_HOUSING.y/2, -SERVO_SCREW_PLANE_HEIGHT])
    if (doFill) {
        cube(SERVO_HOUSING + sizeOffset);
    }
    else {
        difference() {
            cube(SERVO_HOUSING);

            translate([SERVO_HOUSING.x/2-SERVO.x/2, SERVO_HOUSING.y/2-SERVO.y/2, -_SERVO_FIX_Z_FIGHT])
            cube(SERVO);
            
            _servoHousingScrew(SERVO_HOUSING_SCREW_OFFSET);
            _servoHousingScrew(-SERVO_HOUSING_SCREW_OFFSET);
        }
    }
}

/**
 * Turning servo attach.
 */
module servoAttachTurning() {
    difference() {
        servoAttach_flip()
        servoAttach_simple();
        
        translate([-SERVO_HEAD_SIMPLE_TRANSLATION_FILLED.x, SERVO_HEAD_SIMPLE_TRANSLATION_FILLED.y, 0])
        servoWireHole();

        translate([-SERVO_HEAD_SIMPLE_TRANSLATION_FILLED.x, -SERVO_HEAD_SIMPLE_TRANSLATION_FILLED.y, 0])
        servoWireHole();
    }
}
