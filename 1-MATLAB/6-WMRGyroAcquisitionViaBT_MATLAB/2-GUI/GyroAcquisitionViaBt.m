function varargout = GyroAcquisitionViaBt(varargin)
% GYROACQUISITIONVIABT MATLAB code for GyroAcquisitionViaBt.fig
%      GYROACQUISITIONVIABT, by itself, creates a new GYROACQUISITIONVIABT or raises the existing
%      singleton*.
%
%      H = GYROACQUISITIONVIABT returns the handle to a new GYROACQUISITIONVIABT or the handle to
%      the existing singleton*.
%
%      GYROACQUISITIONVIABT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GYROACQUISITIONVIABT.M with the given input arguments.
%
%      GYROACQUISITIONVIABT('Property','Value',...) creates a new GYROACQUISITIONVIABT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GyroAcquisitionViaBt_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GyroAcquisitionViaBt_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GyroAcquisitionViaBt

% Last Modified by GUIDE v2.5 18-Aug-2016 01:27:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GyroAcquisitionViaBt_OpeningFcn, ...
                   'gui_OutputFcn',  @GyroAcquisitionViaBt_OutputFcn, ...
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


% --- Executes just before GyroAcquisitionViaBt is made visible.
function GyroAcquisitionViaBt_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GyroAcquisitionViaBt (see VARARGIN)

% Choose default command line output for GyroAcquisitionViaBt
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GyroAcquisitionViaBt wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GyroAcquisitionViaBt_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btconnect.
function btconnect_Callback(hObject, eventdata, handles)
% hObject    handle to btconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btdisconnect.
function btdisconnect_Callback(hObject, eventdata, handles)
% hObject    handle to btdisconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in readEncoderVal.
function readEncoderVal_Callback(hObject, eventdata, handles)
% hObject    handle to readEncoderVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in readGyroVal.
function readGyroVal_Callback(hObject, eventdata, handles)
% hObject    handle to readGyroVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
