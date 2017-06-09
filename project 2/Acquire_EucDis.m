% This code acquires Euclidean distance Descriptor of each mesh in the
% smallTOSCA datebase.
%
% Input: smallTOSCA *.off files
% Output: Euclidean distance Descriptor. All in one file named:
%         Edescriptor.dat
%
% By Shuaiyu Liang @ Oct. 8th 2015
% NYU Tandon school of Engineering
% Miniproject #2 3D shape search engine
% EL-GY 9143 3D computer vision
%======================================================================%
clc;
clear all; close all;

%% load dir
path = pwd;
files = dir([path,'\smallTOSCALARGEmissing/*.off']);
%Euclidean parameters
bin = 128;                              %Euclideam distance Descriptor vector bin
nomodel = 147;                          %number of model in smallTOSCA
Edescriptor = zeros(1,nomodel*bin);     %initialize Euclidean Descriptor

%% loop on acquiring ED descriptor
% write a file contains all Euclidean distance Descriptor vector as a
% compareing reference source
for flag = 1:nomodel
    x = 1;                              %Initialize Euclidean Distance vector index per loop
    %% load mesh 
    fid=fopen([path,'\smallTOSCALARGEmissing\',files(flag).name]);
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

    %% implement Euclidean distance descriptor

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
    Edescriptor((flag-1)*bin+1:flag*bin) = hist(Edistance_norm,bin)/noEdist * 100;           %precentage of points wise distance bin
    %showing figure
%     figure();
%     histogram(Edistance_norm);
end

%% write out ED descriptor named Edescriptor.dat
fid = fopen('Edescriptor_largemissing.dat','wb');
fwrite(fid,Edescriptor,'float32');
fclose(fid);
