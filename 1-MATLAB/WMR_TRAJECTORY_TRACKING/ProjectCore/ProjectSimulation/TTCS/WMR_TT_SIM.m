function varargout = WMR_TT_SIM(varargin)
% WMR_TT_SIM MATLAB code for WMR_TT_SIM.fig
%      WMR_TT_SIM, by itself, creates a new WMR_TT_SIM or raises the existing
%      singleton*.
%
%      H = WMR_TT_SIM returns the handle to a new WMR_TT_SIM or the handle to
%      the existing singleton*.
%
%      WMR_TT_SIM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WMR_TT_SIM.M with the given input arguments.
%
%      WMR_TT_SIM('Property','Value',...) creates a new WMR_TT_SIM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before WMR_TT_SIM_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to WMR_TT_SIM_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help WMR_TT_SIM

% Last Modified by GUIDE v2.5 28-Aug-2016 03:00:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @WMR_TT_SIM_OpeningFcn, ...
                   'gui_OutputFcn',  @WMR_TT_SIM_OutputFcn, ...
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


% --- Executes just before WMR_TT_SIM is made visible.
function WMR_TT_SIM_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to WMR_TT_SIM (see VARARGIN)
clc;
% set(handles.trajectoryTrackingResult, 'XLim', [-2,1], 'YLim', [-1,2]);
% set(handles.trajectoryTrackingResult, 'XLim', [-1,3], 'YLim', [-1,3]);
global SMCMode LinearSMCModeFlag NonlinearSMCModeFlag
global linearMode nonlinearMode l_lineTrojectory l_circleTrajectory 
global nl_lineTrojectory nl_circleTrajectory

linearMode = 0;
nonlinearMode = 0;
l_lineTrojectory = 0;
l_circleTrajectory = 0;
nl_lineTrojectory = 0;
nl_circleTrajectory = 0;
assignin('base','linearMode',linearMode);
assignin('base','nonlinearMode',nonlinearMode);
assignin('base','l_lineTrojectory',l_lineTrojectory);
assignin('base','l_circleTrajectory',l_circleTrajectory);
assignin('base','nl_lineTrojectory',nl_lineTrojectory);
assignin('base','nl_circleTrajectory',nl_circleTrajectory);

% Choose default command line output for WMR_TT_SIM
handles.output = hObject;
handles.trajectoryType = 0;
handles.flag = 0;
handles.LinearSMCModeFlag = 0;
handles.NonlinearSMCModeFlag = 0;
LinearSMCModeFlag = 0;
NonlinearSMCModeFlag = 0;
assignin('base','LinearSMCModeFlag',LinearSMCModeFlag);
assignin('base','NonlinearSMCModeFlag',NonlinearSMCModeFlag);
handles.SMCMode = 1;
SMCMode = 1;
assignin('base','SMCMode',SMCMode);
% handles.K = 0;
handles.K1 = 0;
handles.K2 = 0;
handles.eps1 = 0;
handles.eps2 = 0;
handles.eta1 = 0;
handles.eta2 = 0;
handles.const = 0;
handles.kphi = 0;
handles.car2DModel = zeros(2,4);
handles.carModel = zeros(2,3);

addpath('ConfigTrajectoryType');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes WMR_TT_SIM wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = WMR_TT_SIM_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in runSimButton.
function runSimButton_Callback(hObject, eventdata, handles)
% hObject    handle to runSimButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Helper function to execute this simulation
runSimulation(hObject, eventdata, handles);

% --- Executes on button press in closeSimButton.
function closeSimButton_Callback(hObject, eventdata, handles)
% hObject    handle to closeSimButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;


function simDurationText_Callback(hObject, eventdata, handles)
% hObject    handle to simDurationText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of simDurationText as text
%        str2double(get(hObject,'String')) returns contents of simDurationText as a double
assignin('base','duration',str2num(get(hObject,'String')));
assignin('base','tSpan',[0 str2num(get(hObject,'String'))]);

% --- Executes during object creation, after setting all properties.
function simDurationText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to simDurationText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function reltoIPText_Callback(hObject, eventdata, handles)
% hObject    handle to reltoIPText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of reltoIPText as text
%        str2double(get(hObject,'String')) returns contents of reltoIPText as a double


% --- Executes during object creation, after setting all properties.
function reltoIPText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reltoIPText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function abstolp_Callback(hObject, eventdata, handles)
% hObject    handle to abstolp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of abstolp as text
%        str2double(get(hObject,'String')) returns contents of abstolp as a double


