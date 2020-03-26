function RS = RiemannUniformSum(f,a,b,n)
% 
deltax = (b-a)/n;  
P = [a:deltax:b]; %makes a row vector
for i=1:n
  start = a+(i-1)*deltax;
  stop = a+i*deltax;
  E(i) = 0.5*(start+stop);
end
RS = RiemannSum(f,P',E'); % send in transpose of P so column
end