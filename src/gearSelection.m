function requestedGear = gearSelection(speed_kph, currentGear, upshift_kph, downshift_kph, maxGear)
%GEARSELECTION Basic speed-based gear selection with hysteresis.
% Threshold vectors contain one threshold per gear transition.
validateattributes(speed_kph, {'numeric'}, {'scalar','real','finite','nonnegative'});
validateattributes(currentGear, {'numeric'}, {'scalar','integer','>=',1});
validateattributes(maxGear, {'numeric'}, {'scalar','integer','>=',2});
if currentGear > maxGear, error('AutoControlLab:InvalidGear', 'Current gear exceeds maxGear.'); end
if numel(upshift_kph) ~= maxGear-1 || numel(downshift_kph) ~= maxGear-1
    error('AutoControlLab:InvalidThresholds', 'Threshold vectors must have maxGear-1 elements.');
end
if any(downshift_kph >= upshift_kph)
    error('AutoControlLab:InvalidHysteresis', 'Each downshift threshold must be below its upshift threshold.');
end
requestedGear = currentGear;
if currentGear < maxGear && speed_kph >= upshift_kph(currentGear)
    requestedGear = currentGear + 1;
elseif currentGear > 1 && speed_kph < downshift_kph(currentGear-1)
    requestedGear = currentGear - 1;
end
end
