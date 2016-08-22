function varargout = DisplayDetailResults(varargin)
% DISPLAYDETAILRESULTS MATLAB code for DisplayDetailResults.fig
%      DISPLAYDETAILRESULTS, by itself, creates a new DISPLAYDETAILRESULTS or raises the existing
%      singleton*.
%
%      H = DISPLAYDETAILRESULTS returns the handle to a new DISPLAYDETAILRESULTS or the handle to
%      the existing singleton*.
%
%      DISPLAYDETAILRESULTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DISPLAYDETAILRESULTS.M with the given input arguments.
%
%      DISPLAYDETAILRESULTS('Property','Value',...) creates a new DISPLAYDETAILRESULTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DisplayDetailResults_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DisplayDetailResults_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DisplayDetailResults

% Last Modified by GUIDE v2.5 21-Aug-2016 14:36:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DisplayDetailResults_OpeningFcn, ...
                   'gui_OutputFcn',  @DisplayDetailResults_OutputFcn, ...
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


% --- Executes just before DisplayDetailResults is made visible.
function DisplayDetailResults_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DisplayDetailResults (see VARARGIN)
global mode_uct TOUT YOUT x_c x_r x_p x_e Tc u_tmp u_tmp2 phi_tmp u_r sigma_1 sigma_2 K c
cla(handles.stateVariablePlot);
cla(handles.linearVelocityControlSignalPlot);
cla(handles.slidingSurfacesPlot);
cla(handles.trackingErrorPlot);
cla(handles.rotationalVelocityControlSignalPlot);
cla(handles.matchedUncertaintyPlot1);
cla(handles.matchedUncertaintyPlot2);
% Choose default command line output for DisplayDetailResults
handles.output = hObject;

% Initialisation of plot
handles.x_p = [];
x_p = [];

for i = 1:length(TOUT)
    handles.Tc = [cos(x_c(3,i)) sin(x_c(3,i)) 0;-sin(x_c(3,i)) cos(x_c(3,i)) 0;0 0 1];
    x_p = [handles.x_p handles.Tc*(x_r(:,i) - x_c(:,i))];
    handles.x_p = x_p;
end

x_e = [handles.x_p(2,:); handles.x_p(1,:); handles.x_p(3,:)];
handles.x_e = x_e;

% output Tc, x_p, x_e to workspace
% MAKE SURE to include "global Tc x_p x_e" variables with EXACT SAME name
assignin('base', 'Tc', Tc);
assignin('base', 'x_p', x_p);
assignin('base', 'x_e', x_e);

