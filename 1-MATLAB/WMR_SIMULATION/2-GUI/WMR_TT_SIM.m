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

% Last Modified by GUIDE v2.5 22-Aug-2016 15:35:43

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

% Choose default command line output for WMR_TT_SIM
handles.output = hObject;
handles.trajectoryType = 0;
handles.cnt = 0;
handles.car2DModel = zeros(2,4);
handles.carModel = zeros(2,3);

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
movegui('northwest');


% --- Executes when selected object is changed in typePanel.
function typePanel_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in typePanel 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vrVal wrVal

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
        handles.frameSize = [-1 3 -1 3];       % Line
        frameSize = [-1 3 -1 3];

        % save handles.frameSize to workspace
        assignin('base','frameSize',frameSize);
        
        vrVal = 0.8;
        wrVal = 0;
        assignin('base','vrVal',vrVal);
        assignin('base','wrVal',wrVal);
        
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
[TOUT, YOUT] = ode45(@TTExec, handles.tSpan, handles.X_0, handles.options);
assignin('base','TOUT',TOUT);
assignin('base','YOUT',YOUT);
handles.TOUT = TOUT;
handles.YOUT = YOUT;
guidata(hObject, handles);

save resultsDataFile.mat TOUT YOUT


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
handles.cnt = handles.cnt + 1;

if handles.trajectoryType == 0
    LineTrajectoryTypeConfig; 
elseif handles.trajectoryType == 1
    CircleTrajectoryTypeConfig;
end
guidata(hObject,handles);

% --- Executes on button press in configUncertainty.
function configUncertainty_Callback(hObject, eventdata, handles)
% hObject    handle to configUncertainty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function runSimulation(hObject, eventdata, handles)
% hObject    handle to configUncertainty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global duration c K eps eta mode_uct mode_tjt kphi frameSize tSpan circle;
global vrVal wrVal x_r x_c YOUT

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
        handles.frameSize = [-1 3 -1 3];       % Line
        frameSize = [-1 3 -1 3];

        % save handles.frameSize to workspace
        assignin('base','frameSize',frameSize);

        if handles.cnt == 0
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
        handles.frameSize = [-2 1 -1 2];     % Circle
        frameSize = [-2 1 -1 2];

        % save handles.frameSize to workspace
        assignin('base','frameSize',frameSize);
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

% Sliding mode control parameters
smc_param_constant = str2num(get(handles.contantText,'String'));
smc_param_gainK = str2num(get(handles.gainText,'String'));
smc_param_eps = str2num(get(handles.epsText,'String'));
smc_param_eta = str2num(get(handles.etaText,'String'));
smc_param_kphi = str2num(get(handles.kphiText,'String'));

% save SMC parameters to handles
handles.K = [smc_param_gainK smc_param_gainK];          % Sliding function parameters
handles.eps = [smc_param_eps smc_param_eps];            % Boundary parameters to alleviate chattering effect
handles.eta = [smc_param_eta; smc_param_eta];           % Reaching gain
handles.kphi = smc_param_kphi;                      % parameter for matched uncertainty
% kpsi = 0.1;                                   % parameter for mismatched uncertainty
handles.const = smc_param_constant;                 % constant parameter

K = [smc_param_gainK smc_param_gainK];          % Sliding function parameters
eps = [smc_param_eps smc_param_eps];            % Boundary parameters to alleviate chattering effect
eta = [smc_param_eta; smc_param_eta];           % Reaching gain
kphi = smc_param_kphi;                      % parameter for matched uncertainty
% kpsi = 0.1;                                   % parameter for mismatched uncertainty
c = smc_param_constant;                 % constant parameter
assignin('base','K',K);
assignin('base','eps',eps);
assignin('base','eta',eta);
assignin('base','kphi',kphi);
assignin('base','c',c);

% Setup the initial condition
% theta_0 = atan(1);
init_x_c = str2num(get(handles.xcText,'String'));
init_y_c = str2num(get(handles.ycText,'String'));
init_theta_c = str2num(get(handles.thetacText,'String'));
init_x_r = str2num(get(handles.xrText,'String'));
init_y_r = str2num(get(handles.yrText,'String'));
init_theta_r = str2num(get(handles.thetarText,'String'));

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

legend('Reference trajectory','WMR trajectory','Start point of reference trajectory','Initial point of actual robot','Location','northwest')
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

