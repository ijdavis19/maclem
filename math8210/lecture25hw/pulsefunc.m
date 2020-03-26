function z = pulsefunc(x,x0,r,H)
%
if x > x0-r && x < x0+r
  z = H;
else
  z = 0;
end