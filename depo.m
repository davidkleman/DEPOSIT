function depo
% DEPO 0.1 by David Kleman (kleman@kth.se)
% Commands:
%
% HELP:  
% help                      - Help, this text. For more help check README and the .m files
% help <command>            - Help for commands (also matlab commands)
%
% SETUP:
% loadveldata filename      - Load velocity field data. If limits is already specified this will also recalculate data to internal grid.
% loadrockdata filename     - Load image containing rock types, for information on fileformat. 
% setgrid [xres yres]       - Set resolution of internal velocity grid to xres times yres and pick simulation area interactively
%                             GTOPO30 elevation data is also extracted for the chosen grid.                              
% setgridres xres yres      - Set resolution of internal grid, 
%                             keep simulation limits (optional function)
% setdepline                - Set grounding line. End input with return key
%
% 
%
% RUN MODEL:
% deposit filename          - Run model. If filename is given data will
%                             be saved automatically.
%
% SAVE/LOAD:
% savevars filename         - Save all variables needed to rerun simulation
%                             in file specified by filename.
% loadvars filename         - Load all variables from filename
% 
% DISPLAY
% showvel 1/0               - Display velocity magnitude. showvel 1 shows vel field, 0, hides
% showflow 1/0              - Display velocity field arrows 
% showtraj 1/0              - Display trajectories
% showrock 1/0              - Display rocktype map  
% showfram 1/0              - Show frame of grid
% showdep  1/0              - Show deposit in new figure and on map
% showtopo 1/0              - Show elevation data.
% 
% MISC
% info                      - Print info about currently loaded data
% q                         - Quit program
%
% Any other command than the ones above will be evaluated by the matlab
% interpreter, for instance
% STARTPOINTS will diplay coordinates of startpoints for trajectories
% VEL will display the velocity matrix
% dir will list files in the current directory
%
% You should either load variables from a previous session, or run
% the functions in the SETUP section in the order printed before running 'deposit'
clear;cla;clf;
warning off;

global graphhandle;
global maphandle;
global flowhandle;
global trajhandle;
global velhandle;
global framhandle;
global rockhandle;
global topohandle;
global steplength;
global dephandle;
global deplinehandle;

global savetraj;
global topodatascalefactor;
global depres;

%precision constants
steplength=0.001;
topodatascalefactor=5;
depres=200;

%other constants
savetraj=0;

%handles to graphics objects
figure(1);
hold on;
maphandle=figure(1);
catchhandle=[];
rockhandle=[];
velhandle=[];
flowhandle=[];
trajhandle=[];
framhandle=[];
topohandle=[];
deplinehandle=[];
graphhandle=[];

%setup functions
globals;
setproj;
settrig;
mapsetup;



disp('Hello and welcome, type h for help');

run;

function run()
while(1)
    pause(0.5);
    I = input(':>','s');
    
    while(length(I)>0)
    [B, I]=strtok(I, ';');
    
    [S,R]=strtok(B);
    %remove whitespace from remainder
    if(length(R)>0)
    while(R(1)==' ')
        R=R(2:length(R));
    end
    end
    if(~isempty(S))
        try
            switch(S)
                
                case 'cmdfile'
                    keyboard;
                    fid=fopen(R);
                    if(fid<0)error(sprintf('Could not open file %s', R));
                    end
                    sadd='';
                    while 1
                        tline = fgetl(fid);
                        if ~ischar(tline), break, end
                        sadd=strcat(sadd,sprintf(';%s',tline));
                    end
                    I=strcat(sadd,I);
                    
            case 'depo'
                %dont start multiple copies
            case 'h','help'
                if(length(R)<1)help depo;
                else
                    help(R)
                end
            case 'loadveldata'
                [szx,szy]=loadveldata(R);
                if(szx > 0 & szy > 0);showflow(1);end
            case 'loadrockdata'
                [szx,szy]=loadrockdata(R);
                if(szx > 0 & szy > 0);showrock(1);end
            case 'deposit'
                if(~isempty(R))disp(sprintf('Running...file will be saved to %s',R));
                else disp('Running..data will not be saved automatically');    
                end;
                src/loadtopo;
                deposit_line(0.001);
                if(~isempty(R))savevars(R);end;
            case 'loadvars'
                loadvars(R);
            case 'savevars'
                savevars(R);
            case 'setgrid'
                setgrid(R);
            case 'setgridres'
                setgridres(R);
            case 'setdepline'
                setdepline(str2num(R));
            case 'showcatchment'
                showcatchment(R);
            case 'showtraj'
                showtraj(str2num(R),[]);
            case 'showflow'
                showflow(str2num(R));
            case 'showvel'
                showvel(str2num(R));
            case 'showrock'
                showrock(str2num(R));
            case 'showfram'
                showfram(str2num(R),[]);
            case 'showdep'
                showdep(str2num(R));
            case 'showtopo'
                showtopo(str2num(R));
            case 'showdepline'
                showdepline(str2num(R));
            
                    
            case 'q','quit';
                a=input('Really quit?[y]:','s');
                switch(a)
                case 'yes'
                    return;
                case 'y'
                    return;
                case 'n'
                    continue;
                case 'no' 
                    continue;
                otherwise 
                    break;
                end
            case 'info'
                info;
            otherwise
                eval(cat(2,S,' ',R));
            end
        catch
            disp(lasterr);
        end
    end
