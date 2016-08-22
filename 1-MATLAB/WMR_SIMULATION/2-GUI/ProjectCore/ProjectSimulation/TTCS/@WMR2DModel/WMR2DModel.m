classdef WMR2DModel < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        q = [0 0 0];
        size = [1 0.8];
        color = 'r';
    end
    
    properties(Access = protected)
        alpha = atan2(1,0.8);
        beta = [atan2(0.5,0.8) atan2(0.5,1.2)];
        r = sqrt(0.5^2+0.4^2);
        rw = [sqrt(0.25^2+0.4^2) sqrt(0.25^2+0.6^2)];
        cb = 0;
        wL = 0;
        wR = 0;
    end
    
    methods(Access = public)
        function obj = WMR2DModel(varargin)
            if nargin == 1
                q = varargin{1};
            elseif nargin == 2
                q = varargin{1};
                obj.color = varargin{2};
            elseif nargin > 2
                for i = 1:2:nargin
                    if  strcmp(varargin{i}, 'q'), q = varargin{i+1};
                    elseif  strcmp(varargin{i}, 'size'), obj.size = varargin{i+1};
                    elseif  strcmp(varargin{i}, 'color'), obj.color = varargin{i+1};
                    else error('Invalid argument');
                    end
                end
            end
        end
        
        function obj = initialise(obj,fig_num)
            figure(fig_num);
            q = obj.q;
            c = obj.color;
            s = obj.size;
            l = s(1)/2;
            a = atan2(s(2),s(1));
            b = [atan2(s(2),s(1)/2) atan2(1.5*s(2),s(1)/2)];
            r = norm(s)/2;
            rw = [sqrt((s(1)/2)^2+s(2)^2)/2 sqrt((s(1)/2)^2+(s(2)*1.5)^2)/2];
            
            xp = [r*cos(q(3)+a) l*1.1*cos(q(3)) r*cos(q(3)-a) r*cos(q(3)+a-pi) r*cos(q(3)-a+pi)]+q(1);
            yp = [r*sin(q(3)+a) l*1.1*sin(q(3)) r*sin(q(3)-a) r*sin(q(3)+a-pi) r*sin(q(3)-a+pi)]+q(2);
            cbp = patch(xp,yp,c);
            
            xp = [rw(1)*cos(q(3)+b(1)) rw(2)*cos(q(3)+b(2)) rw(2)*cos(q(3)+pi-b(2)) rw(1)*cos(q(3)+pi-b(1))]+q(1);
            yp = [rw(1)*sin(q(3)+b(1)) rw(2)*sin(q(3)+b(2)) rw(2)*sin(q(3)+pi-b(2)) rw(1)*sin(q(3)+pi-b(1))]+q(2);
            wLp = patch(xp,yp,'k');
            
            xp = [rw(1)*cos(q(3)-b(1)) rw(2)*cos(q(3)-b(2)) rw(2)*cos(q(3)-pi+b(2)) rw(1)*cos(q(3)-pi+b(1))]+q(1);
            yp = [rw(1)*sin(q(3)-b(1)) rw(2)*sin(q(3)-b(2)) rw(2)*sin(q(3)-pi+b(2)) rw(1)*sin(q(3)-pi+b(1))]+q(2);
            wRp = patch(xp,yp,'k');
            
            obj.alpha = a;
            obj.beta = b;
            obj.r = r;
            obj.rw = rw;
            obj.cb = cbp;
            obj.wL = wLp;
            obj.wR = wRp;
        end
        
        function obj = mov(obj,qi)

            obj.q = qi;
            l = obj.size(1)/2;
            q = obj.q;
            a = obj.alpha;
            b = obj.beta;
            r = obj.r;
            rw = obj.rw;
            
            xp = [r*cos(q(3)+a) l*1.1*cos(q(3)) r*cos(q(3)-a) r*cos(q(3)+a-pi) r*cos(q(3)-a+pi)]+q(1);
            yp = [r*sin(q(3)+a) l*1.1*sin(q(3)) r*sin(q(3)-a) r*sin(q(3)+a-pi) r*sin(q(3)-a+pi)]+q(2);
            set(obj.cb,'XData',xp,'YData',yp);
            
            xp = [rw(1)*cos(q(3)+b(1)) rw(2)*cos(q(3)+b(2)) rw(2)*cos(q(3)+pi-b(2)) rw(1)*cos(q(3)+pi-b(1))]+q(1);
            yp = [rw(1)*sin(q(3)+b(1)) rw(2)*sin(q(3)+b(2)) rw(2)*sin(q(3)+pi-b(2)) rw(1)*sin(q(3)+pi-b(1))]+q(2);
            set(obj.wL,'XData',xp,'YData',yp);
            
            xp = [rw(1)*cos(q(3)-b(1)) rw(2)*cos(q(3)-b(2)) rw(2)*cos(q(3)-pi+b(2)) rw(1)*cos(q(3)-pi+b(1))]+q(1);
            yp = [rw(1)*sin(q(3)-b(1)) rw(2)*sin(q(3)-b(2)) rw(2)*sin(q(3)-pi+b(2)) rw(1)*sin(q(3)-pi+b(1))]+q(2);
            set(obj.wR,'XData',xp,'YData',yp);
        end
    end
end