% --- Executes during object creation, after setting all properties.
function abstolp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to abstolp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in matchedUncertainty.
function matchedUncertainty_Callback(hObject, eventdata, handles)
% hObject    handle to matchedUncertainty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of matchedUncertainty
global mode_uct
assignin('base','mode_uct',get(hObject,'Value'));

% --- Executes on button press in noUncertainty.
function noUncertainty_Callback(hObject, eventdata, handles)
% hObject    handle to noUncertainty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of noUncertainty



function kphiText_Callback(hObject, eventdata, handles)
% hObject    handle to kphiText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kphiText as text
%        str2double(get(hObject,'String')) returns contents of kphiText as a double
assignin('base','kphi',str2num(get(hObject,'String')));

% --- Executes during object creation, after setting all properties.
function kphiText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kphiText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function etaText_Callback(hObject, eventdata, handles)
% hObject    handle to etaText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of etaText as text
%        str2double(get(hObject,'String')) returns contents of etaText as a double
assignin('base','eta',[str2num(get(hObject,'String'));str2num(get(hObject,'String'))]);

% --- Executes during object creation, after setting all properties.
function etaText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to etaText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function epsText_Callback(hObject, eventdata, handles)
% hObject    handle to epsText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epsText as text
%        str2double(get(hObject,'String')) returns contents of epsText as a double
assignin('base','eps',[str2num(get(hObject,'String')) str2num(get(hObject,'String'))]);

% --- Executes during object creation, after setting all properties.
function epsText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epsText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gainText_Callback(hObject, eventdata, handles)
% hObject    handle to gainText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gainText as text
%        str2double(get(hObject,'String')) returns contents of gainText as a double
assignin('base','K',[str2num(get(hObject,'String')) str2num(get(hObject,'String'))]);

% --- Executes during object creation, after setting all properties.
function gainText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gainText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function contantText_Callback(hObject, eventdata, handles)
% hObject    handle to contantText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of contantText as text
%        str2double(get(hObject,'String')) returns contents of contantText as a double
assignin('base','c',str2num(get(hObject,'String')));

% --- Executes during object creation, after setting all properties.
function contantText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to contantText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xcText_Callback(hObject, eventdata, handles)
% hObject    handle to xcText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xcText as text
%        str2double(get(hObject,'String')) returns contents of xcText as a double


% --- Executes during object creation, after setting all properties.
function xcText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xcText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ycText_Callback(hObject, eventdata, handles)
% hObject    handle to ycText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ycText as text
%        str2double(get(hObject,'String')) returns contents of ycText as a double


% --- Executes during object creation, after setting all properties.
function ycText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ycText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thetacText_Callback(hObject, eventdata, handles)
% hObject    handle to thetacText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thetacText as text
%        str2double(get(hObject,'String')) returns contents of thetacText as a double


% --- Executes during object creation, after setting all properties.
function thetacText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thetacText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xrText_Callback(hObject, eventdata, handles)
% hObject    handle to xrText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xrText as text
%        str2double(get(hObject,'String')) returns contents of xrText as a double


% --- Executes during object creation, after setting all properties.
function xrText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xrText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yrText_Callback(hObject, eventdata, handles)
% hObject    handle to yrText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yrText as text
%        str2double(get(hObject,'String')) returns contents of yrText as a double


% --- Executes during object creation, after setting all properties.
function yrText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yrText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thetarText_Callback(hObject, eventdata, handles)
% hObject    handle to thetarText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thetarText as text
%        str2double(get(hObject,'String')) returns contents of thetarText as a double


% --- Executes during object creation, after setting all properties.
function thetarText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thetarText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
movegui('center');


function typePanel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in typePanel 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in typePanel.
function typePanel_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in typePanel 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vrVal wrVal

trajectoryType = get(handles.typePanel, 'SelectedObject');
trajectoryTypeSelection = get(trajectoryType,'String');

handles = guidata(hObject);

switch trajectoryTypeSelection
    case 'Line'
%         msgbox('Line Trajectory');
%         set(handles.noUncertainty, 'Enable', 'Off');
%         set(handles.matchedUncertainty, 'Enable', 'On');
        handles.trajectoryType = 0;
        mode_tjt = 0;
        assignin('base','mode_tjt',mode_tjt);

        % line frame size
        handles.frameSize = [-1 3 -1 3];       % Line
        frameSize = [-1 3 -1 3];

        % save handles.frameSize to workspace
        assignin('base','frameSize',frameSize);
        
    case 'Circle'
