
% close all;

global xrs_l yrs_l xcs_l ycs_l xrs_nl yrs_nl xcs_nl ycs_nl frameSize
global l_lineTrojectory l_circleTrajectory nl_lineTrojectory
global nl_circleTrajectory x_r_l_line x_c_l_line x_r_nl_line x_c_nl_line
global x_r_l_circle x_c_l_circle x_r_nl_circle x_c_nl_circle

% x_r_tmp = x_r;
% x_c_tmp = x_c;

sr = 10;
fig_num = 1;
sh = figure;
fp = axes('Parent', sh);
% sh = figure(fig_num);

cla(sh);

% fig = figure;
% fp = axes('Parent', fig);

% axis([-3 3 -3 3]);
axis(frameSize);

% set(gcf,'Renderer','zbuffer');
set(sh,'position',[400 100 800 800]);

set(gca,'DataAspectRatioMode','manual');
set(gca,'DataAspectRatio',[1 1 1]);

%
% filename = 'WMR_TT_Animation.gif';
% filename = 'RESULTS/Animation_Results/WMR_TT_Animation.gif';


if l_lineTrojectory == 1 && nl_lineTrojectory == 1 
    xrs_l = x_r_l_line(1,1);
    yrs_l = x_r_l_line(2,1);
    xcs_l = x_c_l_line(1,1);
    ycs_l = x_c_l_line(2,1);
    assignin('base','xrs_l',xrs_l);
    assignin('base','yrs_l',yrs_l);
    assignin('base','xcs_l',xcs_l);
    assignin('base','ycs_l',ycs_l);

    xrs_nl = x_r_nl_line(1,1);
    yrs_nl = x_r_nl_line(2,1);
    xcs_nl = x_c_nl_line(1,1);
    ycs_nl = x_c_nl_line(2,1);
    assignin('base','xrs_nl',xrs_nl);
    assignin('base','yrs_nl',yrs_nl);
    assignin('base','xcs_nl',xcs_nl);
    assignin('base','ycs_nl',ycs_nl);


    % xrs = x_r_tmp(1,1);
    % yrs = x_r_tmp(2,1);
    % xcs = x_c_tmp(1,1);
    % ycs = x_c_tmp(2,1);

    fh1 = plot(fp,xrs_l,yrs_l,'r','XDataSource','xrs_l','YDataSource','yrs_l');
    fh2 = plot(fp,xrs_nl,yrs_nl,'r','XDataSource','xrs_nl','YDataSource','yrs_nl');
    hold on;
    fh3 = plot(fp,xcs_l,ycs_l,'b-.','XDataSource','xcs_l','YDataSource','ycs_l');
    fh4 = plot(fp,xcs_nl,ycs_nl,'b-.','XDataSource','xcs_nl','YDataSource','ycs_nl');
    hold off;
    xlabel('x(m)');
    ylabel('y(m)')
    set(gca,'NextPlot','replacechildren');
    WMR_REF_nl = WMR2DModel('q',x_r_nl_line(:,1),'size',[0.20 0.15],'color','m');
    WMR_REF_l = WMR2DModel('q',x_r_l_line(:,1),'size',[0.20 0.15],'color','r');
    WMR_CURR_nl = WMR2DModel('q',x_c_nl_line(:,1),'size',[0.20 0.15],'color','g');
    WMR_CURR_l = WMR2DModel('q',x_c_l_line(:,1),'size',[0.20 0.15],'color','b');
    % WMR_REF = WMR2DModel('q',x_r_tmp(:,1),'size',[0.25 0.2],'color','r');
    % WMR_CURR = WMR2DModel('q',x_r_tmp(:,1),'size',[0.25 0.2],'color','g');
    WMR_REF_l.initialise(fig_num);
    WMR_REF_nl.initialise(fig_num);
    WMR_CURR_l.initialise(fig_num);
    WMR_CURR_nl.initialise(fig_num);

    axis(frameSize);
    % axis([-3 3 -3 3]);

    F = getframe(sh);
    im = frame2im(F);
    [A,map] = rgb2ind(im,256);
    % imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',1/sr);
    [h,w,p] = size(F.cdata);
    rect = [0 0 w h];

    for i = 1+10:24:5400
    % for i = 1+10:10:2501

        xrs_l = x_r_l_line(1,1:i);
        yrs_l = x_r_l_line(2,1:i);
        xcs_l = x_c_l_line(1,1:i);
        ycs_l = x_c_l_line(2,1:i);

        xrs_nl = x_r_nl_line(1,1:i);
        yrs_nl = x_r_nl_line(2,1:i);
        xcs_nl = x_c_nl_line(1,1:i);
        ycs_nl = x_c_nl_line(2,1:i);

    %     xrs = x_r_tmp(1,1:i);
    %     yrs = x_r_tmp(2,1:i);
    % 
    %     xcs = x_c_tmp(1,1:i);
    %     ycs = x_c_tmp(2,1:i);

        refreshdata;

        WMR_REF_l.mov(x_r_l_line(:,i));
        WMR_CURR_l.mov(x_c_l_line(:,i));
        WMR_REF_nl.mov(x_r_nl_line(:,i));
        WMR_CURR_nl.mov(x_c_nl_line(:,i));
    %     WMR_REF.mov(x_r_tmp(:,i));
    %     WMR_CURR.mov(x_c_tmp(:,i));

        axis(frameSize);
    %     axis([-3 3 -3 3]);
        F = getframe(sh,rect);

        im = frame2im(F);
        [A,map] = rgb2ind(im,256);
    %     imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',1/sr);
    end

    % close(sh);
