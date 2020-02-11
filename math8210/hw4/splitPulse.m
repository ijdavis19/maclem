function z = splitPulse(x,t,V,t0)
%
if t < t0
  z = 0;
else
  z = V(x,t);
end