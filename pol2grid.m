function [x,y]=pol2grid(lat,lon)
global MSTRUCT;
[x,y]=mfwdtran(MSTRUCT,lat,lon);