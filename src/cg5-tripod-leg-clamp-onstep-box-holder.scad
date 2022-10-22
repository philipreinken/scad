$fn = 72;
$h = 0.01;

include <BOSL/constants.scad>
use <BOSL/metric_screws.scad>

include <NopSCADlib/vitamins/inserts.scad>
use <NopSCADlib/vitamins/insert.scad>

include <./cg5-tripod-leg-clamp-variables.scad>
include <./onstep-box.scad>

SHOW_LID = false;
SHOW_HOUSING = false;

module onstep_box_holder_bar() {
    resize([0, 0, THICKNESS_CLAMP]) {
        intersection() {
            cube([HOUSING_DIMENSIONS.x + HOUSING_THICKNESS, WIDTH_SADDLE, HOUSING_THICKNESS]);
            translate([(HOUSING_DIMENSIONS.x + HOUSING_THICKNESS) / 2, (HOUSING_DIMENSIONS.y + HOUSING_LENGTH_ADD -1) / 2, 0]) {
                translate(-OFFSET_ARDUINO_HOUSING) {
                    translate(-OFFSET_ORIGIN_HOUSING) {
                        housing_base();
                    }
                }
            }
        }
    }
}

module onstep_box_holder_saddle() {
    translate([(HOUSING_DIMENSIONS.x + HOUSING_THICKNESS) / 2 - WIDTH_SADDLE / 2, 0, 0]) {
        cube([WIDTH_SADDLE, WIDTH_SADDLE, HEIGHT_CLAMP_GRIP / 2]);
    }
}

module countersunk_screw() {
    // Move into base class
    union() {
        cylinder(d=DIAMETER_COUNTERSINK_HOLE, h=HEIGHT_COUNTERSINK_HOLE);
        translate([0, 0, HEIGHT_COUNTERSINK_HOLE]) {
            cylinder(d=DIAMETER_SCREW_HOLE, h=THICKNESS_CLAMP * 4);
        }
    }
}

module onstep_box_holder_holes() {
    translate([(HOUSING_DIMENSIONS.x + HOUSING_THICKNESS) / 2, WIDTH_SADDLE / 2, 0]) {
        // Move into base class
        for (translation_vector = [[-WIDTH_SADDLE / 3 + insert_hole_radius(SCREW_TYPE), 0, 0], [WIDTH_SADDLE / 3 - insert_hole_radius(SCREW_TYPE), 0, 0]]) {
            translate(translation_vector) {
                countersunk_screw();
            }
        }
    }
}

difference() {
    union() {
        onstep_box_holder_bar();
        onstep_box_holder_saddle();
    }
    onstep_box_holder_holes();
}