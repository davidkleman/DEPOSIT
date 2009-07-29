function map=getrockcolormap(white)
%function map=getrockcolormap(white)
%returns colormap for rocktypes 
%if white is true, white is added as the first color in the colormap;
map=[0.5020    1.0000         0; ...,
    1.0000         0         0; ...,
    0.1451    0.6784    0.1882; ...,
    1.0000    1.0000    0.5020; ...,
    0.5529    0.9451    0.9373; ...,
    0.9       0.6       0.8; ....,
    0.6       0.6       0.8; ...,
    0.3       0.3       0.9];
if(white)
   map=[1 1 1; map];
end
end