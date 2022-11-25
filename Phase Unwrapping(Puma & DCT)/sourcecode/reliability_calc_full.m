%   ================================================================
%   Copyright 2015, Vrije Universiteit Brussel. All rights reserved.
%  
%   Author: David Blinder
%   Description: Calculates the reliability map for the unwrapping algorithm found in:
%       M. A. Herraez, D. R. Burton, M. J. Lalor, and M. A. Gdeisat, "Fast two-dimensional phase-unwrapping algorithm
%       based on sorting by reliability following a noncontinuous path," Appl. Opt. 41, 7437–7444 (2002).
%   ================================================================

function R = reliability_calc_full(X, m)

    % calculate reliability submatrices
    Y = mod(X+m/2,m)-m/2;
    H = moddiff( Y(1:end-2,2:end-1), Y(2:end-1,2:end-1) )...
        - moddiff( Y(2:end-1,2:end-1), Y(3:end,2:end-1) );
    V = moddiff( Y(2:end-1,1:end-2), Y(2:end-1,2:end-1) )...
        - moddiff( Y(2:end-1,2:end-1), Y(2:end-1,3:end) );
    D1 = moddiff( Y(1:end-2,1:end-2), Y(2:end-1,2:end-1) )...
        - moddiff( Y(2:end-1,2:end-1), Y(3:end,3:end) );
    D2 = moddiff( Y(1:end-2,3:end), Y(2:end-1,2:end-1) )...
        - moddiff( Y(2:end-1,2:end-1), Y(3:end,1:end-2) );
    
    % create reliability matrix
    R = (H.^2 + V.^2 + D1.^2 + D2.^2).^(-.5);
    R = cat( 1, zeros(1,size(R,2)), R, zeros(1,size(R,2)) );
    R = cat( 2, zeros(size(R,1), 1), R, zeros(size(R,1), 1) );

    % phase difference operator
    function d = moddiff(a,b)
        d = a-b;
        d = d + m*((d < -m/2) - (d >= m/2));
    end
end

