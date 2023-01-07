/**
* @file     model_cybertruck_bottom.scad
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
 * Cybertruck model, bottom part.
 */
module cybertruck_bottom() {
    difference() {
        b_mainCubeBottom();

        b_cutFrontBottom();
        b_cutMidBottom();
        b_cutBackBottom();
        b_cutBackBack();

        b_cutFrontTop();
        b_cutFrontSide(true);
        b_cutFrontSide(false);

        b_cutFrontWheel(true);
        b_cutFrontWheel(false);

        b_cutMidTop();
        b_cutMidBottomSide(true);
        b_cutMidBottomSide(false);

        b_cutBackWheel(true);
        b_cutBackWheel(false);

        b_cutBackSide(true);
        b_cutBackSide(false);

        b_cutBackSideBottom(true);
        b_cutBackSideBottom(false);

        b_cutBackTop();
    }

    b_fenderFront_placed();
    mirror([0, 1, 0])
    b_fenderFront_placed();

    b_fenderBack_placed();
    mirror([0, 1, 0])
    b_fenderBack_placed();
}






module b_mainCubeBottom() {
    translate([-5, 0, -15])
    cube([220, 75, 40], center=true);
}

module b_cutFrontBottom() {
    // front
    translate([111.8, 0, -20])
    rotate([0, 113, 0])
    cube([50, 90, 30], center=true);

    // front front bottom
    translate([90, 0, -38.9])
    rotate([0, -10.8, 0])
    cube([50, 90, 30], center=true);

    // front bottom
    translate([64, 0, -42])
    rotate([0, -6.1, 0])
    cube([50, 90, 30], center=true);
}

module b_cutMidBottom() {
    translate([-20, 0, -43.9])
    rotate([0, 0, 0])
    cube([150, 90, 30], center=true);
}

module b_cutBackBottom() {
    translate([-100, 0, -39.3])
    rotate([0, 19, 0])
    cube([50, 90, 30], center=true);
}

module b_cutBackBack() {
    translate([-113.2, 0, -20])
    rotate([0, -10, 0])
    cube([20, 90, 20], center=true);
}

module b_cutFrontTop() {
    //top
    translate([70, 0, -1.3])
    rotate([0, 0, 0])
    cube([80, 90, 30], center=true);

    //keep mid of the inside wheel
    translate([66, 0, -11.9])
    rotate([0, -11, 0])
    cube([44, 33, 16], center=true);
}

// isLeft if true is the driver side
module b_cutFrontSide(isLeft) {
    // matching front
    cutCube = [30, 40, 70];
    cutCubeCenter = true;

    translation = [99.4, 41, -20];
    rotation = [0, 17, 41];

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

    translation2 = [98.6, 40.8, -20];
    rotation2 = [0, 8, 44];

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
    
    // below
    cutCube3 = [2, 40, 10];
    cutCubeCenter3 = true;

    translation3 = [85.5, 30, -26];
    rotation3 = [0, 37, 41];

    if (isLeft) {
        translate(translation3)
        rotate(rotation3)
        cube(cutCube3, center=cutCubeCenter3);
    }
    else {
        translate([translation3.x, -translation3.y, translation3.z])
        rotate([-rotation3.x, rotation3.y, -rotation3.z])
        cube(cutCube3, center=cutCubeCenter3);
    }

    // side
    cutCube4 = [20, 10, 10];
    cutCubeCenter4 = true;

    translation4 = [80, 38.6, -20];
    rotation4 = [-10.2, 0, 0];

    if (isLeft) {
        translate(translation4)
        rotate(rotation4)
        cube(cutCube4, center=cutCubeCenter4);
    }
    else {
        translate([translation4.x, -translation4.y, translation4.z])
        rotate([-rotation4.x, rotation4.y, -rotation4.z])
        cube(cutCube4, center=cutCubeCenter4);
    }

    // side below
    cutCube5 = [20, 10, 10];
    cutCubeCenter5 = true;

    translation5 = [80, 37.6, -25];
    rotation5 = [-35, 0, 0];

    if (isLeft) {
        translate(translation5)
        rotate(rotation5)
        cube(cutCube5, center=cutCubeCenter5);
    }
    else {
        translate([translation5.x, -translation5.y, translation5.z])
        rotate([-rotation5.x, rotation5.y, -rotation5.z])
        cube(cutCube5, center=cutCubeCenter5);
    }
}