elseif l_circleTrajectory == 1 && nl_circleTrajectory == 1
    
    xrs_l = x_r_l_circle(1,1);
    yrs_l = x_r_l_circle(2,1);
    xcs_l = x_c_l_circle(1,1);
    ycs_l = x_c_l_circle(2,1);
    assignin('base','xrs_l',xrs_l);
    assignin('base','yrs_l',yrs_l);
    assignin('base','xcs_l',xcs_l);
    assignin('base','ycs_l',ycs_l);

    xrs_nl = x_r_nl_circle(1,1);
    yrs_nl = x_r_nl_circle(2,1);
    xcs_nl = x_c_nl_circle(1,1);
    ycs_nl = x_c_nl_circle(2,1);
    assignin('base','xrs_nl',xrs_nl);
    assignin('base','yrs_nl',yrs_nl);
    assignin('base','xcs_nl',xcs_nl);
    assignin('base','ycs_nl',ycs_nl);


    % xrs = x_r_tmp(1,1);
    % yrs = x_r_tmp(2,1);
    % xcs = x_c_tmp(1,1);
    % ycs = x_c_tmp(2,1);

    fh1 = plot(fp,xrs_l,yrs_l,'r','XDataSource','xrs_l','YDataSource','yrs_l');
    hold on;
    fh2 = plot(fp,xcs_nl,ycs_nl,'b-.','XDataSource','xcs_nl','YDataSource','ycs_nl');
    hold off;
    xlabel('x(m)');
    ylabel('y(m)')
    set(gca,'NextPlot','replacechildren');
    WMR_REF_l = WMR2DModel('q',x_r_l_circle(:,1),'size',[0.25 0.2],'color','r');
    WMR_REF_nl = WMR2DModel('q',x_r_nl_circle(:,1),'size',[0.25 0.2],'color','m');
    WMR_CURR_l = WMR2DModel('q',x_c_l_circle(:,1),'size',[0.25 0.2],'color','b');
    WMR_CURR_nl = WMR2DModel('q',x_c_nl_circle(:,1),'size',[0.25 0.2],'color','g');
    % WMR_REF = WMR2DModel('q',x_r_tmp(:,1),'size',[0.25 0.2],'color','r');
    % WMR_CURR = WMR2DModel('q',x_r_tmp(:,1),'size',[0.25 0.2],'color','g');
    WMR_REF_l.initialise(fig_num);
    WMR_REF_nl.initialise(fig_num);
    WMR_CURR_l.initialise(fig_num);
    WMR_CURR_nl.initialise(fig_num);

    axis(frameSize);
    % axis([-3 3 -3 3]);

    F = getframe(sh);
    im = frame2im(F);
    [A,map] = rgb2ind(im,256);
    % imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',1/sr);
    [h,w,p] = size(F.cdata);
    rect = [0 0 w h];

    for i = 1+10:24:5400
    % for i = 1+10:10:2501

        xrs_l = x_r_l_circle(1,1:i);
        yrs_l = x_r_l_circle(2,1:i);
        xcs_l = x_c_l_circle(1,1:i);
        ycs_l = x_c_l_circle(2,1:i);

        xrs_nl = x_r_nl_circle(1,1:i);
        yrs_nl = x_r_nl_circle(2,1:i);
        xcs_nl = x_c_nl_circle(1,1:i);
        ycs_nl = x_c_nl_circle(2,1:i);

    %     xrs = x_r_tmp(1,1:i);
    %     yrs = x_r_tmp(2,1:i);
    % 
    %     xcs = x_c_tmp(1,1:i);
    %     ycs = x_c_tmp(2,1:i);

        refreshdata;

        WMR_REF_l.mov(x_r_l_circle(:,i));
        WMR_REF_nl.mov(x_r_nl_circle(:,i));
        WMR_CURR_l.mov(x_c_l_circle(:,i));
        WMR_CURR_nl.mov(x_c_nl_circle(:,i));
    %     WMR_REF.mov(x_r_tmp(:,i));
    %     WMR_CURR.mov(x_c_tmp(:,i));

        axis(frameSize);
    %     axis([-3 3 -3 3]);
        F = getframe(sh,rect);

        im = frame2im(F);
        [A,map] = rgb2ind(im,256);
    %     imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',1/sr);
    end

    % close(sh);
end

