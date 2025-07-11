% GWI: Graph Wedgelets for Image compression
% (C) W. Erb 01.7.2025

function BWP = GWI_wedgelet_encode(V,f,BWP,M,R,tol,metric)
% Main routine for wedgelet approximation on BWP trees:
% In:
%    V              = set of nodes
%    f              = function on nodes
%    BWP            = Binary Wedge Partitioning Tree containing
%       Q           = initial indices of center nodes
%       F           = initial mean function values
%       c           = initial gemetric wavelet coefficients (JJ)
%       n           = initial size of sets in BWP tree
%       p           = initial partition of V 
%       m           = initial size of partition
%       error       = initial mse for sets in partition
%    M              = maximal partition size (number of leaves in BWP tree)
%    R              = Parameter for greedy method:
%                     'MD': Max-Distance greedy
%                     'FA': Fully-Adaptive greedy
%                     'KC': K-center, with R.val centers
%                     'RA': Random, with R.val centers
%    tol            = stop partitioning if max(error) < tol is 
%    metric         = applied distance metric (1,2, or 'inf')
% Out:
%    BWP            = Binary Wedge Partitioning Tree containing
%       Q           = indices of center nodes for final wedgelet partition
%       F           = mean function values for final wedgelet partition
%       c           = geometric wavelet coefficients in BWP tree (2m-1)
%       n           = size of sets in BWP tree
%       p           = final partition of V (m elements)
%       m           = size of final partition
%       error       = mse for sets in final partition

n = length(f);      % length of signal
m = BWP.m;          % initial partition size

tic;
[errorj,j] = max(BWP.error); 

while (errorj > tol) && (m < M)
       BWP.Q(m+1,2) = j;
       Fj = BWP.F(j,:);
       Pj = BWP.P{j};
       Vj = V(Pj,:);
       qj = find(Pj == BWP.Q(j,1));       
      
       if (R.type=='FA')
           S = length(Pj);
           pj = 1:S;
       elseif (R.type=='MD')
           S = 1;
           dist = GWI_distcenter(Vj,qj,metric);
           [~,pj] = max(dist);
       elseif (R.type=='KC')
           S = min(R.val,length(Pj));
           [~,pj] = GWI_Jcenters(Vj,R.val,1:length(Pj),qj,metric);
       elseif (R.type=='RA')
           rng(1,"twister");
           S = min(R.val,length(Pj));
           pj = randsample(length(Pj),S);
       end
    
       for i = 1:S
      
         cluster = GWI_wedgesplit(Vj,pj(i),qj,metric);
       
         idx1 = Pj(cluster==1);
         idx2 = Pj(cluster==2);
         error1 = norm(f(idx1,:) - ones(length(idx1),1)*mean(f(idx1,:),1),'fro')^2/n/size(f,2);
         error2 = norm(f(idx2,:) - ones(length(idx2),1)*mean(f(idx2,:),1),'fro')^2/n/size(f,2);
         errornew = error1 + error2;

         if errornew <= errorj
           BWP.Q(j,1) = Pj(qj);
           BWP.Q(m+1,1) = Pj(pj(i));
    
           BWP.P{j} = idx1;
           BWP.P{m+1} = idx2;
           BWP.F(j,:) = mean(f(idx1,:),1);
           BWP.F(m+1,:) = mean(f(idx2,:),1);
           BWP.c(m+1,1:size(f,2)) = BWP.F(j,:)-Fj;
           BWP.c(m+1,size(f,2)+1:end) = BWP.F(m+1,:)-Fj;
           BWP.n(m+1,1) = length(idx1);
           BWP.n(m+1,2) = length(idx2);
           BWP.error(j) = error1;
           BWP.error(m+1) = error2;
           errorj = errornew;
         end      
       end
       [errorj,j] = max(BWP.error);
       m = m + 1;
      
       if (mod(m,100)==0)
          fprintf(1, '   Time to level %4d :               ',m); fprintf(1,'%5f \n', toc);
          tic;
       end
end

% Restrict final output
BWP.Q = BWP.Q(1:m,:); 
BWP.F = BWP.F(1:m,:);
BWP.c = BWP.c(1:m,:);
BWP.n = BWP.n(1:m,:);
BWP.error = BWP.error(1:m); 
BWP.P = BWP.P(1:m);
BWP.m = m;

end