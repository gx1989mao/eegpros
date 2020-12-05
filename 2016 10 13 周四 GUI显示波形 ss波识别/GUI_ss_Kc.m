function varargout = GUI_ss_Kc(varargin)
% GUI_SS_KC MATLAB code for GUI_ss_Kc.fig
%      GUI_SS_KC, by itself, creates a new GUI_SS_KC or raises the existing
%      singleton*.
%
%      H = GUI_SS_KC returns the handle to a new GUI_SS_KC or the handle to
%      the existing singleton*.
%
%      GUI_SS_KC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SS_KC.M with the given input arguments.
%
%      GUI_SS_KC('Property','Value',...) creates a new GUI_SS_KC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_ss_Kc_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_ss_Kc_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_ss_Kc

% Last Modified by GUIDE v2.5 13-Oct-2016 21:15:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_ss_Kc_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_ss_Kc_OutputFcn, ...
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

% --- Executes just before GUI_ss_Kc is made visible.
function GUI_ss_Kc_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_ss_Kc (see VARARGIN)

% Choose default command line output for GUI_ss_Kc
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using GUI_ss_Kc.


global M;
global Maxnum;


% load('M_&_N.mat');
% load('J_&_Jins.mat');

eponum = length(M);
axes(handles.axes1);
plot(M,'b');hold on;axis([0, length(M),0,6]);
Maxnum = eponum;

% UIWAIT makes GUI_ss_Kc wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_ss_Kc_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla;
global N;
global M;

Fs = 250;
Sig_Len = Fs*30;
epo = get(handles.slider1, 'Value');

axes(handles.axes1);
cla;
plot(M,'b');hold on;axis([0, length(M),0,6]);
plot(epo,M(epo),'ro');hold on;
set(gca,'ytick',[0 1 2 3 4 5 6]);
set(gca,'yticklabel',{' ','deep','light',' ','REM','W'});
epoch_sig = N((epo-1)*Sig_Len:epo*Sig_Len);

axes(handles.axes2);
plot(epoch_sig);axis([0,Sig_Len,-100e-6,100e-6]);
XX = reshape(0:30,1,31);
set(gca,'xtick',XX*250);
set(gca,'xticklabel',num2cell(XX));
set(gca,'ytick',[-100e-6 -50e-6 0 50e-6 100e-6]);
set(gca,'yticklabel',{'-100uV','-50','0','50','100uV'});
set(handles.edit1,'string',num2str(epo));

axes(handles.axes5);
win_width = 0.5*Fs;
x =1:win_width:Sig_Len-win_width;
xx = reshape(1:length(x),1,length(x))*0.5;
yy = zeros(1,length(x));

judge = zeros(20,length(M));%% all epoch in whole night
judge_ins = zeros(20,length(x),length(M));

SS=[0.5,3,4,7,8,13,12,16,18,30,40,49];
SK=[1,2,5,6,9,11,13,14,20,27,44,48];
tic;
for i=1:6 %% 6 kinds of filters
    
    %%%% build filter
    Wp = [2*SS(i*2-1)/Fs,2*SS(i*2)/Fs];
    Ws =  [2*SK(i*2-1)/Fs,2*SK(i*2)/Fs]; 
    [n,Wn] = buttord(Wp,Ws,1,20);
    [b,a]=butter(n,Wn);
    %%%%%%%%%%%%%%%%%%
    

    Sig = N((epo-1)*Sig_Len+1:epo*Sig_Len,1);   %% signal of this epoch
    Result = filter(b,a,Sig);
    judge(i,epo) = mean(abs(Result));   %%cul the whole 30s epoch judge
    %%%%%%%%%  sweep with 0.5s windows     
    p=1;       
    for poi=1:win_width:Sig_Len-win_width 
        Sig_ins = Sig(poi:poi+win_width);        
        Result = filter(b,a,Sig_ins);
        judge_ins(i,p,epo) = mean(abs(Result));   %% cul the instantaneous judge with 0.5s windows
        p=p+1;
    end

