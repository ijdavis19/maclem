function [c,fstar] = FindBestApprox(check,n,N,pts,L,phihat,f)
%
% n is the number of normalized eigenfunctions
% L is the interval length
% phihat is the function of normalized eigenfunctions
% phihat(i,t) where i is the eigenfunction number
%          and t is the time
% f is the function to be approximated
% pts is the number of points in the Riemann Sum Approximations
% N is the number of points to use in the [0,L] linspace command
% check when 1 verifies the phihat's generate a reasonable
% ip matrix
% check
if (check == 1)
ip = zeros(n,n);
for i = 1:n
    for j = 1:n
        g1 = @(t) phihat(i,t);
        g2 = @(t) phihat(j,t);
        ip(i,j) = innerproduct(g1,g2,0,L,pts);
    end
end
ip
endif
%
c = zeros(n,1);
for i = 1:n
    g = @(t) phihat(i,t);
    c(i) = innerproduct(f,g,0,L,pts);
end
c
fstar = @(t) 0;
for i=1:n
    g = @(t) phihat(i,t);
    fstar = @(t) ( fstar(t) + c(i)*g(t) );
end

T = linspace(0,L,N);
for i = 1:n
    Y(i) = fstar(T(i));
end
plot(T,Y,T,f(T));

end