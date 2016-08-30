%
% @description: Generate different trajectory shapes
%
% @Author: Yankun Yang
% @Email: 88348863@qq.com
% @Version: 001
% @Date: Aug. 19th, 2016
%
function u_r = genTraj(t)
% function to generate different trajectory shapes

global mode_tjt circle vrVal wrVal

% Initialse u_r
u_r = zeros(2,1);

if mode_tjt == 0
%   Line
    v_r = vrVal;
    w_r = wrVal;
elseif mode_tjt == 1
%   Circle (TBA)
    v_r = vrVal;
    w_r = wrVal;
%     v_r = 2 * circle(1) * pi / circle(2);
%     w_r = v_r * circle(1);
end

% output results to u_r
u_r = [v_r;w_r];

end
