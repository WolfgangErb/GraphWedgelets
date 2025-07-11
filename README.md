# Graph Wedgelets for Image Compression

A simple toolbox to illustrate how graph wedgelets can be used to sparsely approximate and compress images 
--------------------------------------------------------------------------------

<img src="img/BWP-eagle.png" width="800"> 
Fig. 1: Wedgelet compression of images. a) original image with 481 x 321 pixels; 
	 b)c)d) BWP compression with 1000, 500 and 100 graph wedgelets; 
	 e)f)g) center nodes for BWP encoding in b)c)d). 
	 The PSNR values are b) 40.762 dB, c) 37.935 dB, and d) 31.827 dB. 

<br><br>
Version: 0.3 (01.07.2025)

Written by <a href="http://www.lissajous.it"> Wolfgang Erb</a>



General Description
-------------------

This package contains a Matlab implementation for the illustration of graph-based wedgelets in image approximation, compression and segmentation. 

<a href="http://www.lissajous.it/wedgelets.html"> Graph wedgelets</a> are a tool for lossy data compression based on the approximation of graph signals by piecewise constant functions on adaptively generated binary wedge partitioning trees (BWP trees) on a graph. Graph wedgelets are discrete variants of continuous wedgelets and binary space partitionings known from image processing. Wedgelet representations of graph signals can be encoded in a simple way by a set of graph nodes and applied easily to the compression and segmentation of graph signals and images. A detailed description of the encoding and decoding of graph signals with wedgelets is given in [1]. An application to image segmentation is presented in [2]. 

<br>

<img src="img/BWP-church.png" width="800"> 
Fig. 2: Wedgelet compression of images. a) original image with 481 x 321 pixels; b)c) FA-greedy BWP compression with 2000 and 1000 nodes; d) wavelet details between b) and c); e)f) MD-greedy BWP compression with 2000 and 1000 nodes; g) wavelet details between e) and f).

<br>



Description of the Code
-----------------------

The package contains three main parts

- The main folder contains six example scripts on how to calculate and apply the wedgelet decomposition for images. The package works for RGB images as well as for gray-scale images. In the various examples it is illustrated how graph wedgelets can be used for image approximation and segmentation. 

- The subfolder *./core* contains the core code of the package for wedgelet encoding and decoding of images. 

- The subfolder *./data* contains two example images from the BSDS500 dataset and one example from Kaggle.


Remarks
--------------------

This code is written for educational purposes and is not optimized for speed nor for optimal data storage. 


Citation and Credits
--------------------

This code was written by Wolfgang Erb at the Dipartimento di Matematica ''Tullio Levi-Civita'', University of Padova. The corresponding theory related to graph wedgelets and data compression can be found in


*   [1] &nbsp; Erb, W. <br>
    <i> Graph Wedgelets: Adaptive Data Compression on Graphs based on Binary
    Wedge Partitioning Trees and Geometric Wavelets. </i> 
    IEEE Trans. Signal Inf. Process. Netw. 9 (2023), 24-34

*   [2] &nbsp; Erb, W. <br>
    <i> Split-and-Merge Segmentation of Biomedical Images Using Graph Wedgelet Decompositions. </i> 
    In: Gervasi, O., et al. Computational Science and Its Applications - ICCSA 2025 Workshops, ICCSA 2025, Istanbul, Turkey. Lecture Notes in Computer Science, vol 15899. Springer, Cham (2026), 252-263





Sources for the original images: Berkeley Segmentation Data Set and Benchmarks 500 (BSDS500), Kaggle (https://www.kaggle.com/sartajbhuvaji/brain-tumor-classification-mri/).

Funding
-------

This project is funded by the Universit&agrave; degli Studi di Padova - Dipartimento di Matematica under 
the project SID BIRD 2023 entitled "ALISIA-ALgorithms for Immersive Stereoscopic Imaging with 
Applications to the Daedalus camera system", and by the European Union-NextGenerationEU under the
National Recovery and Resilience Plan (NRRP), Mission 4 Component 2 Investment 1.1-Call PRIN 2022 No. 
104 of February 2, 2022 of Italian Ministry of University and Research; Project 2022FHCNY3 (subject 
area: PE-Physical Sciences and Engineering) "Computational mEthods for Medical Imaging (CEMI)".

<br>



License
-------

Copyright (C) 2021, 2025 Wolfgang Erb

**GraphWedgelets** is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.