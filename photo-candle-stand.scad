$fn = 72;

size = 100;
bottom_offset = 10;
thickness_wall = 10;

module stand() {
    minkowski() {
        cube(size);
        cylinder(r = size/4, h = size/2);
    }
}

module slope() {
    translate([-size/2, sqrt(size*size*2)+(size-2)/2, -size/3]) rotate([45, 0, 0]) scale([3, 3, 4]) cube(size);
}

module hole() {
    union() {
        translate([thickness_wall, -1, thickness_wall]) scale([1, 1, 1.5]) cube((size*1.5)-thickness_wall*2);
        translate([0, 0, (size*1.5)-thickness_wall]) cube(size*1.5);
    }
    translate([thickness_wall, thickness_wall, thickness_wall*2]) scale([1, 1, 1.5]) cube((size*1.5)-thickness_wall*2);
}

module photo() {
    rotate([90, 0, 0])
        translate([size*0.75, size*0.75, -thickness_wall])
            scale([size*0.00525, size*0.00525, thickness_wall/(size*2)])
                surface("image.png", true, false, 0);
}



union() {
    difference() {
        translate([size/4, size/4, 0]) stand();
        slope();
        hole();
    }
    photo();
}

