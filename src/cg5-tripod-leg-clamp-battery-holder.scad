$fn = 72;
$h = 0.01;

include <BOSL/constants.scad>
use <BOSL/metric_screws.scad>

include <NopSCADlib/vitamins/inserts.scad>
use <NopSCADlib/vitamins/insert.scad>

include <./cg5-tripod-leg-clamp.scad>

THICKNESS_BATTERY_HOLDER = THICKNESS_CLAMP;

WIDTH_BATTERY_HOLDER_LIP = 7;
WIDTH_BATTERY_HOLDER_LIP_BOTTOM = WIDTH_BATTERY_HOLDER_LIP + 1;

WIDTH_BATTERY = 80;
LENGTH_BATTERY = 40;
HEIGHT_BATTERY = 135;

module battery_holder_box() {
    difference() {
        cube([WIDTH_BATTERY + THICKNESS_BATTERY_HOLDER * 2, LENGTH_BATTERY + THICKNESS_BATTERY_HOLDER * 2, HEIGHT_BATTERY + THICKNESS_BATTERY_HOLDER * 2]);
        translate([THICKNESS_BATTERY_HOLDER, THICKNESS_BATTERY_HOLDER, THICKNESS_BATTERY_HOLDER]) {
            cube([WIDTH_BATTERY, LENGTH_BATTERY, HEIGHT_BATTERY]);
        }
    }
}

module battery_holder_saddle() {
    translate([WIDTH_BATTERY / 2 - WIDTH_SADDLE / 2 + THICKNESS_BATTERY_HOLDER, LENGTH_BATTERY + THICKNESS_BATTERY_HOLDER * 2, 0]) {
        cube([WIDTH_SADDLE, THICKNESS_BATTERY_HOLDER, HEIGHT_BATTERY / 2 + THICKNESS_BATTERY_HOLDER]);
    }
}

module countersunk_screw() {
    union() {
        cylinder(d=DIAMETER_COUNTERSINK_HOLE, h=HEIGHT_COUNTERSINK_HOLE);
        translate([0, 0, HEIGHT_COUNTERSINK_HOLE]) {
            cylinder(d=DIAMETER_SCREW_HOLE, h=THICKNESS_BATTERY_HOLDER * 4);
        }
    }
}

module battery_holder_holes() {
    translate([WIDTH_BATTERY / 2 + THICKNESS_BATTERY_HOLDER, LENGTH_BATTERY + THICKNESS_BATTERY_HOLDER - $h, HEIGHT_BATTERY / 2]) {
        for (translation_vector = [[-WIDTH_SADDLE / 3 + insert_hole_radius(SCREW_TYPE), 0, 0], [WIDTH_SADDLE / 3 - insert_hole_radius(SCREW_TYPE), 0, 0]]) {
            translate(translation_vector) {
                rotate([270, 0, 0]) {
                    countersunk_screw();
                }
            }
        }
    }
    translate([WIDTH_BATTERY / 2 + THICKNESS_BATTERY_HOLDER, LENGTH_BATTERY + THICKNESS_BATTERY_HOLDER - $h, THICKNESS_BATTERY_HOLDER * 2]) {
        for (translation_vector = [[-WIDTH_SADDLE / 3 + insert_hole_radius(SCREW_TYPE), 0, 0], [WIDTH_SADDLE / 3 - insert_hole_radius(SCREW_TYPE), 0, 0]]) {
            translate(translation_vector) {
                rotate([270, 0, 0]) {
                    countersunk_screw();
                }
            }
        }
    }
}

module battery_holder() {
    difference() {
        union () {
            battery_holder_box();
            battery_holder_saddle();
        }
        translate([-$h, -$h, (HEIGHT_BATTERY + THICKNESS_BATTERY_HOLDER * 2) / 2 - $h]) {
            cube([WIDTH_BATTERY + THICKNESS_BATTERY_HOLDER * 2 + $h * 2, LENGTH_BATTERY + THICKNESS_BATTERY_HOLDER * 2 + $h * 2, HEIGHT_BATTERY + THICKNESS_BATTERY_HOLDER * 2 + $h * 2]);
        }
        translate([THICKNESS_BATTERY_HOLDER + WIDTH_BATTERY_HOLDER_LIP, - $h, THICKNESS_BATTERY_HOLDER + WIDTH_BATTERY_HOLDER_LIP]) {
            cube([WIDTH_BATTERY - WIDTH_BATTERY_HOLDER_LIP * 2, THICKNESS_BATTERY_HOLDER + $h * 2, HEIGHT_BATTERY]);
        }
        translate([THICKNESS_BATTERY_HOLDER + WIDTH_BATTERY_HOLDER_LIP_BOTTOM, THICKNESS_BATTERY_HOLDER + WIDTH_BATTERY_HOLDER_LIP_BOTTOM / 2, -$h]) {
            cube([WIDTH_BATTERY - WIDTH_BATTERY_HOLDER_LIP_BOTTOM * 2, LENGTH_BATTERY - WIDTH_BATTERY_HOLDER_LIP_BOTTOM, THICKNESS_BATTERY_HOLDER + $h * 2]);
        }
        battery_holder_holes();
    }
}

battery_holder();