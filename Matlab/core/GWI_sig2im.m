% GWI: Graph Wedgelets for Image compression
% (C) W. Erb 01.10.2021

function  I = GWI_sig2im(f,dimIx,dimIy)
% Transforms graph signal back to an image
% In:
%    f              = function on graph vertices
%    dimIx, dimIy   = dimensions of image
% Out:
%    I              = 2D image of dimenstion dimIx x dimIy

if (size(f,2) == 1)
    I = reshape(uint8(f(:,1)),dimIx,dimIy)';
elseif (size(f,2) == 3)
    Ired = reshape(uint8(f(:,1)),dimIx,dimIy)';
    Igreen = reshape(uint8(f(:,2)),dimIx,dimIy)';
    Iblue = reshape(uint8(f(:,3)),dimIx,dimIy)';
    I = cat(3, Ired, Igreen, Iblue);
end
end