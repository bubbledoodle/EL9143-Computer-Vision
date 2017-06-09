clc
clear all
close all
% load data
fid=fopen('lamp2.off');
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

c = hadamard(2^5);


surf(coord,c);









% 
% ofid = fopen('test4.vtk','w');
% fprintf(ofid,'# vtk DataFile Version 3.0\n');
% fprintf(ofid,'vtk output\n');
% fprintf(ofid,'ASCII\n');
% fprintf(ofid,'DATASET POLYDATA\n');
% fprintf(ofid,'POINTS %d float\n',nopts);
% fprintf(ofid,'%g %g %g\n',coord');
% fprintf(ofid,'POLYGONS %d %d\n',notrg, 4*notrg);
% fprintf(ofid,'3 %d %d %d\n',triang'-1);
% fprintf(ofid,'\n');
% fprintf(ofid,'POINT_DATA %d\n',nopts);
% fprintf(ofid,'SCALARS distance_from float\n');
% fprintf(ofid,'LOOKUP_TABLE default\n');
% x = ones(nopts,1);
% 
% 
% fprintf(ofid,'%g\n',x);
% fclose(ofid);