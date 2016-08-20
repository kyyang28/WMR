%
% @description: WMR simulation main file
%
% @Author: Yankun Yang
% @Email: 88348863@qq.com
% @Version: 001
% @Date: Aug. 19th, 2016
%
clear all;
clc;

% Global variables for simulation
global c K eps eta mode_uct mode_tjt circle kphi;

% The duration of simulation
duration = 10;
circle = [1 duration];

% Trajectory type size
% trajectorySize = [-1 3 -1 3];       % Line
frameSize = [-2 1 -1 2];     % Circle

% Control mode
% 0: no uncertainty
% 1: matched uncertainty
mode_uct = 1;

% Trajectory type
% 0: line
% 1: circle
mode_tjt = 1;

% Sliding mode control parameters
K = [1 1];          % Sliding function parameters
eps = [0.1 0.1];    % Boundary parameters to alleviate chattering effect
eta = [4; 4];       % Reaching gain
kphi = 0.5;         % parameter for matched uncertainty
% kpsi = 0.1;         % parameter for mismatched uncertainty
c = 1;             % constant parameter

% Setup the initial condition
theta_0 = atan(1);
xc_0 = [0; -0.75; theta_0 + pi/8];     % forward tracking
% xc_0 = [-0.3; -0.4; theta_0 + 0.6];      % backward tracking
xr_0 = [0; 0; theta_0];     % Initial position of reference robot
X_0 = [xr_0; xc_0];             % Initial states of simulation

% Simulation execution
tSpan = [0 duration];
RelTolP = 1e-8;
AbsTolp = 1e-10;
options = odeset('RelTol',RelTolP,'AbsTol',AbsTolp*ones(1,length(X_0)));
% options = odeset('RelTol',RelTolP,'AbsTol',AbsTolp*ones(1,length(X_0)));

% command to run differential equation (ode45)
% all setup and control strategies are included in dynamicFunc function
% file
[T Y] = ode45(@TTExec, tSpan, X_0, options);

% Save results (T Y) of ode45 command to a specified file.
save resultsDataFile.mat T Y

% Plot the resulting graphs
run plotResults.m

