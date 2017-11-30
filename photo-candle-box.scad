$fn=72;

size=70;
thickness=2;
inner=size-thickness*2;

module photo() {
    rotate([90, 0, 0])
        translate([size/2, size/2 , -thickness])
            scale([0.33, 0.33, 0.02])
                surface("image.png", true, false, 0);   
}

module hollow_cube() {
    difference() {
        cube(size);
        translate([thickness, -1, thickness*2+1])
            cube([inner, inner+thickness+1, inner]);
    }
}

module lamp() {
    photo();
    hollow_cube();
}

intersection() {
    lamp();
    cube(size);
}
