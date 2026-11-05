classdef TestAutoControlLab < matlab.unittest.TestCase
    methods (Test)
        function pedalDemandIsNormalised(testCase)
            y = driverDemand(50, 20);
            testCase.verifyEqual(y.accelDemand, 0.5, 'AbsTol', 1e-12);
            testCase.verifyEqual(y.brakeDemand, 0.2, 'AbsTol', 1e-12);
        end

        function pedalOutOfRangeRejected(testCase)
            testCase.verifyError(@() driverDemand(101, 0), 'MATLAB:expectedLessThanOrEqual');
        end

        function torqueIsSaturatedAndDerated(testCase)
            y = torqueLimiter(400, -100, 250, 0.8);
            testCase.verifyEqual(y, 200, 'AbsTol', 1e-12);
        end

        function invalidTorqueLimitsRejected(testCase)
            testCase.verifyError(@() torqueLimiter(0, 20, 10, 1), 'AutoControlLab:InvalidTorqueLimits');
        end

        function longitudinalPlantReturnsFiniteAcceleration(testCase)
            p = testCase.defaultVehicleParameters();
            in.wheelTorque_Nm = 1200;
            in.vehicleSpeed_mps = 15;
            in.grade_rad = 0;
            y = vehicleLongitudinalDynamics(in, p);
            testCase.verifyTrue(isfinite(y.acceleration_mps2));
            testCase.verifyGreaterThan(y.tractiveForce_N, y.aeroDrag_N);
        end

        function uphillGradeIncreasesResistance(testCase)
            p = testCase.defaultVehicleParameters();
            in.wheelTorque_Nm = 0;
            in.vehicleSpeed_mps = 10;
            in.grade_rad = 0;
            flat = vehicleLongitudinalDynamics(in, p);
            in.grade_rad = 0.1;
            uphill = vehicleLongitudinalDynamics(in, p);
            testCase.verifyGreaterThan(uphill.gradeForce_N, flat.gradeForce_N);
            testCase.verifyLessThan(uphill.acceleration_mps2, flat.acceleration_mps2);
        end

        function cruiseControllerRespectsLimits(testCase)
            cfg.Kp = 1; cfg.Ki = 0.2;
            cfg.minAccel_mps2 = -2; cfg.maxAccel_mps2 = 1.5;
            [u, ~] = cruiseController(30, 0, struct(), cfg, 0.1);
            testCase.verifyLessThanOrEqual(u, cfg.maxAccel_mps2);
            testCase.verifyGreaterThanOrEqual(u, cfg.minAccel_mps2);
        end

        function gearSelectionUpshifts(testCase)
            gear = gearSelection(55, 2, [20 50 80], [12 40 65], 4);
            testCase.verifyEqual(gear, 3);
        end

        function gearSelectionDownshifts(testCase)
            gear = gearSelection(35, 3, [20 50 80], [12 40 65], 4);
            testCase.verifyEqual(gear, 2);
        end

        function regenIsLimitedByBatteryPower(testCase)
            y = regenerativeBrakeBlend(1, 100, 200, 1000, 20);
            testCase.verifyEqual(y.regenTorque_Nm, 50, 'AbsTol', 1e-12);
            testCase.verifyEqual(y.frictionTorque_Nm, 200, 'AbsTol', 1e-12);
        end

        function socDecreasesDuringDischarge(testCase)
            y = batterySocEstimator(0.8, 10, 3600, 50);
            testCase.verifyEqual(y, 0.6, 'AbsTol', 1e-12);
        end

        function socIncreasesDuringCharge(testCase)
            y = batterySocEstimator(0.5, -5, 3600, 50);
            testCase.verifyEqual(y, 0.6, 'AbsTol', 1e-12);
        end
    end

    methods (Access = private)
        function p = defaultVehicleParameters(~)
            p.mass_kg = 1600;
            p.wheelRadius_m = 0.31;
            p.dragCoefficient = 0.29;
            p.frontalArea_m2 = 2.2;
            p.airDensity_kgpm3 = 1.225;
            p.rollingResistance = 0.012;
        end
    end
end
