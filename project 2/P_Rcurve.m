% P-R curve
clear all; close all; clc;
bin = 128;                              %Euclideam distance Descriptor vector bin
nomodel = 147;                          %number of model in smallTOSCA
MAP1 = 0;
MAP2 = 0;
PRECISION1 = zeros(1,nomodel);
RECALL1 = zeros(1,nomodel);
PRECISION2 = zeros(1,nomodel);
RECALL2 = zeros(1,nomodel);

%% load Descriptor
fid = fopen('Edescriptor_largemissing.dat', 'rb');
descriptor = fread(fid, bin * nomodel, 'float32');
descriptor = (reshape(descriptor,bin,nomodel))';

%% load current dir off file
path = pwd;
files = dir([pwd,'\smallTOSCA/*.off']);

for i = 1:nomodel
    %% initializing inner loop
    currentfile = []; 
    A = 0;
    AP = 0;
    criterion = zeros(1,nomodel);
    descriptor_current = zeros(1,bin);
    AintersectB = 0;
    precision = zeros(1,nomodel);
    recall = zeros(1,nomodel);
    
    %% for one model's retrive evalution
    currentfile = files(i).name(1:2);
    % count how many relevant file 
    for j = 1:nomodel
        if currentfile == files(j).name(1:2)
            A = A+1;
        end
    end
    
    % compute current file's retrived sort
    descriptor_current = descriptor(i,:);
    for j = 1:nomodel
        for k = 1:bin
            %criterion is based on euclideann distance
            temp = (descriptor_current(k)-descriptor(j,k))^2;  
            criterion(j) = criterion(j) + temp;
        end
    end
    [B,IX] = sort(criterion, 'ascend');
    
    %% for one model's P-R evalution
    for j = 1:nomodel
        if files(IX(j)).name(1:2) == currentfile
            AintersectB = AintersectB + 1;
            AP = AP + AintersectB/j;
        end
        precision(1,j) = AintersectB/j;
        recall(1,j) = AintersectB/A;
    end
    PRECISION1 = PRECISION1 + precision;
    RECALL1 = RECALL1 + recall;
    MAP1 = MAP1 + AP/A;
end
%% compute average P-R & MAP
PRECISION1 = PRECISION1/nomodel;
RECALL1 = RECALL1/nomodel;
MAP1 = MAP1/nomodel;

%--------------------------------------------------------------------------
%Geo
fid = fopen('Gdescriptor_largemissing.dat', 'rb');
descriptor = fread(fid, bin * nomodel, 'float32');
descriptor = (reshape(descriptor,bin,nomodel))';

%% load current dir off file
path = pwd;
files = dir([pwd,'\smallTOSCA/*.off']);

for i = 1:nomodel
    %% initializing inner loop
    currentfile = []; 
    A = 0;
    AP = 0;
    criterion = zeros(1,nomodel);
    descriptor_current = zeros(1,bin);
    AintersectB = 0;
    precision = zeros(1,nomodel);
    recall = zeros(1,nomodel);
    
    %% for one model's retrive evalution
    currentfile = files(i).name(1:2);
    % count how many relevant file 
    for j = 1:nomodel
        if currentfile == files(j).name(1:2)
            A = A+1;
        end
    end
    
    % compute current file's retrived sort
    descriptor_current = descriptor(i,:);
    for j = 1:nomodel
        for k = 1:bin
            %criterion is based on euclideann distance
            temp = (descriptor_current(k)-descriptor(j,k))^2;  
            criterion(j) = criterion(j) + temp;
        end
    end
    [B,IX] = sort(criterion, 'ascend');
    
    %% for one model's P-R evalution
    for j = 1:nomodel
        if files(IX(j)).name(1:2) == currentfile
            AintersectB = AintersectB + 1;
            AP = AP + AintersectB/j;
        end
        precision(1,j) = AintersectB/j;
        recall(1,j) = AintersectB/A;
    end
    PRECISION2 = PRECISION2 + precision;
    RECALL2 = RECALL2 + recall;
    MAP2 = MAP2 + AP/A;
end
%% compute average P-R
PRECISION2 = PRECISION2/nomodel;
RECALL2 = RECALL2/nomodel;
MAP2 = MAP2/nomodel;
%% ploting
plot(RECALL1,PRECISION1,'r',RECALL2,PRECISION2);
title('P-R curve large part missing model'); grid on;
legend('Euclidean Descriptor','Geodesic Descriptor');
xlabel('Recall');ylabel('Precision'); axis([0,1,0,1]);