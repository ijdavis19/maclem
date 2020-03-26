function [A,B] = FourierApprox (f,L,M,N)
% p is the Nth Fourier Approximation
% f is the original function
% M is the number of Riemann sum terms in the inner product
% N is the number of terms in the approximation
% L is the interval length

% get the first N+1 Fourier cos approximations
g = SetUpCosines(L,N);
% get Fourier Cosine Coefficients
B = zeros(N+1,1);
B(1) = innerproduct(f,g{1},0,L,M)/L;
for i=2:N+1
  B(i) = 2*innerproduct(f,g{i},0,L,M)/L;
end
% get Nth Fourier Cosine Approximation
p = @(x) 0;
for i=1:N+1
  p = @(x) (p(x) + B(i)*g{i}(x));
end

% get the first N Fourier sine approximations
h = SetUpSines(L,N);

% get Fourier Sine Coefficients
A = zeros(N,1);
for i=1:N
  A(i) = 2*innerproduct(f,h{i},0,L,M)/L;
end

% get Nth Fourier Sine Approximation
q = @(x) 0;
for i=1:N
  q = @(x) (q(x) + A(i)*h{i}(x));
end
x = linspace(0,L,101);
for i=1:101
  y(i) = f(x(i));
end
yp = 0.5*(p(x)+q(x));

figure
s = [' Fourier Sin and Cos Approximation with ',int2str(2*N+1),' term(s)'];
plot(x,y,x,yp);
xlabel('x axis');
ylabel('y axis');
title(s);

end
