/**
* @file     cybertruck_ttgo.scad
* @brief    TTGO T-Beam v1.1 simplified case for CyberTruck RC.
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

include <ttgo_t-beam_model.scad>
include <cybertruck_params.scad>


/* INTERNAL PARAMETERS */
_WALL_INNER_MARGIN = [0.4, 0.4, 0.4];

_CASE_OUTTER_POS_OFFSET   = [0, 0, TTGO_BOARD_THICKNESS];
_CASE_OUTTER_SIZE         = [TTGO_MAX_SIZE.x, TTGO_MAX_SIZE.y, TTGO_STEP_SIZE_DOWN] + [TTGO_WALL_THICKNESS.x, TTGO_WALL_THICKNESS.y, 0];

_CASE_INNER_POS_OFFSET   = _CASE_OUTTER_POS_OFFSET;
_CASE_INNER_SIZE         = _WALL_INNER_MARGIN + TTGO_MAX_SIZE + [0, 0, TTGO_STEP_SIZE_DOWN];
_CASE_INNER_ROUND_RADIUS = 2;
_CASE_INNER_ROUND_FACES  = 32;

_BOARD_STEP_POS_OFFSET = [ [4.4, 0.4], [0.4, 0.4], [0.4, 4.4], [4.4, 4.4] ];    // start top left, clockwise

_TTGO_Z_OFFSET = 1.05;

_TTGO_BOARD_STEP_SIZE = 2.4;

_TTGO_BOARD_STEP_ANGLE_POS = [
    [-_TTGO_BOARD_STEP_SIZE*TTGO_BOARD_STEP_SIZE_MULT, 0, 0],
    [_TTGO_BOARD_STEP_SIZE*TTGO_BOARD_STEP_SIZE_MULT, _TTGO_BOARD_STEP_SIZE*TTGO_BOARD_STEP_SIZE_MULT, 0],
    [_TTGO_BOARD_STEP_SIZE*TTGO_BOARD_STEP_SIZE_MULT, 0, 0],
    [-_TTGO_BOARD_STEP_SIZE*TTGO_BOARD_STEP_SIZE_MULT, -_TTGO_BOARD_STEP_SIZE*TTGO_BOARD_STEP_SIZE_MULT, 0]
];
_TTGO_BOARD_STEP_ANGLE_ROT = [
    [0, -45, 0],
    [180, -135, 0],
    [180, -135, 0],
    [0, -45, 0]
];


/**
 * TTGO case left and right walls.
 * @note Parameters to consider:
 *      TTGO_MIDDLE_WALL_CUT_SIZE
 */
module ttgo_case() {
    translate([0, 0, _TTGO_Z_OFFSET]) {
        difference() {
            // Outter box
            rotate([180, 0, 0])
            translate([-_CASE_OUTTER_SIZE.x/2, -_CASE_OUTTER_SIZE.y/2, -TTGO_BOARD_THICKNESS + _WALL_INNER_MARGIN.z])
            cube(_CASE_OUTTER_SIZE + [0, 0, TTGO_BOARD_THICKNESS]);

            // Inner box
            translate(_CASE_INNER_POS_OFFSET)
            minkowskiEasy_cube(_CASE_INNER_SIZE, _CASE_INNER_ROUND_RADIUS, _CASE_INNER_ROUND_FACES, false);

            // only keep corners
            cube(TTGO_MIDDLE_WALL_CUT_SIZE, center=true);
        }
    }
}


/**
 * Board stand-offs.
 * @param isBottom True in case of base, false if lid.
 * @note Parameters to consider:
 *      TTGO_BOARD_STEP_SIZE
 *      TTGO_STEP_SIZE_UP
 *      TTGO_STEP_SIZE_DOWN
 */
module ttgo_steps(isBottom) {
    translate([0, 0, _TTGO_Z_OFFSET]) {
        for (i = [0 : len(TTGO_BOARD_HOLE_POS)-1]) {
            pointOffset = _BOARD_STEP_POS_OFFSET[i];
            point = TTGO_BOARD_HOLE_POS[i] + [pointOffset.x, pointOffset.y, 0];
            translate([point[0], point[1], 0]) {
                translate([-_TTGO_BOARD_STEP_SIZE, -_TTGO_BOARD_STEP_SIZE, 0])    // center cube, without using center=true since that would also center on the Z axis
                if (isBottom) {
                    rotate([180, 0, -180-90*i])
                    cube(
                        [
                            _TTGO_BOARD_STEP_SIZE*2,
                            _TTGO_BOARD_STEP_SIZE*2,
                            TTGO_STEP_SIZE_DOWN + 0.4    // 0.4 to match bottom
                        ]
                    );
                }
                else {
                    translate([0, 0, TTGO_BOARD_THICKNESS]) {
                        rotate([0, 0, -270-90*i])
                        cube(
                            [
                                _TTGO_BOARD_STEP_SIZE*TTGO_BOARD_STEP_SIZE_MULT,
                                _TTGO_BOARD_STEP_SIZE*TTGO_BOARD_STEP_SIZE_MULT,
                                TTGO_STEP_SIZE_UP
                            ]
                        );

                        translate(_TTGO_BOARD_STEP_ANGLE_POS[i])
                        rotate(_TTGO_BOARD_STEP_ANGLE_ROT[i])
                        cube(
                            [
                                _TTGO_BOARD_STEP_SIZE*TTGO_BOARD_STEP_SIZE_MULT,
                                _TTGO_BOARD_STEP_SIZE*TTGO_BOARD_STEP_SIZE_MULT,
                                TTGO_STEP_SIZE_UP
                            ]
                        );
                    }
                }
            }
        }
    }
}

/**
 * TTGO placement box.
 * @param position Position of the box.
 * @param rotation Rotation of the box.
 * @param isBottom True to create bottom part, false for top part only.
 */
module ttgoBox(position, rotation, isBottom) {
    translate(position) {
        rotate(rotation) {
            ttgo_steps(isBottom);

            if (isBottom)
                ttgo_case();
        }
    }
}