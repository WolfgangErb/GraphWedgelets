% GWI: Graph Wedgelets for Image compression
% (C) W. Erb 01.07.2025

function [s,P] = GWI_geometricwavelet_decode(V,Q,c,BWPJ,metric)
% Routine for wedgelet decoding via geometric wavelet coefficients
% In:
%    V              = set of nodes
%    Q              = center nodes characterizing BWP tree with M leaves
%    c              = gemetric wavelet coefficients for BWP tree
%    BWPJ           = BWP initialization
%    metric         = applied distance metric (1,2, or 'inf')
% Out:
%    s              = decoded signal at level M
%    P              = partition at level M

M = size(Q,1);         % final partition size
J = BWPJ.m;            % initial partition size
P = BWPJ.P;            % initial partitioning
fdim = size(c,2)/2;
F = zeros(M,fdim);
F(1:J,:) = c(1:J,1:fdim);

% Generate BWP tree and corresponding mean values
for m = J+1:M
       j = Q(m,2);
       Pj = P{j};
       idxh1 = find(Pj == Q(m,1));
       idxh2 = find(Pj == Q(j,1));
       
       Vj = V(Pj,:);
       
       cluster = GWI_wedgesplit(Vj,idxh1,idxh2,metric);
       
       idx1 = Pj(cluster==1);
       idx2 = Pj(cluster==2);
       
       F(m,:) = F(j,:) + c(m,fdim+1:end);
       F(j,:) = F(j,:) + c(m,1:fdim);
       
       P{j} = idx1;
       P{m} = idx2;      
end

%Decode signal
dimI = length(V(:,1));
s = zeros(dimI,fdim);

for m = 1:M
    s(P{m},:) = ones(length(P{m}),1)*F(m,:);
end

end