# Model assumptions and limitations

## Longitudinal vehicle plant
The plant is a single-degree-of-freedom point-mass model. It includes wheel tractive force, aerodynamic drag, rolling resistance, and road grade. It excludes rotating inertia, driveline efficiency, tyre slip, wind, transient powertrain response, brake dynamics, and road-load parameter variation.

## Driver demand
Pedal inputs are assumed to be already conditioned, valid percentage signals. Sensor diagnostics, debounce, plausibility checks, and redundant-channel handling are not included.

## Torque limiter
The limiter applies hard bounds and a scalar derating factor. It does not implement thermal, voltage, speed, traction, or component-protection maps.

## Cruise controller
A discrete-time PI controller is used. It is a teaching example and is not calibrated for ride comfort, actuator dynamics, safety constraints, or real-vehicle use.

## Gear selection
The strategy changes at most one gear per function call and uses fixed speed thresholds with hysteresis. It does not consider engine speed, torque demand, grade, shift time, clutch protection, or driver mode.

## Regenerative braking
Requested brake torque is split regen-first, then friction. The example does not model axle distribution, ABS/ESC intervention, wheel slip, brake blending transients, motor efficiency maps, or low-temperature battery restrictions beyond a simple charge-power limit.

## Battery SOC
Coulomb counting assumes constant nominal capacity and ideal current measurement. It does not compensate for temperature, ageing, current-sensor offset, open-circuit voltage, or efficiency.
