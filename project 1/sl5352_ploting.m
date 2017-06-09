function sl5352_ploting(dem, model, source, flag)
% this function for ploting in mini project #1
% basically it realized the 2-D and 3-D ploting, according to dataset type.
% by Shuaiyu Liang
    % Original 2D
    if dem == 2 && flag == 0
       plot(model(1,:),model(2,:),'.r'); hold on; axis equal; grid on;
       plot(source(1,:),source(2,:),'.b'); 
       title(['data points(blue) & model points(red) before applying ICP']);
    end
    % ICP 2D
    if dem == 2 && flag == 1
       plot(model(1,:),model(2,:),'.r'); hold on; axis equal; grid on;
       plot(source(1,:),source(2,:),'.b'); 
       title(['data points(blue) & model points(red) after applying ICP']);
    end
    % Original 3D
    if dem == 3 && flag == 0
        plot3(model(1,:),model(2,:),model(3,:),'.r'); hold on; axis equal; grid on;
       plot3(source(1,:),source(2,:),source(3,:),'.b');
       title(['data points(blue) & moder points(red) before applying ICP']);
    end
    % ICP 3D
    if dem == 3 && flag == 1
       plot3(model(1,:),model(2,:),model(3,:),'.r'); hold on; axis equal; grid on;
       plot3(source(1,:),source(2,:),source(3,:),'.g');
       title(['data points(green) & moder points(red) after applying ICP']);
    end