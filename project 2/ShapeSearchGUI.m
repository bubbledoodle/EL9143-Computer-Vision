function varargout = ShapeSearchGUI(varargin)
% SHAPESEARCHGUI MATLAB code for ShapeSearchGUI.fig
% this is a new version of Engine!!!
%      SHAPESEARCHGUI, by itself, creates a new SHAPESEARCHGUI or raises the existing
%      singleton*.
%
%      H = SHAPESEARCHGUI returns the handle to a new SHAPESEARCHGUI or the handle to
%      the existing singleton*.
%
%      SHAPESEARCHGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHAPESEARCHGUI.M with the given input arguments.
%
%      SHAPESEARCHGUI('Property','Value',...) creates a new SHAPESEARCHGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ShapeSearchGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ShapeSearchGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ShapeSearchGUI

% Last Modified by GUIDE v2.5 17-Oct-2015 13:14:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ShapeSearchGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ShapeSearchGUI_OutputFcn, ...
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


% --- Executes just before ShapeSearchGUI is made visible.
function ShapeSearchGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ShapeSearchGUI (see VARARGIN)

bin = 128;                 %Euclideam distance Descriptor vector bin
nomodel = 147;             %number of model in smallTOSCA
path = pwd;
handles.path = path;
% load ED Descriptor for original dataset
ED = [];
fid = fopen('Edescriptor_original.dat', 'rb');
ED = fread(fid, bin * nomodel, 'float32');
ED = (reshape(ED,bin,nomodel))';
handles.ED1 = ED;
% load ED Descriptor for low noise dataset
ED = [];
fid = fopen('Edescriptor_smallnoise.dat', 'rb');
ED = fread(fid, bin * nomodel, 'float32');
ED = (reshape(ED,bin,nomodel))';
handles.ED2 = ED;
% load ED Descriptor for medium noise dataset
ED = [];
fid = fopen('Edescriptor_mediumnoise.dat', 'rb');
ED = fread(fid, bin * nomodel, 'float32');
ED = (reshape(ED,bin,nomodel))';
handles.ED3 = ED;
% load ED Descriptor for high noise dataset
ED = [];
fid = fopen('Edescriptor_highnoise.dat', 'rb');
ED = fread(fid, bin * nomodel, 'float32');
ED = (reshape(ED,bin,nomodel))';
handles.ED4 = ED;
% load ED Descriptor for small partial missing
ED = [];
fid = fopen('Edescriptor_smallmissing.dat', 'rb');
ED = fread(fid, bin * nomodel, 'float32');
ED = (reshape(ED,bin,nomodel))';
handles.ED5 = ED;
% load ED Descriptor for medium partial missing
ED = [];
fid = fopen('Edescriptor_mediummissing.dat', 'rb');
ED = fread(fid, bin * nomodel, 'float32');
ED = (reshape(ED,bin,nomodel))';
handles.ED6 = ED;
% load ED Descriptor for large partial missing
ED = [];
fid = fopen('Edescriptor_largemissing.dat', 'rb');
ED = fread(fid, bin * nomodel, 'float32');
ED = (reshape(ED,bin,nomodel))';
handles.ED7 = ED;

%--------------------------------------------------------------------
% load GD Descriptor for original dataset
GD = [];
fid = fopen('Gdescriptor_original.dat', 'rb');
GD = fread(fid, bin * nomodel, 'float32');
GD = (reshape(GD,bin,nomodel))';
handles.GD1 = GD;
% load GD Descriptor for low noise dataset
GD = [];
fid = fopen('Gdescriptor_smallnoise.dat', 'rb');
GD = fread(fid, bin * nomodel, 'float32');
GD = (reshape(GD,bin,nomodel))';
handles.GD2 = GD;
% load GD Descriptor for medium noise dataset
GD = [];
fid = fopen('Gdescriptor_mediumnoise.dat', 'rb');
GD = fread(fid, bin * nomodel, 'float32');
GD = (reshape(GD,bin,nomodel))';
handles.GD3 = GD;
% load GD Descriptor for high noise dataset
GD = [];
fid = fopen('Gdescriptor_largenoise.dat', 'rb');
GD = fread(fid, bin * nomodel, 'float32');
GD = (reshape(GD,bin,nomodel))';
handles.GD4 = GD;
% load GD Descriptor for small partial missing
GD = [];
fid = fopen('Gdescriptor_smallmissing.dat', 'rb');
GD = fread(fid, bin * nomodel, 'float32');
GD = (reshape(GD,bin,nomodel))';
handles.GD5 = GD;
% load GD Descriptor for medium partial missing
GD = [];
fid = fopen('Gdescriptor_mediummissing.dat', 'rb');
GD = fread(fid, bin * nomodel, 'float32');
GD = (reshape(GD,bin,nomodel))';
handles.GD6 = GD;
% load GD Descriptor for large partial missing
GD = [];
fid = fopen('Gdescriptor_largemissing.dat', 'rb');
GD = fread(fid, bin * nomodel, 'float32');
GD = (reshape(GD,bin,nomodel))';
handles.GD7 = GD;
% Choose default command line output for ShapeSearchGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ShapeSearchGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ShapeSearchGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject,'value');
str = get(hObject,'String');
dataset1 = 0;
switch str{val};
    case 'original'
        dataset1 = 0;
    case 'low noise'
        dataset1 = 1;
    case 'medium noise'
        dataset1 = 2;
    case 'large noise'
        dataset1 = 3;
    case 'small partial missing'
        dataset1 = 4;
    case 'medium partial missing'
        dataset1 = 5;
    case 'large partial missing'
        dataset1 = 6;
