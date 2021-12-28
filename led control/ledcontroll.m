function varargout = ledcontroll(varargin)
% LEDCONTROLL MATLAB code for ledcontroll.fig
%      LEDCONTROLL, by itself, creates a new LEDCONTROLL or raises the existing
%      singleton*.
%
%      H = LEDCONTROLL returns the handle to a new LEDCONTROLL or the handle to
%      the existing singleton*.
%
%      LEDCONTROLL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LEDCONTROLL.M with the given input arguments.
%
%      LEDCONTROLL('Property','Value',...) creates a new LEDCONTROLL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ledcontroll_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ledcontroll_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ledcontroll

% Last Modified by GUIDE v2.5 02-May-2020 18:11:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ledcontroll_OpeningFcn, ...
                   'gui_OutputFcn',  @ledcontroll_OutputFcn, ...
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
 
% --- Executes just before ledcontroll is made visible.
function ledcontroll_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ledcontroll (see VARARGIN)
%ar = serial('COM4','BaudRate',115200,'DataBits',8);
%fopen(ar);
instrreset;
handles.byte1=64;
handles.byte2=128;
handles.byte3=192;
info = instrhwinfo('serial');
if isempty(info.AvailableSerialPorts)
   error('No ports free!');
end
handles.s = serial(info.AvailableSerialPorts{1}, 'BaudRate', 115200);
fopen(handles.s);
% Choose default command line output for ledcontroll
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ledcontroll wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ledcontroll_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB     
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fprintf(handles.s,'%s',char(handles.byte1));


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fprintf(handles.s,'%s',char(handles.byte2));


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fprintf(handles.s,'%s',char(handles.byte3));


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton3.
function pushbutton3_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject,'Value');
ledOffset=64;
switch val
    case 1
        handles.byte1 = uint8(ledOffset+0);
    case 2
        handles.byte1 = uint8(ledOffset+55);
    case 3
        handles.byte1 = uint8(ledOffset+47);     
    case 4
        handles.byte1 = uint8(ledOffset+54);  
    case 5
        handles.byte1 = uint8(ledOffset+46);
    case 6
        handles.byte1 = uint8(ledOffset+53);
    case 7
        handles.byte1 = uint8(ledOffset+45);
    case 8
        handles.byte1 = uint8(ledOffset+39);
    case 9
        handles.byte1 = uint8(ledOffset+52);
    case 10
        handles.byte1 = uint8(ledOffset+31);
    case 11
        handles.byte1 = uint8(ledOffset+44);     
    case 12
        handles.byte1 = uint8(ledOffset+38);  
    case 13
        handles.byte1 = uint8(ledOffset+30);
    case 14
        handles.byte1 = uint8(ledOffset+51);
    case 15
        handles.byte1 = uint8(ledOffset+23);
    case 16
        handles.byte1 = uint8(ledOffset+15);
    case 17
        handles.byte1 = uint8(ledOffset+37);
    case 18
        handles.byte1 = uint8(ledOffset+43);
    case 19
        handles.byte1 = uint8(ledOffset+22);     
    case 20
        handles.byte1 = uint8(ledOffset+29);  
    case 21
        handles.byte1 = uint8(ledOffset+14);
    case 22
        handles.byte1 = uint8(ledOffset+36);
    case 23
        handles.byte1 = uint8(ledOffset+50);
    case 24
        handles.byte1 = uint8(ledOffset+21);
    case 25
        handles.byte1 = uint8(ledOffset+13);
    case 26
        handles.byte1 = uint8(ledOffset+28);
    case 27
        handles.byte1 = uint8(ledOffset+42);     
    case 28
        handles.byte1 = uint8(ledOffset+20);  
    case 29
        handles.byte1 = uint8(ledOffset+35);
    case 30
        handles.byte1 = uint8(ledOffset+12);
    case 31
        handles.byte1 = uint8(ledOffset+27);
    case 32
        handles.byte1 = uint8(ledOffset+19);
    case 33
        handles.byte1 = uint8(ledOffset+49);
    case 34
        handles.byte1 = uint8(ledOffset+11);
    case 35
        handles.byte1 = uint8(ledOffset+34);     
    case 36
        handles.byte1 = uint8(ledOffset+41);  
    case 37
        handles.byte1 = uint8(ledOffset+26);
    case 38
        handles.byte1 = uint8(ledOffset+18);
    case 39
        handles.byte1 = uint8(ledOffset+10);
    case 40
        handles.byte1 = uint8(ledOffset+33);
    case 41
        handles.byte1 = uint8(ledOffset+25);
    case 42
        handles.byte1 = uint8(ledOffset+17);
    case 43
        handles.byte1 = uint8(ledOffset+48);     
    case 44
        handles.byte1 = uint8(ledOffset+9);  
    case 45
        handles.byte1 = uint8(ledOffset+40);
    case 46
        handles.byte1 = uint8(ledOffset+32);
    case 47
        handles.byte1 = uint8(ledOffset+24);
    case 48
        handles.byte1 = uint8(ledOffset+16);
    case 49
       handles.byte1 = uint8(ledOffset+8);
     case 50 %%%constant
       handles.byte1 = uint8(ledOffset+56);
