function [dudx,dudy] = grad(u,rx,ry,sx,sy,jaci,d,mode)

if nargin==6
    mode=0;
end

dudx=[];
dudy=[];

[n1,n2,n3]=size(u);
ur=zeros(n1,n2);
us=zeros(n1,n2);
dt=d';

if mode < 2;
    dudx=zeros(size(u));
end

if mode ~= 1;
    dudy=zeros(size(u));
end



if mode == 0
    for ie=1:size(u,3)
        ur=d*u(:,:,ie);
        us=u(:,:,ie)*dt;
        dudx(:,:,ie)=jaci(i,1)*rx(i)+jaci(i,2)*sx(i);
        dudy(:,:,ie)=jaci(i,1)*ry(i)+jaci(i,2)*sy(i);
    end
end
