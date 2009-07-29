function inside=isinside(x,y)
%function inside=isinside(x,y)
%returns 1 if the point (x,y) is inside the velocity grid
%return 0 if the point is outside
%should be called only after grid has been transformed using setupgrids
global XCOORD;global YCOORD;global GRIDSIZEX;global GRIDSIZEY;
inside = (x>=XCOORD(1,1) & x<=XCOORD(1,GRIDSIZEX) & y>=YCOORD(1,1) & y<=YCOORD(GRIDSIZEY,1));