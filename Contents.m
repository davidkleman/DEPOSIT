% DEPOSIT Numerical Model of Ice sheet erosion
% Version 1.0 05-Sep-2005
%
% Main File
%   depo.m           - This is the main program and user inteface
%
% Global Variables Helper
% 
%   globals.m         - Is included to declare global variables
%
% Math Helpers
%   setproj.m         - 
%   settrig.m         - 
%   rec2pol.m         - rectangular coordinates to polar coordinates
%   pol2rec.m         - polar to rectangular 
%
% Grid Transformation
%   pol2grid.m
%   polgrid.m
%   grid2pol.m
%   gridpol.m 
%
% Loading Geodata
%   loadrockdata.m
%   loadveldata.m
%   loadtopo.m
%   setupgrids.m
%
% Geodata Helpers
%  All the following functions map a lat long coordinate pair to a value
%  
%   gettopocolormap.m
%   getrocktype.m
%   getrocktype2.m
%   getrockcolormap.m
%   getaltitude.m
%
%  Numerical Model
%
%  isinside.m
%  llintersect.m
%  calculate_trajectories.m
%  findclosesttraj.m    - Find trajectory closest to a given point
%  deposit_line.m
%  deposit_old.m        - Older slower method
%  
%  Display
%
%   plotvelmag.m        - Plot velocity magnitude
%   plotflow.m          - Plot ice sheet directional field
%
%
%  Other files
%
%   mex.m
%   progressbar.m        - Display progressbar
%   gui_active.m         - For progressbar abort
%   README               - Info
%   topo_6.2.img         - Can be downloaded for free if not present, see
%                          help satbath in matlab
%
%   Copyright 2005 David Kleman
