% GWI: Graph Wedgelets for Image compression
% (C) W. Erb 01.07.2025

function [s,P] = GWI_merge(V,F,P,m)
% Routine to merge a given partitioning of V based
% on a simple region model and a given merging order
% In:
%    V              = set of nodes
%    F              = mean function values given at level M
%    P              = initial partition of size M 
%    m              = final partition size after merging procedure
% Out:
%    s              = piecewise constant signal on merged partition P
%    P              = merged partition of size m

  M = size(F,1);
  n = zeros(M,1);

  for k = 1:M
    n(k) = length(P{k});
  end

  A = cell2mat( reshape( arrayfun( @(j) min(n(j),n').*vecnorm(F(j,:)'-F',2,1).^2, (1:M), 'uni', false ), [],1 ) );

  for i = 1:M
    A(i,i) = 1e12;
  end

  tic;

  for k = M:-1:m+1
    
    [~,idxmin] = min(A(:));
    [idx1, idx2] = ind2sub([k,k],idxmin(1));

    if n(idx1) < n(idx2)
      [idx2, idx1] = ind2sub([k,k],idxmin(1));
    end
    
    P{idx1} = [P{idx1};P{idx2}];
    P(idx2) = [];
    n(idx1) = n(idx1) + n(idx2);
    A(idx1,:) = min(n(idx1),n').*vecnorm(F(idx1,:)'-F',2,1).^2;
    A(:,idx1) = A(idx1,:)';
    A(idx1,idx1) = 1e12;

    n(idx2) = [];
    F(idx2,:) = [];
    A(:,idx2) = [];
    A(idx2,:) = [];

    if (mod(k,100)==0)
      fprintf(1, '   Time to level %4d :               ',k); fprintf(1,'%5f \n', toc);
      tic;
    end
  end

  %Decode signal
  dimI = length(V(:,1));
  s = zeros(dimI,size(F,2));

  for k = 1:m
    s(P{k},:) = ones(length(P{k}),1)*F(k,:);
  end

end