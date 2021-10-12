
/**
 * This file applies modifications to the thing:
 * https://www.thingiverse.com/thing:25386
 * so it better suits my dishwasher.
 */

$fn = 72;

module imported_axle() {
  difference() {
    union() {
      import("axle.stl", convexity=10);
    }
    translate([-10, -10, 0]) {
      cube(20);
    }
    translate([0, -10, -10]) {
      cube([4, 10, 10], center=true);
    }
  }
}

module modifiers() {
  union() {
    cylinder(r=4.5, h=11.25, center=false);
    translate([0, 0, 11.25]) {
      cylinder(r=5.1, h=10);
    }
    translate([0, 0, -10]) {
      cube([20, 30, 20], center=true);
    }
  }
}

module axle_base() {
  difference() {
    union() {
      cylinder(d=9.4, h=11.25, center=false);
      translate([0, 0, 11.25]) {
        cylinder(d1=10.2, d2=9, h=2);
      }
    }
    translate([0, 0, -1]) {
      cylinder(d=5.8, h=15);
    }
  }
}

module slots() {
  translate([0, 0, 12]) {
    rotate([0, 0, 45]) {
      cube([2, 14, 10], center=true);
    }
    rotate([0, 0, -45]) {
      cube([2, 14, 10], center=true);
    }
  }
}

module axle() {
  difference() {
    axle_base();
    slots();
  }
}

union() {
  imported_axle();
  axle();
}
