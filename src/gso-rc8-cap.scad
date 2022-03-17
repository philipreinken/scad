$fn = 72;
$play = 0.01;

include <BOSL/constants.scad>
use <BOSL/threading.scad>
use <BOSL/metric_screws.scad>

HEIGHT_CAP = 10;

THICKNESS_CAP_TOP = 3;
THICKNESS_CAP_SIDES = 1.6;

DIAMETER_THREAD = 90;
PITCH_THREAD = 1;

module thread () {
    translate([0, 0, -$play])
        trapezoidal_threaded_rod(d=DIAMETER_THREAD, l=(HEIGHT_CAP - THICKNESS_CAP_TOP + $play), pitch=PITCH_THREAD, thread_angle=15, center=false);
}

module cap () {
    rotate([180, 0, 0])
        difference() {
            cylinder(r=(DIAMETER_THREAD / 2 + THICKNESS_CAP_SIDES), h=HEIGHT_CAP);
            thread();
        }
}

cap();