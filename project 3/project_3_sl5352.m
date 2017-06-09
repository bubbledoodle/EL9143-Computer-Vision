% -------------------------------------------------------------------------
% This is the script for EL-GY 9143 project #3 3D image registration 
% Shuaiyu Liang(sl5352) @ NYU Tandon school of Engineering.
% this code produces two vtk file with color mapped as value on surface
%--------------------------------------------------------------------------
clc; close all; clear all;

%% load hks
load('mesh_hks.mat');
mesh015_hks_sample = mesh015_hks(1:125:end,:);
mesh054_hks_sample = mesh054_hks(1:125:end,:);
nopts = size(mesh015_hks_sample,1);
nofetre = size(mesh015_hks_sample,2);

%% weight is counted from mesh_015 to mesh_054
for i = 1:nopts
    %creat a mat compute from one point to all other points distance.
    %repeat nopts times
    meshcurrent = repmat(mesh015_hks_sample(i,:),nopts,1);
    temp = (meshcurrent - mesh054_hks_sample).^2;
    temp = sum(temp,2);
    weight(:,i) = temp;
end
[assignment] = hungarian_sl5352(weight, nopts);

%% load mesh #1
fid=fopen([pwd,'\mesh015.off']);
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

%% color map

color_weight = zeros(1,size(mesh015_hks,1));
color_mat = (100:-1:1)';
% compute sparse matrix
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
EdistGraph = EdistGraph + EdistGraph';
EdistGraph = sparse(EdistGraph);
dist = graphallshortestpaths(EdistGraph);
dist_sample = dist(1:125:end,:);
denominator_color = sum(1:1:100);
color_weight = sum(dist_sample.*repmat(color_mat,1,size(mesh015_hks,1)))/denominator_color;

%% output VTK
fid = fopen('mesh015.vtk','w');
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
fprintf(fid, '%g\n', color_weight);
fclose(fid);


%% load mesh #2
fid=fopen([pwd,'\mesh054.off']);
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

%% color map

color_weight = zeros(1,size(mesh054_hks,1));
color_mat = (100:-1:1)';
% compute sparse matrix
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
EdistGraph = EdistGraph + EdistGraph';
EdistGraph = sparse(EdistGraph);
dist = graphallshortestpaths(EdistGraph);

[m,n] = find(assignment == 1);
dist_sample(m,:) = dist(1+(n-1)*125,:);
denominator_color = sum(1:1:100);
color_weight = sum(dist_sample.*repmat(color_mat,1,size(mesh054_hks,1)))/denominator_color;

%% output VTK
fid = fopen('mesh054.vtk','w');
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
fprintf(fid, '%g\n', color_weight);
fclose(fid);