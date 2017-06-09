    % (GENERATE RANDOM EXAMPLE OF NODES AND SEGMENTS IF NOT GIVEN AS INPUTS)
    % Create a random set of nodes/vertices,and connect some of them with
    % edges/segments. Then graph the resulting map.
    clc; clear all; close all;
    num_nodes = 40; L = 100; max_seg_length = 30; ids = (1:num_nodes)';
    nodes = [ids L*rand(num_nodes,2)]; % create random nodes
    figure(1); plot(nodes(:,2),nodes(:,3),'k.') % plot the nodes
    text(nodes(num_nodes,2),nodes(num_nodes,3),...
        [' ' num2str(ids(num_nodes))],'Color','b','FontWeight','b')
    hold on
    num_segs = 0; segments = zeros(num_nodes*(num_nodes-1)/2,3);
    for i = 1:num_nodes-1 % create edges between some of the nodes
        text(nodes(i,2),nodes(i,3),[' ' num2str(ids(i))],'Color','b','FontWeight','b')
        for j = i+1:num_nodes
            d = sqrt(sum((nodes(i,2:3) - nodes(j,2:3)).^2));
            if and(d < max_seg_length,rand < 0.6)
                plot([nodes(i,2) nodes(j,2)],[nodes(i,3) nodes(j,3)],'k.-')
                % add this link to the segments list
                num_segs = num_segs + 1;
                segments(num_segs,:) = [num_segs nodes(i,1) nodes(j,1)];
            end
        end
    end
    segments(num_segs+1:num_nodes*(num_nodes-1)/2,:) = [];
    axis([0 L 0 L])
    % Calculate Shortest Path Using Dijkstra's Algorithm
    % Get random starting/ending nodes,compute the shortest distance and path.
    start_id = ceil(num_nodes*rand); disp(['start id = ' num2str(start_id)]);
    finish_id = ceil(num_nodes*rand); disp(['finish id = ' num2str(finish_id)]);
    
    %------------------------------------------------------------------------------
     node_ids = nodes(:,1);
    [num_map_pts,cols] = size(nodes);
    table = sparse(num_map_pts,2); % 建立一个稀疏矩阵
    shortest_distance = Inf(num_map_pts,1);% 建立最短距离的存储矩阵，40个点
    settled = zeros(num_map_pts,1); %settled 是个游子，执行完了记1
    path = num2cell(NaN(num_map_pts,1));%path都写成NAN 是cell数据类型的
    col = 2;
    pidx = find(start_id == node_ids);% 找到startID
    shortest_distance(pidx) = 0;      % 初始化以startID为起点的距离 （已经建立一个向量叫shortest_distance）
    table(pidx,col) = 0;              % (startID,2) table 置零
    settled(pidx) = 1;                
    path(pidx) = {start_id};          %初始的path
    if (nargin < 4) % compute shortest path for all nodes输入少于四个量，算对于所有点的最小距离
        while_cmd = 'sum(~settled) > 0';%下面的while cmd就是settle取反 求和 大于零循环，都执行完了就都是1，去反全零 求和也是零 就不去循环了
    else % terminate algorithm early
        while_cmd = 'settled(zz) == 0';%如果设定了终点的话，只有把finishedID记成了settle = 0 同上条件，当且仅当finishedID执行完，变零 不再while
        zz = find(finish_id == node_ids);
    end
    while eval(while_cmd)
        % update the table
        table(:,col-1) = table(:,col);
        table(pidx,col) = 0;
        % find neighboring nodes in the segments list
        neighbor_ids = [segments(node_ids(pidx) == segments(:,2),3);
            segments(node_ids(pidx) == segments(:,3),2)];%记录在一个列向量里
        % calculate the distances to the neighboring nodes and keep track of the paths
        for k = 1:length(neighbor_ids)
            cidx = find(neighbor_ids(k) == node_ids);%找到某一个neighbor点位置
            if ~settled(cidx)%判断这个点没有走过
                d = sqrt(sum((nodes(pidx,2:cols) - nodes(cidx,2:cols)).^2));%算起始点到neighbor的距离 这步可以查表的
                if (table(cidx,col-1) == 0) || ...
                        (table(cidx,col-1) > (table(pidx,col-1) + d))
                    table(cidx,col) = table(pidx,col-1) + d; % table 这里记录了两个距离，第一栏记录之前的，第二栏记录改变的
                    tmp_path = path(pidx);
                    path(cidx) = {[tmp_path{1} neighbor_ids(k)]};
                else
                    table(cidx,col) = table(cidx,col-1);
                end
            end
        end
        % find the minimum non-zero value in the table and save it
        nidx = find(table(:,col));% 这个特殊针对sparse矩阵找到有数的地方
        ndx = find(table(nidx,col) == min(table(nidx,col)));
        if isempty(ndx)
            break
        else
            pidx = nidx(ndx(1));
            shortest_distance(pidx) = table(pidx,col);
            settled(pidx) = 1;
        end
    end
    if (nargin < 4) % return the distance and path arrays for all of the nodes
        dist = shortest_distance';
        path = path';
    else % return the distance and path for the ending node
        dist = shortest_distance(zz);
        path = path(zz);
        path = path{1};
    end
    %------------------------------------------------------------------------
    
    [distance,path] = dijkstra(nodes,segments,start_id,finish_id);
    disp(['distance = ' num2str(distance)]); disp(['path = [' num2str(path) ']']);
    % If a Shortest Path exists,Plot it on the Map.
    figure(h)
    for k = 2:length(path)
        m = find(nodes(:,1) == path(k-1));
        n = find(nodes(:,1) == path(k));
        plot([nodes(m,2) nodes(n,2)],[nodes(m,3) nodes(n,3)],'ro-','LineWidth',2);
    end
    title(['Shortest Distance from ' num2str(start_id) ' to ' ...
        num2str(finish_id) ' = ' num2str(distance)])
    hold off
    
