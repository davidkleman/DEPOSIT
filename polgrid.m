function [x,y]=polgrid(lat,lon)
global MSTRUCT;
[x,y]=mfwdtran(MSTRUCT,lat,lon);