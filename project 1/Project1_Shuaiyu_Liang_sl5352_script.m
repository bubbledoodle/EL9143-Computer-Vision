%==========================================================================
% This is the mini project #1--Implementing ICP algorithm 
% EL-GY 9143 class. 
% Code writen by Shuaiyu Liang from 
% Polytechnic School of Engineering of NYU. 
% Writing date: Sep./ 03/ 2015
%==========================================================================
clc;
close all;
clear all;

%% loading data
disp(sprintf('1:2D_Line \n2:2D_Line_Noise \n3:3D_Cat \n4:3D_Cat_Noise'));
reply = input('select loading(please input 1,2,3,4):','s');
switch reply
    case num2str(1)
        load('2D_Line.mat');
    case num2str(2)
        load('2D_Line_Noise.mat');
    case num2str(3)
        load('3D_Cat.mat');
    case num2str(4)
        load ('3D_Cat_Noise.mat');
    otherwise
        error('input wrong!');
end
%[TR, TT, data] = icp(model, source);       %this is how original ICP works

%% processing & ploting
[demM,nM] = size(model);
[demS,nS] = size(source);
if demM>nM
    demM = nM;
    model = model';
end
if demS>nS
    source = source';
end
if demM~=demS
    error('input data do not have same dimesions!');
end
figure();
subplot(121);
sl5352_ploting(demM, model, source, 0);

%This is calling my own ICP function
[model, source] = sl5352_icp(model,source);
subplot(122);
sl5352_ploting(demM, model, source, 1);
