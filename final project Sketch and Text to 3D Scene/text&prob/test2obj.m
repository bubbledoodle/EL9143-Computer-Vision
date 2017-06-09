%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Final Project for EL-GY 9143 3D Computer Vision                  %
%               NYU Tandon School of Engineering                          %
%          Group #2 This part is Text2Scene Generaiton                    %
%               By Shuaiyu Liang, sl5352@nyu.edu                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear all; close all;

%% textInput
sentence = input('please input your ideal indoor scene:\n','s');
% for type in sentence with comma or dot.
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

%% text_Retrivel
path = pwd;
obj_to_retrieval = object(find(object_status == 1));
obj_retrive_tag = find(object_status == 1);
if isempty(obj_to_retrieval)
    disp('Sorry, we are not able to locate your asking for indoor scene.\n',...
    'Please reinput another response');
    break;
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

%% placement
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

%% load mesh
coord = [];
triang = [];
for i = 1:obj_number
    figure(1);
    mesh = obj_properties(i).obj_coordinates;
    plot3(mesh(:,1),mesh(:,2),mesh(:,3),'.'); hold on;
    coord = [coord;mesh];
    triang = [triang;obj_properties(i).obj_triang];
end
nopts = size(coord, 1);
notrg = size(triang, 1);

%% VTK output
fid = fopen('output_scene.vtk','w');
fprintf(fid, '# vtk DataFile Version 3.0\n');
fprintf(fid, 'vtk output\n');
fprintf(fid, 'ASCII\n');
fprintf(fid, 'DATASET POLYDATA\n');
fprintf(fid, 'POINTS %d float\n', nopts);
fprintf(fid, '%g %g %g\n', coord');
fprintf(fid, 'POLYGONS %d %d\n', notrg, 4 * notrg);
fprintf(fid, '3 %d %d %d\n', triang' - 1);
fprintf(fid, '\n');
fprintf(fid, 'POINT_DATA %d\n', nopts);
fprintf(fid, 'SCALARS distance_from float\n');
fprintf(fid, 'LOOKUP_TABLE default\n');
fprintf(fid, '%g\n', ones(nopts,1));
fclose(fid);