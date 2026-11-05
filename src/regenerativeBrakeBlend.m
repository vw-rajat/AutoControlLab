function out = regenerativeBrakeBlend(brakeDemand, maxRegenTorque_Nm, maxFrictionTorque_Nm, batteryChargePowerLimit_W, motorSpeed_radps)
%REGENERATIVEBRAKEBLEND Allocate requested braking torque to regen then friction.
% brakeDemand is [0,1]. Torque magnitudes are nonnegative. Motor speed is rad/s.
validateattributes(brakeDemand, {'numeric'}, {'scalar','real','finite','>=',0,'<=',1});
validateattributes(maxRegenTorque_Nm, {'numeric'}, {'scalar','real','finite','nonnegative'});
validateattributes(maxFrictionTorque_Nm, {'numeric'}, {'scalar','real','finite','nonnegative'});
validateattributes(batteryChargePowerLimit_W, {'numeric'}, {'scalar','real','finite','nonnegative'});
validateattributes(motorSpeed_radps, {'numeric'}, {'scalar','real','finite','nonnegative'});

requestedTotal = brakeDemand * (maxRegenTorque_Nm + maxFrictionTorque_Nm);
if motorSpeed_radps > 1e-6
    regenByPower = batteryChargePowerLimit_W / motorSpeed_radps;
else
    regenByPower = maxRegenTorque_Nm;
end
availableRegen = min(maxRegenTorque_Nm, regenByPower);
out.regenTorque_Nm = min(requestedTotal, availableRegen);
remaining = max(0, requestedTotal - out.regenTorque_Nm);
out.frictionTorque_Nm = min(remaining, maxFrictionTorque_Nm);
out.unmetBrakeTorque_Nm = max(0, remaining - out.frictionTorque_Nm);
end
