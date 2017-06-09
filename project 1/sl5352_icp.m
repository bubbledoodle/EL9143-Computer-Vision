function [model, source] = sl5352_icp(model,source)
% icp algorithm by Shuaiyu Liang(sl5352). 
% input should be model and source from file, output stored in the same
% matrices. Function relized:
%         1. find closest point using nearest Neighbor
%         2. finding centroid for each dataset
%         3. calculate the covariance matrix
%         4. estimate rotation matrix using SVD
%         5. estimate translation veator
%         6. build transformation
%         7. iterate
%=========================================================================%

% ICP parameters
minIter = 5;                            
maxIter = 100;
threshold = 1e-5;
centdis = 9e99;

[s,numS] = size(source);
R = eye(s);
T = zeros(s,1);
DT = delaunayTriangulation(model');

for iter = 1:maxIter
    lastIterCent = centdis;
    [vi,resid]=nearestNeighbor(DT,source');         %finding the closest point
    Cs = mean(source,2);                            %centroid
    Cm = mean(model(:,vi),2);
    
    centdis = mean(resid.^2);  
    model1 = model(:,vi) - repmat(Cm,1,numS);
    source1 = source - repmat(Cs,1,numS);           %decentroid
    
    H = source1 * model1';                          %covariance matrix
    [U,~,V] = svd(H);                               %SVD
    Ri = V * U';
    Ti = Cm - Ri * Cs;
    
    source = Ri * source;                           %renew source
    source(1,:) = source(1,:)+Ti(1);
    source(2,:) = source(2,:)+Ti(2);
    R = Ri * R;
    T = Ri * T + Ti;
    if iter>=minIter
       if abs(lastIterCent-centdis) < threshold
            break
       end
    end
end