%%
%This functions returns the datapoint matrix and the surface point matrix
%from the .OFF file. A .OFF file is defined with the first line displaying
%the .OFF format and the second line displaying the number of points and 
%triangles. We use this information to then extract the datapoint matrix 
%and the surface point matrix.

%INPUT: Filename (.OFF file)

%OUTPUT: data_points, data_surface

%%
function [data_points,data_surface] = read_off(filename)
fileID = fopen(filename,'r');
str = fgets(fileID);
if ~strcmp(str(1:3),'OFF')
    error('Not an OFF file');
end
%%
str = fgets(fileID);
[vertices,str] = strtok(str);
[surfaces,str] = strtok(str);
v = str2num(vertices);
s = str2num(surfaces);
str = fgets(fileID);
count = 1;
%%
while(ischar(str)&&count<=v)
    data_points_temp = str2num(str);
    if(count == 1)
        m = size(data_points_temp,2);
        data_points = zeros(1,m);
    end
    data_points(count,:) = data_points_temp;
    count = count+1;
    str = fgets(fileID);
end
%%
count =1;
while(ischar(str)&&count<=s)
    [temp,str] = strtok(str);
    data_surface_temp = str2num(str);
    if(count == 1)
        m = size(data_surface_temp,2);
        data_surface = zeros(1,m);
    end
    data_surface(count,:) = data_surface_temp;
    count = count+1;
    str = fgets(fileID);
end
fclose(fileID);
end
