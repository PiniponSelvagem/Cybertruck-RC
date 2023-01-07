/**
* @file     cybertruck_utils.scad
* @brief    CyberTruck utils that contains exported stls for fast rendering and others.
* @version  1.2
* @date     02 Dec 2022
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
 * 3D model used for modeling the cybertruck.
 */
module UTIL_cybertruck_3Dmodel() {
    scale(62)
    rotate([0, 0, 90])
    import("3d-cybertruck.stl");
}

/**
 * Wheel that was exported as STL for fast/easy debug while modeling CyberTruck.
 */
module UTIL_wheel() {
    import("exported/wheel_no_supports.stl");
}

/**
 * CyberTruck top that was exported as STL for fast preview.
 */
module UTIL_top() {
    import("exported/cybertruck_top_preview.stl", convexity=3);
}

/**
 * CyberTruck bottom that was exported as STL for fast preview.
 */
module UTIL_bottom() {
    import("exported/cybertruck_bottom_preview.stl", convexity=3);
}

/**
 * Easy screw creation.
 */
module screw(position) {
    screwHole(
        position,
        SCREW_BODY_TUNNEL_SIZE, SCREW_BODY_TUNNEL_RADIUS, SCREW_BODY_TUNNEL_FACES,
        SCREW_HEAD_SIZE, SCREW_HEAD_TUNNEL_SIZE, SCREW_HEAD_RADIUS_AT_BODY, SCREW_HEAD_RADIUS, SCREW_HEAD_FACES
    );
}