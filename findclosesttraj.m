function traj=findclosesttraj(index,maxdistance,disp)
%function traj=findclosesttraj(index,maxdistance)
globals
maxsq=maxdistance*maxdistance;
handles=[];
lastx=XCOORD(index(1));
xchng=0;
for j=1:length(index)
    min=inf;
    xcoord=XCOORD(index(j));
    ycoord=YCOORD(index(j));
    
    if(xcoord~=lastx)xchng=1;
        lastx=xcoord;
    end
    closetraj=0;
    for i=1:length(TRAJ)
        for k=1:length(TRAJ{i}(:,1))
            d=sum((TRAJ{i}(k,:)-[xcoord ycoord]).^2);
            if(d < min)
                closetraj=i;
                min=d;
            end
        end
    end
    if(min<maxsq)
        traj(j)=closetraj;
    else
        traj(j)=0;
    end
    
    if(disp)
        if(min>maxsq)str='r.';
        else str='mo';
        end
        if(xchng)
            pause(0.001);
            xchng=0;
        end
        handles=[handles plotm(LATI(index(j)),LONGI(index(j)),str)];
    end
end             
hidem(handles);