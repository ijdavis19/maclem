function [x,fx,nEvals,aF,bF] = ...
         GlobalNewtonFDTwo(fName,L,rho,a,b,tolx,tolf,nEvalsMax)
%
% fName        a string that is the name of the function f(x)
% a,b          we look for the root in the interval [a,b]
% tolx         tolerance on the size of the interval
% tolf         tolerance of f(current approximation to root)
% nEvalsMax    Maximum Number of derivative Evaluations
%
% x            Approximate zero of f
% fx           The value of f at the approximate zero
% nEvals       The Number of Derivative Evaluations Needed
% aF, bF       the final interval the approximate root lies in,
%              [aF,bF]
%
% Termination  Interval [a,b] has size < tolx
%              |f(approximate root)| < tolf
%              Have exceeded nEvalsMax derivative Evaluations
%
fa = feval(fName,a,L,rho);
fb = feval(fName,b,L,rho);
x = a;
fx = feval(fName,x,L,rho);
delta = sqrt(eps)* abs(x);
fpval = feval(fName,x+delta,L,rho);
fpx = (fpval-fx)/delta;

nEvals = 1;
k = 1;
%disp(' ')
%disp(' Step     |       k  |       a(k)    |      x(k)     |       b(k) ')
%disp(sprintf('Start     |  %6d  | %12.7f  | %12.7f  | %12.7f',k,a,x,b));
while   (abs(a-b)>tolx) && (abs(fx)> tolf) && (nEvals<=nEvalsMax) || (nEvals==1)
  %[a,b] brackets a root and x=a or x=b
  check = StepIsIn(x,fx,fpx,a,b);
  if check
    %Take Newton Step
    x = x - fx/fpx;
  else
  %Take a Bisection Step:
  x = (a+b)/2;
  end
  fx = feval(fName,x,L,rho);
  fpval = feval(fName,x+delta,L,rho);
  fpx = (fpval-fx)/delta;  
  nEvals = nEvals+1;
  if fa*fx<=0
    %there is a root in [a,x].  Use right endpoint.
    b = x;
    fb = fx;
  else
    %there is a root in [x,b].  Bring in left endpoint.
    a = x;
    fa = fx;
  end
  k = k+1;
  %if(check)
  %  disp(sprintf('Newton    |  %6d  | %12.7f  | %12.7f  | %12.7f',k,a,x,b));
  %else
  %  disp(sprintf('Bisection |  %6d  | %12.7f  | %12.7f  | %12.7f',k,a,x,b));
  %end
end %end of while
aF = a;
bF = b;	 
end %end on function