%         msgbox('Circle Trajectory');
%         set(handles.matchedUncertainty, 'Enable', 'Off');
%         set(handles.noUncertainty, 'Enable', 'On');
        handles.trajectoryType = 1;
        mode_tjt = 1;
        assignin('base','mode_tjt',mode_tjt);

        % circle frame size
        handles.frameSize = [-2 1 -1 2];     % Circle
        frameSize = [-2 1 -1 2];

        % save handles.frameSize to workspace
        assignin('base','frameSize',frameSize);
end

guidata(hObject, handles);

function callODE(hObject, eventdata, handles)
% hObject    handle to the selected object in typePanel 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TOUT YOUT
% [TOUT, YOUT] = ode23s(@TTExec, handles.tSpan, handles.X_0, handles.options);
[TOUT, YOUT] = ode45(@TTExec, handles.tSpan, handles.X_0, handles.options);
assignin('base','TOUT',TOUT);
assignin('base','YOUT',YOUT);
handles.TOUT = TOUT;
handles.YOUT = YOUT;
guidata(hObject, handles);

save resultsDataFile.mat TOUT YOUT
% save RESULTS/MAT_Results/resultsDataFile.mat TOUT YOUT


% --- Executes on button press in detailResults.
function detailResults_Callback(hObject, eventdata, handles)
% hObject    handle to detailResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DisplayDetailResults;

% --- Executes on button press in runAnimation.
function runAnimation_Callback(hObject, eventdata, handles)
% hObject    handle to runAnimation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% RunAnimationGUI;
global compareFlag
if compareFlag == 1
    run RunAnimationCompare.m
else
    run RunAnimation.m
end

% --- Executes on button press in unmatchedUncertainty.
function unmatchedUncertainty_Callback(hObject, eventdata, handles)
% hObject    handle to unmatchedUncertainty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of unmatchedUncertainty


% --- Executes during object creation, after setting all properties.
function trajectoryTrackingResult_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trajectoryTrackingResult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate trajectoryTrackingResult


% --- Executes on button press in configType.
function configType_Callback(hObject, eventdata, handles)
% hObject    handle to configType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);

if handles.trajectoryType == 0
    LineTrajectoryTypeConfig; 
elseif handles.trajectoryType == 1
    CircleTrajectoryTypeConfig;
end

% --- Executes on button press in configUncertainty.
function configUncertainty_Callback(hObject, eventdata, handles)
% hObject    handle to configUncertainty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function runSimulation(hObject, eventdata, handles)
% hObject    handle to configUncertainty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global duration c K1 K2 eps1 eps2 eta1 eta2 mode_uct mode_tjt kphi frameSize tSpan circle;
global SMCMode LinearSMCModeFlag NonlinearSMCModeFlag vrVal wrVal x_r x_c YOUT
global linearMode nonlinearMode l_lineTrojectory l_circleTrajectory 
global nl_lineTrojectory nl_circleTrajectory x_r_l_line x_c_l_line
global x_r_nl_line x_c_nl_line x_r_l_circle x_c_l_circle x_r_nl_circle x_c_nl_circle

handles = guidata(hObject);

% Setup the initial condition
% theta_0 = atan(1);
init_x_c = str2num(get(handles.xcText,'String'));
init_y_c = str2num(get(handles.ycText,'String'));
init_theta_c = str2num(get(handles.thetacText,'String'));
init_x_r = str2num(get(handles.xrText,'String'));
init_y_r = str2num(get(handles.yrText,'String'));
init_theta_r = str2num(get(handles.thetarText,'String'));


trajectoryType = get(handles.typePanel, 'SelectedObject');
trajectoryTypeSelection = get(trajectoryType,'String');

switch trajectoryTypeSelection
    case 'Line'
%         msgbox('Line Trajectory');
%         set(handles.noUncertainty, 'Enable', 'Off');
%         set(handles.matchedUncertainty, 'Enable', 'On');
        handles.trajectoryType = 0;
        mode_tjt = 0;
        assignin('base','mode_tjt',mode_tjt);

        % line frame size
        if init_x_c < 0
            xlim_min_line = init_x_c - 0.5;
            xlim_max_line = abs(init_x_c) + 3;
        elseif init_x_c > 0
            xlim_min_line = init_x_c - 2.5;
            xlim_max_line = init_x_c + 3;
        else
            xlim_min_line = init_x_c - 0.5;
            xlim_max_line = init_x_c + 5;
        end

        if init_y_c < 0
            ylim_min_line = init_y_c - 0.5;
            ylim_max_line = abs(init_y_c) + 3;
        elseif init_y_c > 0
            ylim_min_line = init_y_c - 2.5;
            ylim_max_line = init_y_c + 3;
        else
            ylim_min_line = init_y_c - 2;
            ylim_max_line = init_y_c + 2;
        end
        
