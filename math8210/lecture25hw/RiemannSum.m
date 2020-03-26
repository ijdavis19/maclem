function RS = RiemannSum(f,P,E)
% find Riemann sum
dx = diff(P);
RS = sum(f(E).*dx);
[sizeP,m] = size(P); %get size of Partition
clf; % clear the old graph
%figurehanlde = figure;
hold on % set hold to on
for i = 1:size(P)-1  % graph all the rectangles
  bottom = 0;
  top = f(E(i));
  if f(E(i)) < 0 
    top = 0;
    bottom = f(E(i));
  end
  plot([P(i) P(i+1)],[f(E(i)) f(E(i))]);
  plot([P(i) P(i)], [bottom top]);
  plot([E(i) E(i)], [bottom top],'r');
  plot([P(i+1) P(i+1)], [bottom top]);
  plot([P(i) P(i+1)],[0 0]);
end
y = linspace(P(1),P(sizeP), 101); % overlay the function graph
plot(y,f(y));
xlabel('x axis');
ylabel('y axis');
title('Riemann Sum overlayed on the function graph');
hold off;
end