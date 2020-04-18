function [c,p,q,Z,E,W] = mybessel(k,n,m,u,L)
%
% solution is x(t) = t^r( 1 + sum_{n=1}^\infty a_{2n} t^{2n} )
% k = power
% n = number of terms in exansion of the bessel function
% m = number of points in the plot
%     for the interval [0,u]
% L = the interval is [0,L]
% Z contains the zeros of the Bessel function
% p is the Bessel function partial sum of n+1 terms
% E contains the eigenvalues
%
c = zeros(1,n+1);
% this is a_0
% a_0 = 1 ==> c(1) = a_{i-1}
c(1) = 1;
for i=2:n+1
  % a_{2i} = -a_{2i-2}/[ (2i+k)^2 - k^2] = -a_{2i-2}/[4i^2 + 4iK]
  %        = -a_{2i-2}/[4i(i+k)]
  % c_2 = a_2  = a_{2(2-1)}
  % c_3 = a_4 = a_{2(3-1)}
  % c_4 = a_6 = a_{2(4-1)}
  % c_{p} = a_{2(p-1)}
  % c_{p+1) = a_{2(p+1-1)} = a_{2p}
  m1 = 4*(i-1)*(i-1+k);
  % a_{2i) = -1 a_{2i-2}/[(2i+k)^2-k^2]
  % c_{i+1} = -1 c_{i}/[(2i+k)^2 - k^2]
  % c_i = -1 c_{i-1}/[(2(i-1)+k)^2 - k^2] = -1 c_{i-1}/[4(i-1)(i-1+k)]
  c(i) = -c(i-1)/m1;
end
b = c(1,2:n+1);
% this computes
% c(2) + c(3) x + ...+ c(n+1) x^n
% a(2) + a(4) x + ... + a(2n) x^n
q = MyHorner(b');
% this computes a(2) + a(4)t^2 + a(6) t^4 + ... + a(2n) t^{2n-2}
y = @(z) power(L*z,2);
p = @(z) c(1) + y(z).*q(y(z));
X = linspace(0,u,m);
for i = 1:m
    Y(i) = p(X(i));
end
plot(X,Y);
% find zeros
Z = [];
E = [];
W = [];
for i = 1:m-1
  j = 1;
  if ( (Y(i) < 0) && (Y(i+1) > 0) ) || ( (Y(i) > 0) && (Y(i+1) < 0) )
    M = ( X(i) + X(i+1) )/2.0;
    Z = [Z,L*M];
    E = [E,-power(M,2)];
    W = [W,M];
  end
end

end