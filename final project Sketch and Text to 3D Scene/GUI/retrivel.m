function Out = retrivel(path, current_obj,obj_scale,obj_tag)
%retrivel function: for retrivel the text-represented object
%   This function retrivel single object in each iteration.

%   Input: path: project directory
%          current_obj: The object to retrivel's name
%          obj_scale: current relative scale of object

%   output: output is a structure, which contains such things:
%          {
%           current_obj: The object to retrivel's name
%           obj_file: directory and file name of centern object
%           obj_coordinates: coordinates of object
%           obj_tri: triangulation of object
%           obj_nopts: number of points in object
%           obj_center: center coordinate of centern object
%           object_scale: the Euclidean distance from centroid to the
%                         farest point
%          }
% Final Project Part: Text2Scene by Shuaiyu Liang @ NYU Tandon School of
% Engineering @ 2015/12/13
current_obj = char(current_obj);
path = [path,'\Text2Scene_database\', current_obj];
files = dir([path, '/*.off']); % how many off file
obj_file = ceil(length(files)*rand(1));
obj_file = files(obj_file).name;

% load mesh
fid=fopen([path,'\',obj_file]);
fgetl(fid);
nos = fscanf(fid, '%d %d  %d', [3 1]);
nopts = nos(1);
notrg = nos(2);
coord = fscanf(fid, '%g %g  %g', [3 nopts]);
coord = coord';
triang=fscanf(fid, '%d %d %d %d',[4 notrg]);
triang=triang';
triang=triang(:,2:4)+1; 
fclose(fid);

% compute centroid and scale
center = sum(coord)/nopts;
coord = coord - repmat(center,nopts,1); % decentrolized
scale = max(ED(center, coord, nopts));
coord = coord/scale * obj_scale; % normalize scale
scale = 1 * obj_scale;


% in a formated structure
Out.obj_tag = obj_tag;
Out.current_obj = current_obj;
Out.obj_file = [path,'obj_file'];
Out.obj_coordinates = coord;
Out.obj_tri = triang;
Out.obj_nopts = nopts;
Out.obj_center = center;
Out.obj_scale = scale;
Out.obj_notrg = notrg;
Out.obj_triang = triang;
end

