function N = FindRootSize(EndValue,L,rho,lbtol,ubtol)
%
% EndValue = how far we want to search to find 
%            where approximation can stop
% Q        = the number of eigenvalues we want to find
% L        = the length of the dendrite in space constants
% rho      = the ratio of dendrite to soma conductance, G_D/G_S
% lbtol    = a small tolerance to add to the lower bounds we use
% uptol    = a small tolerance to add to the upper bounds we use
%
% set Q
Q = EndValue;
z = zeros(Q,1);
LB = zeros(Q,1);
UB = zeros(Q,1);
kappa = tanh(L)/(rho*L);
N = Q;
for n=1:Q
     LB(n) = ((2*n-1)/(2*L))*pi*lbtol;
     UB(n) = n*pi/L*ubtol;
     [z(n),fx,nEvals,aF,bF] = GlobalNewtonFDTwo('f2',L,rho,LB(n),UB(n),10^-6,10^-8,500);
     w = z*L;
     testvalue = abs(cos(w(n)));     
     if (abs(testvalue) < 10^-3)
       disp(sprintf('n = %3d  root = %12.7f testvalue = %12.7f',n,w(n),testvalue));
       N = n;
       break;
     end     
end
disp(sprintf('n = %3d  root = %12.7f testvalue = %12.7f',n,w(n),testvalue));