function g = GrahamSchmidtTwo(a,b,N,NIP)
%
% Perform Graham - Schmidt Orthogonalization
% on a set of functions t^0,..., t^N
%
%Setup function handles
f = SetUpFunctions(N);
g = cell(N+1,1);

nf = sqrt(innerproduct(f{1},f{1},a,b,NIP));
g{1} = @(x) f{1}(x)/nf;
d = zeros(N+1,N+1);
for k=2:N+1
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
  
for i=1:N+1
  for j=1:N+1
    d(i,j) = innerproduct(g{i},g{j},a,b,NIP);
  end
end

d

end


