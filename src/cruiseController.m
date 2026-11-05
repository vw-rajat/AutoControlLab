function [accelRequest_mps2, state] = cruiseController(targetSpeed_mps, actualSpeed_mps, state, cfg, dt_s)
%CRUISECONTROLLER PI speed controller with saturation and anti-windup.
% state.integral is the accumulated speed error in (m/s)*s.
% cfg.Kp, cfg.Ki, cfg.minAccel_mps2, cfg.maxAccel_mps2 are required.
validateattributes(targetSpeed_mps, {'numeric'}, {'scalar','real','finite','nonnegative'});
validateattributes(actualSpeed_mps, {'numeric'}, {'scalar','real','finite','nonnegative'});
validateattributes(dt_s, {'numeric'}, {'scalar','real','finite','positive'});
required = {'Kp','Ki','minAccel_mps2','maxAccel_mps2'};
for k = 1:numel(required)
    if ~isfield(cfg, required{k}), error('AutoControlLab:MissingConfig', 'Missing cfg.%s', required{k}); end
end
if cfg.minAccel_mps2 > cfg.maxAccel_mps2
    error('AutoControlLab:InvalidLimits', 'Minimum acceleration must not exceed maximum.');
end
if ~isfield(state, 'integral'), state.integral = 0; end
error_mps = targetSpeed_mps - actualSpeed_mps;
candidateIntegral = state.integral + error_mps * dt_s;
raw = cfg.Kp * error_mps + cfg.Ki * candidateIntegral;
sat = min(max(raw, cfg.minAccel_mps2), cfg.maxAccel_mps2);
% Conditional integration: integrate only when unsaturated or when error
% drives the controller back toward the allowed range.
if raw == sat || (raw > cfg.maxAccel_mps2 && error_mps < 0) ...
               || (raw < cfg.minAccel_mps2 && error_mps > 0)
    state.integral = candidateIntegral;
end
accelRequest_mps2 = sat;
end
