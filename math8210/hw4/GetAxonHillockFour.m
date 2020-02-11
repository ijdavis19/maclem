function [V,Surface] = GetAxonHillockFour(Q,L,rho,Vmax,x0,t0,tf)
%
% Arguments
%
% Q            = the number of eigenvalues we want to find
% L            = the length of the dendrite in space constants
% rho          = the ratio of dendrite to soma conductance, G_D/G_S
% Vmax         = size of voltage impulse
% x0           = cable location of pulse
% t0           = start time of pulse
% tf           = end time for axonal pulse
%
% Computed Quantities
%
% z            = eigenvalue vector
% D            = data vector
% M            = coefficient matrix for approximate voltage model              
% AxonHillock  = the solution at (0,t)
% V            = the solution at (z,t)
%
% get eigenvalue vector z
z = FindRoots(Q,L,rho,1.0,1.0);
% get coefficient matrix M
M = FindM(Q,L,rho,z);
% compute data vector for impulse
D = FindDataTwo(Q,L,rho,z,Vmax,x0);
% Solve MB = D system
[Lower,Upper,piv] = GePiv(M);
y = LTriSol(Lower,D(piv));
B = UTriSol(Upper,y);
% check errors
Error = Lower*Upper*B - D(piv);
Diff = M*B-D;
e = norm(Error);
e2 = norm(Diff);
%normmessage = sprintf(' norm of LU residual = %12.7f norm of MB-D = %12.7f',e,e2);
%disp(normmessage);

EZ = zeros(Q,1);
for n = 1:Q
  EZ(n) = -(1+z(n)^2);
end

BB = zeros(Q,1);
for n = 1:Q
  BB(n) = B(n+1);
end

B(1)+...
B(2)*cos( z(1)*(L-x0))+...
B(3)*cos( z(2)*(L-x0))+...
B(4)*cos( z(3)*(L-x0))

% set spatial and time bounds
%V = @(s,t) B(1)*exp(-abs(t-t0));
%for n=1:Q
%  V = @(s,t) (V(s,t) + B(n+1)*cos(z(n)*(L - s)).*exp(-(1+z(n)^2)*abs(t-t0)));
%            1 2   2    2   2    2 3 3 3     32     2 3   4 4  3    3    321
%end
%
% BB is Qx1
% z is Qx1
% cos(z*(L-s)) is Qx1
% BB.*cos(x*(L-s)) is Qx1
% EZ is Qx1
% EZ.*(t-t0) is Qx1
% exp(EZ.*(t-t0)) is Qx1
% so whole calculation is Qx1 and sum is number
%
V = @(s,t) B(1)*exp(-abs(t-t0)) + sum( ( BB.*cos(z*(L-s)) ).*exp(EZ*abs(t-t0)) );
%                                    1 2        3   4   43 2     2       3    32 1

V(0.1,t0)
%
% draw surface for grid [0,L] x [0,tf]
% set up space and time stuff
sizetime = tf/.1+1;
sizespace = L/.1+1;
 space = linspace(0,L,sizespace);
 time  = linspace(0.3,tf,sizetime);
% set up grid of x and y pairs (space(i),time(j))
 [Space,Time] = meshgrid(space,time);
 
% rows of Space are copies of space
% as many rows are there are time points
% cols of Time are copies of time
% as many cols are there are space points
[rowspace,colspace] = size(Space);
[rowstime,coltime] = size(Space);
% 
% set up surface
%
% for this to work
% rowspace = coltime
% colspace = rowtime
for i=1:sizespace
  for j=1:sizetime
    Z(j,i) = V(space(i),time(j));
  end
end
%[rowZ,colZ] = size(Z);

%Z = V(Space,Time);
%plot surface
figure
mesh(Space,Time,Z,'EdgeColor','black');
Surface = gcf();
xlabel('Dendrite Cable axis');
ylabel('Time axis');
zlabel('Voltage');
title('Dendritic Voltage');
%print -dpng 'DendriticVoltage.png';

end






