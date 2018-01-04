$fn=72; // Decent curves please.

tubeDiameter = 16;
tubeRadius = tubeDiameter/2;

coverDiameter = tubeDiameter*3;
coverRadius = coverDiameter/2;

coverHeight = tubeDiameter/3;

module base() {
    cylinder(d=coverDiameter, h=coverHeight/3);
    translate([0, 0, coverHeight/3-0.001])
        cylinder(coverHeight*(2/3), d1=coverDiameter, d2=coverDiameter*(2/3), true);
}

module tube() {
    cylinder(d=tubeDiameter, h=coverHeight);
}

module cutout() {
    tube();
    translate([-tubeRadius, 0, 0]) cube([tubeDiameter, coverRadius, coverHeight]);
}

module cover() {
    difference() {
        base();
        translate([0, 0, -coverHeight/2])
            scale([1, 1, 2])
                cutout();
    }
}

module sled() {
    intersection() {
        difference() {
            cutout();
            translate([0, 0, -coverHeight/2]) scale([1.005, 1.005, 2]) tube();
        }
        base();
    }
}

module nubsie() {
    translate([0, coverRadius/2, coverHeight/2])
        scale([0.5, 1, 1])
            rotate([0, 45, 0])
                cube([coverHeight/2, coverRadius, coverHeight/2], true);
}

module nubsies() {
    difference() {
        intersection() {
            scale([1.001, 1.001, 1.001])    
                base();
            union() {
                translate([tubeRadius, 0, 0]) nubsie();
                translate([-tubeRadius, 0, 0]) nubsie();
            }
        }
        scale([1.005, 1.005, 1]) tube();
    }
}

translate([-coverRadius, 0, 0]) difference() {
    cover();
    nubsies();
}

translate([tubeRadius+5, 0, 0]) union() {
    sled();
    nubsies();
}
