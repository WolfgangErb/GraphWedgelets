% GWI: Graph Wedgelets for Image compression
% (C) W. Erb 01.10.2021

function [V,f,dimIx,dimIy] = GWI_im2sig(I)
% Transforms image to a graph signal
% In:
%    I              = 2D image of dimenstion dimIx x dimIy
% Out:
%    V              = set of graph nodes (set of pixel positions)
%    f              = function on graph vertices
%    dimIx, dimIy   = dimensions of image

if (size(I,3) == 1)                % For grayscale images
    [dimIx, dimIy] = size(I');
    % Generate graph nodes V and respective graph signal f
    [Y,X] = meshgrid(1:dimIy,1:dimIx);
    V = [X(:),Y(:)];     
    f = reshape(double(I)',[],1);
elseif (size(I,3) == 3)            % For RGB images
    Ired = double(I(:,:,1));       % Red channel
    Igreen = double(I(:,:,2));     % Green channel
    Iblue = double(I(:,:,3));      % Blue channel
    
    [dimIx, dimIy] = size(Ired');  % dimI = dimIx*dimIy;
    % Generate graph nodes V and respective graph signal f
    [Y,X] = meshgrid(1:dimIy,1:dimIx);
    V = [X(:),Y(:)];     
    f = [reshape(Ired',[],1), reshape(Igreen',[],1),reshape(Iblue',[],1)];
end
end