u_tmp = [];
u_tmp2 = [];
phi_tmp = [];
u_r = [];
for i = 1:length(TOUT)
    u_r = [u_r genTraj(TOUT(i))];
    u_tmp2 = [u_tmp2 SMCFunc(YOUT(i,:)', genTraj(TOUT(i)))];
    phi_tmp = [phi_tmp genPhi(TOUT(i),YOUT(i,:)',u_r)];
end

u_tmp = u_tmp2;

handles.u_r = u_r;
handles.u_tmp = u_tmp;
handles.phi_tmp = phi_tmp;

assignin('base', 'u_tmp', u_tmp);
assignin('base', 'u_tmp2', u_tmp2);
assignin('base', 'phi_tmp', phi_tmp);
assignin('base', 'u_r', u_r);

% Define function handle of sliding surfaces
sigma_1 = @(x_e) K(1)*x_e;
sigma_2 = @(y_e,x_e,theta) K(2).* theta + y_e./sqrt(c + y_e.^2 + x_e.^2);
handles.sigma_1 = sigma_1;
handles.sigma_2 = sigma_2;
assignin('base', 'sigma_1', sigma_1);
assignin('base', 'sigma_2', sigma_2);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DisplayDetailResults wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% +-----------------------------------------------------------------------+
% +-------------- Helper function to plot individual graph ---------------+
% +-----------------------------------------------------------------------+
plotStateVariableGraph(hObject, eventdata, handles);
plotLinVelCtrlSigGraph(hObject, eventdata, handles);
plotRotVelCtrlSigGraph(hObject, eventdata, handles);
plotSlidingSurfacesGraph(hObject, eventdata, handles);
plotTrackingErrorGraph(hObject, eventdata, handles);

% Only plot uncertainty graphs when there exists uncertainties in the
% control input channel
if mode_uct > 0
    plotMatchedUncertainty1Graph(hObject, eventdata, handles);
    plotMatchedUncertainty2Graph(hObject, eventdata, handles);
end
% +-----------------------------------------------------------------------+
% +-------------- Helper function to plot individual graph ---------------+
% +-----------------------------------------------------------------------+

% --- Outputs from this function are returned to the command line.
function varargout = DisplayDetailResults_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in plotIndividuallyBtn.
function plotIndividuallyBtn_Callback(hObject, eventdata, handles)
% hObject    handle to plotIndividuallyBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Plot the resulting graphs
% run plotResults.m
plotDetailResults(hObject, eventdata, handles);

% --- Executes on button press in closeBtn.
function closeBtn_Callback(hObject, eventdata, handles)
% hObject    handle to closeBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Clear all the graphs
cla(handles.stateVariablePlot);
cla(handles.linearVelocityControlSignalPlot);
cla(handles.slidingSurfacesPlot);
cla(handles.trackingErrorPlot);
cla(handles.rotationalVelocityControlSignalPlot);
cla(handles.matchedUncertaintyPlot1);
cla(handles.matchedUncertaintyPlot2);
close;


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
movegui('center');


% +-----------------------------------------------------------------------+
% +-------------- Helper function to plot individual graph ---------------+
% +-----------------------------------------------------------------------+
function plotStateVariableGraph(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global TOUT x_e
axis(handles.stateVariablePlot);
plot(handles.stateVariablePlot, TOUT, x_e(1,:), 'r-', TOUT, x_e(2,:), 'b--', TOUT, x_e(3,:), 'm-.');
legend(handles.stateVariablePlot,'x_1','x_2','x_3')
xlabel(handles.stateVariablePlot,'Time (sec)');
ylabel(handles.stateVariablePlot,'State');
title(handles.stateVariablePlot,'Time response of the state variables in error tracking system');


function plotLinVelCtrlSigGraph(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global TOUT u_r u_tmp
plot(handles.linearVelocityControlSignalPlot, TOUT, u_r(1,:),'r', TOUT, u_tmp(1,:), 'b-.');
legend(handles.linearVelocityControlSignalPlot, 'u_{v_{ref}}','u_{v_{curr}}')
xlabel(handles.linearVelocityControlSignalPlot, 'Time (sec)');
ylabel(handles.linearVelocityControlSignalPlot, 'Linear velocity [v] (m/s)');
title(handles.linearVelocityControlSignalPlot, 'Time response of linear velocity');


function plotRotVelCtrlSigGraph(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global TOUT u_r u_tmp
plot(handles.rotationalVelocityControlSignalPlot, TOUT,u_r(2,:), 'r', TOUT, u_tmp(2,:), 'b-.');
legend(handles.rotationalVelocityControlSignalPlot, 'u_{w_{ref}}','u_{w_{curr}}')
xlabel(handles.rotationalVelocityControlSignalPlot, 'Time (sec)');
ylabel(handles.rotationalVelocityControlSignalPlot, 'Angular(Steering) velocity [w] (rad/s)');
title(handles.rotationalVelocityControlSignalPlot, 'Time response of angular(steering) velocity');


function plotSlidingSurfacesGraph(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global TOUT x_e sigma_1 sigma_2
plot(handles.slidingSurfacesPlot, TOUT, sigma_1(x_e(2,:)), 'r-', TOUT, sigma_2(x_e(1,:), x_e(2,:), x_e(3,:)), 'b--');
legend(handles.slidingSurfacesPlot, '\sigma_1','\sigma_2')
xlabel(handles.slidingSurfacesPlot, 'Time (sec)');
ylabel(handles.slidingSurfacesPlot, 'Sliding surfaces');
title(handles.slidingSurfacesPlot, 'Time response of sliding surfaces (\sigma_1 and \sigma_2)');


function plotTrackingErrorGraph(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global TOUT errorTracking x_r x_c

errorTracking = x_r - x_c;

axis(handles.trackingErrorPlot);

plot(handles.trackingErrorPlot, TOUT, errorTracking(1,:), 'r-', TOUT, errorTracking(2,:), 'b--', TOUT, errorTracking(3,:), 'm-.');
legend(handles.trackingErrorPlot, 'q_{x_r} - q_{x_c}', 'q_{y_r} - q_{y_c}', '\theta_r - \theta_c')
xlabel(handles.trackingErrorPlot, 'Time (sec)');
ylabel(handles.trackingErrorPlot, 'Tracking errors');
title(handles.trackingErrorPlot, 'Time response of tracking errors');


function plotMatchedUncertainty1Graph(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global TOUT phi_tmp mode_uct

if mode_uct > 0
    plot(handles.matchedUncertaintyPlot1, TOUT, phi_tmp(1,:));
end


function plotMatchedUncertainty2Graph(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global TOUT phi_tmp mode_uct

if mode_uct > 0
    plot(handles.matchedUncertaintyPlot2, TOUT, phi_tmp(2,:));
end


function plotDetailResults(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Step 1: WMR Motion plot
plotWMRMotionGraph(hObject, eventdata, handles);

% Step 2: State plot
plotStateGraph(hObject, eventdata, handles);

% Step 3: Tracking error
plotErrorTrackingGraph(hObject, eventdata, handles);

% Step 4: Control signal
plotControlSignalGraph(hObject, eventdata, handles);

% Step 5: Sliding surface plot
plotSlidingSurfaceGraph(hObject, eventdata, handles);

% Step 6: Matched uncertainty
plotMatchedUncertaintyGraph(hObject, eventdata, handles);


function plotWMRMotionGraph(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global x_r x_c
% Added by YOUNG - Solve separated plot window override the GUI axes contents
fig = figure;
fp = axes('Parent', fig);
% Added by YOUNG - Solve separated plot window override the GUI axes contents

plot(fp, x_r(1,:),x_r(2,:),'r',x_c(1,:),x_c(2,:),'b-.');

% carShapeRef = draw2DCarModel(hObject, eventdata, handles, x_r);
% carShapeReal = draw2DCarModel(hObject, eventdata, handles, x_c);
% carShapeRef = drawTriangle(hObject, eventdata, handles, x_r);
% carShapeReal = drawTriangle(hObject, eventdata, handles, x_c);
% patch(carShapeRef(1,:), carShapeRef(2,:), 'red');
% patch(carShapeReal(1,:), carShapeReal(2,:), 'blue');

legend('Reference trajectory','WMR trajectory','Location','northwest')
% legend('Reference trajectory','WMR trjectory','Start point of reference trajectory','Initial point of actual robot','Location','northwest')
xlabel('XOUT(m)');
ylabel('YOUT(m)');
title('Trajectory tracking of the WMR');


function plotStateGraph(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global TOUT tSpan x_e

% % Added by YOUNG - Solve separated plot window override the GUI axes contents
% fig1 = figure;
% fp1 = axes('Parent', fig1);
% % Added by YOUNG - Solve separated plot window override the GUI axes contents
% 
% plot(fp1, TOUT,x_e(1,:), 'r-');
% hold on;
% plot(fp1, TOUT,x_e(2,:), 'b--');
% plot(fp1, TOUT,x_e(3,:), 'm-.');
% hold off;
% 
% xlim(tSpan);
% legend('x_1','x_2','x_3')
% xlabel('Time (sec)');
% ylabel('State');
% title('Time response of the state variables in error tracking system');

figure;
plot(TOUT,x_e(1,:), 'r-');
hold on;
plot(TOUT,x_e(2,:), 'b--');
plot(TOUT,x_e(3,:), 'm-.');
hold off;

xlim(tSpan);
legend('x_1','x_2','x_3')
xlabel('Time (sec)');
ylabel('State');
title('Time response of the state variables in error tracking system');



function plotErrorTrackingGraph(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global TOUT tSpan errorTracking x_r x_c

% % Added by YOUNG - Solve separated plot window override the GUI axes contents
% fig2 = figure;
% fp2 = axes('Parent', fig2);
% % Added by YOUNG - Solve separated plot window override the GUI axes contents
% 
% errorTracking = x_r - x_c;
% 
% plot(fp2, TOUT,errorTracking(1,:),'r-');
% hold on;
% plot(fp2, TOUT,errorTracking(2,:),'b--');
% plot(fp2, TOUT,errorTracking(3,:),'m-.');
% hold off;
% 
% xlim(tSpan);
% legend('q_{x_r} - q_{x_c}','q_{y_r} - q_{y_c}','\theta_r - \theta_c')
% xlabel('Time (sec)');
% ylabel('Tracking errors');
% title('Time response of tracking errors');
figure;
errorTracking = x_r - x_c;

plot(TOUT,errorTracking(1,:),'r-');
hold on;
plot(TOUT,errorTracking(2,:),'b--');
plot(TOUT,errorTracking(3,:),'m-.');
hold off;

xlim(tSpan);
legend('q_{x_r} - q_{x_c}','q_{y_r} - q_{y_c}','\theta_r - \theta_c')
xlabel('Time (sec)');
ylabel('Tracking errors');
title('Time response of tracking errors');


function plotControlSignalGraph(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global TOUT tSpan u_r u_tmp

% Added by YOUNG - Solve separated plot window override the GUI axes contents
% fig3 = figure;
% fp3 = axes('Parent', fig3);
figure
% Added by YOUNG - Solve separated plot window override the GUI axes contents

subplot(2,1,1);
% ur(1,:) - all the linear velocity in time TOUT
plot(TOUT, u_r(1,:), 'r',TOUT, u_tmp(1,:), 'b-.');
xlim(tSpan);
legend('u_{v_{ref}}','u_{v_{curr}}')
xlabel('Time (sec)');
ylabel('Linear velocity [v] (m/s)');
title('Time response of linear velocity');
% title(tn);
% subplot(2,2,sn(2));
subplot(2,1,2);
plot(TOUT,u_r(2,:), 'r', TOUT, u_tmp(2,:), 'b-.');
xlim(tSpan);
legend('u_{w_{ref}}','u_{w_{curr}}')
xlabel('Time (sec)');
ylabel('Angular(Steering) velocity [w] (rad/s)');
title('Time response of angular(steering) velocity');


function plotSlidingSurfaceGraph(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global TOUT tSpan x_e sigma_1 sigma_2

% % Added by YOUNG - Solve separated plot window override the GUI axes contents
% fig4 = figure;
% fp4 = axes('Parent', fig4);
% % Added by YOUNG - Solve separated plot window override the GUI axes contents
% 
% plot(fp4, TOUT, sigma_1(x_e(2,:)), 'r-');
% hold on;
% plot(fp4, TOUT, sigma_2(x_e(1,:), x_e(2,:), x_e(3,:)), 'b--');
% hold off;
% xlim(tSpan);
% legend('\sigma_1','\sigma_2')
% xlabel('Time (sec)');
% title('Time response of sliding surfaces (\sigma_1 and \sigma_2)');

figure;
plot(TOUT, sigma_1(x_e(2,:)), 'r-');
hold on;
plot(TOUT, sigma_2(x_e(1,:), x_e(2,:), x_e(3,:)), 'b--');
hold off;
xlim(tSpan);
legend('\sigma_1','\sigma_2')
xlabel('Time (sec)');
title('Time response of sliding surfaces (\sigma_1 and \sigma_2)');


function plotMatchedUncertaintyGraph(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global TOUT tSpan mode_uct phi_tmp

if mode_uct > 0
    
%     % Added by YOUNG - Solve separated plot window override the GUI axes contents
%     fig5 = figure;
%     fp5 = axes('Parent', fig5);
%     % Added by YOUNG - Solve separated plot window override the GUI axes contents    
% 
%     subplot(2,1,1,fp5);
%     plot(fp5, TOUT, phi_tmp(1,:));
%     xlim(tSpan);
%     subplot(2,1,2);
%     plot(fp5, TOUT, phi_tmp(2,:));
%     xlim(tSpan);

    figure
    subplot(2,1,1);
    plot(TOUT, phi_tmp(1,:));
    xlim(tSpan);
    subplot(2,1,2);
    plot(TOUT, phi_tmp(2,:));
    xlim(tSpan);
end

% +-----------------------------------------------------------------------+
% +-------------- Helper function to plot individual graph ---------------+
% +-----------------------------------------------------------------------+
