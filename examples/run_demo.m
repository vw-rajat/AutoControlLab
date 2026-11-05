% AUTOCONTROLLAB DEMO
% Run from the repository root.
addpath(genpath(fullfile(pwd, "src")));

p.mass_kg = 1600;
p.wheelRadius_m = 0.31;
p.dragCoefficient = 0.29;
p.frontalArea_m2 = 2.2;
p.airDensity_kgpm3 = 1.225;
p.rollingResistance = 0.012;

in.wheelTorque_Nm = 1200;
in.vehicleSpeed_mps = 15;
in.grade_rad = 0;

plant = vehicleLongitudinalDynamics(in, p);
pedals = driverDemand(35, 0);
limitedTorque = torqueLimiter(320, -150, 250, 0.9);
socAfterOneHour = batterySocEstimator(0.75, 8, 3600, 60);

fprintf("Vehicle acceleration: %.3f m/s^2\n", plant.acceleration_mps2);
fprintf("Accelerator demand: %.2f\n", pedals.accelDemand);
fprintf("Limited torque: %.1f Nm\n", limitedTorque);
fprintf("SOC after one hour at 8 A discharge: %.1f %%\n", 100*socAfterOneHour);
