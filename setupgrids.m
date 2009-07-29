function setupgrids(pollimits,griddimensions)
%This function changes the grid an internal format
%To import flowdata of another kind you shouldn't need to change this,
%change the load-functions instead.
%This function also loads topo data

globals;
global topodatascalefactor;

%change into internal coordinates
[XCOORD,YCOORD]=pol2grid(LATI,LONGI);
[XVEL,YVEL]=pol2grid(LATI+LATSPEED,LONGI+LONGSPEED);
XVEL=XVEL-XCOORD;
YVEL=YVEL-YCOORD;

%create evenly spaced grid
[xrng,yrng]=pol2grid(pollimits(:,1),pollimits(:,2));
%assert ascending order
xrng=sort(xrng);
yrng=sort(yrng);
[XI,YI]=meshgrid(xrng(1):diff(xrng)/(griddimensions(1)-1):xrng(2),yrng(1):diff(yrng)/(griddimensions(2)-1):yrng(2));
[GRIDSIZEX,GRIDSIZEY]=size(XI);

XVEL=griddata(XCOORD,YCOORD,XVEL,XI,YI);
YVEL=griddata(XCOORD,YCOORD,YVEL,XI,YI);
VEL=sqrt(XVEL.^2+YVEL.^2);
XCOORD=XI;
YCOORD=YI;

ind=find(isnan(VEL));
VEL(ind)=0;
XVEL(ind)=0;
YVEL(ind)=0;

[LATI,LONGI]=grid2pol(XCOORD,YCOORD);


[LATSPEED,LONGSPEED]=grid2pol(XCOORD+XVEL,YCOORD+YVEL);
LATSPEED=LATSPEED-LATI;
LONGSPEED=LONGSPEED-LONGI;