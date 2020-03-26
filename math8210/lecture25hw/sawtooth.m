function f = sawtooth(L,H)
%
%
% fleft = H/(L/2) x 
%       = 2Hx/L
% check fleft(0) = 0
%       fleft(L/2) = 2HL/(2L) = H
%
% fright = H + (H - 0)/(L/2 - L)(x - L/2)
%        = H - (2H/L) *x + (2H/L)*(L/2)
%        = H - 2H/L * x + H
%        = 2H - 2Hx/L
% check fright(L/2) = 2H - 2HL/(2L) = 2H -H = H
%        fright(L)   = 2H - 2HL/L = 0
%
fleft  = @(x) 2*x*H/L;
fright = @(x) 2*H - 2*H*x/L;

f      = @(x) splitfunc(x,fleft,fright,L);

end





