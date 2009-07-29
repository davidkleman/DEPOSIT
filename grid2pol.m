function [lat,lon]=grid2pol(x,y)
%function [lat,lon]=grid2pol(x,y)
global MSTRUCT;
[lat lon]=minvtran(MSTRUCT,x,y);