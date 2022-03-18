$fn = 256;
$play = 0.01;

include <BOSL/constants.scad>
use <BOSL/threading.scad>
use <BOSL/metric_screws.scad>

TOLERANCE_THREAD = -50 * $play;
TOLERANCE_BUSHING = -40 * $play;
WALL_THICKNESS = 4;

DIAMETER_THREAD = 42 + TOLERANCE_THREAD; // At least with my printer, the thread is too wide to be screwed into an actual M42-thread, therefore the tolerance
HEIGHT_THREAD = 5.5;
PITCH_THREAD = 1;

DIAMETER_BUSHING = 50.75 + TOLERANCE_BUSHING;
DIAMETER_BUSHING_BUMPER = DIAMETER_BUSHING + 2 * 0.4;
HEIGHT_BUSHING = 16; // Typically longer -> 23.8mm
HEIGHT_BUSHING_BUMPER = 2.4;

module thread () {
    trapezoidal_threaded_rod(d=DIAMETER_THREAD, l=HEIGHT_THREAD, pitch=PITCH_THREAD, thread_angle=15, center=false);
}

module bushing_bumper() {
    translate([0, 0, HEIGHT_THREAD])
        cylinder(d=DIAMETER_BUSHING_BUMPER, h=HEIGHT_BUSHING_BUMPER);
}

module bushing() {
    translate([0, 0, HEIGHT_THREAD + HEIGHT_BUSHING_BUMPER])
        cylinder(d=DIAMETER_BUSHING, h=HEIGHT_BUSHING);
}

module assembly() {
    difference() {
        thread();
        translate([0, 0, -$play])
            cylinder(d=(DIAMETER_THREAD - WALL_THICKNESS), h=(HEIGHT_THREAD + 2 * $play));
    }
    difference() {
        bushing_bumper();
        translate([0, 0, HEIGHT_THREAD - $play])
            cylinder(d1=(DIAMETER_THREAD - WALL_THICKNESS), d2=(DIAMETER_BUSHING - WALL_THICKNESS), h=(HEIGHT_BUSHING_BUMPER + 2 * $play));
    }
    difference() {
        bushing();
        translate([0, 0, HEIGHT_THREAD + HEIGHT_BUSHING_BUMPER - $play])
            cylinder(d=(DIAMETER_BUSHING - WALL_THICKNESS), h=(HEIGHT_BUSHING + 2 * $play));
    }
}

assembly();