end
end 
     
function setgrid(R)
globals;
global topodatascalefactor;
    griddim=str2num(R);
if(length(griddim)~=2)griddim=[GRIDSIZEX GRIDSIZEY];end;
    fprintf('Gridsize is %f x %f,',griddim(1),griddim(2));
    input('\nZoom in/out now, then press enter to chose simulation area');
    disp('Pick upper left and lower right corner of simulation area:');
    LIMITS=inputm(2);
    fprintf('Creating grid...');
    setupgrids(LIMITS,griddim);

    showflow(1);
    showfram(1,[]);
return

function setgridres(R)
globals;
    griddim=str2num(R);
    if(length(griddim)~=2)griddim=[GRIDSIZEX GRIDSIZEY];end;
    fprintf('Gridsize is %f x %f,',griddim(1),griddim(2));
    fprintf('Creating grid...');
    setupgrids(LIMITS,griddim);
    showflow(1);
    showfram(1,[]);
return
   
function setdepline(R)
globals;

    DEPLINE=[];
    temphandle=[];
    disp('Pick deposit line points, end with return key');
    while(1)
        latlong=inputm(1);
        if(isempty(latlong))
            break;
        else 
            DEPLINE=[DEPLINE; latlong];
            temphandle=[temphandle plotm(latlong(1),latlong(2),'-g*')];
        end
    end
    if(ishandle(temphandle))clmo(temphandle);end
    showdepline(1);
return

function mapsetup()
global maphandle;
%MAPSETUP
globals;
    load worldlo
    maphandle=figure(maphandle);
    set(maphandle,'Color',[1 1 1]);
    set(maphandle,'DefaultTextColor','green')
    axesm(MSTRUCT);
    linehandle=displaym(POline);
    texthandle=displaym(POtext);
    set(linehandle,'LineWidth',2);
    framem('k');
    gridm('k');

function showfram(show,ls)
globals;
%if(ismepty(ls))ls='k';end;
ls='k';
global framhandle;
if(~show & ishandle(framhandl))
    clmo(framhandle);
    framhandle=[];
elseif(show)
    if(ishandle(framhandle))clmo(framhandle);
    end;    
    framhandle=plotm(LATI(:,1),LONGI(:,1),ls);
    framhandle=[framhandle plotm(LATI(1,:),LONGI(1,:),ls)];
    framhandle=[framhandle plotm(LATI(:,GRIDSIZEX),LONGI(:,GRIDSIZEX),ls)];
    framhandle=[framhandle plotm(LATI(GRIDSIZEY,:),LONGI(GRIDSIZEY,:),ls)];
end

function showflow(show)
global maphandle;
figure(maphandle);
global flowhandle;
if(~show & ishandle(flowhandle))
    clmo(flowhandle);
    flowhandle=[];
