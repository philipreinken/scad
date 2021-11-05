include <NopSCADlib/lib.scad>;
include <OpenSCAD-Arduino-Mounting-Library/arduino.scad>;

DEBUG = false;

SCREW_INSERT_TYPE = F1BM3;

HOUSING_THICKNESS = 1.6;
HOUSING_PADDING = 5;
MOUNTING_STANDOFF_HEIGHT = HOUSING_THICKNESS + insert_length(SCREW_INSERT_TYPE);

RJ45_DIMENSIONS = [12, 20, 10];
ARDUINO_DIMENSIONS = [101.6, 53.34, 1.6];
RAMPS_DIMENSIONS = [101.6, 60.19, 1.6];
ONSTEP_SHIELD_DIMENSIONS = [115.45, 66, 1.6];

OFFSET_ARDUINO = [5, 0, MOUNTING_STANDOFF_HEIGHT];
OFFSET_ARDUINO_RAMPS = [OFFSET_ARDUINO.x + 31, OFFSET_ARDUINO.y + 50, OFFSET_ARDUINO.z + 13.25];
OFFSET_RAMPS_ONSTEP_SHIELD = [OFFSET_ARDUINO_RAMPS.x -3, OFFSET_ARDUINO_RAMPS.y + 42, OFFSET_ARDUINO_RAMPS.z + 12.75];

HOUSING_DIMENSIONS = [
  2 * HOUSING_THICKNESS + 2 * HOUSING_PADDING + ONSTEP_SHIELD_DIMENSIONS.x + OFFSET_RAMPS_ONSTEP_SHIELD.x,
  2 * HOUSING_THICKNESS + 2 * HOUSING_PADDING + ONSTEP_SHIELD_DIMENSIONS.y,
  2 * HOUSING_THICKNESS + 2 * HOUSING_PADDING + MOUNTING_STANDOFF_HEIGHT + OFFSET_RAMPS_ONSTEP_SHIELD.z + RJ45_DIMENSIONS.z,
];

ramps_pcb = [
    "ramps_pcb",
    "RAMPS v1.5",
    RAMPS_DIMENSIONS.x, RAMPS_DIMENSIONS.y, RAMPS_DIMENSIONS.z,
    0,
    0,
    0,
    "Gray",
    false,
    [],
    [
        [1, 8, 180, "gterm35", 4],
        [96, 3, 0, "2p54header", 4, 2],
        [78, 3, 0, "2p54header", 5, 2],
        [62, 3, 0, "2p54header", 4, 2],
        [45, 4, 0, "2p54header", 4, 3],
        [100, 37, 90, "2p54header", 18, 1],
        [96, 37, 90, "-2p54header", 18, 2],
        [78, 59, 0, "-2p54header", 8, 1],
    ],
    []
];

onstep_ramps_shield = [
  "onstep_ramps_shield",
  "onstep-ramps-shield v1.0.5",
  ONSTEP_SHIELD_DIMENSIONS.x, ONSTEP_SHIELD_DIMENSIONS.y, ONSTEP_SHIELD_DIMENSIONS.z,
  3,
  0,
  0,
  "Green",
  false,
  [],
  [
    [10, 4, 0, "-2p54socket", 4, 3],
    [27, 3, 0, "-2p54socket", 4, 2],
    [43, 3, 0, "-2p54socket", 5, 2],
    [61, 3, 0, "-2p54socket", 4, 2],
    [65, 37, 90, "-2p54socket", 18, 1],
    [105, 8, 0, "rj45"],
    [105, 24, 0, "rj45"],
    [105, 40, 0, "rj45"],
    [105, 56, 0, "rj45"],
  ]
];

module boards() {
  union() {
    translate(OFFSET_RAMPS_ONSTEP_SHIELD) {
      rotate([0, 0, 90]) {
        pcb(onstep_ramps_shield);
      }
    }
    translate(OFFSET_ARDUINO_RAMPS) {
      rotate([0, 0, 90]) {
        pcb(ramps_pcb);
      }
    }
    translate(OFFSET_ARDUINO) {
      rotate([0, 0, 0]) {
        arduino(MEGA2560);
      }
    }
  }
}

module mounting_standoffs(boardType, type, height) {
  translate([OFFSET_ARDUINO.x, OFFSET_ARDUINO.y, 0]) {
    holePlacement(boardType) {
      insert_boss(type, MOUNTING_STANDOFF_HEIGHT, 2);
    }
  }
}

module bounding_box() {
  translate([-HOUSING_PADDING -HOUSING_THICKNESS, -HOUSING_PADDING -HOUSING_THICKNESS, 0]) {
    cube([HOUSING_DIMENSIONS.y, HOUSING_DIMENSIONS.x, HOUSING_DIMENSIONS.z]);
  }
}

if (DEBUG) {
  boards();
  // bounding_box();
}

mounting_standoffs(MEGA2560, F1BM3, MOUNTING_STANDOFF_HEIGHT);

cube([ONSTEP_SHIELD_DIMENSIONS.y, ONSTEP_SHIELD_DIMENSIONS.x + OFFSET_RAMPS_ONSTEP_SHIELD.x, ONSTEP_SHIELD_DIMENSIONS.z]);
