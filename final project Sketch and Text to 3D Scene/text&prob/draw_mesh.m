path = pwd;
files = dir([pwd,'\Text2Scene_database\bed\*.off']);
fid=fopen([path,'\Text2Scene_database\bed\',files(10).name]);
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

plot3(coord(:,1),coord(:,2),coord(:,3),'.');