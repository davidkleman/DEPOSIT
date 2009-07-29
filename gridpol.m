function [lat,lon] = gridpol(x,y)
global MSTRUCT;
[lat,lon] = minvtran(MSTRUCT, x,y);