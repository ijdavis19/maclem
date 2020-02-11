function D = FindDataTwo(Q,L,rho,z,Vmax,lambda0)
%
% Q       = the number of eigenvalues we want to find
% L       = the length of the dendrite in space constants
% rho     = the ratio of dendrite to soma conductance, G_D/G_S
% z       = eigenvalue vector
% D       = data vector
% Vmax    = size of voltage impulse
% lambda0 = location of the pulse
% M       = matrix of coefficients for our approximate voltage
%           model
%
kappa = tanh(L)/(rho*L);
w = zeros(1+Q,1);
D = zeros(1+Q,1);
multiplier = -Vmax/(2*kappa*L);
%
w(1) = 0;
for n=1:Q
  w(n+1) = z(n);
end
el = exp(-lambda0);
eLl = exp(lambda0-L);
D(1) = multiplier*(2 - el - eLl);
for n = 2:Q+1
  cl = cos(w(n)*L);
  sl = sin(w(n)*L);
  cLl = cos(w(n)*(L-lambda0));
  D(n) = (multiplier/(1+w(n)^2))*(2*cLl - el*(cl - w(n)*sl) - eLl);
end


