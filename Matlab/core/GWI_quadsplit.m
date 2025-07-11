% GWI: Graph Wedgelets for Image compression
% (C) W. Erb 01.07.2025

function BWP = GWI_quadsplit(V,f,dimIx,dimIy,Jx,Jy,M)
% Initialization step for the generation of BWP trees:
% Subdivides a given image in JJ = Jx*Jy blocks and creates
% all necessary variables for subsequent greedy BWP generation
% In:
%    V              = set of nodes
%    f              = function on nodes
%    dimIx, dimIy   = dimensions of image
%    Jx,Jy          = number of blocks per dimension
%    M              = maximal partition size (for initialization) 
% Out:
%    BWP            = Binary Wedge Partitioning Tree containing
%       Q           = initial indices of center nodes of blocks
%       F           = initial mean function values (JJ = Jx*Jy)
%       c           = initial gemetric wavelet coefficients 
%       n           = initial size of blocks
%       P           = initial partition of V in JJ blocks 
%       m           = initial size JJ of partition
%       error       = initial mse for sets in partition

BWP.Q = zeros(M,2);
BWP.F = zeros(M,size(f,2));
BWP.c = zeros(M,2*size(f,2));
BWP.n = zeros(M,2);
BWP.error = zeros(M,1);
BWP.P = cell(M,1);

x = V(:,1); y = V(:,2);
Kx = ceil(dimIx/Jx); Ky = ceil(dimIy/Jy);

k = 1;
for i = 1:Jx
    for j = 1:Jy
        cx = min(ceil(Kx/2)+ (i-1)*Kx,dimIx);
        cy = min(ceil(Ky/2)+ (j-1)*Ky,dimIy);
        BWP.Q(k,1) = find((x == cx).*(y==cy));
        BWP.P{k} = find((x <= i*Kx).*(x > (i-1)*Kx).*(y <= j*Ky).*(y > (j-1)*Ky));
        k = k+1;
    end
end

dimI = dimIx*dimIy;
BWP.m = Jx*Jy;

for j = 1:BWP.m
    BWP.F(j,:) = mean(f(BWP.P{j},:),1);
    BWP.c(j,1:size(f,2)) = mean(f(BWP.P{j},:),1);
    BWP.n(j,1) = length(BWP.P{j});
    BWP.error(j) = norm(f(BWP.P{j},:) - ones(length(BWP.P{j}),1)*BWP.F(j,:),'fro')^2/dimI/size(f,2);
end
end