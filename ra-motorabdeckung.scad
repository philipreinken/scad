$fn=72; // Decent curves please.
$debug=false;

cover_width=83;
cover_depth=96;
cover_height=52;

cover_thickness=2;

connector_radius=10;

gearshaft_radius=10;
gearshaft_offset=28;

ra_radius=45;

axis_offset=sqrt((ra_radius*ra_radius)-((cover_width/2)*(cover_width/2)));

module debug () {
    translate([0, cover_thickness, cover_thickness])
    cube([cover_width, cover_depth, cover_height]);
}

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

module gearshaft () {
    translate([cover_width, cover_depth-gearshaft_offset, gearshaft_offset])
    rotate([-90, 0, 90])
    hull() {
        cylinder(r=gearshaft_radius, h=cover_thickness);
        translate([30, 0, 0]) cylinder(r=gearshaft_radius, h=cover_thickness);
    }
}

module connector () {
    translate([cover_thickness+connector_radius+3, 0, cover_height-connector_radius-cover_thickness-3])
        rotate([-90, 0, 0])
            cylinder(r=connector_radius, h=cover_thickness+1);
}

module ra_cover () {
    union () {
        difference() {
            ra_box();
            ra_axis();
            gearshaft();
            connector();
            if ($debug) {
                debug();
            }
        }
    }
}

color([0.3, 0.3, 0.3, 1])
    ra_cover();