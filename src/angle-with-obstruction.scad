$fn = 72;

/*
 * This part can be used to model an angle constrained by an obstruction.
 *
 * I use it to model ramps which fit halfway under a sliding door to allow
 * a robotic vacuum to drive into rooms with a significant height difference.
 *
 *        / |.       | OBSTRUCTION |
 *        . |    .   |_____________|
 * HEIGHT . |        .              \
 *        . | angle(t)   .          . DISTANCE_OBSTRUCTION_Y
 *        \ |________________.______/
 *          \......../ DISTANCE_OBSTRUCTION_X
 */

HEIGHT = 16.2;
DISTANCE_OBSTRUCTION_X = 12;
DISTANCE_OBSTRUCTION_Y = 8.9;

ANGLE_WIDTH = 100;

function constraint_angle(a, b) = 90 - asin(a / (sqrt(pow(a, 2) + pow(b,2))));

module angle(t) {
    resize([0, HEIGHT, 0], auto=true) {
        polygon([
            [0, 0],
            [0, cos(t)],
            [sin(t), 0]
        ]);
    }
}

rotate([90, 0, 90]) {
    linear_extrude(height = ANGLE_WIDTH) {
        angle(constraint_angle(HEIGHT - DISTANCE_OBSTRUCTION_Y, DISTANCE_OBSTRUCTION_X));
    }
}