%         frameSize = [-1 3 -1 3];
%         handles.frameSize = [-1 3 -1 3];       % Line
        frameSize = [xlim_min_line xlim_max_line ylim_min_line ylim_max_line];
        handles.frameSize = frameSize;       % Line

        % save handles.frameSize to workspace
        assignin('base','frameSize',frameSize);

%         handles = guidata(hObject);
        if handles.flag == 0
            handles.flag = 1;
            guidata(hObject,handles);   % save new value to handles
            vrVal = 0.8;
            wrVal = 0;
            assignin('base','vrVal',vrVal);
            assignin('base','wrVal',wrVal);
        end
    case 'Circle'
%         msgbox('Circle Trajectory');
%         set(handles.matchedUncertainty, 'Enable', 'Off');
%         set(handles.noUncertainty, 'Enable', 'On');
        handles.trajectoryType = 1;
        mode_tjt = 1;
        assignin('base','mode_tjt',mode_tjt);

        % circle frame size
        if init_x_c < 0
            xlim_min_circle = init_x_c - 0.5;
            xlim_max_circle = abs(init_x_c) - 1;
        else
            xlim_min_circle = init_x_c - 1;
            xlim_max_circle = init_x_c;
        end
        
        if init_y_c < 0
            ylim_min_circle = init_y_c - 0.5;
            ylim_max_circle = abs(init_y_c);
        else            
            ylim_min_circle = init_y_c - 0.5;
            ylim_max_circle = init_y_c;
        end
%         if init_x_c < 0
%             xlim_min_circle = init_x_c - 1;
%             xlim_max_circle = abs(init_x_c) + 1;
%         elseif init_x_c > 0
%             xlim_min_circle = init_x_c - 1;
%             xlim_max_circle = init_x_c + 1;
%         else
%             xlim_min_circle = init_x_c - 1;
%             xlim_max_circle = init_x_c + 1;
%         end
% 
%         if init_y_c < 0
%             ylim_min_circle = init_y_c - 1;
%             ylim_max_circle = abs(init_y_c) + 1;
%         elseif init_y_c > 0
%             ylim_min_circle = init_y_c - 1;
%             ylim_max_circle = init_y_c + 1;
%         else
%             ylim_min_circle = init_y_c - 1;
%             ylim_max_circle = init_y_c + 1;
%         end
        
%         frameSize = [-2 1 -1 2];
%         handles.frameSize = [-2 1 -1 2];     % Circle
        frameSize = [xlim_min_circle xlim_max_circle ylim_min_circle ylim_max_circle];
        handles.frameSize = frameSize;     % Circle

        % save handles.frameSize to workspace
        assignin('base','frameSize',frameSize);
end

if SMCMode == 1
%    Linear controller
    % Linear sliding mode controller parameters
    % save SMC parameters to handles
    if LinearSMCModeFlag == 0
        LinearSMCModeFlag = 1;
        assignin('base','LinearSMCModeFlag',LinearSMCModeFlag);
        handles.K1 = 1;          % Sliding function parameters
        handles.K2 = 1;          % Sliding function parameters
        handles.eps1 = 0.1;            % Boundary parameters to alleviate chattering effect
        handles.eps2 = 0.1;            % Boundary parameters to alleviate chattering effect
        handles.eta1 = 2;           % Reaching gain
        handles.eta2 = 2;           % Reaching gain
        handles.kphi = 0.5;                      % parameter for matched uncertainty
        % kpsi = 0.1;                                   % parameter for mismatched uncertainty

        K1 = 1;          % Sliding function parameters
        K2 = 1;          % Sliding function parameters
        eps1 = 0.1;            % Boundary parameters to alleviate chattering effect
        eps2 = 0.1;            % Boundary parameters to alleviate chattering effect
        eta1 = 2;           % Reaching gain 1
        eta2 = 2;           % Reaching gain 2
        kphi = 0.5;                      % parameter for matched uncertainty
        % kpsi = 0.1;                                   % parameter for mismatched uncertainty
        assignin('base','K1',K1);
        assignin('base','K2',K2);
        assignin('base','eps1',eps1);
        assignin('base','eps2',eps2);
        assignin('base','eta1',eta1);
        assignin('base','eta2',eta2);
        assignin('base','kphi',kphi);
    end
