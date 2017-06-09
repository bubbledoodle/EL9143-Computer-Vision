clc
clear all
close all

a = imread('chair east.bmp');
%  convert to gray

b = rgb2gray(a);

count = 1;


for i = 1 : size(b,1)
    for j = 1 : size(b,2)
      if b(i,j) < 155
        chair_east(count,1) = i;
        chair_east(count,2) = j;
        count = count + 1;
      end
   
    end
end

a = imread('chair west.bmp');
%  convert to gray

b = rgb2gray(a);

count = 1;


for i = 1 : size(b,1)
    for j = 1 : size(b,2)
      if b(i,j) < 155
        chair_west(count,1) = i;
        chair_west(count,2) = j;
        count = count + 1;
      end
   
    end
end

a = imread('chair north.bmp');
%  convert to gray

b = rgb2gray(a);

count = 1;


for i = 1 : size(b,1)
    for j = 1 : size(b,2)
      if b(i,j) < 155
        chair_north(count,1) = i;
        chair_north(count,2) = j;
        count = count + 1;
      end
   
    end
end

a = imread('chair south.bmp');
%  convert to gray

b = rgb2gray(a);

count = 1;


for i = 1 : size(b,1)
    for j = 1 : size(b,2)
      if b(i,j) < 155
        chair_south(count,1) = i;
        chair_south(count,2) = j;
        count = count + 1;
      end
   
    end
end

a = imread('closet.bmp');
%  convert to gray

b = rgb2gray(a);

count = 1;


for i = 1 : size(b,1)
    for j = 1 : size(b,2)
      if b(i,j) < 155
        closet(count,1) = i;
        closet(count,2) = j;
        count = count + 1;
      end
   
    end
end

a = imread('table.bmp');
%  convert to gray

b = rgb2gray(a);

count = 1;


for i = 1 : size(b,1)
    for j = 1 : size(b,2)
      if b(i,j) < 155
        table(count,1) = i;
        table(count,2) = j;
        count = count + 1;
      end
   
    end
end

a = imread('TV.bmp');
%  convert to gray

b = rgb2gray(a);

count = 1;


for i = 1 : size(b,1)
    for j = 1 : size(b,2)
      if b(i,j) < 155
        tv(count,1) = i;
        tv(count,2) = j;
        count = count + 1;
      end
   
    end
end





%  plot(chair_east(:,1),chair_east(:,2),'r.');