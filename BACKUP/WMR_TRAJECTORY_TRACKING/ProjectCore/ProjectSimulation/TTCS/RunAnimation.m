
% close all;

global x_r x_c xrs yrs xcs ycs frameSize inLine inCircle

sr = 10;
fig_num = 1;
sh = figure;
fp = axes('Parent', sh);

cla(sh);

axis(frameSize);

% set(gcf,'Renderer','zbuffer');
set(sh,'position',[400 100 800 800]);

set(gca,'DataAspectRatioMode','manual');
set(gca,'DataAspectRatio',[1 1 1]);


%
xrs = x_r(1,1);
yrs = x_r(2,1);
xcs = x_c(1,1);
ycs = x_c(2,1);
assignin('base','xrs',xrs);
assignin('base','yrs',yrs);
assignin('base','xcs',xcs);
assignin('base','ycs',ycs);


fh1 = plot(fp,xrs,yrs,'r','XDataSource','xrs','YDataSource','yrs');
hold on;
fh2 = plot(fp,xcs,ycs,'b-.','XDataSource','xcs','YDataSource','ycs');
hold off;
xlabel('x(m)');
ylabel('y(m)');
set(gca,'NextPlot','replacechildren');

if inLine == 1 && inCircle == 0
    WMR_REF = WMR2DModel('q',x_r(:,1),'size',[0.25 0.2],'color','r');
    WMR_CURR = WMR2DModel('q',x_c(:,1),'size',[0.25 0.2],'color','g');
elseif inLine == 0 && inCircle == 1
    WMR_REF = WMR2DModel('q',x_r(:,1),'size',[0.10 0.1],'color','r');
    WMR_CURR = WMR2DModel('q',x_c(:,1),'size',[0.10 0.1],'color','g');
end

WMR_REF.initialise(fig_num);
WMR_CURR.initialise(fig_num);

axis(frameSize);

F = getframe(sh);
im = frame2im(F);
[A,map] = rgb2ind(im,256);
[h,w,p] = size(F.cdata);
rect = [0 0 w h];

for i = 1+10:34:8500
        
    xrs = x_r(1,1:i);
    yrs = x_r(2,1:i);

    xcs = x_c(1,1:i);
    ycs = x_c(2,1:i);
    
    refreshdata;
    
    WMR_REF.mov(x_r(:,i));
    WMR_CURR.mov(x_c(:,i));

    axis(frameSize);

    F = getframe(sh,rect);
    
    im = frame2im(F);
    [A,map] = rgb2ind(im,256);
end

