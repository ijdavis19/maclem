function f = SetUpOrthogSin(L,N)
%
% Setup function handles
%
f = cell(N,1);
for i=1:N
  f{i} = @(x) sqrt(2/L)*sin( (i)*pi*x/L );
end