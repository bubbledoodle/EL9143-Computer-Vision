% This is the test code acquires Geodesic distance Descriptor of each mesh in the
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
clc;
clear all; close all;
% parpool local;
%% load dir
files = dir('C:\Users\carly\Documents\Matlab\smallTOSCA/*.off');
%Euclidean parameters
bin = 128;                              %Euclideam distance Descriptor vector bin
nomodel = 147;                          %number of model in smallTOSCA
Gdescriptor = zeros(1,nomodel*bin);     %initialize Euclidean Descriptor

%% loop on acquiring ED descriptor
% write a file contains all Euclidean distance Descriptor vector as a
% compareing reference source
for flag = 1:1%nomodel
    %% load mesh 
    fid=fopen(['C:\Users\carly\Documents\Matlab\smallTOSCA\',files(flag).name]);
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
EdistGraph = EdistGraph;
%     EMax = max(Edistance); EMin = min(Edistance);
%     Edistance_norm = Edistance/(EMax-EMin);             %normlized distance in order to make Euclidean distance descriptor rebost to scaler change
%     Edescriptor((flag-1)*bin+1:flag*bin) = hist(Edistance_norm,bin)/noEdist * 100;           %precentage of points wise distance bin
%     %showing figure
% %     figure();
% %     histogram(Edistance_norm);
end
GeoDist = zeros(nopts,nopts);
for i = 1:34
    startID = i;
    GeoDist = Inf(1,nopts);        % store Geo distance
    minor_visit = zeros(1,nopts);              % minor marker. for neighbors
    visit_status = zeros(1,nopts); % marker 1 if point has been root once
    neighbors = [];                % used in later STEP#5
    currentID = startID;
    GeoDist(1,startID) = 0;
    %% Dijkstra implementing
    while sum(~visit_status) > 0 % that means you still got unvisited nodes
      % STEP#1 Set current node status

        visit_status(currentID) = 1;
      %------------------------------------------------------------------------

      % STEP#2 Find neighbors & add to neighbor list
        % find neighborID is to settel one current ID, find every row contains
        % currentID. In this case, column 12, 13, 21, 23, 31, 32. Each number, the
        % first would be currentID
        rownumber1 = find(triang(:,1) == currentID);
        rownumber2 = find(triang(:,2) == currentID);
        rownumber3 = find(triang(:,3) == currentID);
        rownumber = ([rownumber1 + notrg; rownumber1 + notrg * 2; rownumber2;
                    rownumber2 + notrg * 2; rownumber3; rownumber3 + notrg])';
        
        forming_neighborsID(triang(rownumber)) = triang(rownumber);
        sameIndices = find(forming_neighborsID);
        neighborsID = forming_neighborsID(sameIndices);
        nocrntnei = length(neighborsID);
        status_table = [neighborsID;logical((ones(1,nocrntnei)-(visit_status(neighborsID))).*(ones(1,nocrntnei)-(minor_visit(neighborsID))))];
        
        %==================================
        k = status_table(2,:) == 1;
        neighborsID = status_table(1,k);   
        minor_visit(neighborsID) = 1;
        neighbors = [neighbors neighborsID];
        %update corrent neighborID
        nocrntnei = length(neighborsID);
        %======================================================================
        
      %------------------------------------------------------------------------

      % STEP#3 aqcuire distances from currentID to all its neighbors(in neighborID list)
        % the reference is diffcult: first two inputs are positions
        % currentdist sparse mat has the value. Third input is a readin value.
        currentdist = GeoDist(currentID) * ones(1,nocrntnei) + EdistGraph(1,(currentID-1) * nopts + neighborsID);                 
      %------------------------------------------------------------------------

      % STEP#4 update distance
      for n = 1:nocrntnei
        if (currentdist(1,n) < GeoDist(neighborsID(n)))
            GeoDist(neighborsID(n)) = currentdist(1,n);
        end
      end
      %------------------------------------------------------------------------

      % STEP5 pick next visit point & change visit_status
        % by doing this, we really don't want to use all of Geodist. so creat a
        % small matrix
        table = [neighbors;
                 GeoDist(neighbors)];  %this could move to some where else
        maycurrentID = find(table(2,:) == min(table(2,:)));
        if isempty(maycurrentID)
            break
        else
            currentID = table(1,maycurrentID(1));   % pick next point
            visit_status(1,currentID) = 1;          % change visited status
            neighbors(neighbors == currentID) = []; % remove from neighbors's list
        end
      %------------------------------------------------------------------------
    end
end
% tic;
% for i = 1:340
%         GeoDistTemp = Dijkstra_sl5352(triang, coord, EdistGraph, i);
%         GeoDist(i,:) = GeoDistTemp;
% end
% toc;