end

guidata(hObject,handles)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
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


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject,'Value');
ledOffset=128;
switch val
    case 1
        handles.byte2 = uint8(ledOffset+0);
    case 2
        handles.byte2 = uint8(ledOffset+55);
    case 3
        handles.byte2 = uint8(ledOffset+47);     
    case 4
        handles.byte2 = uint8(ledOffset+54);  
    case 5
        handles.byte2 = uint8(ledOffset+46);
    case 6
        handles.byte2 = uint8(ledOffset+53);
    case 7
        handles.byte2 = uint8(ledOffset+45);
    case 8
        handles.byte2 = uint8(ledOffset+39);
    case 9
        handles.byte2 = uint8(ledOffset+52);
    case 10
        handles.byte2 = uint8(ledOffset+31);
    case 11
        handles.byte2 = uint8(ledOffset+44);     
    case 12
        handles.byte2 = uint8(ledOffset+38);  
    case 13
        handles.byte2 = uint8(ledOffset+30);
    case 14
        handles.byte2 = uint8(ledOffset+51);
    case 15
        handles.byte2 = uint8(ledOffset+23);
    case 16
        handles.byte2 = uint8(ledOffset+15);
    case 17
        handles.byte2 = uint8(ledOffset+37);
    case 18
        handles.byte2 = uint8(ledOffset+43);
    case 19
        handles.byte2 = uint8(ledOffset+22);     
    case 20
        handles.byte2 = uint8(ledOffset+29);  
    case 21
        handles.byte2 = uint8(ledOffset+14);
    case 22
        handles.byte2 = uint8(ledOffset+36);
    case 23
        handles.byte2 = uint8(ledOffset+50);
    case 24
        handles.byte2 = uint8(ledOffset+21);
    case 25
        handles.byte2 = uint8(ledOffset+13);
    case 26
        handles.byte2 = uint8(ledOffset+28);
    case 27
        handles.byte2 = uint8(ledOffset+42);     
    case 28
        handles.byte2 = uint8(ledOffset+20);  
    case 29
        handles.byte2 = uint8(ledOffset+35);
    case 30
        handles.byte2 = uint8(ledOffset+12);
    case 31
        handles.byte2 = uint8(ledOffset+27);
    case 32
        handles.byte2 = uint8(ledOffset+19);
    case 33
        handles.byte2 = uint8(ledOffset+49);
    case 34
        handles.byte2 = uint8(ledOffset+11);
    case 35
        handles.byte2 = uint8(ledOffset+34);     
    case 36
        handles.byte2 = uint8(ledOffset+41);  
    case 37
        handles.byte2 = uint8(ledOffset+26);
    case 38
        handles.byte2 = uint8(ledOffset+18);
    case 39
        handles.byte2 = uint8(ledOffset+10);
    case 40
        handles.byte2 = uint8(ledOffset+33);
    case 41
        handles.byte2 = uint8(ledOffset+25);
    case 42
        handles.byte2 = uint8(ledOffset+17);
    case 43
        handles.byte2 = uint8(ledOffset+48);     
    case 44
        handles.byte2 = uint8(ledOffset+9);  
    case 45
        handles.byte2 = uint8(ledOffset+40);
    case 46
        handles.byte2 = uint8(ledOffset+32);
    case 47
        handles.byte2 = uint8(ledOffset+24);
    case 48
        handles.byte2 = uint8(ledOffset+16);
    case 49
       handles.byte2 = uint8(ledOffset+8);
    case 50 %%%constant
       handles.byte2 = uint8(ledOffset+56);
