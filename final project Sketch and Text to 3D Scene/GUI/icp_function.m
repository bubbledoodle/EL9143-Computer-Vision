function [] = icp_function(model,source,iterations)

disp('Performing ICP algorithm')
   disp('2D data set initialized')
   
   plot(model(1,:),model(2,:),'r.',source(1,:),source(2,:),'b.')
%variables
TR = eye(2);
TT = zeros(2,1);

for j = 1 : iterations
M = nearestneighbour(source,model);

 P = zeros(2,size(source,2));
 for i = 1 : size(source,2)
     P(:,i) = model(:,M(:,i));
 end
Cm = mean(P,2);  %mean of nearest points
Cs = mean(source,2);

new_source = zeros(2,size(source,2));
new_P = zeros(2,size(source,2));

new_source(1,:) = source(1,:) - Cs(1,1);
new_source(2,:) = source(2,:) - Cs(2,1);  %removing centroid from source

new_P(1,:) = P(1,:) - Cm(1,1);
new_P(2,:) = P(2,:) - Cm(2,1); %nearest point minus centroid

%correlation matrix
H = new_source * transpose(new_P);
[U,D,V] = svd(H);   %singular value decomposition 

%rotation matrixV(
R = V * transpose(U);
%traslation vector estimation
V = Cm - R*Cs;

%building transformations
TR = R * TR;
TT = R*TT + V;

source = R * source;
source(1,:) = source(1,:) + V(1,1);
source(2,:) = source(2,:) + V(2,1);

end
figure
plot(model(1,:),model(2,:),'r.',source(1,:),source(2,:),'b.') 
     






end
