function [vx, vy, vmag] = getvelocity(x,y)
%getvelocity.m - [vx, vy, vmag] = getvelocity(x,y)
%interpolates velocity between grid points
%bilinear interpolation
global XCOORD;global YCOORD;global XVEL;global YVEL;
%vx=interp2(XCOORD,YCOORD,XVEL,x,y);
%vy=interp2(XCOORD,YCOORD,YVEL,x,y);
[vx,vy]=mylinear(XCOORD,YCOORD,XVEL,YVEL,x,y);

vmag=sqrt(vx.^2+vy.^2);
if(vmag~=0)
vx=vx./vmag;
vy=vy./vmag;
end

function [po,qo] = mylinear(XI,YI,P,Q,p,q)
%fast version of interp2 for 
%output functions(P,Q) with equal interpolation points (p,q)
%error checking is non-existant
    [nrows,ncols] = size(P);
    mx = numel(XI); my = numel(YI);

    s = 1 + (p-XI(1))/(XI(mx)-XI(1))*(ncols-1);
    t = 1 + (q-YI(1))/(YI(my)-YI(1))*(nrows-1);
  
    % Check for out of range values of s and set to 1
%    sout = find((s<1)|(s>ncols));
%    if length(sout)>0, s(sout) = ones(size(sout)); end

    % Check for out of range values of t and set to 1
%    tout = find((t<1)|(t>nrows));
%    if length(tout)>0, t(tout) = ones(size(tout)); end

    % Matrix element indexing
    ndx = floor(t)+floor(s-1)*nrows;
   
   if isempty(s), d = s; else d = find(s==ncols); end
    s(:) = (s - floor(s));
    if length(d)>0, s(d) = s(d)+1; ndx(d) = ndx(d)-nrows; end

    % Compute intepolation parameters, check for boundary value.
    if isempty(t), d = t; else d = find(t==nrows); end
    t(:) = (t - floor(t));
    if length(d)>0, t(d) = t(d)+1; ndx(d) = ndx(d)-1; end
    d = [];

    % Now interpolate, reuse u and v to save memory.
    po =  ( P(ndx).*(1-t) + P(ndx+1).*t ).*(1-s) + ...
           ( P(ndx+nrows).*(1-t) + P(ndx+(nrows+1)).*t ).*s;
   qo =  ( Q(ndx).*(1-t) + Q(ndx+1).*t ).*(1-s) + ...
           ( Q(ndx+nrows).*(1-t) + Q(ndx+(nrows+1)).*t ).*s;