$fn = 72;
$t = 0.05; // Tolerance helper variable

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

// Length of the motor mounting slots. Needed for belt tensioning/tolerance.
NEMA_MOTOR_SLIDE_RANGE = 8;

// Metric screw diameter used for mounting the bracket. For the GSO 2" focuser it's M3.
SCREW_TYPE = F1BM3;
SCREW_DIAMETER = SCREW_TYPE[4];

// Dimensions of the center pressure adjustment screw.
GSO_PRESSURE_SCREW_DIAMETER = 10;
GSO_PRESSURE_SCREW_LENGTH = 14.5;

// Dimensions of the M3 countersink holes.
GSO_COUNTERSINK_HOLE_DIAMETER = 5.95;
GSO_COUNTERSINK_HOLE_LENGTH = 3.1;

// Positions of the 4 screws holding the axle assembly.
GSO_HOLE_POSITIONS = [
    [0, 0, 0],
    [16.9, 0, 0],
    [0, 33.95, 0],
    [16.9, 33.95, 0],
];

// Distance between the leftmost screw hole and the coarse focuser knob.
GSO_HOLE_FOCUSER_KNOB_OFFSET = 46.3;
GSO_HOLE_FOCUSER_Z_OFFSET = 6;

// Dimensions of the focuser axle.
GSO_AXLE_DIAMETER = 4.15;
GSO_AXLE_LENGTH = 141;
GSO_AXLE_Z_OFFSET = -14.2 + GSO_AXLE_DIAMETER / 2;

// Additional tolerance for the recess needed to accomodate the coarse focuser knob.
GSO_KNOBS_TOLERANCE = $t * 50;

// Measurements / distances of the focuser knobs.
GSO_COARSE_KNOB_DIAMETER = 39.85 + GSO_KNOBS_TOLERANCE;
GSO_COARSE_KNOB_LENGTH = 14.6;
GSO_COARSE_KNOB_DISTANCE = 95.5;

GSO_FINE_KNOB_DIAMETER = 27.05 + GSO_KNOBS_TOLERANCE;
GSO_FINE_KNOB_LENGTH = 12;

// Distance from screw hole center to the edge of the bracket.
PADDING = nema_motor_screw_size(NEMA_MOTOR_SIZE) * 1.5;

module motor_base_holes() {
    translate([nema_motor_screw_spacing(NEMA_MOTOR_SIZE) / 2, -nema_motor_screw_spacing(NEMA_MOTOR_SIZE) / 2, 0]) {
        nema_mount_holes(size=NEMA_MOTOR_SIZE, depth=THICKNESS * 4, l=NEMA_MOTOR_SLIDE_RANGE);
    }
}

module motor_base() {
    difference() {
        hull() {
            translate([0, -NEMA_MOTOR_SLIDE_RANGE, 0]) {
                cylinder(r=PADDING, h=THICKNESS);
            }
            translate([nema_motor_screw_spacing(NEMA_MOTOR_SIZE), -NEMA_MOTOR_SLIDE_RANGE, 0]) {
                cylinder(r=PADDING, h=THICKNESS);
            }
            translate([-PADDING, THICKNESS * 2, 0]) {
                cube([nema_motor_screw_spacing(NEMA_MOTOR_SIZE) + PADDING * 2, THICKNESS, THICKNESS]);
            }
        }
        motor_base_holes();
    }
}

module gso_base_holes() {
    translate([(nema_motor_screw_spacing(NEMA_MOTOR_SIZE) - GSO_HOLE_POSITIONS[3].x) / 2, 0, 0]) {
        for(hole = GSO_HOLE_POSITIONS) {
            translate([hole.x, hole.y, hole.z + THICKNESS + $t]) {
                screw(screwsize=SCREW_DIAMETER, screwlen=THICKNESS * 4, headsize=get_metric_bolt_head_size(SCREW_DIAMETER) + $t * 20, countersunk=true);
            }
        }
        translate([GSO_HOLE_POSITIONS[3].x / 2, GSO_HOLE_POSITIONS[3].y / 2, -$t]) {
            translate([0, 0, 0.5]) {
                cylinder(d1=GSO_PRESSURE_SCREW_DIAMETER * 1.5, d2=GSO_PRESSURE_SCREW_DIAMETER * 3, h=THICKNESS - 0.5 + $t * 2);
            }
            cylinder(d=GSO_PRESSURE_SCREW_DIAMETER * 1.5, h=0.5 + $t * 2);
        }
    }
}

