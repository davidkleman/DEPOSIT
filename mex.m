function mex
fr=fzero(@bj0,[5,6])
[x,y]=meshgrid(-fr-1:0.1:fr+1,-fr-1:0.1:fr+1);
[z,c]=mexhat(x,y,fr);
colormap([1 1 1;0 0 0]);
mesh(z,c)

function y=bj0(x)
  y=besselj(0,x);
end

function [z,c] = mexhat(x,y,fr)
  z=zeros(size(x));
  c=ones(size(x));
  ind=find(sqrt(x.^2+y.^2)<fr);
  z(ind)=besselj(0,sqrt(x(ind).^2+y(ind).^2));
end
end