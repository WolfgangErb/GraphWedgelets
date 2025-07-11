% GWI: Graph Wedgelets for Image compression
% (C) W. Erb 01.07.2025

function [s,P] = GWI_wedgelet_decode(V,Q,F,BWPJ,metric)
% Routine for wedgelet decoding via mean function values on last partition
% In:
%    V              = set of nodes
%    Q              = center nodes characterizing BWP tree with M leaves
%    F              = mean function values given at level M
%    BWPJ           = BWP initialization
%    metric         = applied distance metric (1,2, or 'inf')
% Out:
%    s              = decoded signal at level M
%    P              = partition at level M

M = size(Q,1);     % final partition size
J = BWPJ.m;        % initial partition size
P = BWPJ.P;         % initial partitioning

%Generate partition at level MM
for j = J+1:M
       qj = Q(j,2);
       Pj = P{qj};
       idxh1 = find(Pj == Q(j,1));
       idxh2 = find(Pj == Q(qj,1));
       
       Vj = V(Pj,:);
       
       cluster = GWI_wedgesplit(Vj,idxh1,idxh2,metric);
       
       idx1 = Pj(cluster==1);
       idx2 = Pj(cluster==2);
       
       P{qj} = idx1;
       P{j} = idx2;      
end

%Decode signal
dimI = length(V(:,1));
s = zeros(dimI,size(F,2));

for m = 1:M
    s(P{m},:) = ones(length(P{m}),1)*F(m,:);
end

end