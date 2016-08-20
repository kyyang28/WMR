function opt=plotDashline(t,x,n)
    lineOpt={'b.' 'k-.'};
    sizeX=size(x);
    if find(sizeX==n)>1
        xshow=x';
    else
        xshow=x;
    end
    plot(t,xshow(1,:),'r-');
    hold on;
    plot(t,xshow(2,:),'b--');
    if n==3
        plot(t,xshow(3,:),'k-.');
    end
    hold off;
end
