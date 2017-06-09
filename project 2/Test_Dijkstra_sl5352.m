function [ GeoDist ] = Dijkstra_sl5352( triang, coord, EdistGraph, startID)
% Dijkstra_sl5352 function compute points wise Geodesic Distance
%   This function got three inputs: 
%                  Triang: how neighborhood formed
%                  coord: mesh points position in space
%                  EdistGraph: pre-caculated neighborhood dist. in sparse
%                  startID: starting point ID
%
%   This function returns a vector contains all point wise distance gose
%   from starting point to other points in the graph (if connection exists)
%
% By Shuaiyu Liang @ Oct. 11th 2015
% NYU Tandon school of Engineering
% Miniproject #2 3D shape search engine
% EL-GY 9143 3D computer vision
%=========================================================================%
%% initializing
nopts = size(coord,1);
notrg = size(triang,1);
currentdist = sparse(1,nopts);
GeoDist = Inf(1,nopts);        % store Geo distance
minor_visit = [];              % minor marker. for neighbors
visit_status = zeros(1,nopts);
neighbors = [];                % used in later STEP#5
currentID = startID;
%visit_status = [ones(1,currentID),zeros(1,nopts-currentID)]; % marker. This is point visited status
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
    neighborsID = ([triang(currentID == triang(:,1),2); triang(currentID == triang(:,1),3);
                   triang(currentID == triang(:,2),1); triang(currentID == triang(:,2),3);
                   triang(currentID == triang(:,3),1); triang(currentID == triang(:,3),2)])';
    nocrntnei = length(neighborsID);
    minor_visit = zeros(1,nocrntnei); % for leaving out repeated neighbors per loop
    neighborsIDnew = []; % initialize to none every loop
    
    % check visited status and add to list( this step also leave out the same points in neighborID)
    % three list: neighbors ------- for step#5 
    %             neighborsID ----- originally neighbors
    %             neighborsIDnew -- uodated neighborsID
    for n = 1:nocrntnei
        if (~visit_status(neighborsID(n))) && (~minor_visit(n)) && (isempty(find(neighbors == neighborsID(n))))
             neighbors = [neighbors neighborsID(n)];
             neighborsIDnew = [neighborsIDnew neighborsID(n)];
             sameindeices = find(neighborsID == neighborsID(n));
             minor_visit(sameindeices) = 1;
        end
    end
    %update corrent neighborID
    nocrntnei = length(neighborsIDnew);
    neighborsID = neighborsIDnew;
  %------------------------------------------------------------------------
  
  % STEP#3 aqcuire distances from currentID to all its neighbors(in neighborID list)
    % the reference is diffcult: first two inputs are positions
    % currentdist sparse mat has the value. Third input is a readin value.
    currentdist = sparse(ones(1,nocrntnei), neighborsID, GeoDist(currentID) * ones(1,nocrntnei) +...
                         full(EdistGraph(1,(currentID-1) * nopts + neighborsID)));                 
  %------------------------------------------------------------------------
  
  % STEP#4 update distance
  for n = 1:nocrntnei
    if (full(currentdist(1,neighborsID(n))) < GeoDist(neighborsID(n)))
        GeoDist(neighborsID(n)) = full(currentdist(1,neighborsID(n)));
    end
  end
  %------------------------------------------------------------------------
  
  % STEP5 pick next visit point & change visit_status
    % by doing this, we really don't want to use all of Geodist. so creat a
    % small matrix
    table = [neighbors;
             GeoDist(neighbors)];  %this could move to some where else
    if isempty(table)
        break
    else
        maycurrentID = find(table(2,:) == min(table(2,:)));
        currentID = table(1,maycurrentID(1));   % pick next point
        visit_status(1,currentID) = 1;          % change visited status
        neighbors(neighbors == currentID) = []; % remove from neighbors's list
        ans =1;
    end
  %------------------------------------------------------------------------
end