/**
* @file     cybertruck_supports.scad
* @brief    CyberTruck printing supports.
* @version  1.0
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




// TODO: IMPROVE





TAILLIGHT_SUPPORT_PLACED_OFFSET = 1;
TAILLIGHT_SUPPORT_THICKNESS = 0.8;
TAILLIGHT_SUPPORT_DEPTH = 7;
TAILLIGHT_SUPPORT_HEIGHT = 2.8;
module support_tailLight_inside() {
    for (i = [0:8:30]) {
        translate([-(100.15 + TAILLIGHT_SUPPORT_PLACED_OFFSET), i, 6])
        cube([TAILLIGHT_SUPPORT_DEPTH, TAILLIGHT_SUPPORT_THICKNESS, TAILLIGHT_SUPPORT_HEIGHT], center=true);

        translate([-(100.15 + TAILLIGHT_SUPPORT_PLACED_OFFSET), -i, 6])
        cube([TAILLIGHT_SUPPORT_DEPTH, TAILLIGHT_SUPPORT_THICKNESS, TAILLIGHT_SUPPORT_HEIGHT], center=true);
    }
}





HEADLIGHT_SUPPORT_PLACED_OFFSET = 1;
HEADLIGHT_SUPPORT_THICKNESS = 0.8;
HEADLIGHT_SUPPORT_DEPTH = 4;
HEADLIGHT_SUPPORT_HEIGHT = 1.8;

HEADLIGHT_SUPPORT_SIDE_ANGLE_UPDOWN_MULT = 0.23;
HEADLIGHT_SUPPORT_SIDE_ANGLE_UPDOWN_OFFSET = -4.6;
HEADLIGHT_SUPPORT_SIDE_ANGLE_BACK_MULT = 0.9;
HEADLIGHT_SUPPORT_SIDE_ANGLE_BACK_OFFSET = 17.5;
module support_headLight_inside() {
    for (i = [0:4:20]) {
        translate([94.6+HEADLIGHT_SUPPORT_PLACED_OFFSET, i, -6])
        cube([HEADLIGHT_SUPPORT_DEPTH, HEADLIGHT_SUPPORT_THICKNESS, HEADLIGHT_SUPPORT_HEIGHT], center=true);

        translate([94.6+HEADLIGHT_SUPPORT_PLACED_OFFSET, -i, -6])
        cube([HEADLIGHT_SUPPORT_DEPTH, HEADLIGHT_SUPPORT_THICKNESS, HEADLIGHT_SUPPORT_HEIGHT], center=true);
    }

    for (i = [21:4:32]) {
        translate([
            94.6+HEADLIGHT_SUPPORT_PLACED_OFFSET -(HEADLIGHT_SUPPORT_SIDE_ANGLE_BACK_MULT*i)+HEADLIGHT_SUPPORT_SIDE_ANGLE_BACK_OFFSET,
            i,
            -6 +(HEADLIGHT_SUPPORT_SIDE_ANGLE_UPDOWN_MULT*i)+HEADLIGHT_SUPPORT_SIDE_ANGLE_UPDOWN_OFFSET
        ])
        cube([HEADLIGHT_SUPPORT_DEPTH, HEADLIGHT_SUPPORT_THICKNESS, HEADLIGHT_SUPPORT_HEIGHT], center=true);

        translate([
            94.6+HEADLIGHT_SUPPORT_PLACED_OFFSET -(HEADLIGHT_SUPPORT_SIDE_ANGLE_BACK_MULT*i)+HEADLIGHT_SUPPORT_SIDE_ANGLE_BACK_OFFSET,
            -i,
            -6 +(HEADLIGHT_SUPPORT_SIDE_ANGLE_UPDOWN_MULT*i)+HEADLIGHT_SUPPORT_SIDE_ANGLE_UPDOWN_OFFSET
        ])
        cube([HEADLIGHT_SUPPORT_DEPTH, HEADLIGHT_SUPPORT_THICKNESS, HEADLIGHT_SUPPORT_HEIGHT], center=true);
    }
}