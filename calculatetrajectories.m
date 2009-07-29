function handle=calculatetrajectories(steplength,disp)
%function handle=calculatetrajectories(steplength,disp)
%This function calculates trajectories from the flowdata
%The method used is very simple 
globals;

curx=[];cury=[];
[szy,szx]=size(STARTPOINTS);
handle=[];

if(szx~=2)disp('Startpoints should be a n-by-2 array');
end
for i=1:szy
    nstep=0;
    traj=STARTPOINTS(i,:);
    curx=STARTPOINTS(i,1);cury=STARTPOINTS(i,2);
    backx=0;
    backy=0;
    stepy=0;
    stepx=0;
    stop=0;
    steplength=abs(steplength);
    while(isinside(curx,cury) & nstep<2000)
        nstep=nstep+1;
        [stepx,stepy]=getvelocity(curx,cury);
        %stepx and stepy are normalized, stepx^2+stepy^2=1
        stepx=stepx*steplength;stepy=stepy*steplength;
        curx=curx+stepx;cury=cury+stepy;             

        if(stepx==0 & stepy==0)break;
        end
        traj = [traj; curx cury]; 
    end
    %trace other direction    
%    steplength=-steplength;
%    curx=STARTPOINTS(i,1);cury=STARTPOINTS(i,2);
%    while(isinside(curx,cury) & nstep<2000)
%             [stepx,stepy]=getvelocity(curx,cury);
%        %stepx and stepy are normalized, stepx^2+stepy^2=1
%        stepx=stepx*steplength;stepy=stepy*steplength;
%        curx=curx+stepx;cury=cury+stepy;             

%        if(stepx==0 & stepy==0)break;
%        end
%        traj = [curx cury; traj]; 
%    end
    
     TRAJ{i}=traj;
     
     if(disp)
        fprintf('.');
        [lat,lon]=grid2pol(TRAJ{i}(:,1),TRAJ{i}(:,2));
        handle=[handle plotm(lat,lon,'y-')];
        %pause is made to give the figure some cpu time so it can update the screen
        pause(0.001);
    end
end
