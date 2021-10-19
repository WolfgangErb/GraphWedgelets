% GWI: Graph Wedgelets for Image compression
% (C) W. Erb 01.10.2021

function cluster = GWI_wedgesplit(V,idxP,idxQ,metric)

% Performs an elementary wedge split and finds 
% a partition of V into two subsets according to the minimum
% distance to the center nodes V(Pidx) and V(Qidx).    

% In:
%    V         = set of nodes
%    idxP      = index of new node
%    idxQ      = index of reference node
%    metric    = type of metric (1,2 or 'inf')
%
% Out:
%    cluster   = Nx1 vector of assignments of each node to a cluster
%                cluster = 1: node is closer to V(idxQ)
%                cluster = 2: node is closer to V(idxP)

 if ~exist('metric','var')
     metric = 2;
 end

N = size(V,1);
D = zeros(N,2);

D(:,1) = GWI_distcenter(V,idxQ,metric);
D(:,2) = GWI_distcenter(V,idxP,metric);

[~,cluster] = min(D,[],2);

return

