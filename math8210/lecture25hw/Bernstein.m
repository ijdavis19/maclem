function p = Bernstein (f,a,b,n)

% compute Bernstein polynomial approximation
% of order n on the interval [a,b] to f
% f is the function
% n is the order of the Bernstein polynomial
% x in [a,b] is converted to (x-a)/(b-a) to
% give a value in [0,1]
p = @(x) 0;
for i = 1:n+1
  k = i-1;
  % convert the interval [a,b] to [0,1] here
  y = @(x) (x-a)/(b-a);
  % convert the points we evaluate f at to be in [a,b]
  % instead of [0,1]
  z = a + k*(b-a)/n;
  q = @(x) nchoosek(n,k)*(y(x).^k).*((1-y(x)).^(n-k))*f(z);
  p = @(x) (p(x) + q(x) );
end
end