end

guidata(hObject,handles)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject,'Value');
ledOffset=192;
switch val
    case 1
        handles.byte3 = uint8(ledOffset+0);
    case 2
        handles.byte3 = uint8(ledOffset+55);
    case 3
        handles.byte3 = uint8(ledOffset+47);     
    case 4
        handles.byte3 = uint8(ledOffset+54);  
    case 5
        handles.byte3 = uint8(ledOffset+46);
    case 6
        handles.byte3 = uint8(ledOffset+53);
    case 7
        handles.byte3 = uint8(ledOffset+45);
    case 8
        handles.byte3 = uint8(ledOffset+39);
    case 9
        handles.byte3 = uint8(ledOffset+52);
    case 10
        handles.byte3 = uint8(ledOffset+31);
    case 11
        handles.byte3 = uint8(ledOffset+44);     
    case 12
        handles.byte3 = uint8(ledOffset+38);  
    case 13
        handles.byte3 = uint8(ledOffset+30);
    case 14
        handles.byte3 = uint8(ledOffset+51);
    case 15
        handles.byte3 = uint8(ledOffset+23);
    case 16
        handles.byte3 = uint8(ledOffset+15);
    case 17
        handles.byte3 = uint8(ledOffset+37);
    case 18
        handles.byte3 = uint8(ledOffset+43);
    case 19
        handles.byte3 = uint8(ledOffset+22);     
    case 20
        handles.byte3 = uint8(ledOffset+29);  
    case 21
        handles.byte3 = uint8(ledOffset+14);
    case 22
        handles.byte3 = uint8(ledOffset+36);
    case 23
        handles.byte3 = uint8(ledOffset+50);
    case 24
        handles.byte3 = uint8(ledOffset+21);
    case 25
        handles.byte3 = uint8(ledOffset+13);
    case 26
        handles.byte3 = uint8(ledOffset+28);
    case 27
        handles.byte3 = uint8(ledOffset+42);     
    case 28
        handles.byte3 = uint8(ledOffset+20);  
    case 29
        handles.byte3 = uint8(ledOffset+35);
    case 30
        handles.byte3 = uint8(ledOffset+12);
    case 31
        handles.byte3 = uint8(ledOffset+27);
    case 32
        handles.byte3 = uint8(ledOffset+19);
    case 33
        handles.byte3 = uint8(ledOffset+49);
    case 34
        handles.byte3 = uint8(ledOffset+11);
    case 35
        handles.byte3 = uint8(ledOffset+34);     
    case 36
        handles.byte3 = uint8(ledOffset+41);  
    case 37
        handles.byte3 = uint8(ledOffset+26);
    case 38
        handles.byte3 = uint8(ledOffset+18);
    case 39
        handles.byte3 = uint8(ledOffset+10);
    case 40
        handles.byte3 = uint8(ledOffset+33);
    case 41
        handles.byte3 = uint8(ledOffset+25);
    case 42
        handles.byte3 = uint8(ledOffset+17);
    case 43
        handles.byte3 = uint8(ledOffset+48);     
    case 44
        handles.byte3 = uint8(ledOffset+9);  
    case 45
        handles.byte3 = uint8(ledOffset+40);
    case 46
        handles.byte3 = uint8(ledOffset+32);
    case 47
        handles.byte3 = uint8(ledOffset+24);
    case 48
        handles.byte3 = uint8(ledOffset+16);
    case 49
       handles.byte3 = uint8(ledOffset+8);
    case 50 %%%constant
       handles.byte3 = uint8(ledOffset+56);
end

guidata(hObject,handles)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
