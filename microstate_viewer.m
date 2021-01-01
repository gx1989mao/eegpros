function varargout = microstate_viewer(varargin)
% MICROSTATE_VIEWER MATLAB code for microstate_viewer.fig
%      MICROSTATE_VIEWER, by itself, creates a new MICROSTATE_VIEWER or raises the existing
%      singleton*.
%
%      H = MICROSTATE_VIEWER returns the handle to a new MICROSTATE_VIEWER or the handle to
%      the existing singleton*.
%
%      MICROSTATE_VIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MICROSTATE_VIEWER.M with the given input arguments.
%
%      MICROSTATE_VIEWER('Property','Value',...) creates a new MICROSTATE_VIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before microstate_viewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to microstate_viewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help microstate_viewer

% Last Modified by GUIDE v2.5 31-Dec-2020 19:09:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @microstate_viewer_OpeningFcn, ...
                   'gui_OutputFcn',  @microstate_viewer_OutputFcn, ...
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


% --- Executes just before microstate_viewer is made visible.
function microstate_viewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to microstate_viewer (see VARARGIN)

% Choose default command line output for microstate_viewer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes microstate_viewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = microstate_viewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
