
close all;

global x_r x_c

sr = 1;
fig_num = 1;
sh = figure(fig_num);
axis manual
axis([-3 3 -3 3]);

% set(gcf,'Renderer','zbuffer');
set(sh,'position',[400 100 800 800]);

set(gca,'DataAspectRatioMode','manual');
set(gca,'DataAspectRatio',[1 1 1]);

%
filename='WMR_TT_Animation.gif';
% filename='RESULTS/Animation_Results/WMR_TT_Animation.gif';

%
xrs=x_r(1,1);
yrs=x_r(2,1);
xcs=x_c(1,1);
ycs=x_c(2,1);

fh1=plot(xrs,yrs,'r','XDataSource','xrs','YDataSource','yrs');
hold on;
fh2=plot(xcs,ycs,'g-.','XDataSource','xcs','YDataSource','ycs');
hold off;
xlabel('x(m)');
ylabel('y(m)')
set(gca,'NextPlot','replacechildren');
carR = WMR2DModel('q',x_r(:,1),'size',[0.25 0.2],'color','r');
carC = WMR2DModel('q',x_c(:,1),'size',[0.25 0.2],'color','g');
carR.initialise(fig_num);
carC.initialise(fig_num);

axis([-3 3 -3 3]);

F=getframe(sh);
im=frame2im(F);
[A,map]=rgb2ind(im,256);
imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',1/sr);
[h,w,p]=size(F.cdata);
rect=[0 0 w h];
for i=1+10:10:1501
% for i=1+10:10:2501
    xrs=x_r(1,1:i);
    yrs=x_r(2,1:i);

    xcs=x_c(1,1:i);
    ycs=x_c(2,1:i);
    
    refreshdata;
    
    carR.mov(x_r(:,i));
    carC.mov(x_c(:,i));

    axis([-3 3 -3 3]);
    F=getframe(sh,rect);
    
    im=frame2im(F);
    [A,map]=rgb2ind(im,256);
    imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',1/sr);
end
