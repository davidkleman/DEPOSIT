function deposit_old(steplength,disp)
%function deposit_old(steplength,disp)
%start a trajectory in each grid cell, 

globals;
global gridcellsizex;
global gridcellsizey;
gridcellsizex=abs((XCOORD(1,1)-XCOORD(1,GRIDSIZEX))/GRIDSIZEX);
gridcellsizey=abs((YCOORD(1,1)-YCOORD(GRIDSIZEY,1))/GRIDSIZEY);
ind=find(VEL>0);
stps=[XCOORD(ind) YCOORD(ind)];
curx=[];cury=[];
handle=[];
steplength=abs(steplength);

TRAJ=[]

DEPOSIT=zeros(GRIDSIZEX,GRIDSIZEY,ROCKTYPES);
type=getrocktype(LATI(ind),LONGI(ind));

nadd=0;
for i=1:length(ind)
    nstep=0;
    traj=zeros(2000,2);
    traj(1,:)=stps(i,:);
    curx=stps(i,1);cury=stps(i,2);
    backx=0;
    backy=0;
    stepy=0;
    stepx=0;
    stop=0;
    xind=0;yind=0;
    while(isinside(curx,cury) & nstep<2000)
        nstep=nstep+1;
        %take a backward step,then go forward again half the way
        [stepx,stepy]=getvelocity(curx,cury);
        %stepx and stepy are normalized, stepx^2+stepy^2=1
        stepx=stepx*steplength;stepy=stepy*steplength;
        curx=curx+stepx;cury=cury+stepy;             
        if(stepx==0 & stepy==0)break;
        end
        traj(nstep,:) = [curx cury]; 
    end
    TRAJ{i}=traj;
    if(nstep>1)
    [xind,yind]=getclosestcell(traj(nstep-1,1),traj(nstep-1,2));
    if(xind>0 & yind>0 & type(i)>0)
        plotm(LATI(yind,xind),LONGI(yind,xind),'.');
        DEPOSIT(yind,xind,type(i))=DEPOSIT(yind,xind,type(i))+VEL(ind(i));
    end
    end
     if(disp)
        [lat,lon]=grid2pol(traj(:,1),traj(:,2));
        handle=[handle plotm(lat,lon,'y-')];
        if(mod(i,100)==0)pause(0.001);fprintf('%d..',i);end
    end
    nadd;
end

function [xind,yind]=getclosestcell(xcoord,ycoord)
global gridcellsizex;
global gridcellsizey;
globals;
if(~isinside(xcoord,ycoord))
    xind=0;
    yind=0;
    return
end
xins=xcoord-XCOORD(1,1);
yins=ycoord-YCOORD(1,1);
xind=1+round(xins/gridcellsizex);
yind=1+round(yins/gridcellsizey);
if(xind>GRIDSIZEX)
if(xind==GRIDSIZEX+1)xind=GRIDSIZEX;
else xind=0;
end
end
if(yind>GRIDSIZEY)
if(yind>GRIDSIZEY+1)yind=GRIDSIZEY;
else yind=0;
end
end
if(xind<1)
if(xind==0)xind=1;
else xind=0;
end
end
if(yind<1)
if(yind==0)yind=1;
else yind=0;
end
end