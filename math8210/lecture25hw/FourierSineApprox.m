function [A,p] = FourierSineApprox(f,L,M,N)
%
% p is the Nth Fourier Approximation
% f is the original function
% M is the number of Riemann sum terms in the inner product
% N is the number of terms in the approximation
% L is the interval length

% get the first N Fourier sine approximations
g = SetUpSines(L,N);

% get Fourier Sine Coefficients
A = zeros(N,1);
for i=1:N
  A(i) = 2*innerproduct(f,g{i},0,L,M)/L;
end

% get Nth Fourier Sine Approximation
p = @(x) 0;
for i=1:N
  p = @(x) (p(x) + A(i)*g{i}(x));
end

x = linspace(0,L,101);
for i=1:101
  y(i) = f(x(i));
end
yp = p(x);

figure
s = [' Fourier Sine Approximation with ',int2str(N),' term(s)'];
plot(x,y,x,yp);
xlabel('x axis');
ylabel('y axis');
title(s);
end
