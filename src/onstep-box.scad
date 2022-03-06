include <NopSCADlib/lib.scad>;
include <NopSCADlib/printed/printed_box.scad>;
include <NopSCADlib/vitamins/pcb.scad>;

include <OpenSCAD-Arduino-Mounting-Library/arduino.scad>;

DEBUG = false;
SHOW_LID = true;
SHOW_HOUSING = true;

SCREW_INSERT_TYPE = F1BM3;

HOUSING_THICKNESS = 1.6;
HOUSING_WIDTH_ADD = 10;
HOUSING_LENGTH_ADD = 2;
HOUSING_HEIGHT_ADD = 30;

MOUNTING_STANDOFF_HEIGHT = HOUSING_THICKNESS + insert_length(SCREW_INSERT_TYPE);

RJ45_DIMENSIONS = [12, 20, 10];
ARDUINO_DIMENSIONS = [53.34, 101.6, 1.6];
RAMPS_DIMENSIONS = [60.19, 101.6, 1.6];
ONSTEP_SHIELD_DIMENSIONS = [66, 115.45, 1.6];

OFFSET_ORIGIN_ARDUINO = [0, 0, 0];
OFFSET_ORIGIN_RAMPS = [RAMPS_DIMENSIONS.x / 2, RAMPS_DIMENSIONS.y / 2, 0];
OFFSET_ORIGIN_ONSTEP_SHIELD = [ONSTEP_SHIELD_DIMENSIONS.x / 2, ONSTEP_SHIELD_DIMENSIONS.y / 2, 0];

OFFSET_ARDUINO = [0, 8, MOUNTING_STANDOFF_HEIGHT];
OFFSET_ARDUINO_RAMPS = [OFFSET_ARDUINO.x, OFFSET_ARDUINO.y, OFFSET_ARDUINO.z + 13.25];
OFFSET_ARDUINO_ONSTEP_SHIELD = [OFFSET_ARDUINO_RAMPS.x - 6, OFFSET_ARDUINO_RAMPS.y + 35, OFFSET_ARDUINO_RAMPS.z + 12.75];

HOUSING_DIMENSIONS = [
  max(ARDUINO_DIMENSIONS.x, RAMPS_DIMENSIONS.x, ONSTEP_SHIELD_DIMENSIONS.x) + max(abs(OFFSET_ARDUINO.x), abs(OFFSET_ARDUINO_RAMPS.x), abs(OFFSET_ARDUINO_ONSTEP_SHIELD.x)) + HOUSING_WIDTH_ADD,
  max(ARDUINO_DIMENSIONS.y, RAMPS_DIMENSIONS.y, ONSTEP_SHIELD_DIMENSIONS.y) + max(abs(OFFSET_ARDUINO.y), abs(OFFSET_ARDUINO_RAMPS.y), abs(OFFSET_ARDUINO_ONSTEP_SHIELD.y)) + HOUSING_LENGTH_ADD,
  max(ARDUINO_DIMENSIONS.z, RAMPS_DIMENSIONS.z, ONSTEP_SHIELD_DIMENSIONS.z) + max(abs(OFFSET_ARDUINO.z), abs(OFFSET_ARDUINO_RAMPS.z), abs(OFFSET_ARDUINO_ONSTEP_SHIELD.z)) + HOUSING_HEIGHT_ADD,
];

OFFSET_ORIGIN_HOUSING = [HOUSING_DIMENSIONS.x / 2, HOUSING_DIMENSIONS.y / 2, 0];
OFFSET_ARDUINO_HOUSING = [OFFSET_ARDUINO_ONSTEP_SHIELD.x - HOUSING_WIDTH_ADD, 0, 0];

