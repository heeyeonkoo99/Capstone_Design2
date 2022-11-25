function phaUnwrap = tmpPhaseUnwrapping(pha, unwrappingAlgorithm)

    switch unwrappingAlgorithm
        case 'DCT'
            % This implementation expects the input phase to be in the
            % range [-pi, pi).
            pha = DCTPhaseUnwrap(pha -pi);
        case 'PUMA'
            pha = accel_unwrapping(pha, 'puma', 2, 2*pi, 1, 1, 0);
        otherwise
            fprintf('Unrecognised unwrapping algorithm "%s", falling back to PUMA\n', unwrappingAlgorithm);
            pha = accel_unwrapping(pha, 'puma', 2, 2*pi, 1, 1, 0);
    end

    phaUnwrap = pha-mean(pha(:));

end