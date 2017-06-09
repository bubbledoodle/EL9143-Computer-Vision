clc
clear all
close all
fabric = imread('finename4.jpg');

green = 1;
magenta = 1;
red = 1;
blue = 1;
cyan = 1;

for i = 1 : size(fabric,1)
    for j = 1 : size(fabric,2)
        x = fabric(i,j,1);
        y = fabric(i,j,2);
        z = fabric(i,j,3);
        if (fabric(i,j,1) > 150) && (fabric(i,j,2) < 100) && (fabric(i,j,3) > 150)
%          magenta  
magentaData(magenta,1) = i;
magentaData(magenta,2) = j;
magenta = magenta+ 1;
        elseif (fabric(i,j,1) < 100) && (fabric(i,j,2) > 200) && (fabric(i,j,3) > 200) 
%         cyan
cyanData(cyan,1) = i;
cyanData(cyan,2) = j;
cyan = cyan + 1;
        elseif (fabric(i,j,1) < 130) && (fabric(i,j,2) > 170) && (fabric(i,j,3) < 130) 
%         green
greenData(green,1) = i;
greenData(green,2) = j;
green = green + 1;
        elseif (fabric(i,j,1)  < 100) && (fabric(i,j,2)  < 100) && (fabric(i,j,3) >130) 
%         blue
blueData(blue,1) = i;
blueData(blue,2) = j;
blue = blue + 1;
        elseif (fabric(i,j,1) > 130) && (fabric(i,j,2)  < 100) && (fabric(i,j,3)  < 100) 
%         red
redData(red,1) = i;
redData(red,2) = j;
red = red + 1;
        else
        end
                
        
        
    end
end

%Split into RGB Channels
if green > 1
%  plot(greenData(:,1),greenData(:,2),'g.');
%  hold on
 green_image = ones(500,500);
 green_image = green_image*255;
 g_mean = mean(greenData,1);
 greenData_moved = zeros(size(greenData,1),2);
 greenData_moved(:,1) = greenData(:,1) - g_mean(1,1) + 250;
 greenData_moved(:,2) = greenData(:,2) - g_mean(1,2) + 250;
 greenData_moved = round(greenData_moved);
%  plot(greenData_moved(:,1),greenData_moved(:,2),'g.');
 
 for i = 1 : size(greenData_moved,1)
     green_image(greenData_moved(i,1),greenData_moved(i,2)) = 0;
  
 end
 imwrite(green_image,'1.png');

end

if magenta > 1
%  plot(magentaData(:,1),magentaData(:,2),'m.');
%  hold on
 magenta_image = ones(500,500);
 magenta_image = magenta_image*255;
 m_mean = mean(magentaData,1);
 magentaData_moved = zeros(size(magentaData,1),2);
 magentaData_moved(:,1) = magentaData(:,1) - m_mean(1,1) + 250;
 magentaData_moved(:,2) = magentaData(:,2) - m_mean(1,2) + 250;
 magentaData_moved = round(magentaData_moved);
%  plot(magentaData_moved(:,1),magentaData_moved(:,2),'m.');
 
 for i = 1 : size(magentaData_moved,1)
     magenta_image(magentaData_moved(i,1),magentaData_moved(i,2)) = 0;
  
 end
 imwrite(magenta_image,'2.png');

end

% 
if red > 1
%  plot(redData(:,1),redData(:,2),'r.');
%  hold on
 red_image = ones(500,500);
 red_image = red_image*255;
 r_mean = mean(redData,1);
 redData_moved = zeros(size(redData,1),2);
 redData_moved(:,1) = redData(:,1) - r_mean(1,1) + 250;
 redData_moved(:,2) = redData(:,2) - r_mean(1,2) + 250;
 redData_moved = round(redData_moved);
%  plot(redData_moved(:,1),redData_moved(:,2),'r.');
 
 for i = 1 : size(redData_moved,1)
     red_image(redData_moved(i,1),redData_moved(i,2)) = 0;
  
 end
 imwrite(red_image,'3.png');
 
 
end
%  
 if blue > 1
%  plot(blueData(:,1),blueData(:,2),'b.');
%  hold on

 blue_image = ones(500,500);
 blue_image = blue_image*255;
 b_mean = mean(blueData,1);
 blueData_moved = zeros(size(blueData,1),2);
 blueData_moved(:,1) = blueData(:,1) - b_mean(1,1) + 250;
 blueData_moved(:,2) = blueData(:,2) - b_mean(1,2) + 250;
 blueData_moved = round(blueData_moved);
%  plot(blueData_moved(:,1),blueData_moved(:,2),'r.');
 
 for i = 1 : size(blueData_moved,1)
     blue_image(blueData_moved(i,1),blueData_moved(i,2)) = 0;
  
 end
 imwrite(blue_image,'4.png');

 end

%  
 if cyan > 1
%  plot(cyanData(:,1),cyanData(:,2),'c.');

 cyan_image = ones(500,500);
 cyan_image = cyan_image*255;
 c_mean = mean(cyanData,1);
 cyanData_moved = zeros(size(cyanData,1),2);
 cyanData_moved(:,1) = cyanData(:,1) - c_mean(1,1) + 250;
 cyanData_moved(:,2) = cyanData(:,2) - c_mean(1,2) + 250;
 cyanData_moved = round(cyanData_moved);
%  plot(cyanData_moved(:,1),cyanData_moved(:,2),'r.');
 
 for i = 1 : size(cyanData_moved,1)
     cyan_image(cyanData_moved(i,1),cyanData_moved(i,2)) = 0;
  
 end
 imwrite(cyan_image,'5.png');
 
 end
 
%  plot(redData(:,1),redData(:,2),'r.');
 
 
 
%  load 'reference.mat';
%  greenData = transpose(greenData);
%  table = transpose(table);
%  chair_north = transpose(chair_north);
%  icp_function(greenData,chair_north,10);
 
 