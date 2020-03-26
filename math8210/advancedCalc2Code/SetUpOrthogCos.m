function f = SetUpOrthogCos(L,N)
%
% Setup function handles
%
f = cell(N+1,1);
f{1} = @(x) sqrt(1/L);
for i=2:N+1
  f{i} = @(x) sqrt(2/L)*cos( (i-1)*pi*x/L );
end