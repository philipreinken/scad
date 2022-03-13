$fn = 72;

DIAMETER_HEAD = 15;
DIAMETER_LEG_TOP = 9;
DIAMETER_LEG_BOTTOM = 7;

THICKNESS_HEAD = 3;
THICKNESS_LEG = 2;

HEIGHT_LEG = 15;

FILE_LOGO="";

module head() {
    cylinder(h=THICKNESS_HEAD, d=DIAMETER_HEAD);
}

module leg() {
    intersection () {
        for (angle = [0, 90]) {
            translate([0, 0, HEIGHT_LEG / 2])
                rotate([0, 0, angle])
                    cube([DIAMETER_HEAD, THICKNESS_LEG, HEIGHT_LEG], true);
        }
        cylinder(h=(THICKNESS_HEAD + HEIGHT_LEG), d1=DIAMETER_LEG_TOP, d2=DIAMETER_LEG_BOTTOM);
    }
}

module logo() {
    translate([-DIAMETER_HEAD / 2, -DIAMETER_HEAD / 2, 0])
        resize([DIAMETER_HEAD, DIAMETER_HEAD, 0])
            linear_extrude(height=0.6, convexity=3, center=true)
                import(FILE_LOGO, convexity=3);
}

module plug() {
    head();
    leg();
}

difference() {
    plug();
    if (FILE_LOGO != "") {
        logo();
    }
}