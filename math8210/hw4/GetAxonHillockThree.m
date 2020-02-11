function V = GetAxonHillockThree(Q,L,rho,Vmax,location)
%
% Arguments
%
% Q            = the number of eigenvalues we want to find
% L            = the length of the dendrite in space constants
% rho          = the ratio of dendrite to soma conductance, G_D/G_S
% Vmax         = size of voltage impulse
% location     = location of pulse
% z            = eigenvalue vector
% D            = data vector
%
% Computed Quantities
%
% M            = coefficient matrix for approximate voltage model              
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
normmessage = sprintf(' norm of LU residual = %12.7f norm of MB-D = %12.7f',e,e2);
disp(normmessage);

% set spatial and time bounds
V = @(s,t) B(1)*exp(-t);
for n=1:Q
  V = @(s,t) (V(s,t) + B(n+1)*cos(z(n)*(L - s)).*exp(-(1+z(n)^2)*t));
end

%
% draw surface for grid [0,L] x [0,5]
% set up space and time stuff
 space = linspace(0,L,101);
 time  = linspace(0,5,101);
% set up grid of x and y pairs (space(i),time(j))
 [Space,Time] = meshgrid(space,time);
% set up surface
Z = V(Space,Time);

%plot surface
figure
mesh(Space,Time,Z,'EdgeColor','black');
xlabel('Dendrite Cable axis');
ylabel('Time axis');
zlabel('Voltage');
title('Dendritic Voltage');
print -dpng 'DendriticVoltage.png';

end






