$fn = 72;
$h = 0.01;

include <NopSCADlib/vitamins/inserts.scad>
use <NopSCADlib/vitamins/insert.scad>

include <./cg5-tripod-leg-clamp-variables.scad>

module clamp_grip_ring() {
    difference() {
        cylinder(r=RADIUS_LEG + THICKNESS_CLAMP, h=HEIGHT_CLAMP_GRIP);
        translate([0, 0, -$h]) {
            cylinder(r=RADIUS_LEG, h=HEIGHT_CLAMP_GRIP + $h * 2);
        }
    }
}

module clamp_grip_angle() {
    rotate([0, 0, ANGLE_CLAMP_GRIP]) {
        translate([0, 0, -$h]) {
            cube([RADIUS_LEG + THICKNESS_CLAMP, RADIUS_LEG + THICKNESS_CLAMP, HEIGHT_CLAMP_GRIP + $h * 2]);
        }
    }
}

module clamp_grip_angle_ends() {
    AK = (RADIUS_LEG + THICKNESS_CLAMP / 2) * cos(ANGLE_CLAMP_GRIP);
    GK = (RADIUS_LEG + THICKNESS_CLAMP / 2) * sin(ANGLE_CLAMP_GRIP);

    for (translation_vector = [[AK, GK, 0], [-AK, GK, 0]]) {
        translate(translation_vector) {
            cylinder(d=THICKNESS_CLAMP, h=HEIGHT_CLAMP_GRIP);
        }
    }
}

module clamp_grip() {
    difference() {
        clamp_grip_ring();
        for (mirror_vector = [[0, 0, 0], [1, 0, 0]]) {
            mirror(mirror_vector) {
                clamp_grip_angle();
            }
        }
    }
    clamp_grip_angle_ends();
}

module clamp_saddle_holes() {
    for (translation_vector = [[-WIDTH_SADDLE / 3 + insert_hole_radius(SCREW_TYPE), 0, HEIGHT_CLAMP_GRIP / 2], [WIDTH_SADDLE / 3 - insert_hole_radius(SCREW_TYPE), 0, HEIGHT_CLAMP_GRIP / 2]]) {
        translate(translation_vector) {
            translate([0, -RADIUS_LEG -HEIGHT_SADDLE, 0]) {
                rotate([90, 0, 0]) {
                    children(0);
                }
            }
        }
    }
}

module clamp_saddle() {
    difference() {
        translate([-WIDTH_SADDLE / 2, -RADIUS_LEG -HEIGHT_SADDLE, 0]) {
            cube([WIDTH_SADDLE, RADIUS_LEG + HEIGHT_SADDLE, HEIGHT_CLAMP_GRIP]);
        }
        translate([0, 0, -$h]) {
            cylinder(r=RADIUS_LEG + THICKNESS_CLAMP, h=HEIGHT_CLAMP_GRIP + $h * 2);
        }
        clamp_saddle_holes() {
            insert_hole(SCREW_TYPE);
        }
    }
}