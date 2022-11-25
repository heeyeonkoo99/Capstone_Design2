% unpacks one 64-bit matrix into two 32-bit matrices
function [G,I] = unpackGI(P)
    siz = size(P);
    P = typecast(P(:),'int32');
    I = reshape(typecast(P(1:2:end),'single'),siz);
    G = reshape(P(2:2:end),siz);
end

