function altitude=getaltitude(lat,long)
%function latitude=getaltitude(lat,long)
global TOPO;
%global TOPOLEG;
[sz1,sz2]=size(lat);
%altitude=ltln2val(TOPO,TOPOLEG,lat,long,'bilinear');
altitude=TOPO;
%TODO : altitude assumes lat = LATI, long = LONGI
if(size(altitude,1)*size(altitude,2)~=sz1*sz2)
    warning('Getaltitude.m point outside of map');
end