elseif SMCMode == 2
%    Nonlinear controller
    % save SMC parameters to handles
    if NonlinearSMCModeFlag == 0
        NonlinearSMCModeFlag = 1;
        assignin('base','NonlinearSMCModeFlag',NonlinearSMCModeFlag);
        handles.K1 = 1;          % Sliding function parameters
        handles.K2 = 1;          % Sliding function parameters
        handles.eps1 = 0.1;            % Boundary parameters to alleviate chattering effect
        handles.eps2 = 0.1;            % Boundary parameters to alleviate chattering effect
        handles.eta1 = 4;           % Reaching gain
        handles.eta2 = 4;           % Reaching gain
        handles.kphi = 0.5;                      % parameter for matched uncertainty
        % kpsi = 0.1;                                   % parameter for mismatched uncertainty
        handles.const = 1;                 % constant parameter

        K1 = 1;          % Sliding function parameters
        K2 = 1;          % Sliding function parameters
        eps1 = 0.1;            % Boundary parameters to alleviate chattering effect
        eps2 = 0.1;            % Boundary parameters to alleviate chattering effect
        eta1 = 4;           % Reaching gain 1
        eta2 = 4;           % Reaching gain 2
        kphi = 0.5;                      % parameter for matched uncertainty
        % kpsi = 0.1;                                   % parameter for mismatched uncertainty
        c = 1;                 % constant parameter
        assignin('base','K1',K1);
        assignin('base','K2',K2);
        assignin('base','eps1',eps1);
        assignin('base','eps2',eps2);
        assignin('base','eta1',eta1);
        assignin('base','eta2',eta2);
        assignin('base','kphi',kphi);
        assignin('base','c',c);
    end
end

% save duration of simulation to handles
handles.duration = str2num(get(handles.simDurationText,'String'));
duration = str2num(get(handles.simDurationText,'String'));
assignin('base','duration',duration);
circle = [1 duration];
assignin('base','circle',circle);

% save no uncertainty checkbox value to handles
if get(handles.noUncertainty, 'Value') == 0
%    msgbox('No uncertainty is unchecked');
    handles.isNoUncertaintyChecked = 0;
elseif get(handles.noUncertainty, 'Value') == 1
%    msgbox('No uncertainty is checked');    
    handles.isNoUncertaintyChecked = 1;
    mode_uct = 0;
    assignin('base','mode_uct',mode_uct);
end

% save matched uncertainty checkbox value to handles
if get(handles.matchedUncertainty, 'Value') == 0
%    msgbox('No uncertainty is checked');    
    handles.isMatchedUncertaintyChecked = 0;
elseif get(handles.matchedUncertainty, 'Value') == 1
%    msgbox('No uncertainty is checked');    
    handles.isMatchedUncertaintyChecked = 1;
    mode_uct = 1;
    assignin('base','mode_uct',mode_uct);
end


% init_theta_c = atan(1) + pi/8
xc_init = [init_x_c; init_y_c; init_theta_c];       % forward tracking
% xc_0 = [-0.3; -0.4; theta_0 + 0.6];               % backward tracking
xr_init = [init_x_r; init_y_r; init_theta_r];       % Initial position of reference robot
handles.X_0 = [xr_init; xc_init];                   % Initial states of simulation
assignin('base','X_0',handles.X_0);

% Simulation execution
handles.tSpan = [0 handles.duration];
handles.RelTolP = 1e-8;
handles.AbsTolp = 1e-10;
handles.options = odeset('RelTol',handles.RelTolP,'AbsTol',handles.AbsTolp*ones(1,length(handles.X_0)));
% options = odeset('RelTol',RelTolP,'AbsTol',AbsTolp*ones(1,length(X_0)));

tSpan = [0 handles.duration];
assignin('base','tSpan',tSpan);

% save handles data to gui data
guidata(hObject,handles);

% command to run differential equation (ode45)
% all setup and control strategies are included in dynamicFunc function
% file

% [TOUT YOUT] = ode45(@TTExec, handles.tSpan, handles.X_0, handles.options);
callODE(hObject, eventdata, handles);

