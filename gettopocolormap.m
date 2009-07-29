function map=gettopocolormap(topomap, nrcolors)
%function map=gettopocolormap(topomap, nrcolors
%       create colormap where values in topomap < 0 are blue, and other
%       values > 0 progress from green to yellow to orange to red to purple
%       to black..

map=zeros(3,nrcolors);
    cmin=min(min(topomap));
    cmax=max(max(topomap));
    if(cmin<0 & cmax>0)
        indzero=round(nrcolors*(abs(cmin)/(abs(cmin)+abs(cmax))));
        nrcolorsabovezero=nrcolors-indzero;
        d=nrcolorsabovezero/5;
        indyell=round(d)+indzero;
        indorange=round(2*d)+indzero;
        indred=round(3*d)+indzero;
        indpurple=round(4*d)+indzero;
        %add blue shades
        map(:,1:indzero)=copper(indzero)';
        %add green shades
        map(:,indzero+1:nrcolors)=hsv(nrcolors-indzero)';
        %add yellow shades
%        for(i=indyell:indorange-1)map([1 2],i)=(i-indyell)/d;end
        %add orange shades
 %       for(i=indorange:indred-1)map([1 2],i)=(i-indorange)/d;map(2:3,i)=0.5;end
        %add red shades
      %  for(i=indred:indpurple-1)map([1 3],i)=(i-indred)/d;map(2,i)=0.5;end
        %add purple shades
      %  for(i=indpurple:nrcolors)map([2 3],i)=(nrcolors-i)/d;map(1,i)=0.5;end
        map=map';
    else
         map=hsv(nrcolors)
     end


end
