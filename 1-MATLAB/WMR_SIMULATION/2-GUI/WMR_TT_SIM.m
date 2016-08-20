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

% Last Modified by GUIDE v2.5 20-Aug-2016 17:45:25

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
% Choose default command line output for WMR_TT_SIM
handles.output = hObject;

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
% trajectoryType = get(handles.typePanel, 'SelectedObject');
% trajectoryTypeSelection = get(trajectoryType,'String');

% frame size
% handles.frameSize = [-1 3 -1 3];       % Line
handles.frameSize = [-2 1 -1 2];     % Circle

% save duration of simulation to handles
handles.duration = str2num(get(handles.simDurationText,'String'));

% save no uncertainty checkbox value to handles
if get(handles.noUncertainty, 'Value') == 0
%    msgbox('No uncertainty is unchecked');
    handles.isNoUncertaintyChecked = 0;
elseif get(handles.noUncertainty, 'Value') == 1
%    msgbox('No uncertainty is checked');    
    handles.isNoUncertaintyChecked = 1;
end

% save matched uncertainty checkbox value to handles
if get(handles.matchedUncertainty, 'Value') == 0
%    msgbox('No uncertainty is checked');    
    handles.isMatchedUncertaintyChecked = 0;
elseif get(handles.matchedUncertainty, 'Value') == 1
%    msgbox('No uncertainty is checked');    
    handles.isMatchedUncertaintyChecked = 1;
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

% Simulation execution
handles.tSpan = [0 handles.duration];
handles.RelTolP = 1e-8;
handles.AbsTolp = 1e-10;
handles.options = odeset('RelTol',handles.RelTolP,'AbsTol',handles.AbsTolp*ones(1,length(handles.X_0)));
% options = odeset('RelTol',RelTolP,'AbsTol',AbsTolp*ones(1,length(X_0)));

% save handles data to gui data
guidata(hObject,handles);

% command to run differential equation (ode45)
% all setup and control strategies are included in dynamicFunc function
% file
[T Y] = ode45(@TTExec, handles.tSpan, handles.X_0, handles.options);


duration = handles.duration
noUncertainty = handles.isNoUncertaintyChecked
matchedUncertainty = handles.isMatchedUncertaintyChecked

K = handles.K
eps = handles.eps
eta = handles.eta
kphi = handles.kphi
const = handles.const

X_0 = handles.X_0

save resultsDataFile.mat T Y

% Plot the resulting graphs
run plotResults.m

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


% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
trajectoryType = get(handles.typePanel, 'SelectedObject');
trajectoryTypeSelection = get(trajectoryType,'String');

switch trajectoryTypeSelection
    case 'Line'
%         msgbox('Line Trajectory');
%         set(handles.noUncertainty, 'Enable', 'Off');
%         set(handles.matchedUncertainty, 'Enable', 'On');
        handles.trajectoryType = 0;
    case 'Circle'
%         msgbox('Circle Trajectory');
%         set(handles.matchedUncertainty, 'Enable', 'Off');
%         set(handles.noUncertainty, 'Enable', 'On');
        handles.trajectoryType = 1;
end

guidata(hObject, handles);
