function p = MyHorner(a)
% a is a vector of coefficients
% we evaluate the polynomial
% p(x) = a(1) + a(2)*x + ... + 
% a(n)*x^{n-1} + a(n+1)*x^n
% using Horner's method
% p is returned as a function
%
% Example: 
% y = a(1) + a(2) x + a(3)*x^2
%   = a(1) + x * ( a(2) + a(3) * x )
% q = a(2) + a(3) * x
% y = a(1) + x * q 
%
% So set up as a loop
[n,m] = size(a);
if ( n >= 3 )
    p = @(x) a(n-1) + a(n)*x;
    for i = n-2:-1:1
        p = @(x) ( a(i)+ x.*p(x) );
        end
    elseif ( n == 2 )
      p = @(x) a(1) + a(2)*x;
    else
      p = @(x) a(1);
    end
end