%
% @description: Design linear sliding mode controller
%
% @Author: Yankun Yang
% @Email: 88348863@qq.com
% @Version: 001
% @Date: Aug. 26th, 2016
%
function u = SMCFuncL(x, ur)
% Sliding mode controller (SMC) function
% @params x     - initial states of the sytem
% @params ur    - reference linear and rotational velocities
%                 ur = [v_r;w_r]
% @output u     - control law of SMC 

% Control global parameters
global c K eps eta mode_uct kphi;
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

% Step 3: Define linear sliding surfaces
% sigma_1 = K1 * x_e(2) [i.e., ye] + theta_e
% sigma_2 = x_e(1) [i.e., xe]
sigma_1 = K(1) * x_e(2) + x_e(3);
sigma_2 = x_e(1);

% Step 4: Define S and rho matrices
S = [0, K(1), 1; 1, 0, 0];
rho = [0, -K(1)*x_e(1)-1; -1, x_e(2)];

% Step 5: Define F(qe) matrix
% ur(1) = v_r; ur(2) = w_r; x_e(3) = theta_e
% F_pe = [v_r*cos(theta_e); v_r*sin(theta_e); w_r]
F_pe = [ur(1)*cos(x_e(3)); ur(1)*sin(x_e(3)); ur(2)];

% F_tx represents F(t,x)
F_tx = S * F_pe;

% Step 6: Define dp = eta which represents no uncertainty
% dp = eta;

% Deal with uncertainties (including matched (mode_uct = 1) or unmatched (mode_uct = 2))
% if mode_uct > 0
% %   See dissertation notes2 equations 24, 43 for details
%     uphi = kphi * norm(x_e) + 0.6 * abs(ur(1)*ur(2));
% 
% %   new dp = eta(non-uncertainty) + (norm(T_G) * uphi) (matched uncertainty)
%     dp = dp + norm(T_G) * uphi;
% end

% Step 7: Define sign matrix
% SEE PAGE 18 of DISSERTATION NOTES 2
eta_tmp = [2, 0.2];
sign_mat = [eta_tmp(1)*sats(sigma_1,eps(1)); eta_tmp(2)*sats(sigma_2,eps(2))];

% Step 8: Define control law (u)
% Notes: T_G = rho
%        F_tx = T_F(partial derivative) * F_pe
u = -inv(rho) * (F_tx + sign_mat);

%
% Using saturated function instead of sgn function to minimise chattering
% effect
function sgn = sats(x,a)
%  a is the boundary parameter to eliminate chattering effect
   sgn = x / (abs(x) + a);
end

end
