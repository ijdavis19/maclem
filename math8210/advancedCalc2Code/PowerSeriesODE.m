function A = PowerSeriesODE(a0,a1,n)
%
% a0, a1 = arbitrary constants
% n = number of terms to find in PS solution 
%
% Recurrence Relation to use
% Coefficients are off by one
% because of MatLab's indexing
A = zeros(n+1,1);
A(1) = a0;
A(2) = a1;
A(3) = - A(1);
A(4) = -(4/3)*A(2);
for i = 3:n+1
  A(i+2) = -((6*i+2)*A(i)+9*A(i-2))/((i+1)*(i+2)); 
end
