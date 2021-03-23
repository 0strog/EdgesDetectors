function varargout = main(varargin)
clc;
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 18-Feb-2021 11:07:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% Start filter
handles.currentFilter = 'entropy filter';

% Size of start filter
handles.filterSize = 3;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Set size of applying filter
function setFilterSlider(handles)
    sliderMinimum = 0;
    switch handles.currentFilter
        case 'entropy filter'
            sliderMinimum = 0.1;
            set(handles.slider2, 'Max', 0.3);
            set(handles.slider2, 'Min', sliderMinimum);
            set(handles.slider2, 'SliderStep', [0.5, 0.5]);
            set(handles.slider2, 'Value', sliderMinimum);
        case 'Cany filter'
            return;
        case 'something else filter'
            return;
    end


% --- Executes on button press in add_image1.
function add_image1_Callback(hObject, eventdata, handles)
% hObject    handle to add_image1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global imOrigin1 imOrigin2;
    
    [path, user_cance] = imgetfile();
    if user_cance
        msgbox(sprintf('Error'), 'Error', 'Error');
        return
    end
    imOrigin1=imread(path);
    
    axes(handles.axes1);
    imshow(imOrigin1);
    set(handles.apply_entropy_filt, 'Enable', 'on');
    
    if ~isempty(imOrigin1) && ~isempty(imOrigin2)
        set(handles.calcCorrOrigins, 'Enable', 'on');
    end


% --- Executes on button press in add_image2.
function add_image2_Callback(hObject, eventdata, handles)
% hObject    handle to add_image2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global imOrigin2 imOrigin1;
    
    [path, user_cance] = imgetfile();
    if user_cance
        msgbox(sprintf('Error'), 'Error', 'Error');
        return
    end
    imOrigin2=imread(path);
    
    axes(handles.axes2);
    imshow(imOrigin2);
    set(handles.apply_filter, 'Enable', 'on');
    
    if ~isempty(imOrigin1) && ~isempty(imOrigin2)
        set(handles.calcCorrOrigins, 'Enable', 'on');
    end


% --- Executes on button press in apply_entropy_filt.
function apply_entropy_filt_Callback(hObject, eventdata, handles)
% hObject    handle to apply_entropy_filt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global imOrigin1 entropyMap imFiltered;
    
    entropyMap = entropyfilt(rgb2gray(imOrigin1), true(3));
    axes(handles.axes3);
    imshow(entropyMap);
    set(handles.slider1, 'Enable', 'on');
    
    if ~isempty(entropyMap) && ~isempty(imFiltered)
        set(handles.calcCorrMaps, 'Enable', 'on');
    end


% --- Executes on selection change in filters.
function filters_Callback(hObject, eventdata, handles)
% hObject    handle to filters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns filters contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filters
    str = get(hObject, 'String');
    val = get(hObject, 'Value');
    handles.currentFilter = str{val};
    setFilterSlider(handles);


% --- Executes during object creation, after setting all properties.
function filters_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on button press in apply_filter.
function apply_filter_Callback(hObject, eventdata, handles)
% hObject    handle to apply_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global imOrigin2 imFiltered entropyMap;
    
    switch handles.currentFilter
        case 'entropy filter'
            imFiltered = entropyfilt(rgb2gray(imOrigin2), true(handles.filterSize));
        case 'Cany filter'
            return;
        case 'something else filter'
            return;
    end
    
    axes(handles.axes4);
    imshow(imFiltered);
    
    set(handles.slider2, 'Enable', 'on');
    setFilterSlider(handles);
    
    if ~isempty(entropyMap) && ~isempty(imFiltered)
        set(handles.calcCorrMaps, 'Enable', 'on');
    end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    global imOrigin1 entropyMap;
    
    val = 3^(uint8(10*get(hObject, 'Value')));
    [rows, columns] = size(imOrigin1);
    if val > rows || val > columns
        msgbox(sprintf('Image size too small'), 'Error', 'Error');
        return
    end
    entropyMap = entropyfilt(rgb2gray(imOrigin1), true(val));
    
    axes(handles.axes3);
    imshow(entropyMap);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    global imOrigin2 imFiltered;
    
    switch handles.currentFilter
        case 'entropy filter'
            filtSize = 3^(uint8(10*get(hObject, 'Value')));
            [rows, columns] = size(imOrigin2);
            if filtSize > rows || filtSize > columns
                msgbox(sprintf('Image size too small'), 'Error', 'Error');
                return
            end
            
            imFiltered = entropyfilt(rgb2gray(imOrigin2), true(filtSize));
        case 'Cany filter'
            return;
        case 'something else filter'
            return;
    end
        
    axes(handles.axes4);
    imshow(imFiltered);


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end


% --- Executes on button press in calcCorrOrigins.
function calcCorrOrigins_Callback(hObject, eventdata, handles)
% hObject    handle to calcCorrOrigins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global imOrigin1 imOrigin2;
    corr = corr2(rgb2gray(imOrigin1), rgb2gray(imOrigin2));
    set(handles.CorrOriginsValue, 'String', sprintf('%.3f', corr));


% --- Executes on button press in calcCorrMaps.
function calcCorrMaps_Callback(hObject, eventdata, handles)
% hObject    handle to calcCorrMaps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global entropyMap imFiltered;
    corr = corr2(entropyMap, imFiltered);
    set(handles.CorrMapsValue, 'String', sprintf('%.3f', corr));