elseif show
  if(flowhandle)clmo(flowhandle);end;
  flowhandle=plotflow;
end

function showvel(show)
global maphandle;
figure(maphandle);
global velhandle;
if(~show & ishandle(velhandle))
    clmo(velhandle);
    velhandle=[];
elseif show
      if(ishandle(velhandle))clmo(velhandle);end;
    velhandle=plotvelmag;
end

function showrock(show)
global maphandle;
figure(maphandle);
globals;
global rockhandle;
if(~show & ishandle(rockhandle))
    clmo(rockhandle);
    rockhandle=[];
elseif(show)
   if(ishandle(rockhandle))clmo(rockhandle);end;
    rockhandle=meshm(ROCK,ROCKLEG);
    colormap(getrockcolormap(1));
end

function showtopo(show)
global maphandle;
figure(maphandle);
globals;
global topohandle;
if(~show & ishandle(topohandle))
    clmo(topohandle);
    topohandle=[];
elseif(show)
   if(ishandle(topohandle))clmo(topohandle);end;
    latitude=getaltitude(LATI,LONGI);
    topohandle=surfacem(LATI,LONGI,latitude);
    colormap(gettopocolormap(latitude,100));
end

function showtraj(show,ls)
global trajhandle;
globals;
if(isempty(ls))ls='-';end;
if(~show & ishandle(trajhandle))
    clmo(trajhandle);
    trajhandle=[];
elseif(show)
    if(ishandle(trajhandle))clmo(trajhandle);end;
    trajhandle=[];
    for i=1:length(TRAJ);
        if(isempty(TRAJ{i}))continue;end;
        [lat,lon]=grid2pol(TRAJ{i}(:,1),TRAJ{i}(:,2));
        trajhandle=[trajhandle plotm(lat,lon,ls,'Color',[1 0 0],'LineWidth',0.5)];
    end
end

function showcatchment(ls)
global catchhandle;
globals;
show=true;
if(isempty(ls))show=false;end;
if(~show & ishandle(catchhandle))
    clmo(catchhandle);
    catchhandle=[];
elseif(show)
    if(ishandle(catchhandle))clmo(catchhandle);end;
    catchhandle=[];
    for i=1:length(TRAJ);
        if(isempty(TRAJ{i}))continue;end;
        [lat,lon]=grid2pol(TRAJ{i}(1,1),TRAJ{i}(1,2));
        catchhandle=[catchhandle plotm(lat,lon,ls,'LineWidth',0.5)];
    end
end


function showdep(show)
globals;
global dephandle; global graphhandle; global maphandle;
if(~show & ishandle(dephandle))
    clmo(dephandle);
    dephandle=[];
elseif(show)
	if(ishandle(dephandle))clmo(dephandle);dephandle=[];end;
	hold on;
    showdepline(show);
    if(ishandle(graphhandle))clmo(graphhandle);end;
    graphhandle=figure('Name', 'Spatial signature');
    for(i=1:size(DEPLINE,1)-1)
       len(i)=distdim(distance(DEPLINE(i,:),DEPLINE(i+1,:)), 'degrees', 'kilometers');;
    end
    hold on;
    colormap(getrockcolormap(0));
	area('v6',(0:size(DEPOSIT,1)-1)*sum(len)./(size(DEPOSIT,1)-1),DEPOSIT./max(sum(DEPOSIT,2)));
    legend(getrocklegend());
    plot(cumsum([0 len]),0,'r*')
    xlabel('Distance along intersection line (km)');
    ylabel('Rate of deposition (dim m^2/s, relative scale)');
    
    showsignature(true, 0, 0);
 
    figure(maphandle);
end

