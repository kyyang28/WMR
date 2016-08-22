function varargout = RunAnimationGUI(varargin)
% RUNANIMATIONGUI MATLAB code for RunAnimationGUI.fig
%      RUNANIMATIONGUI, by itself, creates a new RUNANIMATIONGUI or raises the existing
%      singleton*.
%
%      H = RUNANIMATIONGUI returns the handle to a new RUNANIMATIONGUI or the handle to
%      the existing singleton*.
%
%      RUNANIMATIONGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RUNANIMATIONGUI.M with the given input arguments.
%
%      RUNANIMATIONGUI('Property','Value',...) creates a new RUNANIMATIONGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RunAnimationGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RunAnimationGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RunAnimationGUI

% Last Modified by GUIDE v2.5 22-Aug-2016 23:19:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RunAnimationGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @RunAnimationGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before RunAnimationGUI is made visible.
function RunAnimationGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RunAnimationGUI (see VARARGIN)

% Choose default command line output for RunAnimationGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RunAnimationGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Run WMR animation
runAnimation(hObject, eventdata, handles);


% --- Outputs from this function are returned to the command line.
function varargout = RunAnimationGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
movegui('center');


% --- Executes on button press in quitBtn.
function quitBtn_Callback(hObject, eventdata, handles)
% hObject    handle to quitBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;


% Helper function
function runAnimation(hObject, eventdata, handles)
% hObject    handle to quitBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global x_r x_c

x_r_tmp = x_r;
x_c_tmp = x_c;

sr = 10;
% fig_num = 1;
% sh = figure(fig_num);
% axis manual
% axis([-3 3 -3 3]);

% set(gcf,'Renderer','zbuffer');
% set(sh,'position',[400 100 800 800]);

% set(gca,'DataAspectRatioMode','manual');
% set(gca,'DataAspectRatio',[1 1 1]);

%
filename='WMR_TT_Animation.gif';
% filename='RESULTS/Animation_Results/WMR_TT_Animation.gif';

%
xrs=x_r_tmp(1,1);
yrs=x_r_tmp(2,1);
xcs=x_c_tmp(1,1);
ycs=x_c_tmp(2,1);

fh1=plot(handles.animationAxes,xrs,yrs,'r','XDataSource','xrs','YDataSource','yrs');
hold on;
fh2=plot(handles.animationAxes,xcs,ycs,'g-.','XDataSource','xcs','YDataSource','ycs');
hold off;
xlabel('x(m)');
ylabel('y(m)')
set(gca,'NextPlot','replacechildren');
carR = WMR2DModel('q',x_r_tmp(:,1),'size',[0.25 0.2],'color','r');
carC = WMR2DModel('q',x_r_tmp(:,1),'size',[0.25 0.2],'color','g');
carR.initialise(fig_num);
carC.initialise(fig_num);

axis([-3 3 -3 3]);

F=getframe(handles.animationAxes);
im=frame2im(F);
[A,map]=rgb2ind(im,256);
imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',1/sr);
[h,w,p]=size(F.cdata);
rect=[0 0 w h];

for i=1+10:10:2501
    xrs=x_r_tmp(1,1:i);
    yrs=x_r_tmp(2,1:i);

    xcs=x_c_tmp(1,1:i);
    ycs=x_c_tmp(2,1:i);
    
    refreshdata;
    
    carR.mov(x_r_tmp(:,i));
    carC.mov(x_c_tmp(:,i));

    axis([-3 3 -3 3]);
    F=getframe(sh,rect);
    
    im=frame2im(F);
    [A,map]=rgb2ind(im,256);
    imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',1/sr);
end

