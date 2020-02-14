function [V,AxonHillock,Input] = GetAxonHillockTwo(Q,L,rho,Vmax,location)
%
% Q            = the number of eigenvalues we want to find
% L            = the length of the dendrite in space constants
% rho          = the ratio of dendrite to soma conductance, G_D/G_S
% z            = eigenvalue vector
% D            = data vector
% Vmax         = size of voltage impulse
% location     = location of pulse
% M            = matrix of coefficients for our approximate voltage
%                model
% Input        = the solution as (z,0) to see if match to
%                input voltage is reasonable
% AxonHillock  = the solution at (0,t)
% V            = the solution at (z,t)
%
% get eigenvalue vector z
z = FindRoots(Q,L,rho,1.0,1.0);
% get coefficient matrix M
M = FindM(Q,L,rho,z);
% compute data vector for impulse
D = FindDataTwo(Q,L,rho,z,Vmax,location);
% Solve MB = D system
[Lower,Upper,piv] = GePiv(M);
y = LTriSol(Lower,D(piv));
B = UTriSol(Upper,y);
% check errors
Error = Lower*Upper*B - D(piv);
Diff = M*B-D;
e = norm(Error);
e2 = norm(Diff);
display(sprintf(' norm of LU residual = %12.7f norm of MB-D = %12.7f',e,e2));
% set spatial and time bounds
lambda = linspace(0,5,301);
tau    = linspace(0,5,101);
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
AxonHillock = V(1,:);
Input       = V(:,2);






