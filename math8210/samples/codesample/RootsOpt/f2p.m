function y = f2p(x)
%
L = 5;
rho = 10.0;
kappa = tanh(L)/(rho*L);
y = L/(cos(x*L)*cos(x*L)) + L*kappa;
