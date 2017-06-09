% This code acquires Geodesic distance Descriptor of each mesh in the
% smallTOSCA datebase. Basically to implement Dijkstra algorithm
%
% Input: smallTOSCA *.off files
% Output: Geodesic distance Descriptor. All in one file named:
%         Gdescriptor.dat
%
% By Shuaiyu Liang @ Oct. 8th 2015
% NYU Tandon school of Engineering
% Miniproject #2 3D shape search engine
% EL-GY 9143 3D computer vision
%======================================================================%
%% initialization
clc;
clear all; close all;
parpool local;
% mkdir
path = pwd;
newfolder = [pwd,'\3DComputerVision\project2\GeodesicdisthighnoiseTable'];
mkdir(newfolder);

%% load dir
files = dir([pwd,'\smallTOSCAhighnoise/*.off']);
%Euclidean parameters
bin = 128;                              %Euclideam distance Descriptor vector bin
nomodel = 147;                          %number of model in smallTOSCA
Gdescriptor = zeros(1,nomodel*bin);     %initialize Euclidean Descriptor

%% loop on acquiring ED descriptor
% write a file contains all Euclidean distance Descriptor vector as a
% compareing reference source
for flag = 142:nomodel
    %% load mesh 
    filename = files(flag).name;
    filename = filename(1:end-4);
    fid=fopen([pwd,'\smallTOSCAhighnoise\',files(flag).name]);
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

    %% implement Dijkstra algorithm by using Geodesic distance descriptor
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

%% running Dijkstra
GeoDist = zeros(nopts,nopts);
parfor i = 1:nopts
        GeoDistTemp = Dijkstra_sl5352_V3(triang, coord, EdistGraph, i);
        GeoDist(i,:) = GeoDistTemp;
end
GeoDist = triu(GeoDist);
GeoDist = GeoDist + GeoDist';
GeoDist = reshape(GeoDist, 1, nopts*nopts);

%% write out ED descriptor named Edescriptor.dat
fid = fopen([pwd,'\3DComputerVision\project2\GeodesicdisthighnoiseTable\', filename, '.dat'], 'wb');
fwrite(fid, nopts, 'float32');
fwrite(fid, GeoDist, 'float32');
fclose(fid);
end


