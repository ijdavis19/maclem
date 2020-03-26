function c = innerproduct(f,g,a,b,N)
%
%
h = @(t) f(t)*g(t);

delx = (b-a)/N;
x = linspace(a,b,N+1);
c = 0;
for i=1:N
  c = c+ h(x(i))*delx;
end

end