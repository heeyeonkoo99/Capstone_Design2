%   ================================================================
%   Copyright 2015, Vrije Universiteit Brussel. All rights reserved.
%  
%   Author: David Blinder
%   Description: applies the modulo haar wavelet transform on the input image for 'lev' levels,
%   returns the resulting coefficients, alongside cell matrix with the pyramid of the lowpass modulo channels.
%   ================================================================

function [X, PYR] = modulo_haar_pyr(X,lev,m)
    
    P = 1; U = .5;
    PYR = cell(0);

    % function implementing modulo haar lifting scheme
    if lev < 0
        error('lev must be positive')
    else
        for l = 1:lev
            f = 2^(l-1);
                PYR{length(PYR)+1} = X(1:size(X,1)/f,1:size(X,2)/f);
            X(1:size(X,1)/f,1:size(X,2)/f) = transformstep(X(1:size(X,1)/f,1:size(X,2)/f));
                PYR{length(PYR)+1} = X(1:size(X,1)/f/2,1:size(X,2)/f);
            X(1:size(X,1)/f/2,1:size(X,2)/f) = transformstep(X(1:size(X,1)/f/2,1:size(X,2)/f)')';
        end
        
        PYR{length(PYR)+1} = X(1:size(X,1)/2^lev, 1:size(X,2)/2^lev);
    end

    % modulo operators
    function r = imc(c, m)
        r = mod(c-1,m)+1;
    end

    function y = modoper(x)
        y = mod(x+m/2,m)-m/2;
    end    

    % single modulo haar transformstep
    function X = transformstep(X)
        A = X(1:2:end-1,:);
        B = X(2:2:end,:);
        s = size(A,1);
    
        [A,B] = operate_lift(A,B,s);
        
        X = [A;B];
    end

    % lifting steps
    function [A,B] = operate_lift(A,B,s)
        z = size(U,1)-1;
        for i=1:s
            inds = imc(i:i+z, s);
            B(i,:) = modoper(B(i,:) - sum( repmat(P,1,size(A,2)).*A(inds,:), 1));
        end

        z = size(P,1)-1;
        for i=1:s
            inds = imc(i-z:i, s);
            A(i,:) = modoper(A(i,:) + sum(repmat(U,1,size(B,2)).*B(inds,:), 1));
        end 
    end    
end

