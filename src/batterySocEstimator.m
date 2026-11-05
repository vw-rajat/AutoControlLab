function soc = batterySocEstimator(previousSoc, current_A, dt_s, capacity_Ah)
%BATTERYSOCESTIMATOR Coulomb-counting SOC update.
% Positive current means battery discharge; negative current means charging.
% SOC is represented as a fraction [0,1].
validateattributes(previousSoc, {'numeric'}, {'scalar','real','finite','>=',0,'<=',1});
validateattributes(current_A, {'numeric'}, {'scalar','real','finite'});
validateattributes(dt_s, {'numeric'}, {'scalar','real','finite','nonnegative'});
validateattributes(capacity_Ah, {'numeric'}, {'scalar','real','finite','positive'});
deltaSoc = (current_A * dt_s / 3600) / capacity_Ah;
soc = min(max(previousSoc - deltaSoc, 0), 1);
end