module gso_base_countersink() {
    translate([(nema_motor_screw_spacing(NEMA_MOTOR_SIZE) - GSO_HOLE_POSITIONS[3].x) / 2, 0, 0]) {
        for(hole = GSO_HOLE_POSITIONS) {
            translate([hole.x, hole.y, hole.z - GSO_COUNTERSINK_HOLE_LENGTH - GSO_HOLE_FOCUSER_Z_OFFSET]) {
                cylinder(d=GSO_COUNTERSINK_HOLE_DIAMETER - $t * 8, h=GSO_COUNTERSINK_HOLE_LENGTH);
            }
            translate([hole.x, hole.y, hole.z - GSO_HOLE_FOCUSER_Z_OFFSET]) {
                cylinder(d=GSO_COUNTERSINK_HOLE_DIAMETER * 1.25, h=GSO_HOLE_FOCUSER_Z_OFFSET);
            }
        }
    }
}

module gso_base() {
    difference() {
        union() {
            hull() {
                translate([GSO_HOLE_POSITIONS[2].x, GSO_HOLE_POSITIONS[2].y, GSO_HOLE_POSITIONS[2].z]) {
                    cylinder(r = PADDING, h = THICKNESS);
                }
                translate([nema_motor_screw_spacing(NEMA_MOTOR_SIZE), GSO_HOLE_POSITIONS[3].y, GSO_HOLE_POSITIONS[3].z]) {
                    cylinder(r = PADDING, h = THICKNESS);
                }
                translate([- PADDING, - PADDING, 0]) {
                    cube([nema_motor_screw_spacing(NEMA_MOTOR_SIZE) + PADDING * 2, THICKNESS, THICKNESS]);
                }
            }
            gso_base_countersink();
        }
        gso_base_holes();
    }
}

module bridge() {
    hull() {
        translate([-PADDING, -$t, 0]) {
            cube([nema_motor_screw_spacing(NEMA_MOTOR_SIZE) + PADDING * 2, $t, THICKNESS]);
        }
        translate([-PADDING, THICKNESS + PADDING - GSO_HOLE_FOCUSER_KNOB_OFFSET, 0]) {
            cube([nema_motor_screw_spacing(NEMA_MOTOR_SIZE) + PADDING * 2, $t, THICKNESS]);
        }
    }
}

module gso_knobs() {
    translate([(nema_motor_screw_spacing(NEMA_MOTOR_SIZE) + PADDING * 2) / 2 - GSO_AXLE_DIAMETER, -GSO_HOLE_FOCUSER_KNOB_OFFSET + GSO_AXLE_LENGTH - GSO_FINE_KNOB_LENGTH, GSO_AXLE_Z_OFFSET]) {
        rotate([90, 0, 0]) {
            union() {
                cylinder(d=GSO_AXLE_DIAMETER, h=GSO_AXLE_LENGTH);
                translate([0, 0, 0]) {
                    cylinder(d=GSO_COARSE_KNOB_DIAMETER, h=GSO_COARSE_KNOB_LENGTH);
                }
                translate([0, 0, GSO_COARSE_KNOB_LENGTH + GSO_COARSE_KNOB_DISTANCE - GSO_KNOBS_TOLERANCE]) {
                    cylinder(d=GSO_COARSE_KNOB_DIAMETER, h=GSO_COARSE_KNOB_LENGTH + GSO_KNOBS_TOLERANCE);
                }
                translate([0, 0, GSO_COARSE_KNOB_LENGTH + GSO_COARSE_KNOB_DISTANCE + GSO_COARSE_KNOB_LENGTH + $t * 20]) {
                    cylinder(d=GSO_FINE_KNOB_DIAMETER, h=GSO_FINE_KNOB_LENGTH);
                }
            }
        }
    }
}

difference() {
    translate([0, 0, GSO_HOLE_FOCUSER_Z_OFFSET]) {
        union() {
            translate([0, PADDING, 0]) {
                gso_base();
            }
            translate([0, PADDING - GSO_HOLE_FOCUSER_KNOB_OFFSET, THICKNESS * 3]) {
                rotate([270, 0, 0]) {
                    motor_base();
                }
            }
            bridge();
        }
    }
    #gso_knobs();
}
