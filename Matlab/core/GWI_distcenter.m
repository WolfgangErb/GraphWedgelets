% GWI: Graph Wedgelets for Image compression
% (C) W. Erb 01.10.2021

function dist = GWI_distcenter(V,idxQ,metric)

% Calculates the distance of the nodes in V to the center V(idxQ) 
% based on the given metric  
% In:
%    V         = set of nodes
%    idxQ      = index of center node
%    metric    = type of metric (1,2 or 'inf')
%
% Out:
%    dist      = vector of distances

  x = V(:,1); 
  y = V(:,2);
  
  qx = x(idxQ); 
  qy = y(idxQ);
  
  switch metric
      
      case 1
          dist = abs(x - qx) + abs(y - qy);
      case 2
          dist = sqrt((x - qx).^2 + (y - qy).^2);
      case 'inf'
          dist = max(abs(x - qx),abs(y - qy));        
  end

end