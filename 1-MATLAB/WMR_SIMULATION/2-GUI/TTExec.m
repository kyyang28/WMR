%
% @description: Trajectory tracking control execution file
%
% @Author: Yankun Yang
% @Email: 88348863@qq.com
% @Version: 001
% @Date: Aug. 19th, 2016
%
function tt_out = TTExec(t,x)
% trajectoryTrackingExec function generates the trajectory and setup the
% sliding mode controller parameters
% @params t - the duration of simulation
% @params x - initial states ([x_c y_c theta_c x_r y_r theta_r])
% @output tt_out

global mode_uct

% Step 1: Parameter initialisation
tt_out = zeros(6,1);    % six row, one column
x_r_dot = zeros(3,1);   % three row, one column
x_c_dot = zeros(3,1);   % three row, one column
u_r = zeros(1,2);    % one row, two column
u_input = zeros(1,2);     % one row, two column
x_r = x(1:3);

% Step 2: Generate trajectory shape
% t     - the duration of simulation (input parameter)
% u_r    - reference linear and rotational speeds v_r and w_r
%         u_r = [v_r;w_r]
% u_r = genTraj(t);

% Step 3: Generate control law without uncertainty situation
% x     - initial states (input param)
% u_r    - reference trajectory shape (input param)
% u_input = SMCFunc(x, u_r);

% Step 4: Deal with uncertainties, either matched uncertainty (mode_uct = 1) or
% mismatched uncertainty (mode_uct = 2) not included
% ONLY DEAL WITH MATCHED UNCERTAINTY ATM
if mode_uct == 1
%    u_phi = genPhi(t,x,u_r);

%  add MATCHED UNCERTAINTY into the input channel of control law to
%  simulate and see the robustness of the SLIDING MODE CONTROL
%    u_input = u_input + u_phi;
end

% Step 5: Build system models
% x_r = x(1:3) = [x_r, y_r, theta_r]
x_r = x(1:3);

% x_c = x(4:6) = [x_c, y_c, theta_c]
x_c = x(4:6);

% Derivative of x_r = [x_r_dot, y_r_dot, theta_r_dot]
% x_r_dot = u_r(1)*cos(x_r(3)) = v_r*cos(theta_r)
% y_r_dot = u_r(1)*sin(x_r(3)) = v_r*sin(theta_r)
% theta_r_dot = u_r(2) = w_r
x_r_dot = [u_r(1)*cos(x_r(3)); u_r(1)*sin(x_r(3)); u_r(2)];

% Derivative of x_c = [x_c_dot, y_c_dot, theta_c_dot]
% x_c_dot = u_r(1)*cos(x_r(3)) = v_r*cos(theta_c)
% y_c_dot = u_r(1)*sin(x_r(3)) = v_r*sin(theta_r)
% theta_c_dot = u(2) = w_r
x_c_dot = [u_input(1)*cos(x_c(3)); u_input(1)*sin(x_c(3)); u_input(2)];


% Step 6(optional ATM): Deal with mismatched uncertainty


% Step 7: Output to dy
tt_out = [x_r_dot; x_c_dot];

end
