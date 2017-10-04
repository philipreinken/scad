text = "Bitte keine Werbung einwerfen";
fontsize = 72;

union() {
    difference() {
        minkowski() {
            c(len(text));
            cylinder(r=15, h=10);
        }
        t(text, fontsize);
    }
}

module c(width) {
    translate([0, -fontsize/2, 0])
        cube([width*fontsize*0.65, fontsize*2, 10]);
}

module t(t, s = 18, style = "") {
    translate([12, 0, 5])
        rotate([0, 0, 0])
            linear_extrude(height = fontsize)
                text(t, size = s, font = str("Liberation Sans", style), $fn = 16);
}

echo(version=version());