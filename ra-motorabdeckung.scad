$fn=72; // Decent curves please.

cover_width=50;
cover_depth=70;
cover_height=40;

cover_thickness=2;

ra_radius=35;

axis_offset=sqrt((ra_radius*ra_radius)-((cover_width/2)*(cover_width/2)));

module ra_axis () {
    translate([cover_width/2, cover_depth+axis_offset, 0])
        color([0, 0, 0, 0.2])
            cylinder(r=ra_radius, h=100);
}

module ra_box () {
    difference() {
        cube([cover_width, cover_depth, cover_height]);
        translate([cover_thickness, cover_thickness, 0]) cube([cover_width-cover_thickness*2, cover_depth, cover_height-cover_thickness]);
    }
}

module ra_cover () {
    union () {
        difference() {
            ra_box();
            ra_axis();
        }
    }
}

color([0.3, 0.3, 0.3, 1])
    ra_cover();