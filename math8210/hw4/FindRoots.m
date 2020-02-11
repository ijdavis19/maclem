function z = FindRoots(Q,L,rho,lbtol,ubtol)
%
% Q     = the number of eigenvalues we want to find
% L     = the length of the dendrite in space constants
% rho   = the ratio of dendrite to soma conductance, G_D/G_S
% lbtol = a small tolerance to add to the lower bounds we use
% uptol = a small tolerance to add to the upper bounds we use
%
z = zeros(Q,1);
LB = zeros(Q,1);
UB = zeros(Q,1);
kappa = tanh(L)/(rho*L);
for n=1:Q
     LB(n) = ((2*n-1)/(2*L))*pi*lbtol;
     UB(n) = n*pi/L*ubtol;
     [z(n),fx,nEvals,aF,bF] = GlobalNewtonFDTwo('f2',L,rho,LB(n),UB(n),10^-6,10^-8,500);
     w = z*L;
     lb = L*LB;
     %disp(sprintf('n = %3d  EV = %12.7f  LB =  %12.7f  Error = %12.7f ',n,w(n),lb(n),w(n)-lb(n)));
     %disp(sprintf('n %3d function value = %12.7f original function value = %12.7f ',n,sin(w(n)) + kappa*w(n)*cos(w(n)),tan(w(n)) + kappa*w(n))); 
end
end
