function [dudx,dudy] = grad(u,rx,ry,sx,sy,jaci,d,mode)

% computes derivative of u with respect to x and y

% mode 0: compute both dudx and dudy (default), 
% mode 1: compute only dudx,
% mode 2: compute only dudy.

if nargin==6; mode=0; end

[n1,n2,n3]=size(u);
ur=zeros(n1,n2);
us=zeros(n1,n2);
dt=d';

dudx=zeros(size(u));
dudy=[]; if mode == 0; dudy=zeros(size(u)); end

if mode == 0
    for ie=1:size(u,3)
        ur=d*u(:,:,ie);
        us=u(:,:,ie)*dt;
        dudx(:,:,ie)=jaci(:,:,ie).*(ur.*rx(:,:,ie)+us.*sx(:,:,ie));
        dudy(:,:,ie)=jaci(:,:,ie).*(ur.*ry(:,:,ie)+us.*sy(:,:,ie));
    end
end

if mode == 1
    for ie=1:size(u,3)
        ur=d*u(:,:,ie);
        us=u(:,:,ie)*dt;
        dudx(:,:,ie)=jaci(:,:,ie).*(ur.*rx(:,:,ie)+us.*sx(:,:,ie));
    end
end

if mode == 2
    for ie=1:size(u,3)
        ur=d*u(:,:,ie);
        us=u(:,:,ie)*dt;
        dudx(:,:,ie)=jaci(:,:,ie).*(ur.*ry(:,:,ie)+us.*sy(:,:,ie));
    end
end
