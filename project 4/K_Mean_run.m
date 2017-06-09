clc; close all; clear all;
%% load HKS and mesh
load('centaur_HKS.mat');
centaur1_hks = sum(centaur1_hks')/101;
centaur2_hks = sum(centaur2_hks')/101;
centaur3_hks = sum(centaur3_hks')/101;
HKS = centaur3_hks;

fid=fopen([pwd,'\centaur3.off']);
fgetl(fid);
nos = fscanf(fid, '%d %d  %d', [3 1]);
nopts = nos(1);
notrg = nos(2);
coord = fscanf(fid, '%g %g  %g', [3 nopts]);
coord = coord';
triang=fscanf(fid, '%d %d %d %d',[4 notrg]);
triang=triang';
triang=triang(:,2:4)+1; 
fclose(fid);

%% GD
EdistGraph = zeros(1,nopts*nopts); % initializing
for nflag = 1:notrg
    % three major processing: compute '#12, #13, #23' point wise Edistance.
    % actually yields less than #triangle * 3 Edistance, cause of
    % neighborhoods and some points may appears more than once.
    for i = 1:2
        for j = i+1:3
            % triang(n,1) to triang(n,2)'s distance
            temp = sqrt((coord(triang(nflag,i),1)-coord(triang(nflag,j),1))^2+...
                   (coord(triang(nflag,i),2)-coord(triang(nflag,j),2))^2+...
                   (coord(triang(nflag,i),3)-coord(triang(nflag,j),3))^2);
            % only write the uptriangle distGraph matrix
            if triang(nflag,i)<triang(nflag,j)
               EdistGraph((triang(nflag,i) - 1) * nopts + triang(nflag,j)) = temp;
            else
               EdistGraph((triang(nflag,j) - 1) * nopts + triang(nflag,i)) = temp;
            end
        end
    end
end
EdistGraph = reshape(EdistGraph, nopts, nopts);    
EdistGraph = sparse(EdistGraph + EdistGraph');
dist = graphallshortestpaths(EdistGraph);

%% K_mean
[cluster_status, iteration] = K_Mean_sl5352(dist, HKS, 10, 3400);

%% output VTK
color_weight = 2000 * cluster_status;
fid = fopen('centaur_Kmean.vtk','w');
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