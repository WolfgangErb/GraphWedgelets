% GWI: Graph Wedgelets for Image compression
% (C) W. Erb 01.07.2025

% Example 1: how to encode an image with graph wedgelets

clear all, close all

%Paths
addpath(genpath('./core/'))
addpath(genpath('./data/'))

%Read image
I = imread('eagle.jpg');

%Extract signal and node information from image
[V,f,dimIx,dimIy] = GWI_im2sig(I); 

%% Parameters for BWP tree and wedgelet encoding
% Parameters for a priori decomposition of image in quadratic blocks
Jx = 5;           % Put Jx=1, Jy=1 if no decomposition is desired
Jy = 5;

% Main parameters for wedgelet decomposition
M      = 200;           % maximal partition size (number of leaves in BWP tree)
R.type = 'KC';
R.val  = 16;            % Parameters for greedy method:
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

%% Decode function from wedgelets
tic;
[s,P] = GWI_wedgelet_decode(V,BWP.Q,BWP.F,BWPin,metric);
fprintf(1, 'Time[s] for wedgelet decoding:        '); fprintf(1,'%5f \n', toc);

%% Rebuild compressed image from graph signal s
Iwedge = GWI_sig2im(s,dimIx,dimIy);

%% Calculate and print PSNR
D = abs(double(I)-double(Iwedge)).^2;
mse  = sum(D(:))/numel(I);
psnr = 10*log10(255*255/mse);
fprintf(1, 'PSNR at level %4d:                  ', M);fprintf(1,'%5f \n', psnr);
fprintf(1, 'Calculation successful! \n');

%% Plot results
figure('Units', 'pixels', 'Position', [0 50 dimIx dimIy]);
imagesc(I)
colormap(gray)
title('Original image')
set(gca,'XTick',[], 'YTick', [])
hold off

figure('Units', 'pixels', 'Position', [0 50 dimIx dimIy]);
imagesc(Iwedge)
colormap(gray)
title('Wedgelet compression')
set(gca,'XTick',[], 'YTick', [])
hold off

figure('Units', 'pixels', 'Position', [0 50 dimIx dimIy]);
imagesc(Iwedge)
colormap(gray)
title('Wedgelet compression and BWP tree encoding')
hold on
plot( V(BWP.Q(:,1),1),V(BWP.Q(:,1),2),'o','color','r','LineWidth',2,'MarkerSize',8)
set(gca,'XTick',[], 'YTick', [])
hold off