function [xr,yr,xs,ys,rx,ry,sx,sy,jac,jaci] = deriv_geo(x,y,xref);
d = deriv_mat(xref);

xr = t2d(d,x,[]);
yr = t2d(d,y,[]);
xs = t2d([],x,d');
ys = t2d([],y,d');

rx = ys*1;
ry = -xs;
sx = -yr;
sy = xr*1;

jac = xr.*ys - xs.*yr; % redundant but ok
jaci = 1./jac;
