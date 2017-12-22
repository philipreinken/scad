$fn=72; // Decent curves please.

module base() {
    union() {
        cylinder(d=50, h=2);
        translate([0, 0, 2])
            cylinder(5, d1=50, d2=30, true);
    }
}

difference() {
    base();
    translate([0, 0, -10])
        cylinder(d=16, h=20);
    translate([-8, 0, -10])
        cube([16, 32, 20]);
}

translate([-8, 8, 0]) cylinder(d=1.5, h=7);
translate([8, 8, 0]) cylinder(d=1.5, h=7);