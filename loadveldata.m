function [sizex,sizey]=loadveldata(filename)

%function [sizex,sizey]=loadveldata(filename)
%creategrid.m Loads velocity data from plain numeric ascii file with 7 columns;
%LONGITUDE LATITUDE XCOORD YCOORD XVEL YVEL VEL
%the coordinates are assumed to be in azimuthal equidistant projection (+some scale factor, FIX?)
%This is the format used by Jim Fasttooks model
%David Kleman 2003-


globals;

sizex=-1;
sizey=-1;

grid1=[];

% LOAD
try
    %grid1=load(filename);
    %catch
    %    lasterr
    %    return;
    fid=fopen(filename);
    while fid
      tline = fgetl(fid);
      if ~ischar(tline), fclose(fid),fid=0;break, end
      if strfind(tline, 'UMAG') 
          while (fid)
              tline = fgetl(fid);
              if(isnumeric(tline))fclose(fid); fid=0;break; end
              tdata = sscanf(tline, '%f');
              if(length(tdata)>7)tdata = [tdata(1) tdata(2) tdata(3) tdata(4) 0 0 0]';
              end;
              
              grid1 = [grid1; tdata'];
          end
      end
    end
end
[rows, cols]=size(grid1);
if(cols~=7)
    disp('Error: file should have 7 columns');
    return;
end
diff_x=abs(diff(grid1(:,3)));


%determine size of grid
diffmed_x=(median(diff_x));

xsusp=0;

for(i=1:length(diff_x))
    if(diff_x(i)>3*diffmed_x)
        xsusp=i;
        if(mod(length(grid1(:,3)),xsusp)==0)
            GRIDSIZEX=xsusp;
            GRIDSIZEY=length(grid1(:,3))/xsusp;
            break
        end
    end
end

if(xsusp==0)
    disp('Error:Could not determine gridsize, aborting');
    return;
end

sizex=GRIDSIZEX;
sizey=GRIDSIZEY;


XVEL=zeros(GRIDSIZEX,GRIDSIZEY);
YVEL=zeros(GRIDSIZEX,GRIDSIZEY);
VEL=zeros(GRIDSIZEX,GRIDSIZEY);
XCOORD=zeros(GRIDSIZEX,GRIDSIZEY);
YCOORD=zeros(GRIDSIZEX,GRIDSIZEY);
LATI=zeros(GRIDSIZEX,GRIDSIZEY);
LONGI=zeros(GRIDSIZEX,GRIDSIZEY);

    
for(i=1:GRIDSIZEX)
    for(k=0:GRIDSIZEY-1)
        LONGI(i,k+1)=grid1(k*GRIDSIZEX+i,1);
        LATI(i,k+1)=grid1(k*GRIDSIZEX+i,2);
        XCOORD(i,k+1)=grid1(k*GRIDSIZEX+i,3);
        YCOORD(i,k+1)=grid1(k*GRIDSIZEX+i,4);
        XVEL(i,k+1)=grid1(k*GRIDSIZEX+i,5);
        YVEL(i,k+1)=grid1(k*GRIDSIZEX+i,6);
        VEL(i,k+1)=grid1(k*GRIDSIZEX+i,7);
       
    end
end

dirx=XVEL./VEL*1000;
diry=YVEL./VEL*1000;
[LATSPEED,LONGSPEED]=rec2pol(XCOORD+dirx,YCOORD+diry);
LATSPEED=(LATSPEED-LATI).*VEL;
LONGSPEED=(LONGSPEED-LONGI).*VEL;
ind=find(VEL==0);
LATSPEED(ind)=0;
LONGSPEED(ind)=0;
