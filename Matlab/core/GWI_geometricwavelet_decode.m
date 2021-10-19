% GWI: Graph Wedgelets for Image compression
% (C) W. Erb 01.10.2021

function [s,BWPM] = GWI_geometricwavelet_decode(V,idxQ,cidxQ,BWPM,JJ,MM,metric)
% Routine for wedgelet decoding via geometric wavelet coefficients
% In:
%    V              = set of nodes
%    idxQ           = center nodes characterizing BWP tree
%    cidxQ          = gemetric wavelet coefficients for BWP tree
%    BWPM           = initially given partition of V
%    JJ             = initial size of partition
%    MM             = level for wedgelet reconstruction (>= JJ)
%    metric         = applied distance metric (1,2, or 'inf')
% Out:
%    s              = decoded signal at level MM
%    BWPM           = partition at level MM

MM = min(MM,size(idxQ,1));
fdim = size(cidxQ,2)/2;
FidxQ = zeros(MM,fdim);
FidxQ(1:JJ,:) = cidxQ(1:JJ,1:fdim);

% Generate BWP tree and corresponding mean values
for m = JJ+1:MM
       idxj = idxQ(m,2);
       indsub = BWPM{idxj};
       idxh1 = find(indsub == idxQ(m,1));
       idxh2 = find(indsub == idxQ(idxj,1));
       
       nodes = V(indsub,:);
       
       cluster = GWI_wedgesplit(nodes,idxh1,idxh2,metric);
       
       idx1 = indsub(cluster==1);
       idx2 = indsub(cluster==2);
       
       FidxQ(m,:) = FidxQ(idxj,:)+cidxQ(m,fdim+1:end);
       FidxQ(idxj,:) = FidxQ(idxj,:) + cidxQ(m,1:fdim);
       
       BWPM{idxj} = idx1;
       BWPM{m} = idx2;      
end

%Decode signal
dimI = length(V(:,1));
s = zeros(dimI,size(FidxQ,2));

for m = 1:MM
    s(BWPM{m},:) = ones(length(BWPM{m}),1)*FidxQ(m,:);
end

end