end


for i=1:length(x)
    sigma = judge_ins(4,i,epo);
    delta = judge_ins(1,i,epo);
    theta = judge_ins(2,i,epo);
    alpha = judge_ins(3,i,epo);
    factor = 1.5;
    factor_abs = 2;
    if sigma>factor_abs*judge(4,epo) %% larger than 2 times of average Sigma of 30s epoch, then skip the other judge process
        yy(i) = 1;
        if i>1
            if yy(i-1)==1;
                yy(i) = 0;
            end
        end
    end
    if sigma>factor*judge(4,epo)%% larger than 1.5 times of average Sigma of 30s epoch
        if sigma>delta && sigma>theta && sigma>alpha*0.8 %% larger than all other freq in same window
            yy(i) = 1;
            if i>1
                if yy(i-1)==1;
                    yy(i) = 0;
                end
            end
        end
    end
end
toc;
bar(xx,yy);
ss_num = sum(yy);
set(handles.edit2,'string',['We have ',num2str(ss_num),' SS']);

kc_fp = [  -2.6189152e-06  -2.5072179e-06  -3.7175838e-06  -4.2825873e-06  -1.2456607e-05  -1.9084726e-05  -2.0514386e-05  -2.0357972e-05  -1.7446055e-05  -2.1344989e-05  -2.5025958e-05  -2.6769725e-05  -2.9693580e-05  -2.9625812e-05  -3.4227890e-05  -3.7213028e-05  -3.8752798e-05  -4.2492727e-05  -4.3317345e-05  -4.8550057e-05  -5.1633305e-05  -5.2125824e-05  -5.3505457e-05  -5.0675654e-05  -5.1588770e-05  -5.0764660e-05  -4.8237746e-05  -4.7841417e-05  -4.5190243e-05  -4.8279964e-05  -5.0052186e-05  -4.9011454e-05  -4.9090079e-05  -4.6856112e-05  -5.0974593e-05  -5.4274302e-05  -5.5199413e-05  -5.7191111e-05  -5.5495163e-05  -5.8543746e-05  -5.9973110e-05  -5.8921255e-05  -5.9241339e-05  -5.6608417e-05  -5.9792605e-05  -6.1574401e-05  -6.0431406e-05  -6.0607982e-05  -5.7565622e-05  -5.9738136e-05  -6.0329468e-05  -5.8359190e-05  -5.7982207e-05  -5.4278689e-05  -5.5828810e-05  -5.5969297e-05  -5.3448079e-05  -5.2367620e-05  -4.7840646e-05  -4.8623653e-05  -4.8730973e-05  -4.7173166e-05  -4.7099887e-05  -4.2680392e-05  -4.2299089e-05  -3.9630073e-05  -3.4974144e-05  -3.3226736e-05  -2.8174719e-05  -2.8031120e-05  -2.7068412e-05  -2.4569306e-05  -2.3996268e-05  -1.9418553e-05  -1.9579849e-05  -1.8150083e-05  -1.4389999e-05  -1.2820281e-05  -8.1725260e-06  -9.5215711e-06  -1.0450596e-05  -9.4022408e-06  -1.0269514e-05  -7.2515779e-06  -9.1445222e-06  -9.9680865e-06  -8.6020402e-06  -8.9215914e-06  -5.3364467e-06  -7.0074280e-06  -7.5184758e-06  -5.5441439e-06  -5.1078836e-06  -5.5797579e-07  -1.6231137e-06  -1.7596608e-06   1.1844692e-06   2.5019547e-06   7.0588071e-06   5.9087543e-06   6.2713996e-06   1.0223915e-05   1.3233199e-05   1.9768999e-05   1.9783920e-05   2.0696184e-05   2.5030812e-05   2.7542479e-05   3.2967552e-05   3.1896346e-05   3.1092785e-05   3.3379101e-05   3.4875447e-05   4.0139535e-05   3.8616049e-05   3.6923744e-05   3.8254134e-05   3.9052701e-05   4.4603602e-05   4.4596981e-05   4.4720612e-05   4.6832259e-05   4.6398867e-05   4.8801240e-05   4.5138326e-05   4.2457606e-05   4.3282659e-05   4.4077284e-05   5.0582101e-05   5.1790993e-05   5.2582410e-05   5.4957630e-05   5.4928110e-05   5.8813418e-05   5.7388353e-05   5.6436932e-05   5.8358425e-05   5.9115612e-05   6.3688263e-05   6.1853160e-05   5.9713984e-05   5.9753089e-05   5.7970880e-05   6.0390293e-05   5.7347511e-05   5.4466755e-05   5.3694780e-05   5.0722585e-05   5.2120510e-05   4.9051522e-05   4.7339577e-05   4.8919937e-05   4.8998863e-05   5.3147710e-05   5.1668660e-05   5.0094253e-05   4.9676491e-05   4.5518967e-05   4.6285002e-05   4.4877040e-05   4.5729589e-05   4.9150378e-05   4.9773636e-05   5.3564932e-05   5.1166340e-05   4.7748241e-05   4.6068654e-05   4.2596068e-05   4.3642930e-05   4.0237229e-05   3.8043522e-05   3.8846189e-05   3.7398878e-05   3.9514245e-05   3.6274804e-05   3.3150526e-05   3.2999865e-05   3.2271720e-05   3.6595527e-05   3.5166318e-05   3.2262485e-05   3.1533457e-05   3.0176619e-05   3.3743319e-05   3.2143487e-05   2.9936318e-05   2.9610827e-05   2.7624410e-05   3.0145108e-05   2.7892948e-05   2.5858026e-05   2.6442906e-05   2.5278146e-05   2.8004409e-05   2.5061450e-05   2.1246257e-05   1.9826089e-05   1.7262624e-05   1.9186736e-05   1.6039025e-05   1.2799880e-05   1.2869214e-05   1.2048887e-05   1.5013709e-05   1.1903997e-05   7.6258548e-06   6.1217079e-06   4.3603809e-06   7.7982553e-06   6.4235986e-06   4.2782191e-06   4.4521241e-06   3.1854916e-06   5.8684910e-06   2.9420588e-06  -1.4287142e-06  -3.1324305e-06  -4.4514063e-06   1.2108892e-07   2.0175721e-07  -1.1934094e-06  -1.3492530e-06  -3.6337678e-06  -1.9122193e-06  -4.5384936e-06  -7.3389400e-06  -7.5623537e-06  -9.0946779e-06  -6.5551845e-06  -8.7131301e-06  -1.1682172e-05  -1.2613847e-05];

axes(handles.axes6);
cla;
fff = 2;
plot(xx,judge_ins(fff,:,epo),'b');hold on;
plot([0,length(xx)/2 ],[judge(fff,epo),judge(fff,epo)],'r-'); hold on;
axes(handles.axes7);
cla;
% plot(xx,judge_ins(1,:,epo),'b');hold on;
% plot(xx,judge_ins(2,:,epo),'g');hold on;
% plot(xx,judge_ins(3,:,epo),'y');hold on;
% plot(xx,judge_ins(4,:,epo),'r');hold on;
con_re = conv(epoch_sig,kc_fp);

plot(con_re(1+length(kc_fp):Sig_Len+length(kc_fp)));hold on;axis([0 Sig_Len -2e-7 5e-7]);



% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
str = get(hObject,'String');
disp(str);
set(handles.slider1,'Value',str2double(str));


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
current = get(hObject,'Value');
current = floor(current);
set(hObject,'Value',current);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
global Maxnum;
set(hObject,'Max',Maxnum);
set(hObject,'SliderStep',[1/Maxnum,10/Maxnum]);



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes6


% --- Executes during object creation, after setting all properties.
function axes7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes7
