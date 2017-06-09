clc;close all; clear all;
%acquire geo_descriptor
%% initializing
path = pwd;
files = dir([path,'\3DComputerVision\project2\GeodesicdistlargemissingTable/*.dat']);
nomodel = 147;
bin = 128; 
Gdescriptor = zeros(1,nomodel*bin);

%% load GeoDist & create Geodescriptor
for flag = 1:nomodel
    filename = files(flag).name;
    filename = filename(1:end-4);
    fid = fopen([path,'\3DComputerVision\project2\GeodesicdistlargemissingTable\', filename, '.dat'], 'rb');
    nopts = fread(fid,1, 'float32');
    GeoDist = (fread(fid, 'float32'))';
    fclose(fid);
    noGdist = size(GeoDist,2);
    Gdescriptor((flag-1)*bin+1:flag*bin) = hist(GeoDist,bin)/noGdist * 100;  
end

fid = fopen('Gdescriptor_largemissing.dat','wb');
fwrite(fid,Gdescriptor,'float32');
fclose(fid);
