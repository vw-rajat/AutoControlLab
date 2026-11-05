function out = vehicleLongitudinalDynamics(in, p)
%VEHICLELONGITUDINALDYNAMICS Simple 1-D longitudinal vehicle plant.
% Inputs:
% in.wheelTorque_Nm, in.vehicleSpeed_mps, in.grade_rad
% Parameters: mass_kg, wheelRadius_m, dragCoefficient, frontalArea_m2,
% airDensity_kgpm3, rollingResistance.
% Positive wheel torque propels the vehicle forward. Grade is positive uphill.
requiredIn = {'wheelTorque_Nm','vehicleSpeed_mps','grade_rad'};
requiredP = {'mass_kg','wheelRadius_m','dragCoefficient','frontalArea_m2', ...
             'airDensity_kgpm3','rollingResistance'};
checkFields(in, requiredIn, 'input');
checkFields(p, requiredP, 'parameter');
validateattributes(in.wheelTorque_Nm, {'numeric'}, {'scalar','real','finite'});
validateattributes(in.vehicleSpeed_mps, {'numeric'}, {'scalar','real','finite','>=',0});
validateattributes(in.grade_rad, {'numeric'}, {'scalar','real','finite'});
validateattributes(p.mass_kg, {'numeric'}, {'scalar','real','finite','positive'});
validateattributes(p.wheelRadius_m, {'numeric'}, {'scalar','real','finite','positive'});
validateattributes(p.dragCoefficient, {'numeric'}, {'scalar','real','finite','nonnegative'});
validateattributes(p.frontalArea_m2, {'numeric'}, {'scalar','real','finite','positive'});
validateattributes(p.airDensity_kgpm3, {'numeric'}, {'scalar','real','finite','positive'});
validateattributes(p.rollingResistance, {'numeric'}, {'scalar','real','finite','nonnegative'});

g = 9.81;
v = in.vehicleSpeed_mps;
out.tractiveForce_N = in.wheelTorque_Nm / p.wheelRadius_m;
out.aeroDrag_N = 0.5 * p.airDensity_kgpm3 * p.dragCoefficient * p.frontalArea_m2 * v^2;
out.rollingResistance_N = p.rollingResistance * p.mass_kg * g * cos(in.grade_rad);
out.gradeForce_N = p.mass_kg * g * sin(in.grade_rad);
out.netForce_N = out.tractiveForce_N - out.aeroDrag_N ...
                 - out.rollingResistance_N - out.gradeForce_N;
out.acceleration_mps2 = out.netForce_N / p.mass_kg;
end

function checkFields(s, names, kind)
for k = 1:numel(names)
    if ~isstruct(s) || ~isfield(s, names{k})
        error('AutoControlLab:MissingField', 'Missing %s field: %s', kind, names{k});
    end
end
end