// isLeft if true is the driver side
module b_cutFrontWheel(isLeft) {
    cutCube = [37.8, 40, 20];
    cutCubeCenter = true;

    translation = [64.8, 36, -20.5];
    rotation = [0, 0, 0];

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

module b_cutMidTop() {
    translate([45.95, 45, -15])   // center
    translate([0, 0, -8.9])
    rotate([0, 0, 180])
    cube([92.3, 90, 30], center=false);
}

// isLeft if true is the driver side
module b_cutMidBottomSide(isLeft) {
    // side
    cutCube = [100, 10, 10];
    cutCubeCenter = true;

    translation = [0, 35.8, -28];
    rotation = [-20, 0, 0];

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

    // top
    cutCube2 = [100, 10, 10];
    cutCubeCenter2 = true;

    translation2 = [0, 34, -20.4];
    rotation2 = [-20, 0.5, 0];

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

// isLeft if true is the driver side
module b_cutBackWheel(isLeft) {
    cutCube = [39.7, 40, 40];
    cutCubeCenter = true;

    translation = [-66.1, 36.2, -10];
    rotation = [0, 0, 0];

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
module b_cutBackSide(isLeft) {
    cutCube = [50, 20, 40];
    cutCubeCenter = true;

    translation = [-95, 40, -24];
    rotation = [-30, 0, 10];

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
module b_cutBackSideBottom(isLeft) {
    cutCube = [50, 20, 40];
    cutCubeCenter = true;

    translation = [-95, 20, -35];
    rotation = [-90, 19, -21];

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


module b_cutBackTop() {
    // back
    translate([-103.7, 0, -1])
    rotate([0, 5, 0])
    cube([40, 90, 30], center=true);

