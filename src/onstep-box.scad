include <NopSCADlib/lib.scad>;
include <OpenSCAD-Arduino-Mounting-Library/arduino.scad>;

preview = true;

ramps_pcb = [
    "ramps_pcb",
    "RAMPS v1.5",
    101.608, 60.19, 1.6,
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
  101.608, 70, 1.6,
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
    [91, 8, 0, "rj45"],
    [91, 24, 0, "rj45"],
    [91, 40, 0, "rj45"],
    [91, 56, 0, "rj45"],
  ]
];

module boards() {
  translate([26, 85, 26]) {
    rotate([0, 0, 90]) {
      pcb(onstep_ramps_shield);
    }
  }
  translate([31, 50, 13.25]) {
    rotate([0, 0, 90]) {
      pcb(ramps_pcb);
    }
  }
  arduino(MEGA2560);
}

if (preview) {
  boards();
}
