/**
* @file     cybertruck_params.scad
* @brief    Parameters for CyberTruck RC.
* @version  1.1
* @date     04 Dec 2022
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


// Gear library from: https://github.com/dpellegr/PolyGear
// do not 'include' PolyGear, 'use' instead
use <PolyGear/PolyGear.scad>

include <cybertruck_params.scad>

//TODO
module gears(gear1=true, gear2=true) {
    //holeN1_radius = 1.2;
    //holeN1_faces  = 6;
    widthN1 = GEAR_WIDTH[0];

    holeN2_radius = GEAR_AXLE_CENTER_RADIUS;
    holeN2_faces  = GEAR_AXLE_CENTER_FACES;
    widthN2 = GEAR_WIDTH[1];

    N1 = GEAR_TEETH[0];
    N2 = GEAR_TEETH[1];

    if (gear1) {
        difference() {
            spur_gear(n=N1, w=widthN1);
            //cylinder(h=widthN1+0.1, r=holeN1_radius, $fn=holeN1_faces, center=true);
        }
    }

    if (gear2) {
        translate([(N1+N2)/2, 0, 0])
        difference() {
            spur_gear(n=N2, w=widthN2);
            cylinder(h=widthN2+0.1, r=holeN2_radius, $fn=holeN2_faces, center=true);
        }
    }

    gearRatio = N1/N2;
    echo(str("GEAR RATIO"), gearRatio);
}


//TODO
module gearsSpace() {
    cylinder(h=12, r=13);

    translate([19.4, 0, 7])
    cylinder(h=10, r=11, center=true);
}


module gearAtServo() {
    difference() {
        union() {
            gears(gear2=false);

            translate([0, 0, GEAR_ATTACH_OFFSET])
            servoAttach_flip()
            servoAttach_round();
        }

        translate([7, 0, 8])
        rotate([180, 0, 0])
        servoWireHole(10);

        translate([-7, 0, 8])
        rotate([180, 0, 0])
        servoWireHole(10);
    }
}

module gearAtAxle() {
    gears(gear1=false);
}