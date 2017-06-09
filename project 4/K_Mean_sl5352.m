function [ cluster_status, iteration ] = K_Mean_sl5352(dist, HKS, num_centers, nopts)
% K_Mean_sl5352 function provide cluster method for 3d point clouds. The
% inputs are 1. dist that is any one kind of distance
%            2. HKS in the form of row vector that is mean of 101 features
%            3. num_centers, desired center number
% by Shuaiyu Liang @ 11/18/2015 NYU Tandon School of Engineering
% This is version 4
%--------------------------------------------------------------------------
% initialize
centers = floor(nopts * rand(1,num_centers));
centers_hks = zeros(num_centers,1);
CENTERS =  zeros(1,num_centers);
cost = zeros(nopts, num_centers);
w = 0.8;
iteration = 1;

while and(sum(centers ~= CENTERS)~=0, iteration<1000)

% define cost function
centers_hks = (HKS(centers))';
cost = w * dist(centers,:) + (1 - w) * (repmat(HKS,num_centers,1) - repmat(centers_hks,1,nopts));

% group points
[min_value, cluster_status] = min(cost);

%restore centers
CENTERS = centers;

% update centers
for i = 1: num_centers
    mask = zeros(1,nopts);
    mask(cluster_status == i) = 1;
    [max_value,centers(i)] = max(mask.*HKS);
end

iteration  = iteration + 1;
end

