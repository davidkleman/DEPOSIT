function h=plotflow()
%function h=plotflow()
%Plots arrows to show the velocity field.
%Arrows are centered over the point where the velocity is known
globals;
ind=find(VEL~=0 & ~isnan(VEL));

lsmag=sqrt(LATSPEED(ind).^2+LONGSPEED(ind).^2);
difflat=diff(LATI(ind));
difflat=[difflat; difflat(length(difflat))];
difflong=diff(LONGI(ind));
difflong=[difflong; difflong(length(difflong))];
dirlat=LATSPEED(ind)./lsmag;
dirlong=LONGSPEED(ind)./lsmag;
h=quiverm(LATI(ind)-dirlat*0.5,LONGI(ind)-dirlong*0.5,dirlat,dirlong);
