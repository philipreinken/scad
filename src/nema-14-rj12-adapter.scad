$fn = 72;
$t = 0.05;
$l = 100;

include <BOSL/constants.scad>
use <BOSL/metric_screws.scad>
use <BOSL/nema_steppers.scad>

include <NopSCADlib/vitamins/inserts.scad>
use <NopSCADlib/vitamins/insert.scad>

// Thickness of the bracket.
THICKNESS = 5;

// Use heatfit inserts to mount the connector board.
USE_INSERT = true;

// Either NEMA-11, -14, -17, -23 or -34.
NEMA_MOTOR_SIZE = 14;

// Metric screw diameter used for mounting the connector PCB. Choose one of the ones available as a heatfit insert type in NopSCADlib.
SCREW_TYPE = F1BM3;
SCREW_DIAMETER = SCREW_TYPE[4];

// Size of the connector to be used.
CONNECTOR_DIMENSIONS = [15.7, 20.5, 15];

// Specific to https://www.sparkfun.com/products/14021
SPARKFUN_BREAKOUT_DIMENSIONS = [21.6, 20.7, 1.55];
SPARKFUN_BREAKOUT_MOUNTING_HOLE_POSITIONS = [
    [SPARKFUN_BREAKOUT_DIMENSIONS.x - 2.9, 2.9, 0],
    [SPARKFUN_BREAKOUT_DIMENSIONS.x - 2.9, SPARKFUN_BREAKOUT_DIMENSIONS.x - 2.9, 0],
];
SPARKFUN_BREAKOUT_CABLE_DUCT_DIMENSIONS = [SPARKFUN_BREAKOUT_DIMENSIONS.x - 6.25, 2.8, $l];
SPARKFUN_BREAKOUT_CABLE_DUCT_POSITION = [0, SPARKFUN_BREAKOUT_DIMENSIONS.y - 2.8, -$l / 2];

module motor_base_holes() {
    translate([nema_motor_screw_spacing(NEMA_MOTOR_SIZE) / 2, -nema_motor_screw_spacing(NEMA_MOTOR_SIZE) / 2, 0]) {
        nema_mount_holes(size=NEMA_MOTOR_SIZE, depth=$l, l=0);
    }
}

module motor_base() {
    difference() {
        hull() {
            translate([0, 0, 0]) {
                cylinder(d=nema_motor_screw_size(NEMA_MOTOR_SIZE) * 2, h=THICKNESS);
            }
            translate([nema_motor_screw_spacing(NEMA_MOTOR_SIZE), 0, 0]) {
                cylinder(d=nema_motor_screw_size(NEMA_MOTOR_SIZE) * 2, h=THICKNESS);
            }
            translate([- nema_motor_screw_size(NEMA_MOTOR_SIZE), CONNECTOR_DIMENSIONS.z, 0]) {
                cube([nema_motor_screw_spacing(NEMA_MOTOR_SIZE) + nema_motor_screw_size(NEMA_MOTOR_SIZE) * 2, THICKNESS, THICKNESS]);
            }
        }
        motor_base_holes();
    }
}

module sparkfun_board_holes() {
    for(hole = SPARKFUN_BREAKOUT_MOUNTING_HOLE_POSITIONS) {
        translate(hole) {
            if (USE_INSERT) {
                insert_hole(SCREW_TYPE);
            } else {
                metric_bolt(size=SCREW_DIAMETER, shank=THICKNESS, pitch=0, align="shank");
            }
        }
    }
    translate(SPARKFUN_BREAKOUT_CABLE_DUCT_POSITION) {
        cube(SPARKFUN_BREAKOUT_CABLE_DUCT_DIMENSIONS);
    }
}

module sparkfun_board(holes=false) {
    if (holes) {
        sparkfun_board_holes();
    } else {
        difference() {
            cube(SPARKFUN_BREAKOUT_DIMENSIONS);
            sparkfun_board_holes();
        }
    }
}

module connector_base_holes() {
    translate([(nema_motor_screw_spacing(NEMA_MOTOR_SIZE) - SPARKFUN_BREAKOUT_DIMENSIONS.x) / 2, CONNECTOR_DIMENSIONS.y + THICKNESS + SCREW_DIAMETER, 0]) {
        mirror([0, -1, 0]) {
            sparkfun_board(true);
        }
    }
}

module connector_base() {
    difference() {
        hull() {
            translate([-nema_motor_screw_size(NEMA_MOTOR_SIZE), 0, 0]) {
                cube([nema_motor_screw_spacing(NEMA_MOTOR_SIZE) + nema_motor_screw_size(NEMA_MOTOR_SIZE) * 2, THICKNESS, THICKNESS]);
            }
            translate([0, CONNECTOR_DIMENSIONS.y + THICKNESS + SCREW_DIAMETER, 0]) {
                cylinder(d=SCREW_DIAMETER * 2, h=THICKNESS);
            }
            translate([nema_motor_screw_spacing(NEMA_MOTOR_SIZE), CONNECTOR_DIMENSIONS.y + THICKNESS + SCREW_DIAMETER, 0]) {
                cylinder(d=SCREW_DIAMETER * 2, h=THICKNESS);
            }
        }
        connector_base_holes();
    }
}

module assembly() {
    motor_base();
    translate([0, CONNECTOR_DIMENSIONS.z, THICKNESS]) {
        rotate([270, 0, 0]) {
            connector_base();
        }
    }
}

assembly();