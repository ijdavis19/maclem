function g = GrahamSchmidtThree(f,a,b,NIP)
%
% Perform Graham - Schmidt Orthogonalization
% on a set of functions f
%
%Setup function handles
N = length(f);
g = cell(N,1);

nf = sqrt(innerproduct(f{1},f{1},a,b,NIP));
g{1} = @(x) f{1}(x)/nf;
d = zeros(N,N);
for k=2:N
  %compute next orthogonal piece
  phi = @(x) 0;
  for j = 1:k-1
    c = innerproduct(f{k},g{j},a,b,NIP);
    phi = @(x) (phi(x)+c*g{j}(x));
  end
  psi = @(x) (f{k}(x) - phi(x));
  nf = sqrt(innerproduct(psi,psi,a,b,NIP));
  g{k} = @(x) (psi(x)/nf);
  end
  
for i=1:N
  for j=1:N
    d(i,j) = innerproduct(g{i},g{j},a,b,NIP);
  end
end

d

end


