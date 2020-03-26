function f = SetUpCosines(L,N)
%
% Setup function handles
%
f = cell(N+1,1);
for i=1:N+1
  f{i} = @(x) cos( (i-1)*pi*x/L );
end