if SMCMode == 1
    % linear controller
    linearMode = 1;
    assignin('base','linearMode',linearMode);
    
    if mode_tjt == 0
       % line trajectory
        l_lineTrojectory = 1;
        l_circleTrajectory = 0;
        assignin('base','l_lineTrojectory',l_lineTrojectory);
        assignin('base','l_circleTrajectory',l_circleTrajectory);
        x_r_l_line = YOUT(:,1:3)';
        x_c_l_line = YOUT(:,4:6)';
        assignin('base','x_r_l_line',x_r_l_line);
        assignin('base','x_c_l_line',x_c_l_line);        
    elseif mode_tjt == 1
       % circle trajectory
       l_circleTrajectory = 1;
       l_lineTrojectory = 0;
        assignin('base','l_circleTrajectory',l_circleTrajectory);
        assignin('base','l_lineTrojectory',l_lineTrojectory);
        x_r_l_circle = YOUT(:,1:3)';
        x_c_l_circle = YOUT(:,4:6)';
        assignin('base','x_r_l_circle',x_r_l_circle);
        assignin('base','x_c_l_circle',x_c_l_circle);
    end    
elseif SMCMode == 2
    % nonlinear controller
    nonlinearMode = 1;
    assignin('base','nonlinearMode',nonlinearMode);

    if mode_tjt == 0
       % line trajectory
        nl_lineTrojectory = 1;
        nl_circleTrajectory = 0;
        assignin('base','nl_lineTrojectory',nl_lineTrojectory);
        assignin('base','nl_circleTrajectory',nl_circleTrajectory);
        x_r_nl_line = YOUT(:,1:3)';
        x_c_nl_line = YOUT(:,4:6)';
        assignin('base','x_r_nl_line',x_r_nl_line);
        assignin('base','x_c_nl_line',x_c_nl_line);        
    elseif mode_tjt == 1
       % circle trajectory
       nl_circleTrajectory = 1;
       nl_lineTrojectory = 0;
        assignin('base','nl_circleTrajectory',nl_circleTrajectory);
        assignin('base','nl_lineTrojectory',nl_lineTrojectory);
        x_r_nl_circle = YOUT(:,1:3)';
        x_c_nl_circle = YOUT(:,4:6)';
        assignin('base','x_r_nl_circle',x_r_nl_circle);
        assignin('base','x_c_nl_circle',x_c_nl_circle);
    end    
end

x_r = YOUT(:,1:3)';
x_c = YOUT(:,4:6)';
assignin('base','x_r',x_r);
assignin('base','x_c',x_c);

% plot the motion
axis(handles.trajectoryTrackingResult);
plot(handles.trajectoryTrackingResult, x_r(1,:),x_r(2,:),'r',x_c(1,:),x_c(2,:),'b-.');

% carModelRecRef = draw2DCarModelRec(hObject, eventdata, handles, x_r);
% carModelRecReal = draw2DCarModelRec(hObject, eventdata, handles, x_c);
carModelTriRef = draw2DCarModelTri(hObject, eventdata, handles, x_r);
carModelTriReal = draw2DCarModelTri(hObject, eventdata, handles, x_c);

% draw the graph based on the rotationed matrix of robot
patch(carModelTriRef(1,:), carModelTriRef(2,:), 'red');
patch(carModelTriReal(1,:), carModelTriReal(2,:), 'green');

% handles = guidata(hObject);
% output = handles.carShape

legend('Reference trajectory','WMR trajectory','Initial point of the reference trajectory','Initial point of the robot','Location','northwest')
% legend('Reference trajectory','WMR trjectory','Start point of reference trajectory','Initial point of actual robot','Location','northwest')
xlabel('XOUT(m)');
ylabel('YOUT(m)');
title('Trajectory tracking of the WMR');

% Enable Detail Results and Run Animation buttons to check the results
set(handles.detailResults,'enable','on');
set(handles.runAnimation,'enable','on');

if handles.trajectoryType == 0
    uiwait(msgbox('Line simulation is finished!!!','Done','modal'));
elseif handles.trajectoryType == 1
    uiwait(msgbox('Circle simulation is finished!!!','Done','modal'));
end

if (l_lineTrojectory == 1 && nl_lineTrojectory == 1) || (l_circleTrajectory == 1 && nl_circleTrajectory == 1)
   % both linear line trajectory and nonlinear line trajectory results are saved to workspace
    set(handles.compareResultsBtn,'enable','on');
end


function carModelCoords = draw2DCarModelRec(hObject, eventdata, handles, stateVars)
% hObject    handle to configUncertainty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

% Rotational angle in radian
theta = 0.7854;

% Rotational matrix
R = [cos(theta) -sin(theta); sin(theta) cos(theta)];

% Length of the square
L = 0.3;

