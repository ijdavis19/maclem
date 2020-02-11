function D = FindVR(Q,L,rho,z,VR)
%
% Q       = the number of eigenvalues we want to find
% L       = the length of the dendrite in space constants
% rho     = the ratio of dendrite to soma conductance, G_D/G_S
% z       = eigenvalue vector
% D       = data vector
% VR      = cable equilibrium voltage
% M       = matrix of coefficients for our approximate voltage
%           model
%
kappa = tanh(L)/(rho*L);
w = zeros(1+Q,1);
D = zeros(1+Q,1);
multiplier = -VR/(2*kappa*L);
%
w(1) = 0;
for n=1:Q
  w(n+1) = z(n);
end
D(1) = multiplier*L;
for n = 2:Q+1
  D(n) = multiplier*sin(w(n)*L)/w(n);
end


