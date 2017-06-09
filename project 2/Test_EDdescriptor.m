function [exact, similar1, similar2, similar3] = EDdescriptor(filename)
% This function compute and call back four parameters that is most like
% model input, and the other three most similiar ones.
%
% Input: one *.off filename. String form.
% Output: indecies of most likely models in the list.
%
% By Shuaiyu Liang @ Oct. 8th 2015
% NYU Tandon school of Engineering
% Miniproject #2 3D shape search engine
% EL-GY 9143 3D computer vision
%======================================================================%
%Euclidean parameters
x = 1;
bin = 128;                              %Euclideam distance Descriptor vector bin
nomodel = 147;                          %number of model in smallTOSCA
Edescriptorone = zeros(1,bin);     %initialize Euclidean Descriptor

%% load ED descriptor dataset
fid = fopen('Edescriptor.dat', 'rb');
Edescriptor = fread(fid, bin * nomodel, 'float32');
Edescriptor = (reshape(Edescriptor,bin,nomodel))';

%% acquire current file
fid = fopen(['C:\Users\carly\Documents\Matlab\smallTOSCA\',filename]);
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

%% acquire ED descriptor from current file
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
Edescriptorone = hist(Edistance_norm,bin)/noEdist * 100;

%% acquiring criterion
criterion = zeros(1,nomodel);   %initializing
for m = 1:nomodel
    for n = 1:bin
        temp = (Edescriptorone(n)-Edescriptor(m,n))^2;  %criterion is based on euclideann distance
        criterion(m) = criterion(m) + temp;
    end
end
[B,IX] = sort(criterion, 'ascend');
exact = IX(1);
similar1 = IX(2); similar2 = IX(3); similar3 = IX(4);
end