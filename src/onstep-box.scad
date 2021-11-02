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


if($preview)
    let($show_threads = true)
        translate([31, 50, 13.25]) {
          rotate([0, 0, 90]) {
            pcb(ramps_pcb);
          }
        }
        arduino(MEGA2560);
