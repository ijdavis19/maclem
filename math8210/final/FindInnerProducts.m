function [ip,norm,phihat] = FindInnerProducts(k,c,W,L,m,pts,mycol)
% 
%Let's find eigenfunctions.
%
% c is the coefficient vector from the previous approximation of the
% coefficients a_{2n}
% k is the positive integer chosen
% W is a vector of eigenvalues
% m is the number of points to use in the plots
% pts is the number of points to use in the Riemann sum approximations
% mycol is the number of eigenfunctions to try to plot.
% Numerical problems make it difficult to get them all, so
% we can choose to plot fewer.
%
[row,col] = size(W);
q2 = MyHorner(c');
p2 = @(w,z) power(w*z,2);
f= @(w,t) power(t,k).*q2(p2(w,t));
phi = @(i,t) f(W(i),t);
EF = zeros(col,pts);
TT = linspace(0,L,pts);
for i = 1:col
    for j = 1:pts
        EF(i,j) = phi(i,TT(j));
    end
end
norm = zeros(1,col);
for i = 1:col
    for j = 1: pts
        norm(i) = norm(i) +  EF(i,j) * EF(i,j) *TT(j) *(L/pts);
    end
    norm(i) = sqrt(norm(i));
end
for i = 1:col
    phihat = @(i,t) phi(i,t)/norm(i);
end
%
ip = zeros(mycol,mycol);
for i = 1:mycol
    for j = 1:mycol
        for k = 1: pts
            ip(i,j)  = ip(i,j) + EF(i,k) * EF(j,k) *TT(k) *(L/pts);
        end
        ip(i,j) = ip(i,j)/(norm(i)*norm(j));
    end
end

%
clf;
hold on;
for i = 1:mycol
    for j = 1:pts
        W(j) = EF(i,j);
    end
    plot(TT,W);
end
hold off;

end