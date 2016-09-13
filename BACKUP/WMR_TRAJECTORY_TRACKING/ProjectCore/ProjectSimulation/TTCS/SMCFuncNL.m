%
% @description: Design nonlinear sliding mode controller
%
% @Author: Yankun Yang
% @Email: 88348863@qq.com
% @Version: 001
% @Date: Aug. 19th, 2016
%
function u = SMCFuncNL(x, ur)
% Sliding mode controller (SMC) function
% @params x     - initial states of the sytem
% @params ur    - reference linear and rotational velocities
%                 ur = [v_r;w_r]
% @output u     - control law of SMC 

% Control global parameters
global c K1 K2 eps1 eps2 eta1 eta2 mode_uct kphi;
% global kpsi   % for mismatched uncertainty

% Step 1: Initialise initial states to x_r and x_c
u = zeros(2,1);
x_r = x(1:3);       % reference posture
x_c = x(4:6);       % current posture

% Step 2: Define transformation matrix T
T = [cos(x_c(3)) sin(x_c(3)) 0; -sin(x_c(3)) cos(x_c(3)) 0; 0 0 1];

% Step 3: Define error system model
% xe(1) = xe ?xr - xc?
% xe(2) = ye ?yr - yc?
% xe(3) = theta_e ?theta_r - theta_c?
x_e = T * (x_r - x_c);

% Step 3: Define nonlinear sliding surfaces
% sigma_1 = K1 * xe
% sigma_2 = K2 * theta_e + ye / sqrt(c + ye^2 + xe^2)
sigma_1 = K1 * x_e(1);
sigma_2 = K2 * x_e(3) + x_e(2) / sqrt(c + x_e(2)^2 + x_e(1)^2);

% Step 4: Define T_F and T_G matrix
% Notes:    T_G = rho
%           T_F is acquired from partial derivative
T_G = [-K1 K1*x_e(2); x_e(1)*x_e(2)/((c+x_e(1)^2+x_e(2)^2)^(3/2)) -x_e(1)/((c+x_e(1)^2+x_e(2)^2)^(1/2))-K2];
T_F = [K1 0 0; -x_e(1)*x_e(2)/((c+x_e(1)^2+x_e(2)^2)^(3/2)) (c+x_e(2)^2)/(c+x_e(2)^2+x_e(1)^2)^(3/2) K2];

% Step 5: Define F(qe) matrix
% ur(1) = v_r; ur(2) = w_r; x_e(3) = theta_e
% F_pe = [v_r*cos(theta_e); v_r*sin(theta_e); w_r]
F_pe = [ur(1)*cos(x_e(3)); ur(1)*sin(x_e(3)); ur(2)];

% F_tx represents F(t,x)
F_tx = T_F * F_pe;

% Step 6: Define dp = eta which represents no uncertainty
eta = [eta1,eta2];
dp = eta;

% Deal with uncertainties (including matched (mode_uct = 1) or unmatched (mode_uct = 2))
if mode_uct > 0
%   See dissertation notes2 equations 24, 43 for details
    uphi = kphi * norm(x_e) + 0.6 * abs(ur(1)*ur(2));

%   new dp = eta(non-uncertainty) + (norm(T_G) * uphi) (matched uncertainty)
    dp = dp + norm(T_G) * uphi;
end

% Step 7: Define sign matrix
% SEE PAGE 18 of DISSERTATION NOTES 2

sign_mat = [dp(1)*sats(sigma_1,eps1); dp(2)*sats(sigma_2,eps2)];

% Step 8: Define control law (u)
% Notes: T_G = rho
%        F_tx = T_F(partial derivative) * F_pe
u = -inv(T_G) * (F_tx + sign_mat);

%
% Using saturated function instead of sgn function to minimise chattering
% effect
function sgn = sats(x,a)
%  a is the boundary parameter to eliminate chattering effect
   sgn = x / (abs(x) + a);
end

end
