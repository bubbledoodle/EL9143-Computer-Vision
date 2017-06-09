function [distance] = ED(point, coord, nopts)
%ED computes pair wised point Euclidean distance
%   Input: point: starting point
%          coord: end point array
%          nopts: nunber of point in array
%
%   Output: distance: pair-wised distance

for n = 1:nopts
    distance(n) = sqrt((point(1) - coord(n,1))^2 + (point(2) - coord(n,2))^2 + (point(3) - coord(n,3))^2);
end
end

