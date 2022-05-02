$fn = 72;
$t = 0.05;
$l = 100;

include <BOSL/constants.scad>
use <BOSL/metric_screws.scad>
use <BOSL/nema_steppers.scad>

// Thickness of the bracket.
THICKNESS = 4;

// Either NEMA-11, -14, -17, -23 or -34.
NEMA_MOTOR_SIZE = 14;

// Metric screw diameter used for mounting the connector PCB.
SCREW_DIAMETER = 3;

// Size of the connector to be used.
CONNECTOR_DIMENSIONS = [15, 25, 20];

// Specific to https://www.sparkfun.com/products/14021
SPARKFUN_BREAKOUT_DIMENSIONS = [20, 20, 1.5];
SPARKFUN_BREAKOUT_MOUNTING_HOLE_POSITIONS = [
    [SPARKFUN_BREAKOUT_DIMENSIONS.x - 2, 2, $l / 2],
    [SPARKFUN_BREAKOUT_DIMENSIONS.x - 2, SPARKFUN_BREAKOUT_DIMENSIONS.x - 2, $l / 2],
];
SPARKFUN_BREAKOUT_CABLE_DUCT_DIMENSIONS = [SPARKFUN_BREAKOUT_DIMENSIONS.x - 4, 2, $l];
SPARKFUN_BREAKOUT_CABLE_DUCT_POSITION = [0, SPARKFUN_BREAKOUT_DIMENSIONS.y - 2, -$l / 2];

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
            metric_bolt(size=SCREW_DIAMETER, l=$l, pitch=0);
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
    translate([(nema_motor_screw_spacing(NEMA_MOTOR_SIZE) - SPARKFUN_BREAKOUT_DIMENSIONS.x) / 2, CONNECTOR_DIMENSIONS.y + SCREW_DIAMETER * 2, 0]) {
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
            translate([nema_motor_screw_spacing(NEMA_MOTOR_SIZE) / 2 + CONNECTOR_DIMENSIONS.x / 2, CONNECTOR_DIMENSIONS.y + SCREW_DIAMETER * 2, 0]) {
                cylinder(d=SCREW_DIAMETER * 2, h=THICKNESS);
            }
            translate([nema_motor_screw_spacing(NEMA_MOTOR_SIZE) / 2 - CONNECTOR_DIMENSIONS.x / 2, CONNECTOR_DIMENSIONS.y + SCREW_DIAMETER * 2, 0]) {
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