ramps_pcb = [
    "ramps_pcb",
    "RAMPS v1.5",
    RAMPS_DIMENSIONS.x, RAMPS_DIMENSIONS.y, RAMPS_DIMENSIONS.z,
    0,
    0,
    0,
    "SteelBlue",
    false,
    [],
    [
        [RAMPS_DIMENSIONS.x - 10, 0, 270, "gterm508", 4],
        [RAMPS_DIMENSIONS.x - 3, 96, 90, "2p54header", 4, 2],
        [RAMPS_DIMENSIONS.x - 3 ,78, 90, "2p54header", 5, 2],
        [RAMPS_DIMENSIONS.x - 3, 62, 90, "2p54header", 4, 2],
        [RAMPS_DIMENSIONS.x - 4, 45, 90, "2p54header", 4, 3],
        [RAMPS_DIMENSIONS.x - 36, 100, 180, "2p54header", 18, 1],
        [RAMPS_DIMENSIONS.x - 36, 96, 180, "-2p54header", 18, 2],
        [RAMPS_DIMENSIONS.x - 58, 78, 90, "-2p54header", 8, 1],
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
    [ONSTEP_SHIELD_DIMENSIONS.x - 4, 10, 90, "-2p54socket", 4, 3],
    [ONSTEP_SHIELD_DIMENSIONS.x - 3, 27, 90, "-2p54socket", 4, 2],
    [ONSTEP_SHIELD_DIMENSIONS.x - 3, 43, 90, "-2p54socket", 5, 2],
    [ONSTEP_SHIELD_DIMENSIONS.x - 3, 61, 90, "-2p54socket", 4, 2],
    [ONSTEP_SHIELD_DIMENSIONS.x - 36, 65, 180, "-2p54socket", 18, 1],
    [ONSTEP_SHIELD_DIMENSIONS.x - 8, 105, 90, "rj45"],
    [ONSTEP_SHIELD_DIMENSIONS.x - 24, 105, 90, "rj45"],
    [ONSTEP_SHIELD_DIMENSIONS.x - 40, 105, 90, "rj45"],
    [ONSTEP_SHIELD_DIMENSIONS.x - 56, 105, 90, "rj45"],
  ]
];

housing = pbox(
  name = "housing",
  wall = HOUSING_THICKNESS,
  top_t = HOUSING_THICKNESS,
  base_t = HOUSING_THICKNESS,
  radius = 4,
  size = HOUSING_DIMENSIONS,
  screw = M3_cap_screw
);

module arduino_board() {
  translate(OFFSET_ORIGIN_ARDUINO) {
    arduino(MEGA2560);
  }
}

module ramps_pcb_board() {
  translate(OFFSET_ORIGIN_RAMPS) {
    pcb(ramps_pcb);
  }
}

module onstep_ramps_shield_board() {
  translate(OFFSET_ORIGIN_ONSTEP_SHIELD) {
    pcb(onstep_ramps_shield);
  }
}

module boards() {
  union() {
    translate(OFFSET_ARDUINO_ONSTEP_SHIELD) {
      onstep_ramps_shield_board();
    }
    translate(OFFSET_ARDUINO_RAMPS) {
      ramps_pcb_board();
    }
    translate(OFFSET_ARDUINO) {
      arduino_board();
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

module cutouts() {
  union() {
    translate(OFFSET_ORIGIN_ONSTEP_SHIELD) {
      translate(OFFSET_ARDUINO_ONSTEP_SHIELD) {
        // OnStep cutouts
        pcb_cutouts(onstep_ramps_shield);
      }
    }
    translate(OFFSET_ORIGIN_RAMPS) {
      translate(OFFSET_ARDUINO_RAMPS) {
        translate([pcb_component_position(ramps_pcb, "gterm508").x, pcb_component_position(ramps_pcb, "gterm508").y, RAMPS_DIMENSIONS.z]) {
          // RAMPS cutouts
          block([gt_5p08[1] * 4, gt_5p08[2] * 4, gt_5p08[3] * 2]);
        }
      }
    }
    translate(OFFSET_ORIGIN_ARDUINO) {
      translate([OFFSET_ARDUINO.x, 0, OFFSET_ARDUINO.z]) {
        // Arduino cutouts
        components(MEGA2560, USB);
      }
    }
  }
}

module housing() {
  difference() {
    translate([0, HOUSING_DIMENSIONS.y, HOUSING_DIMENSIONS.z + HOUSING_THICKNESS * 2 + eps]) {
      vflip() {
        translate(OFFSET_ARDUINO_HOUSING) {
          translate(OFFSET_ORIGIN_HOUSING) {
            pbox(housing);
          }
        }
      }
    }
    cutouts();
  }
}

module housing_base() {
  translate(OFFSET_ARDUINO_HOUSING) {
    translate(OFFSET_ORIGIN_HOUSING) {
      pbox_base(housing) {
        translate([-HOUSING_DIMENSIONS.x / 2 - OFFSET_ARDUINO_HOUSING.x, -HOUSING_DIMENSIONS.y / 2 - OFFSET_ARDUINO_HOUSING.y, 0]) {
          mounting_standoffs(MEGA2560, F1BM3, MOUNTING_STANDOFF_HEIGHT);
        }
      }
    }
  }
}

if (DEBUG) {
  boards();
  housing_base();

  %render() housing();
  #render() cutouts();
} else {
  if (SHOW_LID) {
    housing_base();
  }

  if (SHOW_HOUSING) {
    translate([SHOW_LID ? HOUSING_DIMENSIONS.x + 20 : 0, 0, 0]) {
      housing();
    }
  }
}
