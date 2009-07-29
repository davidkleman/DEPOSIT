%DEPOSIT_LINE.M 
%deposit along trajs crossing DEPLINE
function deposit_line(steplength)


%start a trajectory in each grid cell, determine if and where
%the trajectory intersects DEPLINE

globals;
global gridcellsizex;
global gridcellsizey;
global savetraj;
global savecrossingtraj;
savecrossingtraj=1;
global depres
depres=200;

global depx;global depy;global lengthdep;
lengthdep=length(DEPLINE);
[depx depy]=pol2grid(DEPLINE(:,1),DEPLINE(:,2));


%calculate length of DEPLINE
for(i=1:size(DEPLINE,1)-1)
   len(i)=distdim(distance(DEPLINE(i,:),DEPLINE(i+1,:)), 'degrees', 'kilometers');;
end
   DEPOSIT=zeros(depres+1,ROCKTYPES);


gridcellsizex=abs((XCOORD(1,1)-XCOORD(1,GRIDSIZEX))/GRIDSIZEX);
gridcellsizey=abs((YCOORD(1,1)-YCOORD(GRIDSIZEY,1))/GRIDSIZEY);
ind=find((abs(VEL)+1) > 0);
stps=[XCOORD(ind) YCOORD(ind)];
curx=[];cury=[];
handle=[];
steplength=abs(steplength);

TRAJ=[];
type=getrocktype(LATI(ind),LONGI(ind));
altitude=getaltitude(LATI,LONGI);
cp=find(isnan(altitude));
altitude(cp)=0;

%setup progressbar
 gui_active(1); % will add an abort button
 h = progressbar( [],0,'Depositing' );


nadd=0;
ticksplotted=0;
for i=1:GRIDSIZEX
    for j=0:GRIDSIZEY-1
    crosstraj=0;
    nstep=0;
    if(type(i+GRIDSIZEY*j)==0 || VEL(ind(i+GRIDSIZEY*j))<1e-10)continue;end;
   
    traj=[];
    traj(1,:)=stps(i+GRIDSIZEY*j,:);
    curx=stps(i+GRIDSIZEY*j,1);cury=stps(i+GRIDSIZEY*j,2);
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
        %see if the new line segment intersects DEPLINE
        [n,s]=deplineintersect([curx cury],[curx+stepx cury+stepy]);
        if(n>0)
            if(n==1)
                lineind=s*len(1)/sum(len)*depres+1;
            else lineind=(s*len(n)+sum(len(1:n-1)))/sum(len)*depres+1;
            end
            
            if(altitude(ind(i))>500)eroded=0;
            else
                eroded=VEL(ind(i+GRIDSIZEY*j))*(500-altitude(ind(i+GRIDSIZEY*j)));
            end 
            erodeddist=normpdf(1:depres+1, lineind, depres/80)';

            DEPOSIT(:,type(i+GRIDSIZEY*j))=DEPOSIT(:,type(i+GRIDSIZEY*j))+erodeddist.*eroded;
            if(isnan(DEPOSIT(:,1)))
                 keyboard;    
            end
            crosstraj=1;
            break;
        end 
            
        curx=curx+stepx;cury=cury+stepy;             
        if(stepx==0 & stepy==0)break;
        end
        traj(nstep,:) = [curx cury]; 
    end
    if((savetraj>0) || (savecrossingtraj>0 && crosstraj>0))
           TRAJ{i+GRIDSIZEY*j,1}=traj;
           TRAJ{i+GRIDSIZEY*j,2}=crosstraj;
    else
           TRAJ{i+GRIDSIZEY*j,1}=[];
    end;

   h = progressbar( h,1/length(ind) );
   if ~gui_active
       break;
   end
   
    pause(0.001);
    end
end


progressbar( h,-1 );

function  [n,s] = deplineintersect(p1,p2)
global DEPLINE;
global depx;global depy;global lengthdep;
%input: line segment point 1 & 2
%output: n=line segment in DEPLINE which p1-p2 intersects, s normalized parameter describing intersection..ie s=0
% means intersection is at point 1 of segment n in DEPLINE, s=1 at point 2
n=0;
for(j=1:lengthdep-1)
    [int,pi,s,q] = llintersect(p1,p2,[depx(j) depy(j)],[depx(j+1) depy(j+1)]);
    if(int)n=j;s=q;return;
    end
end

        