function [V,AH] = FindVoltage(Q,L,rho,z,M,D)
%
% Q       = the number of eigenvalues we want to find
% L       = the length of the dendrite in space constants
% rho     = the ratio of dendrite to soma conductance, G_D/G_S
% z       = eigenvalue vector
% D       = data vector
% M       = matrix of coefficients for our approximate voltage
%           model
%
% set time scale for dendrite model
TD = 10.0;
%
[Lower,Upper,piv] = GePiv(M);
y = LTriSol(Lower,D(piv));
B = UTriSol(Upper,y);
Error = Lower*Upper*B - D(piv);
Diff = M*B-D;
e = norm(Error);
e2 = norm(Diff);
disp(sprintf(' norm of LU residual = %12.7f norm of MB-D = %12.7f',e,e2));
% set spatial and time bounds
% divide L into 300 parts
lambda = linspace(0,L,301);
%divide time into 100 parts
tau    = linspace(0,TD,101);
V = zeros(301,101);
% find voltage at space point lambda(s) and time point tau(t)
for s = 1:301
  for t = 1:101
    V(s,t) = B(1)*exp(-tau(t));
    for n=1:Q
      V(s,t) = V(s,t) + B(n+1)*cos(z(n)*(L - lambda(s)))*exp(-(1+z(n)^2)*tau(t));
    end
  end
end
AH = V(1,:);






