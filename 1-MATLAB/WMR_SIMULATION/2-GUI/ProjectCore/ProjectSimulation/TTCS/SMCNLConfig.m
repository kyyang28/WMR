function varargout = SMCNLConfig(varargin)
% SMCNLCONFIG MATLAB code for SMCNLConfig.fig
%      SMCNLCONFIG, by itself, creates a new SMCNLCONFIG or raises the existing
%      singleton*.
%
%      H = SMCNLCONFIG returns the handle to a new SMCNLCONFIG or the handle to
%      the existing singleton*.
%
%      SMCNLCONFIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SMCNLCONFIG.M with the given input arguments.
%
%      SMCNLCONFIG('Property','Value',...) creates a new SMCNLCONFIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SMCNLConfig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SMCNLConfig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SMCNLConfig

% Last Modified by GUIDE v2.5 26-Aug-2016 06:22:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SMCNLConfig_OpeningFcn, ...
                   'gui_OutputFcn',  @SMCNLConfig_OutputFcn, ...
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


% --- Executes just before SMCNLConfig is made visible.
function SMCNLConfig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SMCNLConfig (see VARARGIN)

% Choose default command line output for SMCNLConfig
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SMCNLConfig wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SMCNLConfig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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



function eta1Text_Callback(hObject, eventdata, handles)
% hObject    handle to eta1Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eta1Text as text
%        str2double(get(hObject,'String')) returns contents of eta1Text as a double


% --- Executes during object creation, after setting all properties.
function eta1Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eta1Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function eps1Text_Callback(hObject, eventdata, handles)
% hObject    handle to eps1Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eps1Text as text
%        str2double(get(hObject,'String')) returns contents of eps1Text as a double


% --- Executes during object creation, after setting all properties.
function eps1Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eps1Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gain1Text_Callback(hObject, eventdata, handles)
% hObject    handle to gain1Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gain1Text as text
%        str2double(get(hObject,'String')) returns contents of gain1Text as a double


% --- Executes during object creation, after setting all properties.
function gain1Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gain1Text (see GCBO)
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



function eps2Text_Callback(hObject, eventdata, handles)
% hObject    handle to eps2Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eps2Text as text
%        str2double(get(hObject,'String')) returns contents of eps2Text as a double


% --- Executes during object creation, after setting all properties.
function eps2Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eps2Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function eta2Text_Callback(hObject, eventdata, handles)
% hObject    handle to eta2Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eta2Text as text
%        str2double(get(hObject,'String')) returns contents of eta2Text as a double


% --- Executes during object creation, after setting all properties.
function eta2Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eta2Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in confirmBtn.
function confirmBtn_Callback(hObject, eventdata, handles)
% hObject    handle to confirmBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global c K1 K2 eps1 eps2 eta1 eta2 kphi NonlinearSMCModeFlag

dlgTitle = 'Quit';
dlgQuestion = 'Do you want to confirm and quit the config window?';
choice = questdlg(dlgQuestion, dlgTitle, 'Yes', 'No', 'Yes');
switch choice
    case 'Yes'
        c = str2num(get(handles.contantText,'String'));
        K1 = str2num(get(handles.gain1Text,'String'));
        K2 = str2num(get(handles.gain2Text,'String'));
        eps1 = str2num(get(handles.eps1Text,'String'));
        eps2 = str2num(get(handles.eps2Text,'String'));
        eta1 = str2num(get(handles.eta1Text,'String'));
        eta2 = str2num(get(handles.eta2Text,'String'));
        kphi = str2num(get(handles.kphiText,'String'));

        assignin('base','c',c);
        assignin('base','K1',K1);
        assignin('base','K2',K2);
        assignin('base','eps1',eps1);
        assignin('base','eps2',eps2);
        assignin('base','eta1',eta1);
        assignin('base','eta2',eta2);
        assignin('base','kphi',kphi);
        
        NonlinearSMCModeFlag = 1;
        assignin('base','NonlinearSMCModeFlag',NonlinearSMCModeFlag);
        close;
    case 'No'
end


% --- Executes on button press in quitBtn.
function quitBtn_Callback(hObject, eventdata, handles)
% hObject    handle to quitBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;



function gain2Text_Callback(hObject, eventdata, handles)
% hObject    handle to gain2Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gain2Text as text
%        str2double(get(hObject,'String')) returns contents of gain2Text as a double


% --- Executes during object creation, after setting all properties.
function gain2Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gain2Text (see GCBO)
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
