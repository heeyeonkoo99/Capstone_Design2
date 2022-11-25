% packs two 32-bit matrices into one 64-bit matrix
function P = packGI(G,I)
    P = [typecast(single(I(:)),'int32'), int32(G(:))]';
    P = reshape(typecast(P(:), 'double'),size(G));
end

