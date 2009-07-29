function type=getrocktype(lat,long)
%function type=getrocktype(lat,long)
global ROCK;
global ROCKLEG;
[sz1,sz2]=size(lat);
type=ltln2val(ROCK,ROCKLEG,lat,long,'nearest');
if(length(type)~=sz1*sz2)
    warning('Points outside of map, falling back to getrocktype2');
    type=getrocktype_helper(lat,long);
end