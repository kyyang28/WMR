%
% @description: Plot the results of WMR simulation
%
% @Author: Yankun Yang
% @Email: 88348863@qq.com
% @Version: 001
% @Date: Aug. 19th, 2016
%
% close all;

global TOUT YOUT

width = 500;
pos_gcf = [500 100 800 800];
pos_gcf2 = [500 100 width 500];
pos_gcf3 = [500 100 width 250];
x_r = YOUT(:,1:3)';
x_c = YOUT(:,4:6)';
x_p = [];

for i=1:length(TOUT)
    Tc=[cos(x_c(3,i)) sin(x_c(3,i)) 0;-sin(x_c(3,i)) cos(x_c(3,i)) 0;0 0 1];
    x_p = [x_p Tc*(x_r(:,i)-x_c(:,i))];
end

x_e = [x_p(2,:);x_p(1,:);x_p(3,:)];

% Motion plot
% figure(1)
% plot(x_r(1,:),x_r(2,:),'r',x_c(1,:),x_c(2,:),'b-.');
% 
% %-----------------------------------------------%
% %-------------Generate Trangle------------------%
% a=.1;
% datap=trian(x_r(:,1),a);         
% xsr=datap(1,:);
% ysr=datap(2,:);
% datap=trian(x_c(:,1),a);
% xsc=datap(1,:);
% ysc=datap(2,:);
% rr=patch(xsr,ysr,'r');
% rc=patch(xsc,ysc,'w');
% %---------------------End-----------------------%
% %-----------------------------------------------%
% 
% set(gcf,'position',pos_gcf);
% set(gca,'DataAspectRatioMode','manual');
% set(gca,'DataAspectRatio',[1 1 1]);
% axis(frameSize);
% legend('Reference trajectory','WMR trjectory','Start point of reference trajectory','Initial point of actual robot')
% xlabel('x (m)');
% ylabel('YOUT (m)');
% title('Motion of the WMR');

% State plot
figure(2)
set(gcf,'position',pos_gcf3);

plotDashline(TOUT,x_e,3);
xlim(tSpan);
legend('x_1','x_2','x_3')
xlabel('Time (sec)');
ylabel('State');
title('Time response of the state variables in error tracking system');

% Tracking error
figure(3)
set(gcf,'position',pos_gcf3);
plotDashline(TOUT,x_r-x_c,3);
xlim(tSpan);
legend('q_{xr}-q_{x}','q_{yr}-q_{YOUT}','\theta_{r}-\theta_{c}')
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
for i=1:length(TOUT)
    ur=[ur genTraj(TOUT(i))];
    ushowp=[ushowp SMCFunc(YOUT(i,:)',genTraj(TOUT(i)))];
    phishow=[phishow genPhi(TOUT(i),YOUT(i,:)',ur)];
end

ushow=ushowp;

subplot(2,1,1);
plot(TOUT,ur(1,:),'r',TOUT,ushow(1,:),'b-.');
xlim(tSpan);
legend('u_{r1}','u_1')
xlabel('Time (sec)');
ylabel('Linear velocity v (m/s)');
title('Time response of linear velocity');
% title(tn);
% subplot(2,2,sn(2));
subplot(2,1,2);
plot(TOUT,ur(2,:),'r',TOUT,ushow(2,:),'b-.');
xlim(tSpan);
legend('u_{r2}','u_2')
xlabel('Time (sec)');
ylabel('Steering velocity w (rad/s)');
title('Time response of steering velocity');

% Sliding surface plot
figure(5)
set(gcf,'position',pos_gcf3);

s1=@(x_e) K(1)*x_e;
s2=@(ye,x_e,the) K(2).*the+ye./sqrt(c+ye.^2+x_e.^2);

plot(TOUT,s1(x_e(2,:)),'r-');
hold on;
plot(TOUT,s2(x_e(1,:),x_e(2,:),x_e(3,:)),'b--');
hold off;
xlim(tSpan);
legend('s_1','s_2')
xlabel('Time (sec)');
title('Time response of sliding surfaces');

% Uncertainty
if mode_uct > 0
    figure(6);
    set(gcf,'position',pos_gcf2);
    subplot(2,1,1);
    plot(TOUT,phishow(1,:));
    xlim(tSpan);
    subplot(2,1,2);
    plot(TOUT,phishow(2,:));
    xlim(tSpan);
end

