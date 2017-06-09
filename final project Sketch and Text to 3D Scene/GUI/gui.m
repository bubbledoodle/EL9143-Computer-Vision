function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 22-Dec-2015 15:10:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% user written
handles.current = 1;  %current object tag
% 


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
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




switch handles.current
    case 1
       hFH1 = imfreehand('Closed',false);
       setColor(hFH1,'g');
       
    case 2
        hFH2 = imfreehand('Closed',false);
       setColor(hFH2,'m');
      
    case 3
        hFH3 = imfreehand('Closed',false);
       setColor(hFH3,'r'); 
      
    case 4
        hFH4 = imfreehand('Closed',false);
       setColor(hFH4,'b'); 
       
    case 5
       hFH5 = imfreehand('Closed',false);
       setColor(hFH5,'c');   
       
end



guidata(hObject, handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
maxObjects = 5;
handles.current = handles.current  + 1;

switch handles.current
    case 1
       hFH1 = imfreehand('Closed',false);
       setColor(hFH1,'g');
       set(handles.text2,'string','Draw Object - 1');
    case 2
        hFH2 = imfreehand('Closed',false);
       setColor(hFH2,'m');
        set(handles.text2,'string','Draw Object - 2');
    case 3
         hFH3 = imfreehand('Closed',false);
       setColor(hFH3,'r');
       set(handles.text2,'string','Draw Object - 3');
    case 4
        hFH4 = imfreehand('Closed',false);
       setColor(hFH4,'b'); 
        set(handles.text2,'string','Draw Object - 4');
    case 5
        hFH5 = imfreehand('Closed',false);
       setColor(hFH5,'c'); 
        set(handles.text2,'string','Draw Object - 5');
    otherwise
        set(handles.text2,'string','Object Limit Exceeded');
end

guidata(hObject, handles);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% publish drawing
% figure1 = figure;
% axes1 = axes('Parent',handles.axes1)
% rmdir('Segmented Samples','s');
saveas(handles.axes1,'finename.jpg')
fabric = imread('finename.jpg');
mkdir('Segmented Samples');
green = 1;
magenta = 1;
red = 1;
blue = 1;
cyan = 1;

for i = 1 : size(fabric,1)
    for j = 1 : size(fabric,2)
        x = fabric(i,j,1);
        y = fabric(i,j,2);
        z = fabric(i,j,3);
        if (fabric(i,j,1) > 150) && (fabric(i,j,2) < 100) && (fabric(i,j,3) > 150)
%          magenta  
magentaData(magenta,1) = i;
magentaData(magenta,2) = j;
magenta = magenta+ 1;
        elseif (fabric(i,j,1) < 100) && (fabric(i,j,2) > 200) && (fabric(i,j,3) > 200) 
%         cyan
cyanData(cyan,1) = i;
cyanData(cyan,2) = j;
cyan = cyan + 1;
        elseif (fabric(i,j,1) < 130) && (fabric(i,j,2) > 170) && (fabric(i,j,3) < 130) 
%         green
greenData(green,1) = i;
greenData(green,2) = j;
green = green + 1;
        elseif (fabric(i,j,1)  < 100) && (fabric(i,j,2)  < 100) && (fabric(i,j,3) >130) 
%         blue
blueData(blue,1) = i;
blueData(blue,2) = j;
blue = blue + 1;
        elseif (fabric(i,j,1) > 130) && (fabric(i,j,2)  < 100) && (fabric(i,j,3)  < 100) 
%         red
redData(red,1) = i;
redData(red,2) = j;
red = red + 1;
        else
        end
                
        
        
    end
end

%Split into RGB Channels
if green > 1
%  plot(greenData(:,1),greenData(:,2),'g.');
%  hold on
 green_image = ones(500,500);
 green_image = green_image*255;
 g_mean = mean(greenData,1);
 greenData_moved = zeros(size(greenData,1),2);
 greenData_moved(:,1) = greenData(:,1) - g_mean(1,1) + 250;
 greenData_moved(:,2) = greenData(:,2) - g_mean(1,2) + 250;
 greenData_moved = round(greenData_moved);
%  plot(greenData_moved(:,1),greenData_moved(:,2),'g.');
 
 for i = 1 : size(greenData_moved,1)
     green_image(greenData_moved(i,1),greenData_moved(i,2)) = 0;
  
 end
 imwrite(green_image,'Segmented Samples\1.png','png');

end

if magenta > 1
%  plot(magentaData(:,1),magentaData(:,2),'m.');
%  hold on
 magenta_image = ones(500,500);
 magenta_image = magenta_image*255;
 m_mean = mean(magentaData,1);
 magentaData_moved = zeros(size(magentaData,1),2);
 magentaData_moved(:,1) = magentaData(:,1) - m_mean(1,1) + 250;
 magentaData_moved(:,2) = magentaData(:,2) - m_mean(1,2) + 250;
 magentaData_moved = round(magentaData_moved);
%  plot(magentaData_moved(:,1),magentaData_moved(:,2),'m.');
 
 for i = 1 : size(magentaData_moved,1)
     magenta_image(magentaData_moved(i,1),magentaData_moved(i,2)) = 0;
  
 end
 imwrite(magenta_image,'Segmented Samples\2.png','png');

end

% 
if red > 1
%  plot(redData(:,1),redData(:,2),'r.');
%  hold on
 red_image = ones(500,500);
 red_image = red_image*255;
 r_mean = mean(redData,1);
 redData_moved = zeros(size(redData,1),2);
 redData_moved(:,1) = redData(:,1) - r_mean(1,1) + 250;
 redData_moved(:,2) = redData(:,2) - r_mean(1,2) + 250;
 redData_moved = round(redData_moved);
%  plot(redData_moved(:,1),redData_moved(:,2),'r.');
 
 for i = 1 : size(redData_moved,1)
     red_image(redData_moved(i,1),redData_moved(i,2)) = 0;
  
 end
 imwrite(red_image,'Segmented Samples\3.png','png');
 
 
end
%  
 if blue > 1
%  plot(blueData(:,1),blueData(:,2),'b.');
%  hold on

 blue_image = ones(500,500);
 blue_image = blue_image*255;
 b_mean = mean(blueData,1);
 blueData_moved = zeros(size(blueData,1),2);
 blueData_moved(:,1) = blueData(:,1) - b_mean(1,1) + 250;
 blueData_moved(:,2) = blueData(:,2) - b_mean(1,2) + 250;
 blueData_moved = round(blueData_moved);
%  plot(blueData_moved(:,1),blueData_moved(:,2),'r.');
 
 for i = 1 : size(blueData_moved,1)
     blue_image(blueData_moved(i,1),blueData_moved(i,2)) = 0;
  
 end
 imwrite(blue_image,'Segmented Samples\4.png','png');

 end

%  
 if cyan > 1
%  plot(cyanData(:,1),cyanData(:,2),'c.');

 cyan_image = ones(500,500);
 cyan_image = cyan_image*255;
 c_mean = mean(cyanData,1);
 cyanData_moved = zeros(size(cyanData,1),2);
 cyanData_moved(:,1) = cyanData(:,1) - c_mean(1,1) + 250;
 cyanData_moved(:,2) = cyanData(:,2) - c_mean(1,2) + 250;
 cyanData_moved = round(cyanData_moved);
%  plot(cyanData_moved(:,1),cyanData_moved(:,2),'r.');
 
 for i = 1 : size(cyanData_moved,1)
     cyan_image(cyanData_moved(i,1),cyanData_moved(i,2)) = 0;
  
 end
 imwrite(cyan_image,'Segmented Samples\5.png','png');
 
 end
 
 
guidata(hObject, handles);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
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


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
sentence = get(handles.edit1,'string');
sentence = strsplit(sentence,{'.',' ',','},'CollapseDelimiters',true); 
% predefined-labels
object = [{'table'} {'chair'} {'TV'} {'sofa'} {'lamp'} {'bed'} {'desk'} ...
          {'book'} {'cabinet'} {'monitor'} {'cup'} {'laptop'} {'light'} {'pencil'} ...
          {'piano'} {'plant'}];
object_scaling = [1,0.7,0.25,1.3,0.12,3,1,...
                0.3,1,0.25,0.02,0.20,0.8,0.02,...
                1.3,0.4];

% check if object is in our list
object_status = zeros(1, length(object)); % check if object exist
sentence_Ostatus = zeros(1, length(sentence)); % check where object mentioned in sentense
flip_id = zeros(1, length(object)); % check whether object should flip. this happens iff
obj_count = zeros(1, length(object)); %  flip_id is 1 and object_count to certen obj > 1

for i = 1: length(sentence)
    for j = 1: length(object)
        if isequal(sentence(i), object(j));
            if object_status(j) == 1
                flip_id(j) = 1;  % represent this object is showed up once
            else
                object_status(j) = 1;
            end
            sentence_Ostatus(i) = 1;
            obj_count(j) = obj_count(j) + 1;
        end
    end
end
obj_number = sum(object_status);
obj_to_retrival_scale = object_scaling(find(object_status == 1));

% text_Retrivel
path = pwd;
obj_to_retrieval = object(find(object_status == 1));
obj_retrive_tag = find(object_status == 1);
if isempty(obj_to_retrieval)
    disp('Sorry, we are not able to locate your asking for indoor scene.\n',...
    'Please reinput another response');    
else
    
    % call for retrivel function. 
    % input:  current directory and obj name.
    % output: struct named as object. with properties specified in retrivel
    %         function
    obj_properties = [];
    for i = 1:length(obj_to_retrieval)
        current_obj = obj_to_retrieval(i);
        temp = retrivel(path,current_obj,obj_to_retrival_scale(i),obj_retrive_tag(i));
        obj_properties = [obj_properties; temp];
    end
end

% placement
% position keywords find
position = [{'left'},{'right'},{'front'},{'behind'},{'on'},{'under'},{'next'}];
position_status = zeros(1, length(position));
sentence_Pstatus = zeros(1, length(sentence));
for i = 1: length(sentence)
    for j = 1: length(position)
        if isequal(sentence(i), position(j));
            % represent this position exist
            position_status(j) = 1;
            sentence_Pstatus(i) = 1;
        end
    end
end
sentence_Ostatus = find(sentence_Ostatus == 1);
sentence_Ostatus_tag = sentence(sentence_Ostatus);
% the place this position is specified in sentence
sentence_Pstatus = find(sentence_Pstatus == 1);
no_position = 0; % flag if no position relation specified
%more then one object specified
if obj_number ~= 1
    % no specified position, using 'left'
    if isempty(sentence_Pstatus)
        sentence_Pstatus = ones(1,length(sentence_Pstatus)-1);
        no_position = 1;
    end
    for i = 1:length(sentence_Pstatus)
       A = find(cellfun('isempty',strfind({obj_properties.current_obj},char(sentence_Ostatus_tag(2*(i-1)+1)))) == 0);
       B = find(cellfun('isempty',strfind({obj_properties.current_obj},char(sentence_Ostatus_tag(2*(i-1)+2)))) == 0);
       if no_position == 1
           pattern_position = 'left';
       else
           pattern_position = sentence(sentence_Pstatus(i));
       end
       obj_properties = Position(obj_properties, A, B, pattern_position);
    end
end
handles.obj_to_retrieval = obj_to_retrieval;
guidata(hObject, handles);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
load('histdata.mat');
load('BOF_final.mat');
directory = dir('C:\Users\carly\Desktop\EL-GY 9143 3D Computer Vision\3d final\GUI\Segmented Samples\*.png');
img_tot = size(directory,1);
for j = 1:img_tot
    test1 = imread(directory(j).name);
    p = 1024;
    [m,n] = size(test1);
    test1_pad = padarray(test1, [floor((p-m)/2) floor((p-n)/2)], 'replicate','post');
    test1_pad = padarray(test1_pad, [ceil((p-m)/2) ceil((p-n)/2)], 'replicate','pre');
    test1_resize=imresize(test1_pad, [512 512]);
    test1_resize=im2double(test1_resize);
    points = detectSURFFeatures(test1_resize);
    [features,validPoints] = extractFeatures(test1_resize,points);
    pre_assignment = pdist2(features,C,'euclidean');
    assignment = bsxfun(@eq,pre_assignment,min(pre_assignment,[],2));
    [r,c] = find(assignment == 1);
    index(r,1) = c;
    [h,b] = hist(index);
    h_n = h./sum(h);
    h_n = h_n';
    iter = size(H,2);
    diff = zeros(iter,2);
    for i = 1:iter
        diff(i,1) = sum(abs(h_n-H(:,i)));
        diff(i,2) = i;
    end
    diff = sortrows(diff,1);
    top5(:,j) = diff(1:5,2);
end
%top5 gives us the top5 matches for all the sketches
%The following code displays the 3D objects

retrieved = [];
for i=1:size(top5,1)
    for j =1:size(top5,2)
        retrieved = [retrieved,{f(top5(i,j)).name(1:end-4)}];
    end
end
handles.retrieved = retrieved;
guidata(hObject, handles);


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
obj_list = [{'table'} {'chair'} {'TV'} {'sofa'} {'lamp'} {'bed'} {'desk'} ...
          {'book'} {'cabinet'} {'monitor'} {'cup'} {'laptop'} {'light'} {'pencil'} ...
          {'piano'} {'plant'}];
%==========================================================================
text_obj = handles.obj_to_retrieval;
n = length(text_obj);
obj_list = lower(obj_list);
obj_list = sort(obj_list);
path = strcat(pwd,'\annotations\*.mat');
path = dir(path);
iter = size(path,1);
template = zeros(iter,length(obj_list));
for i = 1:iter
    load(path(i).name);
    obj_len = length(objtypes);
    text_obj = lower(text_obj);
    objtypes = lower(objtypes);
    text_obj = sort(text_obj);
    objtypes = sort(objtypes);
    check = sum(ismember(text_obj,objtypes));
    if(check==n)
        C = setdiff(objtypes,text_obj);
        logical = ismember(C,obj_list);
        C(~logical) = [];
        [val,loc] = ismember(C,obj_list);
        template(i,loc) = val;
    end    
end
template = sum(template,1);
retrieved = handles.retrieved;
m = 5;
[template_desc,indices] = sort(template,2,'descend');
best_result = indices(1:(m-n));
most_likely = [text_obj,obj_list(best_result)];
for i = 1:length(most_likely)
    temp_ret = strmatch(most_likely(i),retrieved);
end