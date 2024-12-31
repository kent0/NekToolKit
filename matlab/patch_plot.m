function patch_plot(x, y, z, filename, varargin)
    if nargin < 4; filename = []; end

    drawax = true;
    ptitle = '';

    ecolor = 'k';

    cmap = 'jet';
    plot_type='surface';
    cpos=[];
    ctgt=[];
    cvec=[];

    for k = 1:2:length(varargin)
        if strcmp(varargin{k}, 'EdgeColor')
            ecolor = varargin{k+1};
        elseif strcmp(varargin{k}, 'Annotations')
            drawax = varargin{k+1};
        elseif strcmp(varargin{k}, 'ColorMap')
            cmap = varargin{k+1};
        elseif strcmp(varargin{k}, 'Title')
            ptitle = varargin{k+1};
        elseif strcmp(varargin{k}, 'CameraPosition')
            cpos = varargin{k+1};
        elseif strcmp(varargin{k}, 'CameraTarget')
            ctgt = varargin{k+1};
        elseif strcmp(varargin{k}, 'CameraVector')
            cvec = varargin{k+1};
        elseif strcmp(varargin{k}, 'PlotType')
            plot_type= varargin{k+1};
        end
    end

    zmin = min(z(:));
    zmax = max(z(:));
    xmin = min(x(:));
    xmax = max(x(:));
    ymin = min(y(:));
    ymax = max(y(:));

    lx=xmax-xmin;
    ly=ymax-ymin;
    
    if ~isempty(filename)
        h1 = figure();
        set(h1, 'Visible', 'off');
    else
        clf
    end
    hold off

    a1=0;
    a2=0;
    interval=5;
    start=interval;
    stop=100 - interval;
    level_weights = [start:interval:stop]/100;
    levels = (1-level_weights)*zmin + level_weights*zmax;
    for i = 1:size(z, 3)
        if strcmp(plot_type, 'surface')
            surface(x(:,:,i), y(:,:,i), z(:,:,i),'FaceColor','interp','EdgeColor','none'); hold on
        elseif strcmp(plot_type, 'contour')
            contour(x(:,:,i), y(:,:,i), z(:,:,i),levels); hold on
        else
            error('Unrecognized plot type');
        end;
    end

    colormap(cmap);
    cb=colorbar;
    try
        cb.TickLabelInterpreter = 'latex';
    catch 
        warning('colorbar is not an object in Octave');
    end;

    if ~strcmp(ecolor, '')
        zconst = zeros(size(x,1),1)+zmax+(zmax-zmin)*0.01;
        nx = size(x, 1);
        ny = size(x, 2);
        index = [1:nx-1,(1:ny)*nx,(ny-1)*nx+(nx-1:-1:1),1+(ny-2:-1:0)*nx];
        for i = 1:size(z, 3)
            xx=reshape(x(:,:,i),nx*ny,1);
            yy=reshape(y(:,:,i),nx*ny,1);
            zz=reshape(z(:,:,i),nx*ny,1);
            plot3(xx(index),yy(index),zz(index),ecolor, 'LineWidth', 1); hold on
%           plot3(x(1,:,i), y(1,:,i), zconst,ecolor, 'LineWidth', 1); hold on
%           plot3(x(end,:,i), y(end,:,i), zconst,ecolor, 'LineWidth', 1); hold on
%           plot3(x(:,1,i), y(:,1,i), zconst,ecolor, 'LineWidth', 1); hold on
%           plot3(x(:,end,i), y(:,end,i), zconst,ecolor, 'LineWidth', 1); hold on
        end
    end

%   if ~isempty(xo) && ~isempty(yo)
%       zconst=xo*0+zmax+(zmax-zmin)*0.02;
%       scatter3(xo(:), yo(:), zconst(:), 0.3, 'k.');
%   end

    if drawax
        margin=0.1;
        xlim([xmin-margin*lx, xmax+margin*lx]);
        ylim([ymin-margin*ly, ymax+margin*ly]);
        axis equal;
    else
        axis off;
    end

    if ~isempty(ptitle)
        title(ptitle);
    end

    if ~isempty(cpos) && ~isempty(ctgt) && ~isempty(cvec)
        ax=gca;
        ax.CameraPosition=cpos;
        ax.CameraTarget=ctgt;
        ax.CameraUpVector=cvec;
    end

    if ~isempty(filename)
        exportgraphics(gcf, filename, 'Resolution', 300);
    else
        drawnow()
%       figure(gcf);
    end
end
