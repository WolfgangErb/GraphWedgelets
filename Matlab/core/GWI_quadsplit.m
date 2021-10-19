% GWI: Graph Wedgelets for Image compression
% (C) W. Erb 01.10.2021

function [idxQ,FidxQ,cidxQ,nidxQ,BWPJJ,JJ,error] = GWI_quadsplit(V,f,dimIx,dimIy,Jx,Jy,MM)
% Initialization step for the generation of BWP trees:
% Subdivides a given image in Jx*Jy blocks and creates
% all necessary variables for subsequent greedy BWP generation
% In:
%    V              = set of nodes
%    f              = function on nodes
%    dimIx, dimIy   = dimensions of image
%    Jx,Jy          = number of blocks per dimension
%    MM             = maximal partition size (for initialization) 
% Out:
%    idxQ           = indices of center nodes for sets in partition
%    FidxQ          = mean function values for sets in partition
%    cidxQ          = geometric wavelet coefficients for BWP tree
%    nidxQ          = size of sets in BWP tree
%    BWPJJ          = encoded partition of V in JJ blocks
%    JJ             = number of partitions (JJ quadratic blocks)
%    error          = mse for sets in partition

idxQ = zeros(MM,2);
FidxQ = zeros(MM,size(f,2));
cidxQ = zeros(MM,2*size(f,2));
nidxQ = zeros(MM,2);
error = zeros(MM,1);
BWPJJ = cell(MM,1);

x = V(:,1); y = V(:,2);
Kx = ceil(dimIx/Jx); Ky = ceil(dimIy/Jy);

k = 1;
for i = 1:Jx
    for j = 1:Jy
        cx = min(ceil(Kx/2)+ (i-1)*Kx,dimIx);
        cy = min(ceil(Ky/2)+ (j-1)*Ky,dimIy);
        idxQ(k,1) = find((x == cx).*(y==cy));
        BWPJJ{k} = find((x <= i*Kx).*(x > (i-1)*Kx).*(y <= j*Ky).*(y > (j-1)*Ky));
        k = k+1;
    end
end

dimI = dimIx*dimIy;
JJ = Jx*Jy;

for j = 1:JJ
    FidxQ(j,:) = mean(f(BWPJJ{j},:),1);
    cidxQ(j,1:size(f,2)) = mean(f(BWPJJ{j},:),1);
    nidxQ(j,1) = length(BWPJJ{j});
    error(j) = norm(f(BWPJJ{j},:) - ones(length(BWPJJ{j}),1)*FidxQ(j,:),'fro')^2/dimI/size(f,2);
end
end