function root = Bisection(fname,a,b,delta)
%
% fname is a string that gives the name of a 
%       continuous function f(x) 
% a,b   this is the interval [a,b] on
%       which f is defined and for which
%       we assume that the product
%       f(a)*f(b) <= 0
% delta this is a non negative real number
%
% root  this is the midpoint of the interval
%       [alpha,beta] having the property that
%       f(alpha)*f(beta) <= 0 and
%       |beta-alpha| <= delta + eps * max(|alpha|,|beta|)
%       and eps is machine zero
%
  disp(' ')
  disp('      k  |       a(k)    |      b(k)     |       b(k) - a(k) ')
  k = 1;
  disp(sprintf(' %6d  | %12.7f  | %12.7f  | %12.7f',k,a,b,b-a));           
  fa = feval(fname,a);
  fb = feval(fname,b);
  while abs(a-b) > delta + eps*max(abs(a),abs(b))
    mid = (a+b)/2;
    fmid = feval(fname,mid);
    if fa*fmid <= 0
      % there is a root in [a,mid]
      b = mid;
      fb = fmid;
    else
      % there is a root in [mid,b]
      a = mid;
      fa = fmid;
    end
    k = k+1;
    disp(sprintf(' %6d  | %12.7f  | %12.7f  | %12.7f',k,a,b,b-a));
  end
  root = (a+b)/2;