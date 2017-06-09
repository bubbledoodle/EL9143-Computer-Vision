function [ obj_struct ] = Position( obj_struct, a, b, index)
%Position implement position relation to one of the mesh s.t. their mesh
%coordinate is changed
%   Input: obj_struct: retrivel object structure
%          A: index of first input object
%          B: index pf second input object
%          index: specifies the position index, range from left, right so
%                 on and so forth

%   Output: struct after
A = obj_struct(a);
B = obj_struct(b);
centerDist = A.obj_scale + B.obj_scale;
switch(char(index)) % switch input can only be str or num
    case 'left'
        A.obj_coordinates = A.obj_coordinates(:,:,:) - repmat([centerDist,0,0], A.obj_nopts,1);
    case 'right'
        A.obj_coordinates = A.obj_coordinates(:,:,:) + repmat([centerDist,0,0], A.obj_nopts,1);
    case 'front'
        A.obj_coordinates = A.obj_coordinates(:,:,:) - repmat([0,centerDist,0], A.obj_nopts,1);
    case 'behind'
        A.obj_coordinates = A.obj_coordinates(:,:,:) + repmat([0,centerDist,0], A.obj_nopts,1);
    case 'on'
        A.obj_coordinates = A.obj_coordinates(:,:,:) + repmat([0,0,centerDist], A.obj_nopts,1);
    case 'under'
        A.obj_coordinates = A.obj_coordinates(:,:,:) - repmat([0,0,centerDist], A.obj_nopts,1);
    case 'next'
        A.obj_coordinates = A.obj_coordinates(:,:,:) - repmat([centerDist,centerDist,0], A.obj_nopts,1);
end
obj_struct(a).obj_coordinates = A.obj_coordinates;
end

