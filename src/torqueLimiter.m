function limitedTorque_Nm = torqueLimiter(requestedTorque_Nm, minTorque_Nm, maxTorque_Nm, derateFactor)
%TORQUELIMITER Saturate requested torque and apply a [0,1] derating factor.
% All torque values are in Nm. Derating is applied after saturation.
validateattributes(requestedTorque_Nm, {'numeric'}, {'scalar','real','finite'});
validateattributes(minTorque_Nm, {'numeric'}, {'scalar','real','finite'});
validateattributes(maxTorque_Nm, {'numeric'}, {'scalar','real','finite'});
validateattributes(derateFactor, {'numeric'}, {'scalar','real','finite','>=',0,'<=',1});
if minTorque_Nm > maxTorque_Nm
    error('AutoControlLab:InvalidTorqueLimits', 'Minimum torque must not exceed maximum torque.');
end
saturated = min(max(requestedTorque_Nm, minTorque_Nm), maxTorque_Nm);
limitedTorque_Nm = saturated * derateFactor;
end
