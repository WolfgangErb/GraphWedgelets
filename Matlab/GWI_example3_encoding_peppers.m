% GWI: Graph Wedgelets for Image compression
% (C) W. Erb 01.07.2025

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
M = 1000;         % maximal partition size (number of leaves in BWP tree)
R.type = 'RA';
R.val  = 50;      % Parameters for greedy method:
                  % 'MD': Max-Distance greedy
                  % 'FA': Fully-Adaptive greedy
                  % 'KC': K-center, with R.val centers
                  % 'RA': Random, with R.val centers
tol = 1e-3;       % stop partitioning if max(error) < tol 
metric1 = 1;      % applied distance metric (1,2, or 'inf')
metric2 = 2;      % applied distance metric (1,2, or 'inf')

%% Initialisation (split image in quadratic blocks and initialize tree)
tic; fprintf(1, 'Starting calculation... \n'); 
BWPin = GWI_quadsplit(V,f,dimIx,dimIy,Jx,Jy,M);
fprintf(1, 'Time[s] for quadratic subdivision:    '); fprintf(1,'%5f \n', toc);

%% Encode function in wedgelets
fprintf(1, 'Time[s] for 1. wedgelet encoding (1-norm): \n'); 
BWP1 = GWI_wedgelet_encode(V,f,BWPin,M,R,tol,metric1);
fprintf(1, 'Time[s] for 2. wedgelet encoding (2-norm): \n'); 
BWP2 = GWI_wedgelet_encode(V,f,BWPin,M,R,tol,metric2);
%% Decode function from wedgelets
tic;
s1 = GWI_wedgelet_decode(V,BWP1.Q,BWP1.F,BWPin,metric1);
s2 = GWI_wedgelet_decode(V,BWP2.Q,BWP2.F,BWPin,metric2);
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