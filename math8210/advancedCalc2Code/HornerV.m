function pval = HornerV(a,z)
%
% a    column vector of polynomial coefficients
% z    column vector of domain points to evaluate
%      the polynomial at.
%
% pval column vector of same size at z.
%      pval(i) = polynomial(z(i))
%
n = length(a);
m = length(z);
pval = a(n)*ones(m,1);
for k=n-1:-1:1
  pval = z'.*pval + a(k);
end
end
