# GUPPY - Graph Uncertainty Principle PlaYground

A very simple toolbox to illustrate space-frequency localization and uncertainty principles on graphs
--------------------------------------------------------------------------------

<img src="img/example_guppy.png" width="400"> 

Version: 0.1 (01.10.2019)

Written by <a href="http://www.lissajous.it"> Wolfgang Erb</a>



General Description
-------------------

**GUPPY** contains a simple Matlab implementation for the illustration of uncertainty principles and the space-frequency localization of signals on graphs. 

Many uncertainty principles on graphs can be described as an admissibility region for the simultaneous space-frequency localization of a graph signal. This localization is determined by a pair (f,g) of filter functions that measures the spatial and spectral localization of the signal. The boundaries of the convex admissibility region describe the limit beyond which a signal can not be localized simulataneously in space and frequency. 

In this package, the admissibility region is calculated as the numerical range of two localization operators linked to the filter pair (f,g). A more precise description of the calculations and the different terminologies can be found in [1]. 

<br>

<img src="img/SFA_bunny.png" width="800"> 
Fig. 1 Optimally space-frequency localized signals for four different pairs (f,g) of filter functions on the bunny graph. 

Description of the Code
-----------------------

The package contains three main parts

- The main folder contains a lot of examples, scripts and demos on how to use the different tools of the package. 

- The subfolder *./core* contains the core code of the package for the generation of the different graphs, the filters and the plots. 

- The subfolder *./data* contains several *.mat* files with the node information of the example graphs. 

The example scripts can be divided into three categories:

- The files of the form **GUP_example_(graph).m** can be used to obtain simple illustrations of the graphs and show how space-frequency decompositions can be calculated and illustrated. 

- In the scripts **GUP_SFA_(graph).m** a more detailed space-frequency analysis is performed for different types of filter pairs (f,g) on a graph. 

- In the scripts of the form **GUP_UP_(graph).m** the shapes of the admissibility regions are plotted for different filter pairs (f,g) on a graph.  

<img src="img/ShapeUP_sensor1.png" width="800"> 
Fig. 2 Shapes of uncertainty for four different pairs (f,g) of filter functions on a sensor graph. 

Remarks
--------------------

The main purpose of this code is to obtain nice illustrations of uncertainty curves for graphs of small size. The calculations rely heavily on the graph Fourier transform and are therefore quite expensive if larger spectral decompositions have to be calculated. I didn't optimize the code for speed, so some of the computations will be quite slow for larger graphs. 

Anybody interested in accelerating or refining the actual code is warmly welcome to contribute. The same holds true if anybody is interested in adding new examples and analysis tools.


Citation and Credits
--------------------

This code was developed by Wolfgang Erb at the Dipartimento di Matematica ''Tullio Levi-Civita'', University of Padova. The corresponding theory related to uncertainty principles on graphs is given in


*   [1] &nbsp; Erb, W. <br>
    <i> Shapes of Uncertainty in Spectral Graph Theory </i> <br>
    arXiv:1909.10865  [eess.SP] (2019) 

<br>
Source for the Stanford bunny: Stanford
University Computer Graphics Laboratory.


License
-------

Copyright (C) 2019 Wolfgang Erb

GUPPY is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
