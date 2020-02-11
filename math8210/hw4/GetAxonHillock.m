function [V,AH,Input] = GetAxonHillock(Q,L,TD,rho,Vmax,location)
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
% AxonHillock  = the solution at (L,t)
% V            = the solution at (z,t)
%
% get eigenvalue vector z
z = FindRoots(Q,L,rho,1.0,1.0);
% get coefficient matrix M
M = FindM(Q,L,rho,z);
% compute data vector for impulse
D = FindData(Q,L,rho,z,Vmax,location);
% Solve MB = D system
[Lower,Upper,piv] = GePiv(M);
y = LTriSol(Lower,D(piv));
B = UTriSol(Upper,y);
% check errors
Error = Lower*Upper*B - D(piv);
Diff = M*B-D;
e = norm(Error);
e2 = norm(Diff);
disp(sprintf(' norm of LU residual = %12.7f norm of MB-D = %12.7f',e,e2));
% set dendritic spatial and time bounds
% divide dendritic time into 100 parts
tau    = linspace(0,TD,101);
% divide dendritic space L into 300 parts
lambda = linspace(0,L,301);
%
V = zeros(301,101);
A = zeros(Q,1);
for n = 1:Q
  A(n) = B(n+1);
end
% find voltage at space point lambda(s) and time point tau(t)
for s = 1:301
  for t = 1:101
    w = z*(L-lambda(s));
    u = -(1+z.*z)*tau(t);
    V(s,t) = B(1)*exp(-tau(t))+ dot(A,cos(w).*exp(u));
  end
end
% axon hillock is at lambda = 1
AH = V(1,:);
% pulse is modeled at initial time by
Input = V(:,1);






