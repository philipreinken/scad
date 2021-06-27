$fn = 72;
$o = .1;

use <tracklib.scad>;
use <trains/track-wooden/track-standard.scad>;

include <NopSCADlib/lib.scad>;
include <MCAD/bearing.scad>;

VIEW_MODE=false;
TEST_MODE=false;

function assembly_diameter() = 150;
function bearing_model() = 608;
function magnet_size() = 5.5;

module turntable_base_ring(diameter) {
  difference() {
    cylinder(h=wood_height(), d=diameter);
    translate([0, 0, -$o])
      cylinder(h=wood_height() + $o*2, d=diameter - wood_plug_neck_length() - wood_plug_radius() * 7);
  }
  translate([0, 0, wood_height() / 2]) {
    cube([diameter, wood_height(), wood_height()], center = true);
    cylinder(h=wood_height(), d=wood_width(), center=true);
  }
}

module bearing_base(model) {
  cylinder(d=bearingDimensions(model)[0] + 3, h=0.75);
  difference() {
    cylinder(d=bearingDimensions(model)[0], h=bearingDimensions(model)[2] + 0.75);
    translate([0, 0, bearingDimensions(model)[2] + 0.75])
      insert_hole(F1BM3);
  }
}

module turntable_base_cutouts(diameter, number) {
  for (angle = [0:(360 / number):360])
    rotate([0, 0, angle])
      translate([diameter / 2, 0, 0]) {
        rotate([180, 180, 0])
          wood_cutout();
        translate([-wood_plug_radius() * 2 -wood_plug_neck_length(), -magnet_size() / 2, wood_well_height() - magnet_size()])
          magnet_hole();
      }
}

module turntable_base() {
  difference() {
    turntable_base_ring(assembly_diameter());
    turntable_base_cutouts(assembly_diameter(), 8);
  }
  translate([0, 0, wood_height()])
    bearing_base(bearing_model());
}

module ramp(length, angle) {
  difference() {
    union() {
      intersection() {
        rotate([0, -angle, 0])
          translate([0, 0, -wood_well_height()])
            wood_track(length=50);
        wood_track(length);
      }
      translate([wood_well_height() / tan(angle), 0, 0])
        wood_track(length - wood_well_height() / tan(angle), bevel_ends=false);
    }
    rotate([0, -angle - 10, 0])
      cube(wood_width());
  }
}

module middle_track() {
  ramp(assembly_diameter() / 2, 15);
  translate([assembly_diameter(), 0, 0])
    mirror([1, 0, 0])
      ramp(assembly_diameter() / 2, 15);
}

module middle_track_bearing_hole() {
  translate([assembly_diameter() / 2, wood_width() / 2, -$o]) {
    bearing(model=bearing_model(), outline=true);
    cylinder(h=bearingDimensions(bearing_model())[2] + 3, d=bearingDimensions(bearing_model())[1] - 6);
  }
}

module middle_track_magnet_holes() {
  translate([wood_plug_radius() + wood_plug_neck_length(), wood_width() / 2 - magnet_size() / 2, -$o])
    scale([1, 1, 1.25])
      magnet_hole();
  translate([assembly_diameter() - wood_plug_radius() * 2 - wood_plug_neck_length(), wood_width() / 2 - magnet_size() / 2, -$o])
    scale([1, 1, 1.25])
      magnet_hole();
}

module middle_track_assembly() {
  difference() {
    middle_track();
    middle_track_bearing_hole();
    middle_track_magnet_holes();
  }
}

module assembly() {
  translate([assembly_diameter() / 2, assembly_diameter() / 2, 0])
    turntable_base();
  translate([0, assembly_diameter() / 2 - wood_width() / 2, wood_height() + 1])
    middle_track_assembly();
}

module magnet_hole() {
  cube(magnet_size());
}

if (VIEW_MODE) {
  !assembly();
} else if (TEST_MODE) {
  bearing_base(bearing_model());
  translate([10, 0, 0])
    difference() {
      cube(magnet_size() * 3);
      translate([magnet_size(), magnet_size(), magnet_size()])
        magnet_hole();
    }
}

middle_track_assembly();
