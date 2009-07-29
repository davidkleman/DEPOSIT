function [szlat,szlong]=loadrockdata(filename)
% Loads rock data
%
% function [szlat,szlong]=loadrockdata(filename)
% The image specified by filename MUST BE IN GEOGRAPHIC PROJECTION (x,y)=(lat,lon)
% The data should be in band 1 of the image (red band)
% Unknown should have value 255
% all values between 10 will be placed in category 1, 20 in cat 2 FIX
% etc.. So using 10 for cat 1, 20 for cat 2 is a good idea
% (Did not use 1,2,3 etc because some programs(ie Esri progs) have problem
% rounding colorinput, round the 2 you enter into a 1 etc)
%
% Filename can point to an image file of any format compatible with imread(TIFF,PNG,BMP,JPEG,PCX,GIF and more)
% 

% IMPORTANT IMPORTANT IMPORTANT
% In addition to the imagefile an ascii LOCATIONfile with the name
% filename.loc should exist. This file must contain the four numbers
% ullat ullong lrlat lrlong separated by whitespace,
% specifying [lat,lon] of upper left and lower right corner of data respectively
% Example litholow.pcx is the filename given
% a file named litholow.loc should exist with content like;
%       80.26
%       -108.82
%       43.0
%       -54.77

limvec=load(strcat(strtok(filename,'.'),'.loc'));

ullat=limvec(1);ullong=limvec(2);
lrlat=limvec(3);lrlong=limvec(4);

globals;
try
ROCK=imread(filename);
catch
lasterr
return;
end

%only use band 1 (red band)
ROCK=ROCK(:,:,1);

[szlat,szlong]=size(ROCK);

ROCKTYPES=limvec(5);
ind=find(ROCK>ROCKTYPES*10+5);
ROCK(ind)=0;
%values 0-5 into category 1, 6-15 into 2 etc..
drock=(double(ROCK)+1)./10.0;
ROCKTYPES=limvec(5);
ROCK=uint8(round(drock));
ind=find(ROCK>ROCKTYPES);
ROCK(ind)=0;


%ADD wrapping issues with longitude
%ADD check that cells are within a reasonable tolerance rectangular
ROCKLEG=[szlong/(lrlong-ullong) ullat ullong];
ROCK=flipud(ROCK);