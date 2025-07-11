% GWI: Graph Wedgelets for Image compression
% (C) W. Erb 01.07.2025

function [cluster,Q] = GWI_Jcenters(V,J,W,Qin,metric)

% Performs a reduced J-center clustering based on greedy search: 
% Finds cluster assignments "cluster" based on a reduced greedy procedure 
% on the subset W of the nodes. 
    
% Determining cluster indices and cluster centers is both done in an
% efficient way.  Cluster assignment is O(n J) and cluster
% centering is O(J*(max cluster size)^2)
%
% INPUTS
%    V         = the set of nodes
%    J         = number of clusters
%    W         = subset on which the greedy search is performed
%    Qin       = predefined input centers (optional)
%    metric    = type of metric (1,2 or 'inf')
%
% OUTPUTS
%    cluster   = Jx1 vector of assignments of each node to a cluster
%    Q         = Jx1 index vector of the cluster centers

N = size(V,1);
D = zeros(J,N);

if (nargin == 3)
    Qin = idxW(randi([1,length(W)],1,1));
    % If no input is given choose a random center from W
end

sizeQin = length(Qin);
Q = zeros(J,1); 
Q(1:sizeQin) = Qin;

for j = 1:J-1
    D(j,:) = GWI_distcenter(V,Q(j),metric);
    if j >= sizeQin 
       [~,indmax] = max(min(D(1:j,W),[],1));
       Q(j+1) = W(indmax(1));
    end
end


D(J,:) = GWI_distcenter(V,Q(J),metric);

[~,cluster] = min(D,[],1);
cluster = cluster';

return