% Calculate four corner coordinates based on the robot center coordinate
cornerP1 = [stateVars(1)+1/2*L*sin(stateVars(3)), stateVars(2)+1/2*L*cos(stateVars(3))]
cornerP2 = [stateVars(1)-1/2*L*cos(stateVars(3)), stateVars(2)+1/2*L*sin(stateVars(3))]
cornerP3 = [stateVars(1)-1/2*L*sin(stateVars(3)), stateVars(2)-1/2*L*cos(stateVars(3))]
cornerP4 = [stateVars(1)+1/2*L*cos(stateVars(3)), stateVars(2)-1/2*L*sin(stateVars(3))]

% Robot X axises matrix
carX = [cornerP1(1), cornerP2(1), cornerP3(1), cornerP4(1)];

% Robot Y axises matrix
carY = [cornerP1(2), cornerP2(2), cornerP3(2), cornerP4(2)];

% Coordinates of all four corner points
groupP = [carX; carY];

% Coordinates of all four corner points after applying rotational matrix
rotGroupP = R * groupP;

handles.car2DModel = [rotGroupP(1,:); rotGroupP(2,:)];
guidata(hObject,handles);
carModelCoords = [rotGroupP(1,:); rotGroupP(2,:)];


function carModel = draw2DCarModelTri(hObject, eventdata, handles, stateVars)
% hObject    handle to configUncertainty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);

% xs(1) = stateVars(1) + sqrt(4) / 4 * 0.1 * cos(stateVars(3));
% xs(2) = stateVars(1) + sqrt(4) / 4 * 0.1 * cos(stateVars(3) + 2 * pi / 3);
% xs(3) = stateVars(1) + sqrt(4) / 4 * 0.1 * cos(stateVars(3) - 2 * pi / 3);
% 
% ys(1) = stateVars(2) + sqrt(3) / 3 * 0.1 * sin(stateVars(3));
% ys(2) = stateVars(2) + sqrt(3) / 3 * 0.1 * sin(stateVars(3) + 2 * pi / 3);
% ys(3) = stateVars(2) + sqrt(3) / 3 * 0.1 * sin(stateVars(3) - 2 * pi / 3);

carX(1) = stateVars(1) + sqrt(1) / 1 * 0.1 * cos(stateVars(3));
carX(2) = stateVars(1) + sqrt(1) / 1 * 0.1 * cos(stateVars(3) + 2 * pi / 3);
carX(3) = stateVars(1) + sqrt(1) / 1 * 0.1 * cos(stateVars(3) - 2 * pi / 3);

carY(1) = stateVars(2) + sqrt(1) / 1 * 0.1 * sin(stateVars(3));
carY(2) = stateVars(2) + sqrt(1) / 1 * 0.1 * sin(stateVars(3) + 2 * pi / 3);
carY(3) = stateVars(2) + sqrt(1) / 1 * 0.1 * sin(stateVars(3) - 2 * pi / 3);

handles.carModel = [carX; carY];
guidata(hObject,handles);
carModel = [carX; carY];


% --- Executes on button press in smcParamsConfigBtn.
function smcParamsConfigBtn_Callback(hObject, eventdata, handles)
% hObject    handle to smcParamsConfigBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global SMCMode

if SMCMode == 1
    SMCLConfig;
elseif SMCMode == 2
    SMCNLConfig;
end


% --- Executes when selected object is changed in SMCDesign.
function SMCDesign_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in SMCDesign 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global SMCMode
SMCDesignOption = get(handles.SMCDesign, 'SelectedObject');
SMCDesignSelection = get(SMCDesignOption,'String');

handles = guidata(hObject);

switch SMCDesignSelection
    case 'Linear controller'
%         msgbox('Linear SMC Controller');
        SMCMode = 1;
        handles.SMCMode = 1;
        assignin('base','SMCMode',SMCMode);

    case 'Nonlinear controller'
%         msgbox('Nonlinear SMC Controller');
        SMCMode = 2;
        handles.SMCMode = 2;
        assignin('base','SMCMode',SMCMode);
end

guidata(hObject,handles);


% --- Executes on button press in compareResultsBtn.
function compareResultsBtn_Callback(hObject, eventdata, handles)
% hObject    handle to compareResultsBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global l_lineTrojectory l_circleTrajectory nl_lineTrojectory
global nl_circleTrajectory x_r_l_line x_c_l_line x_r_nl_line x_c_nl_line
global x_r_l_circle x_c_l_circle x_r_nl_circle x_c_nl_circle
global compareFlag

