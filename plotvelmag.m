function handle=plotvelmag();
%function handle=plotvelmag();
globals
lvel=zeros(size(VEL));
ind=find(VEL>1/10000);
lvel(ind)=log(VEL(ind).*10000);
handle=surfacem(LATI,LONGI,lvel);
%the first cal
colormap(jet(501));