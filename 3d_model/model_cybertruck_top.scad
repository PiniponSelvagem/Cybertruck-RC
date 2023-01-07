/**
* @file     model_cybertruck_top.scad
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


/**
 * Cybertruck model, top part.
 */
module cybertruck_top() {
    difference() {
        t_mainCubeTop();

        t_cutTopFront();
        t_cutTopBack();
        t_cutTopSide(true);
        t_cutTopSide(false);

        t_cutMidSide(true);
        t_cutMidSide(false);

        t_cutBottomSide(true);
        t_cutBottomSide(false);

        t_cutBottomBack();
        t_cutBottomFront();
        t_cutBottomFrontSide(true);
        t_cutBottomFrontSide(false);

        t_cutBottomFrontLower();
        t_cutBottomFrontLowerSide(true);
        t_cutBottomFrontLowerSide(false);

        t_cutBottomLowerBack();
        t_cutBottomLowerBackSide(true);
        t_cutBottomLowerBackSide(false);

        t_cutWindShield();
        t_cutTrunk();
        t_cutWindowSide(true);
        t_cutWindowSide(false);

        t_cutFloor();
        t_cutWheelsFront();
        t_cutWheelsBack();

        t_cutTailLights();
        t_cutHeadLights();
    }
}






WINDOW_POLY_EXTRUDE = 2.2;
module t_sideWindow() {
    linear_extrude(height=WINDOW_POLY_EXTRUDE)
    polygon(points=[[0.8,1], [1.60,10], [40.8,18], [100, 1.2]], paths=[[0,1,2], [0,2,3]]);
}

TAILLIGHT_CUT_DEPTH = 10;
TAILLIGHT_CUT_WIDTH = 60;
TAILLIGHT_CUT_HEIGHT = 3;
module t_cutTailLights() {
    translate([-100.15, 0, 6])
    cube([TAILLIGHT_CUT_DEPTH, TAILLIGHT_CUT_WIDTH, TAILLIGHT_CUT_HEIGHT], center=true);
}

HEADLIGHT_CUT_DEPTH = 10;
HEADLIGHT_CUT_WIDTH = 40.8;
HEADLIGHT_CUT_HEIGHT = 2;
HEADLIGHT_CUT_SIDE_DEPTH = 10;
HEADLIGHT_CUT_SIDE_WIDTH = 15;
HEADLIGHT_CUT_SIDE_HEIGHT = 2;
module t_cutHeadLights_side() {
    // side
    translate([89.9, 24, -4.95])
    rotate([10, 0, 42.5])
    translate([0.2, -0.5, 0])
    rotate([0, -7, 0])
    cube([HEADLIGHT_CUT_SIDE_DEPTH, HEADLIGHT_CUT_SIDE_WIDTH, HEADLIGHT_CUT_SIDE_HEIGHT], center=true);
}

module t_cutHeadLights() {
    difference() {
        union() {
            // front
            translate([94.6, 0, -6])
            cube([HEADLIGHT_CUT_DEPTH, HEADLIGHT_CUT_WIDTH, HEADLIGHT_CUT_HEIGHT], center=true);

            // side left
            t_cutHeadLights_side();

            // side right
            mirror([0, 1, 0])
            t_cutHeadLights_side();
        }

        // front
        translate([94.6, 0, -6-HEADLIGHT_CUT_HEIGHT])
        cube([HEADLIGHT_CUT_DEPTH+HEADLIGHT_CUT_SIDE_DEPTH, HEADLIGHT_CUT_WIDTH, HEADLIGHT_CUT_HEIGHT], center=true);
    }
}




module t_mainCubeTop() {
    translate([-5, 0, -8])
    cube([220, 80, 75], center=true);
}

module t_cutTopFront() {
    // windshield
    translate([50, 0, 38])
    rotate([0, 18.45, 0])
    cube([93.8, 90, 50], center=true);

