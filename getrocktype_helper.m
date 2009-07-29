%Getrocktype.m helper
function types=getrocktype_helper(lat,lon)
    global ROCK;
    global ROCKLEG;
    sz=length(lat);
    types=zeros(sz,1);
    for i=1:sz
        a=ltln2val(ROCK,ROCKLEG,lat(i),lon(i),'nearest');
        if(isempty(a))
            types(i)=0;
        else
            types(i)=a;
        end
    end
        