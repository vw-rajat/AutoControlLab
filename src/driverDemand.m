function demand = driverDemand(accelPedal_pct, brakePedal_pct)
%DRIVERDEMAND Convert pedal positions into normalised driver demands.
% Inputs: accelerator and brake pedal positions in percent [0,100].
% Output: struct with accelDemand and brakeDemand in [0,1].
validateattributes(accelPedal_pct, {'numeric'}, {'scalar','real','finite','>=',0,'<=',100});
validateattributes(brakePedal_pct, {'numeric'}, {'scalar','real','finite','>=',0,'<=',100});

demand.accelDemand = accelPedal_pct / 100;
demand.brakeDemand = brakePedal_pct / 100;
end
