% GWI: Graph Wedgelets for Image compression
% (C) W. Erb 01.07.2025

% Example 2: how to use geometric wavelet coefficients for level adaptive 
% BWP decoding of images and for visualization of wavelet details

clear all, close all

%Paths
addpath(genpath('./core/'))
addpath(genpath('./data/'))

%Read image
I = imread('church.jpg');

%Extract signal and node information from image
[V,f,dimIx,dimIy] = GWI_im2sig(I); 

%% Parameters for BWP tree and wedgelet encoding
% Parameters for a priori decomposition of image in quadratic blocks
Jx = 5;           % Put Jx=1, Jy=1 if no decomposition is desired
Jy = 5;

% Main parameters for wedgelet decomposition
M      = 1000;          % maximal partition size (number of leaves in BWP tree)
R.type = 'RA';
R.val  = 50;            % Parameters for greedy method:
                        % 'MD': Max-Distance greedy
                        % 'FA': Fully-Adaptive greedy
                        % 'KC': K-center, with R.val centers
                        % 'RA': Random, with R.val centers
tol = 1e-3;             % stop partitioning if max(error) < tol 
metric = 2;             % applied distance metric (1,2, or 'inf')

%% Initialisation (split image in quadratic blocks and initialize tree)
tic; fprintf(1, 'Starting calculation... \n'); 
BWPin = GWI_quadsplit(V,f,dimIx,dimIy,Jx,Jy,M);
fprintf(1, 'Time[s] for quadratic subdivision:    '); fprintf(1,'%5f \n', toc);

%% Encode function in wedgelets
fprintf(1, 'Time[s] for wedgelet encoding: \n'); 
BWP = GWI_wedgelet_encode(V,f,BWPin,M,R,tol,metric);

%% Decode function from M and N wedgelets
N = M/2;         % NN half of MM
tic;
[sM,~] = GWI_geometricwavelet_decode(V,BWP.Q,BWP.c,BWPin,metric);
[sN,~] = GWI_geometricwavelet_decode(V,BWP.Q(1:N,:),BWP.c(1:N,:),BWPin,metric);
fprintf(1, 'Time[s] for wedgelet decoding:        '); fprintf(1,'%5f \n', toc);

%% Rebuild compressed image from graph signal s
IwedgeM = GWI_sig2im(sM,dimIx,dimIy);
IwedgeN = GWI_sig2im(sN,dimIx,dimIy);

% Calculate wavelet details 
Idiff = reshape(uint8(sqrt(sum((sM - sN).^2,2))),dimIx,dimIy)';
fprintf(1, 'Calculation successful! \n');

%% Plot results
figure('Units', 'pixels', 'Position', [0 50 dimIx dimIy]);
imagesc(I)
colormap(gray)
title('Original image')
set(gca,'XTick',[], 'YTick', [])
hold off

figure('Units', 'pixels', 'Position', [0 50 dimIx dimIy]);
imagesc(IwedgeM)
colormap(gray)
title('Wedgelet compression (full)')
set(gca,'XTick',[], 'YTick', [])
hold off

figure('Units', 'pixels', 'Position', [0 50 dimIx dimIy]);
imagesc(IwedgeN)
colormap(gray)
title('Wedgelet compression (half)')
set(gca,'XTick',[], 'YTick', [])
hold off

figure('Units', 'pixels', 'Position', [0 50 dimIx dimIy]);
imagesc(Idiff)
colormap(flipud(gray))
title('Wavelet details')
set(gca,'XTick',[], 'YTick', [])
hold off