%LLINTERSECT.M - determines if two finite line segments intersect
function [int,pi,si,ti] = llintersect(ls1p1,ls1p2,ls2p1,ls2p2);
% INPUT: ls1p1 = line segment 1 point 1 and so on
% OUTPUT: int = 0 if no intersect, 1 if intersect
%         pi = point of intersection
%         si = intersection coordinate for ls1. 0 if intersection is at p1,
%         1 if at p2..0.5 for midway between etc
%         ti = the same as si but for ls2.

u=ls1p2-ls1p1;
v=ls2p2-ls2p1;
w=ls1p1-ls2p1;
si=0;
ti=0;
pi=0;

D=perp(u,v);

if(abs(D) < 0.00000001) %test if parallel ..can still intersect (lying on top of each other)
    %but not interesting in this application..
    int = 0;
    return
end

si=perp(v,w) / D;
if( si < 0 | si > 1 )
    int=0;return;
end
ti=perp(u,w) / D;
if( ti <0 | ti > 1 )
    int=0;return;
end

pi=ls1p1+si*u;
int=1;
end

%perpendicular dot product
function p = perp(a,b)
p=a(1)*b(2)-a(2)*b(1);
end