end
handles.dataset1 = dataset1;
guidata(hObject, handles);
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
str = get(hObject,'String');
val = get(hObject,'value');
desc = 0; %default
switch str{val};
    case 'Euclidean Distance Descriptor'
        desc = 0;
    case 'Geodesic Distance Descriptor'
        desc = 1;
end
handles.desc = desc;
guidata(hObject, handles);
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



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = get(hObject,'String');
% handles.filename = filename;
path = handles.path;
fid = fopen([path,filename,'.off']);
fgetl(fid);
nos = fscanf(fid, '%d %d  %d', [3 1]);
nopts = nos(1);
notrg = nos(2);
coord = fscanf(fid, '%g %g  %g', [3 nopts]);
coord = coord';
triang=fscanf(fid, '%d %d %d %d',[4 notrg]);
triang=triang';
triang=triang(:,2:4)+1; %%we have added 1 because the vertex indices start from 0 in vtk format
fclose(fid);
data{1} = coord;
data{2} = nopts;
data{3} = triang;
data{4} = notrg;
handles.data = data;
handles.data1 = coord;
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
% data = handles.data;
% coord = data{1}; %nopts = data{2}; triang = data{3};
coord = handles.data1;
axes(handles.axes1);
%global coord;
plot3(coord(:,1),coord(:,2),coord(:,3),'.'); axis equal;

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
dataset1 = handles.dataset1;
data = handles.data;
coord = data{1}; nopts = data{2}; triang = data{3}; notrg = data{4};
nomodel = 147; bin = 128;
desc = handles.desc;
switch desc
    case 0
        switch dataset1
            case 0
                descriptor = handles.ED1;
            case 1
                descriptor = handles.ED2;   
            case 2
                descriptor = handles.ED3;
            case 3
                descriptor = handles.ED4;
            case 4
                descriptor = handles.ED5;
            case 5
                descriptor = handles.ED6;
            case 6
                descriptor = handles.ED7;
        end
        % EucDesc----------------------------------------------------------
        x = 1;
        for n = 1:nopts-1
            for m = n+1:nopts
                temp = sqrt((coord(n,1)-coord(m,1))^2+(coord(n,2)-coord(m,2))^2+(coord(n,3)-coord(m,3))^2);
                Edistance(x) = temp;
                x = x + 1;
            end
        end
        noEdist = size(Edistance,2);
        EMax = max(Edistance); EMin = min(Edistance);
        Edistance_norm = Edistance/(EMax-EMin);             %normlized distance in order to make Euclidean distance descriptor rebost to scaler change
        descriptorone = hist(Edistance_norm,bin)/noEdist * 100;
    case 1
        switch dataset1
            case 0
                descriptor = handles.GD1;
            case 1
                descriptor = handles.GD2;
            case 2
                descriptor = handles.GD3;
            case 3
                descriptor = handles.GD4;
            case 4
                descriptor = handles.GD5;
            case 5
                descriptor = handles.GD6;
            case 6
                descriptor = handles.GD7;
                
        end
        % GeoDesc----------------------------------------------------------
        EdistGraph = zeros(1,nopts*nopts); % initializing
        for nflag = 1:notrg
            % three major processing: compute '#12, #13, #23' point wise Edistance.
            % actually yields less than #triangle * 3 Edistance, cause of
            % neighborhoods and some points may appears more than once.

            % triang(n,1) to triang(n,2)'s distance
            temp = sqrt((coord(triang(nflag,1),1)-coord(triang(nflag,2),1))^2+(coord(triang(nflag,1),2)-coord(triang(nflag,2),2))^2+...
                   (coord(triang(nflag,1),3)-coord(triang(nflag,2),3))^2);
            % only write the uptriangle distGraph matrix
            if triang(nflag,1)<triang(nflag,2)
               EdistGraph((triang(nflag,1) - 1) * nopts + triang(nflag,2)) = temp;
            else
               EdistGraph((triang(nflag,2) - 1) * nopts + triang(nflag,1)) = temp;
            end

            % triang(n,1) to triang(n,3)'s distance
            temp = sqrt((coord(triang(nflag,1),1)-coord(triang(nflag,3),1))^2+(coord(triang(nflag,1),2)-coord(triang(nflag,3),2))^2+...
                   (coord(triang(nflag,1),3)-coord(triang(nflag,3),3))^2);
            % only write the uptriangle distGraph matrix
            if triang(nflag,1)<triang(nflag,3)
               EdistGraph((triang(nflag,1) - 1) * nopts + triang(nflag,3)) = temp;
            else
               EdistGraph((triang(nflag,3) - 1) * nopts + triang(nflag,1)) = temp;
            end

            % triang(n,2) to triang(n,3)'s distance
            temp = sqrt((coord(triang(nflag,2),1)-coord(triang(nflag,3),1))^2+(coord(triang(nflag,2),2)-coord(triang(nflag,3),2))^2+...
                   (coord(triang(nflag,2),3)-coord(triang(nflag,3),3))^2);
            % only write the uptriangle distGraph matrix
            if triang(nflag,2)<triang(nflag,3)
               EdistGraph((triang(nflag,2) - 1) * nopts + triang(nflag,3)) = temp;
            else
               EdistGraph((triang(nflag,3) - 1) * nopts + triang(nflag,2)) = temp;
            end
        end
        
        EdistGraph = reshape(EdistGraph, nopts, nopts);    
        EdistGraph = reshape(EdistGraph + EdistGraph', 1, nopts*nopts);
        EdistGraph = sparse(EdistGraph);
        % real part implementing Dijkstra Algorithm------------------------
        GeoDist = zeros(nopts,nopts);
        parfor i = 1:nopts
                GeoDistTemp = Dijkstra_sl5352_V3(triang, coord, EdistGraph, i);
                GeoDist(i,:) = GeoDistTemp;
        end
        descriptorone = zeros(1,nomodel*bin);
        GeoDist = triu(GeoDist);
        GeoDist = GeoDist + GeoDist';
        GeoDist = reshape(GeoDist, 1, nopts*nopts);
        % Geo descriptor
        noGdist = size(GeoDist,2);
        descriptorone((flag-1)*bin+1:flag*bin) = hist(GeoDist,bin)/noGdist * 100;
    end
% acquiring criterion------------------------------------------------------

criterion = zeros(1,nomodel);   %initializing
for m = 1:nomodel
    for n = 1:bin
        temp = (descriptorone(n)-descriptor(m,n))^2;  %criterion is based on euclideann distance
        criterion(m) = criterion(m) + temp;
    end
end
[B,IX] = sort(criterion, 'ascend');
retrieved = IX(1:5);
%plotting------------------------------------------------------------------
coord = read_mesh(IX(1),handles.path);
axes(handles.axes2);
plot3(coord(:,1),coord(:,2),coord(:,3),'.'); axis equal;
coord = read_mesh(IX(2),handles.path);
axes(handles.axes3);
plot3(coord(:,1),coord(:,2),coord(:,3),'.'); axis equal;
coord = read_mesh(IX(3),handles.path);
axes(handles.axes4);
plot3(coord(:,1),coord(:,2),coord(:,3),'.'); axis equal;
coord = read_mesh(IX(4),handles.path);
axes(handles.axes5);
plot3(coord(:,1),coord(:,2),coord(:,3),'.'); axis equal;
coord = read_mesh(IX(5),handles.path);
axes(handles.axes6);
plot3(coord(:,1),coord(:,2),coord(:,3),'.'); axis equal;

function coord = read_mesh(nk,path)
files = dir([path,'\smallTOSCA/*.off']);
fid = fopen([path,'\smallTOSCA\',files(nk).name]);
%ans = files(flag).name              % defunction this part if not intend to witness real time processing position and to speed up computation
fgetl(fid);
nos = fscanf(fid, '%d %d  %d', [3 1]);
nopts = nos(1);
notrg = nos(2);
coord = fscanf(fid, '%g %g  %g', [3 nopts]);
coord = coord';
triang=fscanf(fid, '%d %d %d %d',[4 notrg]);
triang=triang';
triang=triang(:,2:4)+1; %%we have added 1 because the vertex indices start from 0 in vtk format
fclose(fid);
