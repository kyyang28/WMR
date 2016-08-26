
function [] = freefall(h,tf,x0,v0)

t = 0:0.01:tf;

for ii = 1:1:length(t)
   y(ii) = h - 9.8*(t(ii)^2);   % find y
   x(ii) = x0 + v0*t(ii);       % find x
   plot(x(ii),y(ii),'*b');      % plot x y
   hold on;
   drawnow;
end

end
