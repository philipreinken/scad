/* Image size: 256px*256px */

$fn=72;

size=60;
thickness=2.4;
inner=size-thickness*2;

module photo() {
    rotate([90, 0, 0])
        translate([size/2, size/2 , 0])
            scale([size*0.004, size*0.004, thickness/(size*2)])
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

lamp();