    // hood
    translate([107.5, 0, 19.72])
    rotate([0, 15, 0])
    cube([30, 90, 50], center=true);
}

module t_cutTopBack() {
    translate([-50, 0, 42.2])
    rotate([0, -7.99, 0])
    cube([140, 90, 50], center=true);
}

module t_cutTrunk() {
    translate([0, 0, -0.6])
    translate([-71.4, 0, 40])
    rotate([0, 90-3.6, 0])
    rotate([0, 0, 45]) {
        cylinder(h=64.4, r1=40, r2=33, $fn=4, center=true);
    }
}

// isLeft if true is the driver side
module t_cutTopSide(isLeft) {
    cutCube = [240, 20, 70];
    cutCubeCenter = true;

    translation = [0, 41, 8.8];
    rotation = [21.8, 0, -1.15];

    if (isLeft) {
        translate(translation)
        rotate(rotation)
        cube(cutCube, center=cutCubeCenter);
    }
    else {
        translate([translation.x, -translation.y, translation.z])
        rotate([-rotation.x, rotation.y, -rotation.z])
        cube(cutCube, center=cutCubeCenter);
    }
}

// isLeft if true is the driver side
module t_cutMidSide(isLeft) {
    cutCube = [240, 20, 70];
    cutCubeCenter = true;

    translation = [0, 41, -20];
    rotation = [-3, 0, 0.15];

    if (isLeft) {
        translate(translation)
        rotate(rotation)
        cube(cutCube, center=cutCubeCenter);
    }
    else {
        translate([translation.x, -translation.y, translation.z])
        rotate([-rotation.x, rotation.y, -rotation.z])
        cube(cutCube, center=cutCubeCenter);
    }
}

// isLeft if true is the driver side
module t_cutBottomSide(isLeft) {
    cutCube = [95, 20, 70];
    cutCubeCenter = true;

    translation = [0, 41, -20.5];
    rotation = [-23, 0, 0.40];

    if (isLeft) {
        translate(translation)
        rotate(rotation)
        cube(cutCube, center=cutCubeCenter);
    }
    else {
        translate([translation.x, -translation.y, translation.z])
        rotate([-rotation.x, rotation.y, -rotation.z])
        cube(cutCube, center=cutCubeCenter);
    }
}

module t_cutBottomBack() {
    translate([-126.5, 0, -20])
    rotate([0, 82, 0])
    cube([80, 90, 50], center=true);
}

module t_cutBottomFront() {
    translate([120.8, 0, -20])
    rotate([0, -82.5, 0])
    cube([80, 90, 50], center=true);
}

// isLeft if true is the driver side
module t_cutBottomFrontSide(isLeft) {
    // matching front
    cutCube = [30, 40, 70];
    cutCubeCenter = true;

    translation = [99.2, 41, -20];
    rotation = [0, -1, 41.5];

    if (isLeft) {
        translate(translation)
        rotate(rotation)
        cube(cutCube, center=cutCubeCenter);
    }
    else {
        translate([translation.x, -translation.y, translation.z])
        rotate([-rotation.x, rotation.y, -rotation.z])
        cube(cutCube, center=cutCubeCenter);
    }


    // matching back
    cutCube2 = [30, 40, 70];
    cutCubeCenter2 = true;

    translation2 = [97.52, 41, -20];
    rotation2 = [0, 3, 45.5];

    if (isLeft) {
        translate(translation2)
        rotate(rotation2)
        cube(cutCube2, center=cutCubeCenter2);
    }
    else {
        translate([translation2.x, -translation2.y, translation2.z])
        rotate([-rotation2.x, rotation2.y, -rotation2.z])
        cube(cutCube2, center=cutCubeCenter2);
    }
}

module t_cutBottomFrontLower() {
    translate([106, 0, -18.3])
    rotate([0, 35, 0])
    cube([20, 90, 100], center=true);
}

// isLeft if true is the driver side
module t_cutBottomFrontLowerSide(isLeft) {
    // matching front
    cutCube = [30, 40, 70];
    cutCubeCenter = true;

