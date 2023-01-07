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

include <ttgo_t-beam_model.scad>

/**
* NOTE: If the array is related to wheels positions and/or similar,
* the array should be seen as the car going up this code, with its top
* going towards you.
*
* Example:
*   front of the car
*   [
*       value1, value2,
*       value3, value4
*   ]
*   back of the car
*
* Unless otherwise stated.
*/

/**
* NOTE: If the array is related to servo positions and/or similar,
* the array should be seen as the car going up this code, with its top
* going towards you.
*
* Example:
*   front of the car
*   [
*       value1,
*       value2
*   ]
*   back of the car
*
* Unless otherwise stated.
*/


/* MODE */
// WARNING: SET ALL PREVIEW TO false WHEN EXPORTING
PREVIEW_TOP = false;
PREVIEW_BOT = false;


/* TTGO T-BEAM v1.1 */
TTGO_POSITION = [-3, 6, -3];
TTGO_ROTATION = [0, 0, 180];

TTGO_WALL_THICKNESS = [8, 8];
TTGO_MIDDLE_WALL_CUT_SIZE = 91.6;

TTGO_BOARD_STEP_SIZE_MULT = 4;    // at top part of cybertruck
TTGO_BOARD_THICKNESS = 1.8;

TTGO_STEP_SIZE_UP   = 20;
TTGO_STEP_SIZE_DOWN = 22;


/* TTGO POWER BUTTON */
POWER_BTN_POSITION = [TTGO_POSITION.x, 0, TTGO_POSITION.z] + [0, 6, 0];
POWER_BTN_HOUSING = TTGO_BTN_SIZE + [4, 2, 4];
POWER_BTN_HOUSING_MARGIN = 1.8;
POWER_BTN_MARGIN = 2.4;


/* SERVOS */
SERVO_POSITION = [ [61,   0, -20], [-72.4, -6, -10] ];
SERVO_ROTATION = [ [ 0, 180, 180], [-90,    0,   0] ];
SERVO_CABLE_CUT_POSITION_OFFSET = [ [-12, 0, 18], [-12, -16, 1] ];
SERVO_CABLE_CUT_SIZE = [ [6, 6, 6], [6, 6, 8] ];


/* SCREW TOOL CUT */
STOOL_POSITION = [-58.4, -5, -9.9];
STOOL_SIZE = 50;
STOOL_RADIUS = 2;


/* WHEELS */
WHEEL_POSITION = [
    [ 65, 29.5, -25], [ 65, -29.5, -25],
    [-66, 29.5, -25], [-66, -29.5, -25]
];



/* GEARS */
GEAR_TEETH = [21, 17];
GEAR_WIDTH = [5, 4];
GEAR_AXLE_CENTER_RADIUS = 1.5;  // TODO: maybe place WHEEL_AXLE_... here
GEAR_AXLE_CENTER_FACES  = 16;
GEAR_ATTACH_OFFSET = 2.4;


/* SCREWS */
SCREW_BODY_TUNNEL_SIZE = 14;
SCREW_BODY_TUNNEL_RADIUS = 1.4;
SCREW_BODY_TUNNEL_FACES = 5;

SCREW_HEAD_SIZE = 3.2;
SCREW_HEAD_TUNNEL_SIZE = 8;
SCREW_HEAD_RADIUS_AT_BODY = 1.4;
SCREW_HEAD_RADIUS = 4.0;
SCREW_HEAD_FACES = 32;

/* front and back
SCREW_POSITION      = [ [89, 0, -25   ], [-93, 0, -25  ] ];
SCREW_FILL_POSITION = [ [90, 0, -11.9 ], [-93, 0, -11.4] ];
SCREW_FILL_SIZE     = [ [ 8, 6,   8.8 ], [  5, 6,   9] ];
*/
// TODO: remove hardcoded "remove outside excess" in "... screw fill"
SCREW_POSITION      = [ [0, 25, -29   ], [0, -25, -29  ] ];
SCREW_FILL_POSITION = [ [0, 26, -16.9 ], [0, -26, -16.9] ];
SCREW_FILL_SIZE     = [ [8, 10,  14   ], [8,  10,  14  ] ];


/* DEBUG */
DEBUG_CYBERTRUCK   = 0;
DEBUG_TTGO         = 0;
DEBUG_SERVO        = [0, 0];
DEBUG_SERVO_CENTER = [0, 0];
DEBUG_WHEELS       = [0, 0, 0, 0];
DEBUG_WHEEL_TURN   = [0, 0];
DEBUG_WHEEL_ANGLE  = [0, 0];    // NOT 100% accurary representation
DEBUG_AXLE_REAR    = 0;
DEBUG_GEARS        = 0;