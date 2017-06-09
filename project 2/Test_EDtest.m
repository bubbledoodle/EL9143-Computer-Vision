clc; clear all; close all;
%% search main
%readin name list
files = dir('C:\Users\carly\Documents\Matlab\smallTOSCA/*.off');
%type in *.off file name
filename = 'horse4.off';
disp(['searching: ',filename]);
[aim1, aim2, aim3, aim4] = EDdescriptor(filename);

%% ploting feedback
fid=fopen(['C:\Users\carly\Documents\Matlab\smallTOSCA\',files(aim1).name]);
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
plot3(coord(:,1),coord(:,2),coord(:,3),'.'); axis equal;
title(['the most likely mesh you are searching. the name is: ',files(aim1).name]);