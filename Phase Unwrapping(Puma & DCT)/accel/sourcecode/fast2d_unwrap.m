%   ================================================================
%   Copyright 2015, Vrije Universiteit Brussel. All rights reserved.
%  
%   Author: David Blinder
%   Description: Matlab implementation of the unwrapping algorithm found in:
%       M. A. Herraez, D. R. Burton, M. J. Lalor, and M. A. Gdeisat, "Fast two-dimensional phase-unwrapping algorithm
%       based on sorting by reliability following a noncontinuous path," Appl. Opt. 41, 7437–7444 (2002).
%   ================================================================

function [W, G, GL] = fast2d_unwrap(X, M, XE, YE, m, G, GL)
% Unwraps the pixels M==1 of 'X'. M==0 pixels were already unwrapped at a higher level
% M==2 pixels are aliased and therefore ignored.

% INPUTS:
    % X: (partially) wrapped image to be unwrapped
    % M: mask indicating what pixel should be unwrapped at the current modulo wavelet level.
    % XE,YE: horizontal and vertical reliability maps
% INPUTS+OUTPUTS
    % G: Group matrix: determines which pixel belongs to what group (zero means no group). (not needed at highest level)
    % GL: Group list: Cell matrix containing list of pixels per group (not needed at highest level)
% OUTPUTS:
    % W: wrap count matrix result

    if nargin<6
        G = int32(zeros(size(X))); 
        GL = cell(0); 
        groupind = 0;               % Last group index (counter)
    else
        groupind = length(GL);
    end

    % calculations are performed using a linearized matrix.
    % "list" contains three rows: reliability, pixel1, pixel2
    N = reshape(1:numel(X),size(X,1),size(X,2));
    
    list = cat(1,...
            cat(2, XE(:), reshape(N(1:end-1,:),[],1), reshape(N(2:end,:),[],1)),...
            cat(2, YE(:), reshape(N(:,1:end-1),[],1), reshape(N(:,2:end),[],1)) ...
           );
              
    % weeds out all entries involving pairs of unmarked pixels, sorts them by reliability
    list( (M(list(:, 2))==2) | (M(list(:, 3))==2) | (M(list(:, 2))+M(list(:, 3)))==0, :) = [];
    list = sortrows(list);
    list = int32(list(:,2:3));
    
    W = (~M).*round(X/m);   % Wrap matrix: number of +m wraps per pixel
    X = mod(X+m/2,m)-m/2;   % Wrapped phase values
    
    % go over edges along reliability
    for i = size(list,1):-1:1
        p = list(i,1); q = list(i,2);
       
        % do both pixels have the same index?
        if G(p)==G(q)
           
            % do neither of the pixels belong a group?
            if G(p)==0
                W(q) = wrapind( X(p), X(q) );
                groupind = groupind+1;
                GL{groupind} = int32([p,q]);
                G([p,q]) = groupind;
            end
            
            % otherwise, they already belong to the same group; do nothing    
        else
            
            % is either pixel without a group?
            if G(p)==0
                joinsinglepixel(p,q);
            elseif G(q)==0
                joinsinglepixel(q,p);
            % otherwise, both pixels belong to different groups.
            % add smaller group to bigger one.
            else
                if ( length(GL{G(p)}) > length(GL{G(q)}) )
                    joingroups(q,p);
                else
                    joingroups(p,q);
                end
            end
        end
    end
    
    % returns how many "m" you have to add (-1,0 or 1) to the base in order to
    % have the minimal absolute phase distance between base and novel
    function w = wrapind(base, novel)
        d = base - novel;
        w = (d > m/2) - (d < -m/2);
    end

    % joins a groupless pixel 'singl' to a grouped pixel 'group'
    function joinsinglepixel(singl, group)
        W(singl) = W(group) + wrapind( X(group), X(singl) );
        G(singl) = G(group);
        GL{ G(group) } = [ GL{ G(group) }, int32(singl) ];
    end
    
    % joins a pixel together with its smaller group 'joiner' to a larger group associated to pixel 'base' 
    function joingroups(joiner, base)
        K = GL{G(joiner)}; % indices of joiner group
        W(K) = W(K) + W(base) - W(joiner) + wrapind( X(base), X(joiner) );
            GL{G(joiner)} = int32([]); % frees memory; optional
        G(K) = G(base);
        GL{ G(base) } = [ GL{ G(base) }, int32(K) ];
    end
end