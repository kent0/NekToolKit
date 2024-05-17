% Parameters

Jfac = 4; % 2 ok for 'smooth' functions
cname='case';
cname='/Users/kaneko/Developer/NekROM/examples/cyl/snaps/cyl';
isnaps=100:101;

ifbin=true;

base='../../';
base='';

tgt='frames/';
mkdir(tgt);

if ifbin
    fnames=arrayfun(@(x) sprintf([cname,'0.f%05d'],x),isnaps,'UniformOutput',false);
else
    fnames=arrayfun(@(x) sprintf([cname,'.fld%02d'],x),isnaps,'UniformOutput',false);
end

x=[];
y=[];
xo=[];
yo=[];

nsnaps=length(isnaps);
for i = 1:nsnaps
    while ~exist(fnames{min(i+1,nsnaps)}, 'file'); pause(0.1); end
    if i == nsnaps; pause(2); end
    tic

    data = fld_reader([base,fnames{i}],ifbin);
    fprintf('istep %f, time: %f\n', data.istep, data.time);

%   if isfield(data, 't'), f = data.t; end
    if isfield(data, 'u'), f = data.p; end

    if isfield(data,'x')
        if isempty(xo) || max(abs(data.x(:)-xo(:))) / max(abs(data.x(:))) + max(abs(data.y(:)-yo(:))) / max(abs(data.y(:))) > 1e-10
            if Jfac == 0
                J = [];
                x = data.x;
                y = data.y;
                xo = x;
                yo = y;
            else
                lx1 = size(data.x,1);
                [zi, w] = zwgll(lx1-1);
                zo = linspace(-1, 1, ceil(lx1*Jfac));
                J = interp_mat(zo, zi);

                xo=data.x;
                yo=data.y;

                x = interp_2d(xo, J);
                y = interp_2d(yo, J);
            end
        end
    end

    if ~isempty(J)
        f = interp_2d(f, J);
    end

    if isempty(x)
        disp('ERROR: Missing x,y data, exiting...');
        return
    end
    toc

    tic
%   patch_plot(x, y, f, sprintf([tgt,'f_%04d.png'], i),true,true);
    patch_plot(x, y, f)
    toc
%   patch_plot(x, y, f)
end
