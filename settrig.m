function settrig
%SETTRIG.M - should be called before using rec2pol, pol2rec
radius =2/pi;
circum=2*pi*radius;
global rkmpdeg;
rkmpdeg=circum/360.0;
global radpdeg;
radpdeg=pi/180.0;
global degprad;
degprad=180.0/pi;

