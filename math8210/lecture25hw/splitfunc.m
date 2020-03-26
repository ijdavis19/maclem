function z = splitfunc(x,f,g,L)
%
if x < L/2
  z = f(x);
else
  z = g(x);
end