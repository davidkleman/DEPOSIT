function loadtopo()
%function loadtopo()
%load SATBATH data into internal grid
globals;

latrng=[min([LATI(1,1) LATI(GRIDSIZEX,1) LATI(1,GRIDSIZEY) LATI(GRIDSIZEX,GRIDSIZEY)]) ...,
        max([LATI(1,1) LATI(GRIDSIZEX,1) LATI(1,GRIDSIZEY) LATI(GRIDSIZEX,GRIDSIZEY)])];
lonrng=[min([LONGI(1,1) LONGI(GRIDSIZEX,1) LONGI(1,GRIDSIZEY) LONGI(GRIDSIZEX,GRIDSIZEY)]) ...,
        max([LONGI(1,1) LONGI(GRIDSIZEX,1) LONGI(1,GRIDSIZEY) LONGI(GRIDSIZEX,GRIDSIZEY)])];
latrng(1)=latrng(1)-1;latrng(2)=latrng(2)+1;
lonrng(1)=lonrng(1)-1;lonrng(2)=lonrng(2)+1;


[topolat,topolon,TOPO]=satbath(5,latrng,lonrng);
topolon=topolon-360;
TOPO=griddata(topolat,topolon,TOPO,LATI,LONGI);
