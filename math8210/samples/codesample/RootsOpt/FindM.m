function M = FindM(Q,L,rho,z)
%
% Q     = the number of eigenvalues we want to find
% L     = the length of the dendrite in space constants
% rho   = the ratio of dendrite to soma conductance, G_D/G_S
% M     = matrix of coefficients for our approximate voltage
%         model
%       In MatLab the root numbering is off by 1; so
%       the roots we find start at 1 and end at Q.
%       So M is Q+1 by Q+1.
kappa = tanh(L)/(rho*L);
w = zeros(1+Q,1);
M = zeros(1+Q,1+Q);
w(1) = 0;
% set first diagonal position
M(1,1) = -1/(2*kappa);
for n=1:Q
  w(n+1) = z(n)*L;
end
% set first column
for n = 2:Q+1
  M(1,n) = 0.5*cos(w(n));
end
% set first row
for n = 2:Q+1
  M(n,1) = 0.5*cos(w(n));
end
% set main block
for m=2:Q+1
  for n = 2:Q+1
     if m ~= n
       M(m,n) = cos(w(m))*cos(w(n));
     end
     if m == n
       M(m,m) = -1/(4*kappa)*(1 + sin(2*w(m))/(2*w(m)));
     end
  end
end

