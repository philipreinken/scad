$fn=72;
radius=17.5;
fontsize=10;

color([0.3,0.3,0.3,1]) union() {
    difference() {
        body();
        slits();
        logo();
    }   
    bumps();
}

module logo() {
    mirror() translate([-radius+2, -fontsize/2, 0]) linear_extrude((radius/10)-1) text("ADM", fontsize);
}

module body() {
    difference() {
        cylinder(r=radius, h=radius*0.75);
        cylinder(r=radius-radius/20, h=radius);
    }
    cylinder(r=radius+1, h=radius/10);
}     

module bumps() {
    translate([radius-0.25, radius/10, (radius*0.75-radius/10)])
        rotate([90, 0, 0])
            cylinder(r=radius/30, h=radius/5);

    translate([-radius+0.25, radius/10, (radius*0.75-radius/10)])
        rotate([90, 0, 0])
            cylinder(r=radius/30, h=radius/5);

    translate([-radius/10, radius-0.25, (radius*0.75-radius/10)])
        rotate([0, 90, 0])
            cylinder(r=radius/30, h=radius/5);

    translate([-radius/10, -radius+0.25, (radius*0.75-radius/10)])
        rotate([0, 90, 0])
            cylinder(r=radius/30, h=radius/5);
}

module slits() {
    translate([sin(45)*radius, sin(45)*radius, radius/10])
        cylinder(r=radius/10, h=radius);
    translate([-sin(45)*radius, -sin(45)*radius, radius/10])
        cylinder(r=radius/10, h=radius);
    translate([sin(45)*radius, -sin(45)*radius, radius/10])
        cylinder(r=radius/10, h=radius);
    translate([-sin(45)*radius, sin(45)*radius, radius/10])
        cylinder(r=radius/10, h=radius);
}