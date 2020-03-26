function CheckOrtho(f,a,b,NIP)
%
% Perform Graham - Schmidt Orthogonalization
% on a set of functions f
%
%Setup function handles
N = length(f);

for i=1:N
  for j=1:N
    d(i,j) = innerproduct(f{i},f{j},a,b,NIP);
  end
end

d

end


