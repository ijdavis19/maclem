function f = SetUpSines(L,N)
%
% Setup function handles
%
f = cell(N,1);
for i=1:N
  f{i} = @(x) sin( i*pi*x/L );
end