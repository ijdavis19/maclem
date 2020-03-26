function f = SetUpFunctions(N)
%
% Setup function handles
%
f = cell(N+1,1);
for i=1:N+1
  f{i} = @(x) Powers(x,i-1);
end