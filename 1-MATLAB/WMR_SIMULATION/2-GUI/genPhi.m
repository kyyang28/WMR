%
% @description: Generate an arbitrary MATCHED UNCERTAINTY
%
% @Author: Yankun Yang
% @Email: 88348863@qq.com
% @Version: 001
% @Date: Aug. 19th, 2016
%
function out_phi = genPhi(t,x,ur)
% Generate an arbitray MATCHED UNCERTAINTY to test the performance of
% control law (u) defined in SMCFunc.m file
% @params t   - the duration of the simulation
% @params x   - the initial states of the simulation
% @params ur  - the reference linear and rotational velocities
%               ur = [v_r;w_r]
% @output out_phi - an arbitrary MATCHED UNCERTAINTY

global kphi;

out_phi = zeros(2,1);

% reference initial conditions
x_r = x(1:3);

% current initial conditions
x_c = x(4:6);

% transformation matrix
T = [cos(x_c(3)) sin(x_c(3)) 0; -sin(x_c(3)) cos(x_c(3)) 0; 0 0 1];

% Error system
x_e = T * (x_r - x_c);

% bounded phi matrix (matched uncertainty)
phi_temp = kphi * norm(x_e); %+0.1;%+2*abs(ur(1)*ur(2));

% arbitrary simulated sin and cos matched uncertainties functions
phi_extra = sin(400 * t);
phi_extra2 = cos(400 * t);

phi_out1 = phi_temp * phi_extra;
phi_out2 = phi_temp * phi_extra2;

% output matched uncertainty
out_phi = [phi_out1; phi_out2];

end
