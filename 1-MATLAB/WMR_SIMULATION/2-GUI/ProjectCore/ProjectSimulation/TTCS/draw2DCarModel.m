
clc;

% Rotational angle in radian
theta = 0.7854;

% Rotational matrix
R = [cos(theta) -sin(theta); sin(theta) cos(theta)];

% Length of the square
L = 0.3;

% Robot center coordinate
centerP = [0.25, 0, theta];

% Calculate four corner coordinates based on the robot center coordinate
cornerP1 = [centerP(1)+1/2*L*sin(centerP(3)), centerP(2)+1/2*L*cos(centerP(3))]
cornerP2 = [centerP(1)-1/2*L*cos(centerP(3)), centerP(2)+1/2*L*sin(centerP(3))]
cornerP3 = [centerP(1)-1/2*L*sin(centerP(3)), centerP(2)-1/2*L*cos(centerP(3))]
cornerP4 = [centerP(1)+1/2*L*cos(centerP(3)), centerP(2)-1/2*L*sin(centerP(3))]

% Robot X axises matrix
cornerP_X = [cornerP1(1), cornerP2(1), cornerP3(1), cornerP4(1)];

% Robot Y axises matrix
cornerP_Y = [cornerP1(2), cornerP2(2), cornerP3(2), cornerP4(2)];

% Coordinates of all four corner points
groupP = [cornerP_X; cornerP_Y];

% Coordinates of all four corner points after applying rotational matrix
rotGroupP = R*groupP;

% draw the graph based on the rotationed matrix of robot
hh = patch(rotGroupP(1,:), rotGroupP(2,:), 'r');

