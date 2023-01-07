/**
* @file     ttgo_t-beam_model.scad
* @brief    Simplified model of TTGO T-Beam v1.1.
* @version  1.0
* @date     28 Oct 2022
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

/**
 * NOTE:
 * > TTGO_TOTAL_HEIGHT must be changed/revised if any Z axis in the model is changed
 */
TTGO_TOTAL_HEIGHT = 35.4;

TTGO_BOARD_SIZE = [100.4, 32.8, 1.5];
TTGO_BOARD_POS  = [0, 0, 2];
TTGO_BOARD_CORNER = 2;
TTGO_BOARD_HOLE_RADIUS = 1;
TTGO_BOARD_HOLE_POS = [ [-(48.8-1), 15-1, 0], [48.8-1, 15-1, 0], [48.8-1, -(15-1), 0], [-(48.8-1), -(15-1), 0] ];    // start top left, go clockwise

TTGO_BTN_SIZE = [4.4, 4, 2];
TTGO_BTN_POS  = [ [8.4, -15.6, 3.75], [17.8, -15.6, 3.75], [27.2, -15.6, 3.75] ];

TTGO_USB_SIZE = [7.6, 5.8, 2.8];
TTGO_USB_POS  = [-2.6, -14.7, 4.15];

TTGO_LORA_RADIUS = 3.15;
TTGO_LORA_POS    = [11, 15.8, 8.35];

TTGO_PIN_SIZE = [34, 2.4, 8.5];
TTGO_PIN_POS  = [ [-27.5, 12.6, 7], [-27.5, -12.6, 7] ];    // upper, lower

TTGO_GPS_SIZE = [16, 5, 6];
TTGO_GPS_POS  = [5.7, 14.9, -4.8];

DISPLAY_SIZE = [28.4, 27.4, 6];
DISPLAY_POS  = [-24, 0.5, 14.2];
////////////////////////
TTGO_MAX_SIZE = [100.4, 32.8, 35.4]; // board with X and Y, height with battery to display, does not include GPS / btns / usb
TTGO_BOARD_HEIGHT_AT_Z = TTGO_BOARD_POS.z + TTGO_BOARD_SIZE.z/2;
////////////////////////

/**
 * TTGO T-Beam v1.1 board model.
 * @param alpha Transparency [0..1].
 */
module ttgo_board(alpha) {
    difference() {
        color("grey", 1)
        minkowski() {
            //Minkowski size fix
            matx=TTGO_BOARD_SIZE.x - TTGO_BOARD_CORNER*2; 
            maty=TTGO_BOARD_SIZE.y - TTGO_BOARD_CORNER*2;
            matz=TTGO_BOARD_SIZE.z/2;
            
            // body with minkowski adjustments
            cube([matx,maty,matz], center=true);

            // corners
            cylinder(h=matz, r=TTGO_BOARD_CORNER, $fn=32, center=true);
        }

        // board holes
        for (i = [0 : len(TTGO_BOARD_HOLE_POS)-1]) {
            point=TTGO_BOARD_HOLE_POS[i];
            translate(point) {
                cylinder((TTGO_BOARD_SIZE.z*2), TTGO_BOARD_HOLE_RADIUS, TTGO_BOARD_HOLE_RADIUS, $fn=32, center=true);
            }
        }
    }
}

/**
 * Simple board pins line.
 * @param alpha Transparency [0..1].
 */
module ttgo_pins(alpha) {
    color("purple", alpha)
    cube(TTGO_PIN_SIZE, center=true);
}

/**
 * Simple side button model.
 * @param alpha Transparency [0..1].
 */
module ttgo_button(alpha) {
    color("red", alpha)
    cube(TTGO_BTN_SIZE, center=true);
}

/**
 * Simple side micro-usb model.
 * @param alpha Transparency [0..1].
 */
module ttgo_usb(alpha) {
    color("lime", alpha)
    cube(TTGO_USB_SIZE, center=true);
}

/**
 * Simple lora device module.
 * @param alpha Transparency [0..1].
 */
module ttgo_lora(alpha) {
    rotate([90, 90, 0])
    color("green", alpha)
    cylinder(14.4, TTGO_LORA_RADIUS, TTGO_LORA_RADIUS, $fn=32, center=true);

    translate([-28, 15, 0])
    rotate([0, 90, 0])
    color("green", alpha)
    cylinder(62, TTGO_LORA_RADIUS, TTGO_LORA_RADIUS, $fn=32, center=true);
}

/**
 * Simple gps antena box.
 * @param alpha Transparency [0..1].
 */
module ttgo_gps(alpha) {
    color("red", alpha)
    cube(TTGO_GPS_SIZE, center=true);
}

/**
 * Simple battery holder model.
 * @param alpha Transparency [0..1].
 */
module ttgo_battery_holder(alpha) {
    color("black", alpha)
    cube([77, 21, 15], center=true);
}

/**
 * Simple battery model.
 * @param alpha Transparency [0..1].
 */
module ttgo_battery(alpha) {
    rotate([0, 90, 0])
    color("cyan", alpha)
    cylinder(69.35, 9.25, 9.25, $fn=64, center=true);
}

/**
 * Simple display, based on SSD1306.
 * @param alpha Transparency [0..1].
 */
module display(alpha) {
    color("blue", alpha)
    cube(DISPLAY_SIZE, center=true);
}


////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////


/**
 * TTGO T-Beam v1.1 + Display SSD1306 + Battery.
 * @param alpha Transparency [0..1].
 */
module ttgo(alpha) {
    // battery
    translate([0, 0, -8]) {
        ttgo_battery(alpha);
    }

    // battery holder
    translate([0, 0, -6.25]) {
        ttgo_battery_holder(alpha);
    }

    // buttons
    for (i = [0 : len(TTGO_BTN_POS)-1]) {
        point=TTGO_BTN_POS[i];
        translate(point) {
            ttgo_button(alpha);
        }
    }

    // usb
    translate(TTGO_USB_POS) {
        ttgo_usb(alpha);
    }

    // lora
    translate(TTGO_LORA_POS) {
        ttgo_lora(alpha);
    }

    // pins
    for (i = [0 : len(TTGO_PIN_POS)-1]) {
        point=TTGO_PIN_POS[i];
        translate(point) {
            ttgo_pins(alpha);
        }
    }

    // GPS antena
    translate(TTGO_GPS_POS) {
        ttgo_gps(alpha);
    }

    // display
    translate(DISPLAY_POS) {
        display(alpha);
    }
    
    // board
    translate(TTGO_BOARD_POS) {
        ttgo_board(alpha);
    }
}



//ttgo();