compareFlag = 1;
assignin('base','compareFlag',compareFlag);

% plot the motion
axis(handles.trajectoryTrackingResult);

if l_lineTrojectory == 1 && nl_lineTrojectory == 1
    % Plot linear and nonlinear line trajectories
    plot(handles.trajectoryTrackingResult, x_r_l_line(1,:),x_r_l_line(2,:),'r',x_c_l_line(1,:),x_c_l_line(2,:),'b-.');
    legend('Reference trajectory','WMR using linear sliding mode controller','WMR using nonlinear sliding mode controller','Location','northwest')
    % legend('Reference trajectory','WMR trjectory','Start point of reference trajectory','Initial point of actual robot','Location','northwest')
    xlabel('XOUT(m)');
    ylabel('YOUT(m)');
    title('Trajectory tracking of the WMR');

    hold on
    plot(handles.trajectoryTrackingResult, x_r_nl_line(1,:),x_r_nl_line(2,:),'r',x_c_nl_line(1,:),x_c_nl_line(2,:),'m--');

    carModelTriRef1 = draw2DCarModelTri(hObject, eventdata, handles, x_r_l_line);
    carModelTriReal1 = draw2DCarModelTri(hObject, eventdata, handles, x_c_l_line);
    carModelTriRef2 = draw2DCarModelTri(hObject, eventdata, handles, x_r_nl_line);
    carModelTriReal2 = draw2DCarModelTri(hObject, eventdata, handles, x_c_nl_line);

    % draw the graph based on the rotationed matrix of robot
    patch(carModelTriRef1(1,:), carModelTriRef1(2,:), 'red');
    patch(carModelTriRef2(1,:), carModelTriRef1(2,:), 'magenta');
    patch(carModelTriReal1(1,:), carModelTriReal1(2,:), 'blue');
    patch(carModelTriReal2(1,:), carModelTriReal2(2,:), 'green');
    
elseif l_circleTrajectory == 1 && nl_circleTrajectory == 1
    % Plot linear and nonlinear circle trajectories
    plot(handles.trajectoryTrackingResult, x_r_l_circle(1,:),x_r_l_circle(2,:),'r',x_c_l_circle(1,:),x_c_l_circle(2,:),'b-.');
    legend('Reference trajectory','WMR using linear sliding mode controller','WMR using nonlinear sliding mode controller','Location','northwest')
    % legend('Reference trajectory','WMR trjectory','Start point of reference trajectory','Initial point of actual robot','Location','northwest')
    xlabel('XOUT(m)');
    ylabel('YOUT(m)');
    title('Trajectory tracking of the WMR');

    hold on
    plot(handles.trajectoryTrackingResult, x_r_nl_circle(1,:),x_r_nl_circle(2,:),'r',x_c_nl_circle(1,:),x_c_nl_circle(2,:),'m--');

    carModelTriRef1 = draw2DCarModelTri(hObject, eventdata, handles, x_r_l_circle);
    carModelTriReal1 = draw2DCarModelTri(hObject, eventdata, handles, x_c_l_circle);
    carModelTriRef2 = draw2DCarModelTri(hObject, eventdata, handles, x_r_nl_circle);
    carModelTriReal2 = draw2DCarModelTri(hObject, eventdata, handles, x_c_nl_circle);

    % draw the graph based on the rotationed matrix of robot
    patch(carModelTriRef1(1,:), carModelTriRef1(2,:), 'red');
    patch(carModelTriRef2(1,:), carModelTriRef1(2,:), 'magenta');
    patch(carModelTriReal1(1,:), carModelTriReal1(2,:), 'blue');
    patch(carModelTriReal2(1,:), carModelTriReal2(2,:), 'green');    
end

% carModelTriRef = draw2DCarModelTri(hObject, eventdata, handles, x_r);
% carModelTriReal = draw2DCarModelTri(hObject, eventdata, handles, x_c);

% draw the graph based on the rotationed matrix of robot
% patch(carModelTriRef(1,:), carModelTriRef(2,:), 'red');
% patch(carModelTriReal(1,:), carModelTriReal(2,:), 'green');

legend('Reference trajectory','WMR trajectory','Initial point of the reference trajectory','Initial point of the robot','Location','northwest')
% legend('Reference trajectory','WMR trjectory','Start point of reference trajectory','Initial point of actual robot','Location','northwest')
xlabel('XOUT(m)');
ylabel('YOUT(m)');
title('Trajectory tracking of the WMR');
