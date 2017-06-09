
clc
clear all
close all

load('histdata.mat');
load('BOF_final.mat');
directory = dir('Segmented Samples/*.png');
img_tot = size(directory,1);
for j = 1:img_tot
    test1 = imread(directory(j).name);
    p = 1024;
    [m,n] = size(test1);
    test1_pad = padarray(test1, [floor((p-m)/2) floor((p-n)/2)], 'replicate','post');
    test1_pad = padarray(test1_pad, [ceil((p-m)/2) ceil((p-n)/2)], 'replicate','pre');
    test1_resize=imresize(test1_pad, [512 512]);
    test1_resize=im2double(test1_resize);
    points = detectSURFFeatures(test1_resize);
    [features,validPoints] = extractFeatures(test1_resize,points);
    pre_assignment = pdist2(features,C,'euclidean');
    assignment = bsxfun(@eq,pre_assignment,min(pre_assignment,[],2));
    [r,c] = find(assignment == 1);
    index(r,1) = c;
    [h,b] = hist(index);
    h_n = h./sum(h);
    h_n = h_n';
    iter = size(H,2);
    diff = zeros(iter,2);
    for i = 1:iter
        diff(i,1) = sum(abs(h_n-H(:,i)));
        diff(i,2) = i;
    end
    diff = sortrows(diff,1);
    top5(:,j) = diff(1:5,2);
end
%top5 gives us the top5 matches for all the sketches
%The following code displays the 3D objects


for i=1:size(top5,1)
    figure;
    count = 1;
    for j =1:size(top5,2)
        filename = strcat(f(top5(i,j)).name(1:end-4),'.off');
        [D,V] = read_off(filename);
           
           subplot(3,3,count);
           plot3(D(:,1),D(:,2),D(:,3),'b.');
           axis equal;
  
        count = count + 1;
        
        
        
        %3D display part mesh(D) or surf(D) 
    end
end