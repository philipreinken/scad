$fn = 72;

r = 100;
t = 0.9;

translate([0, 0, -10])
  top(r, t);
translate([r * 2 + 10, 0, 0])
  base(r, t);

module top(radius, baseThicknessMultiplier) {
  difference() {
    hollowDome(radius - 0.01, baseThicknessMultiplier);
    base(radius, baseThicknessMultiplier);
    translate([-radius, -radius, -radius * 2 + 10])
        cube(radius*2);
  }
}

module base(radius, baseThicknessMultiplier) {
  union() {
    translate([radius * baseThicknessMultiplier - 15, 0, 0])
      nubsie(15);
    translate([(radius * baseThicknessMultiplier - 15)*-1, 0, 0])
      rotate([0, 0, 180])
        nubsie(15);
    ring(radius, baseThicknessMultiplier);
    latches(radius);
  }
}

module latches(radius) {
  for(x = [90:90:360]) {
    offsetX = (radius - 3) * sin(x) - 10 * cos(x);
    offsetY = (radius - 8) * cos(x) -10 * sin(x);
    echo(offsetX, offsetY);
    translate([offsetX, offsetY, 1])
      rotate([0, 0, x])
        cube([20, 5, 15]);
  }
}

module nubsie(size) {
  difference() {
    union() {
      cylinder(9.99, size, size);
      translate([0, -size, 0])
        cube([size, size*2, 9.99]);
    }
    translate([0, 0, 5.01])
        cylinder(5, size - 3, size - 3);
    translate([0, 0, -0.01])
      cylinder(10.02, 3, 3);
  }
}

module ring(radius, thicknessMultiplier) {
  difference() {
    hollowDome(radius, thicknessMultiplier);
    translate([-radius, -radius, 10])
      cube(radius*2);
  }
}

module hollowDome(radius, thicknessMultiplier) {
    difference() {
    dome(radius);
    translate([0, 0, -0.01])
      scale([thicknessMultiplier, thicknessMultiplier, thicknessMultiplier])
        dome(radius);
    }
}

module dome(radius) {
    difference() {
      sphere(radius);
      translate([-radius, -radius, -radius*2])
        cube(radius*2);
    }
}