include <BOSL/constants.scad>
use <BOSL/metric_screws.scad>

include <NopSCADlib/vitamins/inserts.scad>
use <NopSCADlib/vitamins/insert.scad>

include <./cg5-tripod-leg-clamp.scad>

DIMENSIONS_FLIRC_CASE = [65.8, 93.6, 28.5];

FLIRC_CASE_BRACKET_LENGTH = 15;

module countersunk_screw() {
    union() {
        cylinder(d=DIAMETER_COUNTERSINK_HOLE, h=HEIGHT_COUNTERSINK_HOLE);
        translate([0, 0, HEIGHT_COUNTERSINK_HOLE]) {
            cylinder(d=DIAMETER_SCREW_HOLE, h=THICKNESS_CLAMP * 4);
        }
    }
}

module pi_holder_box() {
    difference() {
        let (
            dim = DIMENSIONS_FLIRC_CASE, toff = THICKNESS_CLAMP, off = toff * 2,
            x = dim.x, y = dim.y, z = dim.z
        ) {
            translate([toff, toff, toff]) {
                cube([x, y, z]);
            }
            cube([x + off, y + off, z + off]);
        }
    }
}

module pi_holder_box_holes() {
    let (
        dim = DIMENSIONS_FLIRC_CASE, toff = THICKNESS_CLAMP, off = toff * 2,
        x = dim.x, y = dim.y, z = dim.z
    ) {
        translate([off, -$h, toff]) {
            cube([x - off, y + off + $h * 2, z + toff + $h * 2]);
        }
        translate([-$h, FLIRC_CASE_BRACKET_LENGTH, toff]) {
            cube([x + off + $h * 2, y + off - FLIRC_CASE_BRACKET_LENGTH * 2, z + toff + $h * 2]);
        }
        translate([toff, -toff, toff]) {
            cube([x, y + off + $h * 2, z]);
        }
        translate([dim.x / 2 + toff, dim.y / 2 + toff, HEIGHT_COUNTERSINK_HOLE + 2]) {
            rotate([90, 0, 0]) {
                translate([0, RADIUS_LEG + HEIGHT_SADDLE, -HEIGHT_CLAMP_GRIP / 2]) {
                    clamp_saddle_holes() {
                        countersunk_screw();
                    }
                }
            }
        }
    }
}

module pi_holder_box_assy() {
    difference() {
        pi_holder_box();
        pi_holder_box_holes();
    }
}

pi_holder_box_assy();