    // over back wheels
    translate([-68, 0, -5.2])
    rotate([0, 9, 0])
    cube([50, 90, 30], center=true);
}




FENDER_FRONT_EXTRUDE = 0.01;
FENDER_FRONT_HEIGHT_ANGLE = 2.4;
FENDER_FRONT_ANGLE = 2;
module b_fender_front_housing_polygon() {
    polygon(
        points=[  // clockwise starting from bottom left
            [5.3,0.5],     [3.6,0.5],
            [3.6,6.3],     [6.3, 5.9],
            [13.8, 23.83], [15.26, 21.1],
            [38.75,22.8],  [36.8,20.45],
            [47.4,9.3],    [43.7, 9.3]
        ],
        paths=[
            [0,1,2], [0,2,3],
            [3,2,4], [3,4,5],
            [5,4,6], [5,6,7],
            [6,8,7], [7,8,9]
        ]
    );
}
module b_fender_back_housing_polygon() {
    polygon(
        points=[  // clockwise starting from bottom left
            [6.2,0.5],    [3.6,0.5],
            [3.6,7.6],    [6.8, 7.9],
            [14.2, 23.6], [16, 21.1],
            [38.6,23.8],  [37,21.1],
            [49.4,8.4],   [45.9, 8]
        ],
        paths=[
            [0,1,2], [0,2,3],
            [3,2,4], [3,4,5],
            [5,4,6], [5,6,7],
            [6,8,7], [7,8,9]
        ]
    );
}

module b_fender_backFace(isFront, h) {
    if (isFront) {
        linear_extrude(height=h)
        b_fender_front_housing_polygon();
    }
    else {
        linear_extrude(height=h)
        b_fender_back_housing_polygon();
    }
}
module b_fender_frontFace(isFront, h) {
    if (isFront) {
        linear_extrude(height=h)
        polygon(
            points=[  // clockwise starting from bottom left
                [5.7,0.5],
                [5.72,6.05],    [6.3, 5.9],
                [14.97, 21.71], [15.26, 21.1],
                [37.02,21.02],  [36.8,20.45],
                [44.4, 9.5],    [44.28, 9.67]
            ],
            paths=[
                [0,1,2],
                [2,1,3], [2,3,4],
                [4,3,5], [4,5,6],
                [5,7,6], [6,7,8]
            ]
        );
    }
    else {
        linear_extrude(height=h)
        polygon(
            points=[  // clockwise starting from bottom left
                [6.2,0.5],
                [5.9,8],       [6.8, 7.9],
                [15.5, 21.73], [16, 21.1],
                [37.3,21.8],   [37,21.1],
                [46.7, 8],     [45.9, 8]
            ],
            paths=[
                [0,1,2],
                [2,1,3], [2,3,4],
                [4,3,5], [4,5,6],
                [5,7,6], [6,7,8]
            ]
        );
    }
}

module b_fender_removeExcessHull(isFront) {
    if (isFront) {
        h = FENDER_FRONT_EXTRUDE*2 + FENDER_FRONT_HEIGHT_ANGLE*2;
        translate([0, 0, -(h/2)])
        linear_extrude(height=h*2)
        polygon(
            points=[  // clockwise starting from bottom left
                [5.7,0.45], [6.3, 5.9], [15.26, 21.1], [36.8,20.45], [44.5, 8]
            ],
            paths=[
                [0,1,2], [0,2,3], [0,3,4]
            ]
        );
    }
    else {
        h = FENDER_FRONT_EXTRUDE*2 + FENDER_FRONT_HEIGHT_ANGLE*2;
        translate([0, 0, -(h/2)])
        linear_extrude(height=h*2)
        polygon(
            points=[  // clockwise starting from bottom left
                [6.2,0.5], [6.8, 7.9], [16, 21.1], [37,21.1], [46.2, 7.5]
            ],
            paths=[
                [0,1,2], [0,2,3], [0,3,4]
            ]
        );
    }
}

module b_fenderFront_cutBottomAngle() {
    translate([0, 0, -1.5])
    rotate([17, -20, 0])
    cube([10, 10, 5]);
}

// right side (passenger), use mirror for left side (driver)
module b_fenderFront() {
    difference() {
        hull() {
            b_fender_backFace(true, FENDER_FRONT_EXTRUDE);
            translate([0, 0, FENDER_FRONT_HEIGHT_ANGLE])
            rotate([FENDER_FRONT_ANGLE, 0, 0])
            b_fender_frontFace(true, FENDER_FRONT_EXTRUDE);
        }
        b_fender_removeExcessHull(true);

        b_fenderFront_cutBottomAngle();
    }
}

FENDER_FRONT_WALL_THICKNESS = 1;
FENDER_FRONT_WALL_OFFSET = 0.1;
module b_fenderFront_placed() {
    translate([40.1, -30.9, -25.7]) {
        rotate([93, 0, 0])
        b_fenderFront();
        
        // inside section
        extrude=15;
        translate([0, extrude, 0])
        rotate([90, 0, 0]) {
            b_fender_backFace(true, extrude);
            
            translate([0,0,-FENDER_FRONT_WALL_THICKNESS+FENDER_FRONT_WALL_OFFSET])
            hull() {    // back wall
                linear_extrude(FENDER_FRONT_WALL_THICKNESS)
                b_fender_front_housing_polygon();
            }
        }

        e=2;
        translate([0, 2, 0.05])
        rotate([93, 0, 0]) {
            b_fender_backFace(true, e);
        }
    }
}





// right side (passenger), use mirror for left side (driver)
module b_fenderBack() {
    difference() {
        hull() {
            b_fender_backFace(false, FENDER_FRONT_EXTRUDE);
            translate([0, 0, FENDER_FRONT_HEIGHT_ANGLE])
            rotate([FENDER_FRONT_ANGLE, 0, 0])
            b_fender_frontFace(false, FENDER_FRONT_EXTRUDE);
        }
        b_fender_removeExcessHull(false);

        b_fenderFront_cutBottomAngle();
    }
}

FENDER_BACK_WALL_THICKNESS = 1;
FENDER_BACK_WALL_OFFSET = 0.4;
module b_fenderBack_placed() {
    rotate([0, 0, 180])
    translate([40.1, -30.8, -25.7]) {
        rotate([93, 0, 0])
        b_fenderBack();
        
        // inside section
        extrude=15;
        translate([0, extrude, 0])
        rotate([90, 0, 0]) {
            b_fender_backFace(false, extrude);
            
            translate([0,0,-FENDER_BACK_WALL_THICKNESS+FENDER_BACK_WALL_OFFSET])
            hull() {    // back wall
                linear_extrude(FENDER_BACK_WALL_THICKNESS)
                b_fender_back_housing_polygon();
            }
        }

        e=2;
        translate([0, 2, 0.05])
        rotate([93, 0, 0]) {
            b_fender_backFace(false, e);
        }
    }
}