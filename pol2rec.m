function [x,y]=pol2rec(lat,long)
%POL2REC [x,y]=pol2rec(lat,long)
%call settrig before using this function
global rkmpdeg;
global radpdeg;
  x=1e7*(90.0-lat)*rkmpdeg.*cos(long*radpdeg);
  y=1e7*(90.0-lat)*rkmpdeg.*sin(long*radpdeg);