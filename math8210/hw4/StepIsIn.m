function ok = StepIsIn(x,fx,fpx,a,b)
%
% x       current approximate root
% fx      value of f at the approximate root
% fpx     value of derivative of f at the approximate
%         root
% a,b     the interval the root is in.
%
% ok      1 if the Newton Step x - fx/fpx is in [a,b]
%         0 if not
%
if fpx > 0
  ok = ((a-x)*fpx <= -fx) & (-fx <= (b-x)*fpx);
elseif fpx < 0
  ok = ((a-x)*fpx >= -fx) & (-fx >= (b-x)*fpx);
else
  ok = 0;
end   