function showsignature(show,startkm,endkm)
global depres;
globals;
    global graphhandle;
    if(startkm==0 && endkm==0)
        fig=figure('Name','Total signature');
        dep_sum = sum(DEPOSIT,1);dep_sum = dep_sum./sum(dep_sum);
    else
        fig=figure('Name',sprintf('Composition between km %d and %d',startkm, endkm));
       for(i=1:size(DEPLINE,1)-1)
           len(i)=distdim(distance(DEPLINE(i,:),DEPLINE(i+1,:)), 'degrees', 'kilometers');
       end
       totlenkm=sum(len);
       startind=startkm*depres./totlenkm+1;
       slutind=endkm*depres./totlenkm+1;
       dep_sum=sum(DEPOSIT(startind:slutind,:),1);dep_sum=dep_sum./sum(dep_sum);
    end
    graphhandle=[graphhandle fig];
    %ensure all elements in dep_sum are nonzero
    dep_sum = dep_sum + repmat(0.000001,size(dep_sum));
    h=pie(dep_sum);
    colormap(getrockcolormap(0));
    textObjs = findobj(h,'Type','text');
    oldStr = get(textObjs,{'String'});
    val = get(textObjs,{'Extent'});
    oldExt = cat(1,val{:});
    %Create the new strings, then set the text objects' String properties to the new strings. 
    Names = {'Paleozoic carb. '; 'Churchill '; 'Nain '; 'Superior '; 'Grenville '};
    newStr = strcat(Names,oldStr);
    set(textObjs,{'String'},newStr)
    %Find the difference between the widths of the new and old text strings and change the values of the Position properties. 
    val1 = get(textObjs, {'Extent'});
    newExt = cat(1, val1{:});
    offset = sign(oldExt(:,1)).*(newExt(:,3)-oldExt(:,3))/2;
    pos = get(textObjs, {'Position'});
    textPos =  cat(1, pos{:});
    textPos(:,1) = textPos(:,1)+offset;
    set(textObjs,{'Position'},num2cell(textPos,[3,2]))


function showdepline(show)
globals;
global deplinehandle;global maphandle;
if(~show & ishandle(deplinehandle))
    clmo(deplinehandle);
    deplinehandle=[];
elseif(show)
    if(ishandle(deplinehandle))clmo(deplinehandle);end;
    deplinehandle=[];
    figure(maphandle);
    deplinehandle = plotm(DEPLINE,'-r*');
end

function info
%Print some info on loaded data.
globals;global steplength;
fprintf('Gridresolution: %d x %d', GRIDSIZEX,GRIDSIZEY);
fprintf('\nCorner 1: Latitude %f Longitude %f',LIMITS(1,1),LIMITS(1,2));
fprintf('\nCorner 2: Latitude %f Longitude %f',LIMITS(2,1),LIMITS(2,2));
fprintf('\nNumber of trajectories: %d',length(TRAJ));
fprintf('\nSteplength (trajectory generation) : %f',steplength); 

function loadvars(R)
globals;
global graphhandle;
global maphandle;
global flowhandle;
global trajhandle;
global velhandle;
global framhandle;
global rockhandle;
global topohandle;
global deplinehandle;
    load(R,'DEPLINE','XCOORD','YCOORD','XVEL','YVEL','VEL','ROCK','ROCKLEG','ROCKTYPES','LIMITS','STARTPOINTS','LATSPEED','LONGSPEED','TRAJ','LATI','LONGI','GRIDSIZEX','GRIDSIZEY','DEPOSIT');
    %update visible graphics 
    if(GRIDSIZEX > 0 & GRIDSIZEY > 0)
        if(ishandle(flowhandle))
            showflow(1);
        end
        if(ishandle(deplinehandle))
            showdep(1);
        end
        if(ishandle(rockhandle))
            showrock(1);
        end
        if(ishandle(velhandle))
            showvel(1);
        end
        if(ishandle(framhandle))
            showfram(1);
        end
        if(ishandle(deplinehandle))
            showdep(1);
        end
        if(ishandle(trajhandle))
            showtraj(1);
        end
        if(ishandle(topohandle))
            showdep(1);
        end
    end

        

function savevars(R)
globals;
    save(R,'DEPLINE','XCOORD','YCOORD','XVEL','YVEL','VEL','ROCK','ROCKLEG','ROCKTYPES','LIMITS','STARTPOINTS','LATSPEED','LONGSPEED','TRAJ','LATI','LONGI','GRIDSIZEX','GRIDSIZEY','DEPOSIT');
    


