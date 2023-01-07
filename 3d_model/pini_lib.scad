/**
* @file     pini_lib.scad
* @brief    Small library developed to be used with OpenScad.
* @version  1.2
* @date     30 Nov 2022
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
 * Easy minkowsky that keeps the original size of a cube.
 * @param cubeSize Size of the main cube.
 * @param radius Radius of the corners.
 * @param nFaces Number of faces for the corners.
 * @param isSphere Should be a sphere, if not then use a cylinder. (Optional)
 * @param rotation Rotation of the secondary object. Only used if isSphere==true. (Optional)
 */


FIX_Z_FIGHTING = 0.01;


/**
 * Easy minkowsky that keeps the original size of a cube.
 * @param cubeSize Size of the cube.
 * @param radius Radius of the corners.
 * @param nFaces Number of faces for the corners. (Optional)
 * @param isSphere True uses a sphere, false uses a cylinder.
 */
module minkowskiEasy_cube(cubeSize, radius, nFaces=64, isSphere=true, rotation=[0,0,0]) {
    if (isSphere) {
        minkowski() {
            //Minkowski size fix
            matx=cubeSize.x - radius*2; 
            maty=cubeSize.y - radius*2;
            matz=cubeSize.z - radius*2;
            
            // body with minkowski adjustments
            cube([matx,maty,matz], center=true);

            // corners
            sphere(r=radius, $fn=nFaces);
        }
    }
    else {
        rotate(rotation) {
            minkowski() {
                //Minkowski size fix
                matx=cubeSize.x - radius*2; 
                maty=cubeSize.y - radius*2;
                matz=cubeSize.z/2;
                
                // body with minkowski adjustments
                cube([matx,maty,matz], center=true);

                // corners
                cylinder(h=matz, r=radius, $fn=nFaces, center=true);
            }
        }
    }
}

/**
 * Easy minkowsky that keeps the original size of a cylinder.
 * @param cyHeight Size of the main cylinder.
 * @param cyRadius Radius of the main cylinder.
 * @param radiusCorner Radius of the corners.
 * @param nFaces Number of faces for the corners. (Optional)
 */
module minkowskiEasy_cylinder(cyHeight, cyRadius, radiusCorner, nFaces=64) {
    minkowski() {
        //Minkowski size fix
        radius=cyRadius - radiusCorner; 
        height=cyHeight - radiusCorner*2;
        
        // body with minkowski adjustments
        cylinder(h=height, r1=radius, r2=radius, $fn=nFaces, center=true);

        // corners
        sphere(r=radiusCorner, $fn=nFaces);
    }
}

/**
 * Isosceles triangle, taken from: Thejollymreaper youtube channel.
 * Video link: https://www.youtube.com/watch?v=QcQJvNeJat0
 * @param side Side size.
 * @param tall Triangle tall height at the center.
 * @param cornerRadius Corner radius to create rounded corner.
 * @param cornerFaces Number for corner faces.
 * @param height Thickness of the triangle.
 * @param center Center objects vertically.
 */
module triangle(side, tall, cornerRadius, cornerFaces, thickness, center=false) {
    translate([0, cornerRadius, 0])
    hull() {
        translate([side/2 - cornerRadius, 0, 0])
        cylinder(h=thickness, r=cornerRadius, $fn=cornerFaces, center=center);

        translate([-side/2 + cornerRadius, 0, 0])
        cylinder(h=thickness, r=cornerRadius, $fn=cornerFaces, center=center);

        translate([0, tall-cornerRadius*2, 0])
        cylinder(h=thickness, r=cornerRadius, $fn=cornerFaces, center=center);
    }
}


/**
 * Create a screw hole at position.
 * @param position Origin is at the center of the lower face of the screw, with the screw pointing up.
 * @param screwBodyTunnel_size Lenght of the tunnel for the screw body.
 * @param screwBodyTunnel_radius Radius of the tunnel screw body.
 * @param screwBodyTunnel_faces Number of faces for the tunnel screw body.
 * @param screwHead_size Lenght of the in between portion, where the head will sit.
 * @param screwHeadTunnel_size Leght of the tunnel at the head side of the screw.
 * @param screwHead_radiusAtBody Radius of the screw at body.
 * @param screwHead_radius Radius of the screw at head.
 * @param screwHead_faces Number of faces for the tunnel head screw.
 */
module screwHole(
    position,
    screwBodyTunnel_size, screwBodyTunnel_radius, screwBodyTunnel_faces,
    screwHead_size, screwHeadTunnel_size, screwHead_radiusAtBody, screwHead_radius, screwHead_faces
) {
    translate(position) {
        union() {
            // screw tunnel
            translate([0, 0, screwHead_size])
            rotate([0, 0, 45])
            cylinder(h=screwBodyTunnel_size, r=screwBodyTunnel_radius, $fn=screwBodyTunnel_faces);

            // head
            translate([0, 0, FIX_Z_FIGHTING])
            cylinder(h=screwHead_size, r1=screwHead_radius, r2=screwHead_radiusAtBody, $fn=screwHead_faces);

            // head tunnel
            translate([0, 0, FIX_Z_FIGHTING*2])
            rotate([0, 180, 0])
            cylinder(h=screwHeadTunnel_size, r=screwHead_radius, $fn=screwHead_faces);
        }
    }
}