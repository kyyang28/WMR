function output = trian( x,a )

%UNTITLED 此处显示有关此函数的摘要

%   此处显示详细说明

xs=zeros(1,3);

ys=zeros(1,3);

xs(1)=x(1)+sqrt(3)/3*a*cos(x(3));

xs(2)=x(1)+sqrt(3)/3*a*cos(x(3)+2*pi/3);

xs(3)=x(1)+sqrt(3)/3*a*cos(x(3)-2*pi/3);



ys(1)=x(2)+sqrt(3)/3*a*sin(x(3));

ys(2)=x(2)+sqrt(3)/3*a*sin(x(3)+2*pi/3);

ys(3)=x(2)+sqrt(3)/3*a*sin(x(3)-2*pi/3);

output=[xs;ys];

end



