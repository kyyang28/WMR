%
% @description: Plot the results of WMR simulation
%
% @Author: Yankun Yang
% @Email: 88348863@qq.com
% @Version: 001
% @Date: Aug. 19th, 2016
%
close all;

width = 500;
pos_gcf = [500 100 800 800];
pos_gcf2 = [500 100 width 500];
pos_gcf3 = [500 100 width 250];
x_r = Y(:,1:3)';
x_c = Y(:,4:6)';
x_p = [];

for i=1:length(T)
    Tc=[cos(x_c(3,i)) sin(x_c(3,i)) 0;-sin(x_c(3,i)) cos(x_c(3,i)) 0;0 0 1];
    x_p = [x_p Tc*(x_r(:,i)-x_c(:,i))];
end

x_e = [x_p(2,:);x_p(1,:);x_p(3,:)];

% Motion plot
figure(1)
plot(x_r(1,:),x_r(2,:),'r',x_c(1,:),x_c(2,:),'b-.');

%-----------------------------------------------%
%-------------Generate Trangle------------------%
a=.1;
datap=trian(x_r(:,1),a);         
xsr=datap(1,:);
ysr=datap(2,:);
datap=trian(x_c(:,1),a);
xsc=datap(1,:);
ysc=datap(2,:);
rr=patch(xsr,ysr,'r');
rc=patch(xsc,ysc,'w');
%---------------------End-----------------------%
%-----------------------------------------------%

set(gcf,'position',pos_gcf);
set(gca,'DataAspectRatioMode','manual');
set(gca,'DataAspectRatio',[1 1 1]);
axis(handles.frameSize);
legend('Reference trajectory','Robot trjectory','Start point of reference trajectory','Initial point of actual robot')
xlabel('x (m)');
ylabel('y (m)');
title('Motion of the WMR');

% State plot
figure(2)
set(gcf,'position',pos_gcf3);

plotDashline(T,x_e,3);
xlim(handles.tSpan);
legend('x_1','x_2','x_3')
xlabel('Time (sec)');
ylabel('State');
title('Time response of the state variables in error tracking system');

% Tracking error
figure(3)
set(gcf,'position',pos_gcf3);
plotDashline(T,x_r-x_c,3);
xlim(handles.tSpan);
legend('q_{xr}-q_{x}','q_{yr}-q_{y}','\theta_{r}-\theta_{c}')
xlabel('Time (sec)');
ylabel('Tracking errors');
title('Time response of tracking errors');

% Control signal
figure(4)
set(gcf,'position',pos_gcf2);

%======================================================================%
ushow=[];
ushowp=[];
phishow=[];
ur=[];
for i=1:length(T)
    ur=[ur genTraj(T(i))];
    ushowp=[ushowp SMCFunc(Y(i,:)',genTraj(T(i)))];
    phishow=[phishow genPhi(T(i),Y(i,:)',ur)];
end

ushow=ushowp;

subplot(2,1,1);
plot(T,ur(1,:),'r',T,ushow(1,:),'b-.');
xlim(handles.tSpan);
legend('u_{r1}','u_1')
xlabel('Time (sec)');
ylabel('Linear velocity v (m/s)');
title('Time response of linear velocity');
% title(tn);
% subplot(2,2,sn(2));
subplot(2,1,2);
plot(T,ur(2,:),'r',T,ushow(2,:),'b-.');
xlim(handles.tSpan);
legend('u_{r2}','u_2')
xlabel('Time (sec)');
ylabel('Steering velocity w (rad/s)');
title('Time response of steering velocity');

% Sliding surface plot
figure(5)
set(gcf,'position',pos_gcf3);

s1=@(x_e) K(1)*x_e;
s2=@(ye,x_e,the) K(2).*the+ye./sqrt(c+ye.^2+x_e.^2);

plot(T,s1(x_e(2,:)),'r-');
hold on;
plot(T,s2(x_e(1,:),x_e(2,:),x_e(3,:)),'b--');
hold off;
xlim(handles.tSpan);
legend('s_1','s_2')
xlabel('Time (sec)');
title('Time response of sliding surfaces');

% Uncertainty
if mode_uct>0
    figure(6);
    set(gcf,'position',pos_gcf2);
    subplot(2,1,1);
    plot(T,phishow(1,:));
    xlim(handles.tSpan);
    subplot(2,1,2);
    plot(T,phishow(2,:));
    xlim(handles.tSpan);
end

