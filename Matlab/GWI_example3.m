% GWI: Graph Wedgelets for Image compression
% (C) W. Erb 01.10.2021

% Example 3: visualization of the role of the metric for wedgelet approximation

clear all, close all

%Paths
addpath(genpath('./core/'))
addpath(genpath('./data/'))

%Read image
I = imread('peppers.png');

%Extract signal and node information from image
[V,f,dimIx,dimIy] = GWI_im2sig(I); 

%% Parameters for BWP tree and wedgelet encoding
% Parameters for a priori decomposition of image in quadratic blocks
Jx = 5;           % Put Jx=1, Jy=1 if no decomposition is desired
Jy = 5;

% Main parameters for wedgelet decomposition
MM = 1000;        % maximal partition size (number of leaves in BWP tree)
RR = 50;          % Parameter for greedy method:
                  % 'MD': Max-Distance greedy
                  % 'FA': Fully-Adaptive greedy
                  % otherwise: number of randomized splits for R-greedy
tol = 1e-3;       % stop partitioning if max(error) < tol is 
metric1 = 1;      % applied distance metric (1,2, or 'inf')
metric2 = 2;      % applied distance metric (1,2, or 'inf')

%% Initialisation (split image in quadratic blocks and initialize tree)
tic; fprintf(1, 'Starting calculation... \n'); 
[idxQ,FidxQ,cidxQ,nidxQ,BWPJJ,JJ,error] = GWI_quadsplit(V,f,dimIx,dimIy,Jx,Jy,MM);
fprintf(1, 'Time[s] for quadratic subdivision:    '); fprintf(1,'%5f \n', toc);

%% Encode function in wedgelets
fprintf(1, 'Time[s] for 1. wedgelet encoding (1-norm): \n'); 
[idxQ1,FidxQ1,~,~,~,~,~] = GWI_wedgelet_encode(V,f,idxQ,FidxQ,cidxQ,nidxQ,BWPJJ,JJ,error,MM,RR,tol,metric1);
fprintf(1, 'Time[s] for 2. wedgelet encoding (2-norm): \n'); 
[idxQ2,FidxQ2,~,~,~,~,~] = GWI_wedgelet_encode(V,f,idxQ,FidxQ,cidxQ,nidxQ,BWPJJ,JJ,error,MM,RR,tol,metric2);
%% Decode function from wedgelets
tic;
s1 = GWI_wedgelet_decode(V,idxQ1,FidxQ1,BWPJJ,JJ,metric1);
s2 = GWI_wedgelet_decode(V,idxQ2,FidxQ2,BWPJJ,JJ,metric2);
fprintf(1, 'Time[s] for wedgelet decoding:        '); fprintf(1,'%5f \n', toc);

%% Rebuild compressed image from graph signal s
Iwedge1 = GWI_sig2im(s1,dimIx,dimIy);
Iwedge2 = GWI_sig2im(s2,dimIx,dimIy);
fprintf(1, 'Calculation successful! \n');

%% Plot results
figure('Units', 'pixels', 'Position', [0 50 dimIx dimIy]);
imagesc(I)
colormap(gray)
title('Original image')
set(gca,'XTick',[], 'YTick', [])
hold off

figure('Units', 'pixels', 'Position', [0 50 dimIx dimIy]);
imagesc(Iwedge1)
colormap(gray)
title('Wedgelet compression 1-norm')
set(gca,'XTick',[], 'YTick', [])
hold off

figure('Units', 'pixels', 'Position', [0 50 dimIx dimIy]);
imagesc(Iwedge2)
colormap(gray)
title('Wedgelet compression 2-norm')
set(gca,'XTick',[], 'YTick', [])
hold off