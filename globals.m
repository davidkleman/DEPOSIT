%GLOBALS.M
%defines all global variables

%global projection struct
%all calculations will take place in this projection, and grid data will be evenly spaced in this projection. 
%chose a suitable projection for the area of simulation, change in setproj()
global MSTRUCT;

%rock type matrix map
global ROCK;
global ROCKLEG;
global ROCKTYPES;

%topo data
global TOPO;
global TOPOLEG;

% matrix specifying limits of internal grid 
global LIMITS;
% starting point of trajectories
global STARTPOINTS;
%griddata, This is first straight from jims grid but later converted to internal grid spacing..
%all these neeeds to be doubled if two different gridresolutions are used..
global XCOORD;
global YCOORD;
global XVEL;
global YVEL;
global VEL;
global LATI;
global LONGI;

%size of grid
global GRIDSIZEX;
global GRIDSIZEY;

%these are the rates of change of latitude and longitude at the points
%specified by LATI and LONGI. note that these rates are only true at the
%point itself since the scalefactors depends on the lat and long
%coordinates themselves
global LATSPEED;
global LONGSPEED;

%cell array containing trajectories  TRAJ(i) is a 2-by-n matrix specifying trajectory i
%in internal grid coordinates
global TRAJ;

global DEPOSIT;

global DEPLINE;

