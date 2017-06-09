% function [most_likely] = likelihood(n,m,text_obj,obj_list)
load('ret.mat');
text_obj = [{'table'}, {'chair'}];
n = 2;
obj_list = [{'table'} {'chair'} {'TV'} {'sofa'} {'lamp'} {'bed'} {'desk'} ...
          {'book'} {'cabinet'} {'monitor'} {'cup'} {'laptop'} {'light'} {'pencil'} ...
          {'piano'} {'plant'}];
%==========================================================================
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
m = 5;
[template_desc,indices] = sort(template,2,'descend');
best_result = indices(1:(m-n));
most_likely = [text_obj,obj_list(best_result)];
for i = 1:length(most_likely)
    temp_ret = strmatch(most_likely(i),retrieved);
    if(isempty(temp_ret))
        if(strmatch('table',most_likely(i)))
            temp_ret = strmatch('desk',retrieved);
        elseif(strmatch('tv',most_likely(i)))
            temp_ret = strmatch('laptop',retrieved);
        end
    end
    filename = strcat(retrieved(temp_ret(1)),'.off');

    fid=fopen(['C:\Users\carly\Desktop\EL-GY 9143 3D Computer Vision\final proj\3DModels\',char(filename)]);
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
    figure();

    % plot3(coord(:,1),coord(:,2),coord(:,3),'.'); axis equal;
    %% VTK output
    fid = fopen( [char(filename),'.vtk'],'w');
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
    
    disp(retrieved(temp_ret(1)));
end
%end

