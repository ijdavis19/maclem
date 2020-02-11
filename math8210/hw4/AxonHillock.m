function [tau,VAH] = AxonHillock(Q,L,TD,rho,t0,tf,h,Vmax,location)
%
% Q            = the number of eigenvalues we want to find
% L            = the length of the dendrite in space constants
% rho          = the ratio of dendrite to soma conductance, G_D/G_S
% t0           = initial time
% tf           = final time
% h            = time increment
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
% set dendrite spatial and time bounds
% divide dendritic time into 100 parts
tau = linspace(0,TD,101);
% divide space into 300 parts
lambda = linspace(0,L,301);
% divide axon time into parts of size h
N = round((tf-t0)/h);
tau    = linspace(t0,tf,N);
VAH = zeros(1,N);
A = zeros(Q,1);
for j = 1:Q
  A(j) = B(j+1);
end
% find voltage at space point 0 and time point tau(t)
%for t = 1:N
%  w = z*L;
%  u = -(1+z.*z)*tau(t);
%  x =  (1+z.*z);
%  y = cos(w).*exp(u);
%  VAH(t) = B(1)*exp(-tau(t))+ dot(A,cos(w).*exp(u));
%  dVAHdt(t) = -B(1)*exp(-tau(t)) - dot(A, x.*y); 
%end
% find voltage at space point L and time point tau(t)
for t = 1:N
  w = z*L;
  u = -(1+z.*z)*tau(t);
  x =  (1+z.*z);
  y = x.*exp(u);
  VAH(t) = B(1)*exp(-tau(t))+ dot(A,exp(u));
dVAHdt(t) = -B(1)*exp(-tau(t)) - dot(A, y); 
end







