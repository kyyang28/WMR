
tt = 0:0.01:30;

v_r = 0.3;
w_r = 0.3;

x_r_0 = 0;
y_r_0 = 0;

theta_r = w_r * tt;
xr = x_r_0 + v_r * cos(theta_r);
yr = y_r_0 + v_r * sin(theta_r);
% theta_r = theta_r_0 + w_r * tt;
% xr = x_r_0 + v_r * cos(theta_r) .* tt;
% yr = y_r_0 + v_r * sin(theta_r) .* tt;
plot(xr, yr,'r','LineWidth',2);