    translation = [99.2, 41, -18.3];
    rotation = [0, 35, 45.5];

    if (isLeft) {
        translate(translation)
        rotate(rotation)
        cube(cutCube, center=cutCubeCenter);
    }
    else {
        translate([translation.x, -translation.y, translation.z])
        rotate([-rotation.x, rotation.y, -rotation.z])
        cube(cutCube, center=cutCubeCenter);
    }
}

module t_cutBottomLowerBack() {
    // inner back wall
    translate([-108.3, 0, -39])
    rotate([0, 0, 0])
    cube([20, 90, 50], center=true);

    // top angle
    translate([-110.5, 0, -38])
    rotate([0, 5, 0])
    cube([20, 90, 50], center=true);
}

// isLeft if true is the driver side
module t_cutBottomLowerBackSide(isLeft) {
    // matching front
    cutCube = [20, 50, 50];
    cutCubeCenter = true;

    translation = [-99, 38, -39.15];
    rotation = [5, 0, 100];

    if (isLeft) {
        translate(translation)
        rotate(rotation)
        cube(cutCube, center=cutCubeCenter);
    }
    else {
        translate([translation.x, -translation.y, translation.z])
        rotate([-rotation.x, rotation.y, -rotation.z])
        cube(cutCube, center=cutCubeCenter);
    }
}

// isLeft if true is the driver side
module t_cutWindowSide(isLeft) {
    translation = [-33, 32, 8.8];
    rotation = [109, 3.2, 0];

    if (isLeft) {
        translate(translation)
        rotate(rotation)
        t_sideWindow();
    }
    else {
        mirror([0,1,0])
        translate(translation)
        rotate(rotation)
        t_sideWindow();
    }
}

module t_cutWindShield() {
    translate([0, 0, -0.4])
    translate([45, 0, 39.8])
    rotate([0, -77.3, 0])
    rotate([0, 0, 45]) {
        cylinder(h=60, r1=40, r2=31.5, $fn=4, center=true);
    }
}


module t_cutFloor() {
    // front
    translate([100, 0, -36])
    rotate([0, 0, 0])
    cube([40, 80, 40], center=true);

    // mid
    translate([0, 0, -43.9])
    cube([220, 80, 40], center=true);

    // back
    translate([-100, 0, -36.2])
    rotate([0, 5, 0])
    cube([40, 80, 40], center=true);
}

module t_cutWheelsFront() {
    // front front
    translate([70.8, 0, -22.70])
    rotate([0, 57.3, 0])
    translate([-1.5, 0, 2.9])
    cube([22.1, 80, 30], center=true);

    // front top
    translate([65.6, 0, -19.84])
    rotate([0, 2.35, 0])
    translate([0.05, 0, 2.9])
    cube([25.3, 80, 30], center=true);

    // front back
    translate([63.6, 0, -19.9])
    rotate([0, -59.8, 0])
    translate([0.70, 0, 2.8])
    cube([20.6, 80, 30], center=true);

    // front back bottom vertical
    translate([54.20, 0, -34.2])
    rotate([0, 0, 0])
    cube([21.6, 80, 30], center=true);
}

module t_cutWheelsBack() {
    // back front vertical
    translate([-54.2, 0, -33.2])
    rotate([0, 0, 180])
    cube([21.6, 80, 30.4], center=true);

    // back front
    translate([-63.7, 0, -19.7])
    rotate([0, -56.4, 180])
    translate([0, 0, 2.9])
    cube([19.6, 80, 30], center=true);

    // back top
    translate([-66.7, 0, -16.50])
    rotate([0, 0.5, 0])
    cube([24.8, 80, 30], center=true);

    // back back
    translate([-68.5, 0, -18.65])
    rotate([0, 54.9, 180])
    translate([6.9, 0, 3.45])
    cube([30, 80, 30], center=true);
}


