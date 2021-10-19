% GWI: Graph Wedgelets for Image compression
% (C) W. Erb 01.10.2021

function [s,BWPM] = GWI_wedgelet_decode(V,idxQ,FidxQ,BWPM,JJ,metric)
% Routine for wedgelet decoding via mean function values on last partition
% In:
%    V              = set of nodes
%    idxQ           = center nodes characterizing BWP tree with MM leaves
%    FidxQ          = mean function values given at level MM
%    BWPM           = initially given partition of V
%    JJ             = initial size of partition
%    metric         = applied distance metric (1,2, or 'inf')
% Out:
%    s              = decoded signal at level MM
%    BWPM           = partition at level MM

MM = size(idxQ,1);

%Generate partition at level MM
for h = JJ+1:MM
       idxj = idxQ(h,2);
       indsub = BWPM{idxj};
       idxh1 = find(indsub == idxQ(h,1));
       idxh2 = find(indsub == idxQ(idxj,1));
       
       nodes = V(indsub,:);
       
       cluster = GWI_wedgesplit(nodes,idxh1,idxh2,metric);
       
       idx1 = indsub(cluster==1);
       idx2 = indsub(cluster==2);
       
       BWPM{idxj} = idx1;
       BWPM{h} = idx2;      
end

%Decode signal
dimI = length(V(:,1));
s = zeros(dimI,size(FidxQ,2));

for m = 1:MM
    s(BWPM{m},:) = ones(length(BWPM{m}),1)*FidxQ(m,:);
end

end