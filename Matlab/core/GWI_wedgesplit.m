% GWI: Graph Wedgelets for Image compression
% (C) W. Erb 01.07.2025

function cluster = GWI_wedgesplit(V,p,q,metric)

% Performs an elementary wedge split and finds 
% a partition of V into two subsets according to the minimum
% distance to the center nodes V(p) and V(q).    

% In:
%    V         = set of nodes
%    p         = index of new node
%    q         = index of reference node
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

D(:,1) = GWI_distcenter(V,q,metric);
D(:,2) = GWI_distcenter(V,p,metric);

[~,cluster] = min(D,[],2);

return

