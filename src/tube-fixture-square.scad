$fn = 72;

include <NopSCADlib/vitamins/inserts.scad>;

use <BOSL/metric_screws.scad>;

USE_MOUNTING_SCREWS=true;
USE_FIXATION_SCREW=true;

rod_radius = 16 / 2;

base_screw_diameter = 4.5;
base_screw_head_diameter = 9;
base_corner_radius = 3;
minimum_base_width = base_screw_head_diameter * 2 + rod_radius * 2 - base_corner_radius * 2;
base_width = 40 - base_corner_radius * 2;
base_depth = base_width;

screw_vectors = [
    [base_width * 0.5, 2, 2],
    [base_width * 0.5, base_width - 2, 2]
];

quad_corner_vectors = [
    [0, 0, 0],
    [1, 0, 0],
    [1, 1, 0],
    [0, 1, 0]
];

assert (base_width >= minimum_base_width, "base_width is too small");

module base() {
    hull() {
        for (pos = quad_corner_vectors * base_width)
            translate(pos)
                cylinder(h=1, r=base_corner_radius);
        translate([base_width * 0.25, base_width * 0.5, rod_radius * 2.5])
            rotate([0, 90, 0])
                cylinder(h=base_width * 0.5, r=rod_radius);
    }
}

module rod() {
    translate([-base_width * 0.25, base_width * 0.5, rod_radius * 1.75])
        rotate([0, 90, 0])
            cylinder(h=base_width * 1.5, r=rod_radius);
}

module screws() {
    for (pos = screw_vectors)
        translate(pos)
            screw(screwsize=base_screw_diameter,screwlen=10,headsize=base_screw_head_diameter,headlen=base_width, align="base");
}

module fixation_screw_insert() {
    translate([base_width * 0.5, base_width * 0.5, rod_radius * 3.5])
        insert_hole(F1BM3);
}

difference() {
    base();
    rod();

    if (USE_MOUNTING_SCREWS) {
        screws();
    }

    if (USE_FIXATION_SCREW) {
        fixation_screw_insert();
    }
}
