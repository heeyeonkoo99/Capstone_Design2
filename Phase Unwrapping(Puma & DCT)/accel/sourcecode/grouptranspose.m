%   ================================================================
%   Copyright 2015, Vrije Universiteit Brussel. All rights reserved.
%  
%   Author: David Blinder
%   Description: subroutine for the relabeling group indices when progressively unwrapping the signal during
%   the niverse modulo wavelet transforms.
%   ================================================================

function G = grouptranspose(G, siz)
% relabels group members for transposition and expands them

    % reassign cell groups
    for i=1:length(G)
        if ~isempty(G{i})
            G{i} = G{i}-1;
            G{i} = siz(2)*mod(G{i},siz(1)) + idivide(G{i},siz(1)) + 1;
        end
    end

    % expand groups
    G = cellfun( @dexp, G, 'UniformOutput', false);

    function B = dexp(A)
       B = [2*A-1 2*A];
    end

end