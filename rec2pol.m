function [lat,long]= rec2pol(x,y)
%REC2POL [lat,long]= rec2pol(x,y)
%call settrig before using this function
%x,y can be matrices
global degprad,global rkmpdeg;
x=x*1e-7;
y=y*1e-7;
[m,n]=size(x);[p,q]=size(y);
if(m~=p | n~=q)error('x,y must have same size');
  end
lat=zeros(m,n);long=zeros(m,n);
for(i=1:m)
for(j=1:n)
if(x(i,j)==0)
 if(y(i,j)==0)
   theta=90.0
 else
   theta=270.0
end
else
  theta=degprad*atan(y(i,j)/x(i,j));
  if(x(i,j)<0)
    theta=180.0+theta;
  elseif(y(i,j)<0)
      theta=theta+360;
  elseif(theta>360)
    theta = theta-360;
end
end
R=sqrt(x(i,j)^2+y(i,j)^2);
lat(i,j)=90.0-R/rkmpdeg;
long(i,j)=theta;
end
end
