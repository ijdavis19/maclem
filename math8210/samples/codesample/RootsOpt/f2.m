function y = f2(x,L,rho)
%
% L = length of the dendrite cable in spatial lengths
% rho = ratio of dendrite to soma conductance, G_D/G_S
%
%
kappa = tanh(L)/(rho*L);
u = x*L;
y = sin(u) + kappa*u*cos(u);
