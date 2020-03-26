function [A,p] = FourierCosineApprox(f,L,M,N)
%
% p is the Nth Fourier Approximation
% f is the original function
% M is the number of Riemann sum terms in the inner product
% N is the number of terms in the approximation
% L is the interval length

% get the first N+1 Fourier cos approximations
g = SetUpCosines(L,N);

% get Fourier Cosine Coefficients
A = zeros(N+1,1);
A(1) = innerproduct(f,g{1},0,L,M)/L;
for i=2:N+1
  A(i) = 2*innerproduct(f,g{i},0,L,M)/L;
end

% get Nth Fourier Cosine Approximation
p = @(x) 0;
for i=1:N+1
  p = @(x) (p(x) + A(i)*g{i}(x));
end

x = linspace(0,L,101);
for i=1:101
  y(i) = f(x(i));
end
yp = p(x);

figure
s = [' Fourier Cosine Approximation with ',int2str(N+1),' term(s)'];
plot(x,y,x,yp);
xlabel('x axis');
ylabel('y axis');
title(s);

end