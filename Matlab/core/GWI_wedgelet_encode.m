% GWI: Graph Wedgelets for Image compression
% (C) W. Erb 01.10.2021

function [idxQ,FidxQ,cidxQ,nidxQ,BWPM,m,error] = GWI_wedgelet_encode(V,f,idxQ,FidxQ,cidxQ,nidxQ,BWPM,m,error,MM,RR,tol,metric)
% Main routine for wedgelet approximation on BWP trees:
% In:
%    V              = set of nodes
%    f              = function on nodes
%    idxQ           = initial indices of center nodes
%    FidxQ          = initial mean function values
%    cidxQ          = initial gemetric wavelet coefficients (JJ)
%    nidxQ          = initial size of sets in BWP tree
%    BWPM           = initial partition of V 
%    m              = initial size of partition
%    error          = initial mse for sets in partition
%    MM             = maximal partition size (number of leaves in BWP tree)
%    RR             = Parameter for greedy method:
%                     'MD': Max-Distance greedy
%                     'FA': Fully-Adaptive greedy
%                     otherwise: number of randomized splits for R-greedy
%    tol            = stop partitioning if max(error) < tol is 
%    metric         = applied distance metric (1,2, or 'inf')
% Out:
%    idxQ           = indices of center nodes for final wedgelet partition
%    FidxQ          = mean function values for final wedgelet partition
%    cidxQ          = gemetric wavelet coefficients in BWP tree (2m-1)
%    nidxQ          = size of sets in BWP tree
%    BWPM           = final partition of V (m elements)
%    m              = size of final partition
%    error          = mse for sets in final partition

N = length(f);

tic;
[errorj,idxj] = max(error); 

while (errorj > tol) && (m < MM)
       idxQ(m+1,2) = idxj;
       Fidxj = FidxQ(idxj,:);
       indsub = BWPM{idxj};
       idxqsub = find(indsub == idxQ(idxj,1));
       
       nodes = V(indsub,:);
       
       if (RR=='FA')
           MC = length(indsub);
           idxpsub = 1:MC;
       elseif (RR=='MD')
           MC = 1;
           dist = GWI_distcenter(nodes,idxqsub,metric);
           [~,idxpsub] = max(dist);
       else
           MC = min(RR,length(indsub));
           idxpsub = randsample(length(indsub),MC);
       end
    
       for i = 1:MC
      
         cluster = GWI_wedgesplit(nodes,idxpsub(i),idxqsub,metric);
       
         idx1 = indsub(cluster==1);
         idx2 = indsub(cluster==2);
         error1 = norm(f(idx1,:) - ones(length(idx1),1)*mean(f(idx1,:),1),'fro')^2/N/size(f,2);
         error2 = norm(f(idx2,:) - ones(length(idx2),1)*mean(f(idx2,:),1),'fro')^2/N/size(f,2);
         errornew = error1 + error2;

         if errornew <= errorj
           idxQ(idxj,1) = indsub(idxqsub);
           idxQ(m+1,1) = indsub(idxpsub(i));
    
           BWPM{idxj} = idx1;
           BWPM{m+1} = idx2;
           FidxQ(idxj,:) = mean(f(idx1,:),1);
           FidxQ(m+1,:) = mean(f(idx2,:),1);
           cidxQ(m+1,1:size(f,2)) = FidxQ(idxj,:)-Fidxj;
           cidxQ(m+1,size(f,2)+1:end) = FidxQ(m+1,:)-Fidxj;
           nidxQ(m+1,1) = length(idx1);
           nidxQ(m+1,2) = length(idx2);
           error(idxj) = error1;
           error(m+1) = error2;
           errorj = errornew;
         end      
       end
       [errorj,idxj] = max(error);
       m = m + 1;
      
       if (mod(m,100)==0)
          fprintf(1, '   Time to level %4d :               ',m); fprintf(1,'%5f \n', toc);
          tic;
       end
end

idxQ = idxQ(1:m,:); 
FidxQ = FidxQ(1:m,:);
cidxQ = cidxQ(1:m,:);
nidxQ = nidxQ(1:m,:);
error = error(1:m); 
BWPM = BWPM(1:m);

end