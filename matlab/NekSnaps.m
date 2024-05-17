classdef NekSnaps < handle
    
    properties
        cname
        isnaps

        ifbin=true;
        flds={};
        index=1;
        pfun='x';
        verbose=true;

        % plot options
        colormap='jet';
        ecolor='k';     % Element Edge Color, set to '' to disable
        Jfac=4;         % interpolation factor (0 == no interpolation)
    end

    methods
        function obj = NekSnaps(cname, isnapsu)
            if nargin < 1
                if exist('SESSION.NAME','file')
                    fileID = fopen('SESSION.NAME');
                    cname = fgetl(fileID);
                    if obj.verbose
                        disp(['Found SESSION.NAME with case name: ',cname]);
                        disp(' ');
                    end
                else
                    disp('ERROR: SESSION.NAME not found, exiting...');
                    return
                end
            end

            ifbin=true;
            isnaps = find_snaps(cname);
            if isempty(isnaps)
                isnaps = find_snaps(cname,'ASCII');
                if isempty(isnaps)
                    disp('ERROR: No snapshots found, exiting...');
                    return
                end
                ifbin = false;
            end
            if nargin >= 2; isnaps = isnapsu; end

            obj.cname = cname;
            obj.isnaps = isnaps;
            obj.ifbin = ifbin;

            if obj.verbose
                if length(isnaps)>1
                    disp(['Found ',num2str(length(isnaps)),' snapshots:']);
                else
                    disp('Found 1 snapshot:');
                end
                f1=obj.fname(1);
                disp(f1{1});

                if length(isnaps)>2
                    f2=obj.fname(2);
                    disp(f2{1});
                end
                if length(isnaps)>1
                    disp('...');
                    f3=obj.fname(length(isnaps));
                    disp(f3{1});
                end
                disp(' ');
            end

            obj.load();
        end

        function f=fname(obj,index)
            if obj.ifbin
                f=arrayfun(@(x) sprintf([obj.cname,'0.f%05d'],obj.isnaps(x)),index,'UniformOutput',false);
            else
                f=arrayfun(@(x) sprintf([obj.cname,'.fld%02d'],obj.isnaps(x)),index,'UniformOutput',false);
            end
        end

        function load(obj)
            fnames = obj.fname(1:length(obj.isnaps));
            obj.flds = cell(length(obj.isnaps),1);
            for i = 1:length(fnames)
                obj.flds{i} = fld_reader(fnames{i},obj.ifbin);
            end
        end

        function show(obj,index,pfun)
            x=[];
            y=[];

            if nargin<3
                if ~isnumeric(index)
                    pfun=index;
                    index=obj.index;
                else
                    obj.index=index;
                    pfun=obj.pfun;
                end
            end
            fi=obj.fname(index);

            if index < 0
                index=find(obj.isnaps==-index);
            end

            if index < 1 || index > length(obj.isnaps)
                disp('ERROR: Index out of bounds, exiting...');
                return
            end

            disp(['Plotting ',fi{1}])
            disp(' ');

            ixyz=index;

            while isempty(x)
                if isfield(obj.flds{ixyz},'x')
                    x=obj.flds{ixyz}.x;
                    y=obj.flds{ixyz}.y;
                    nx1 = size(x,1);
                    [zi, w] = zwgll(nx1-1);

%                   [xr,yr,xs,ys,rx,ry,sx,sy,jac,jaci] = deriv_geo(x,y,zi);

                else
                    ixyz=ixyz-1;
                    if ixyz<1
                        disp('ERROR: No xyz data found, exiting...');
                        return
                    end
                end
            end

            J=[];
            if obj.Jfac == 0
                xJ = x;
                yJ = y;
            else
                zo = linspace(-1, 1, ceil(nx1*obj.Jfac));
                J = interp_mat(zo, zi);
                xJ = interp_2d(x, J);
                yJ = interp_2d(y, J);
            end

            ptitle='';

            if ischar(pfun)
                if strcmp(pfun,'x')
                    f = x;
                elseif strcmp(pfun,'y')
                    f = y;
                elseif strcmp(pfun,'umag')
                    f = sqrt(obj.flds{index}.u.^2 + obj.flds{index}.v.^2);
                else
                    f = obj.flds{index}.(pfun);
                end
                ptitle=[pfun,', '];
            else
                ftmp=obj.flds{index};
                ftmp.x=x;
                ftmp.y=y;
                f = pfun(ftmp);
                ptitle='User Function, ';
            end
            if isempty(J)
                fJ = f;
            else
                fJ = interp_2d(f, J); % for now interpolate field from 'coarse' grid
            end

            ptitle = [ptitle,sprintf('istep = %g, time = %g', obj.flds{index}.istep, obj.flds{index}.time)];

            ff=obj.fname(index);
            ptitle = [ptitle, ', ', ff{1}];

            ax = gca;
            cpos = ax.CameraPosition;
            ctgt = ax.CameraTarget;
            cvec = ax.CameraUpVector;

            patch_plot(xJ, yJ, fJ, [], 'ColorMap', obj.colormap, 'Title', ptitle, 'EdgeColor', obj.ecolor, 'CameraPosition', cpos, 'CameraTarget', ctgt, 'CameraUpVector', cvec);
            obj.index=index;
            obj.pfun=pfun;
        end

        function prev(obj,nskip,pfun)
            if nargin<2; nskip=1; end
            if nargin<3;
                if ~isnumeric(nskip)
                    pfun=nskip;
                    nskip=1;
                else
                    pfun=obj.pfun;
                end
            end

            if obj.index>nskip
                obj.show(obj.index-nskip,obj.pfun);
            else
                disp(['ERROR: Index (',num2str(obj.index-nskip),') out of bounds, exiting...']);
            end
        end

        function next(obj,nskip,pfun)
            if nargin<2; nskip=1; end
            if nargin<3;
                if ~isnumeric(nskip)
                    pfun=nskip;
                    nskip=1;
                else
                    pfun=obj.pfun;
                end
            end

            if obj.index<length(obj.isnaps)+1-nskip
                obj.show(obj.index+nskip,obj.pfun);
            else
                disp(['ERROR: Index (',num2str(obj.index+nskip),') out of bounds, exiting...']);
            end
        end

        function first(obj,pfun)
            if nargin<2; pfun=obj.pfun; end
            obj.show(1,pfun);
        end

        function last(obj,pfun)
            if nargin<2; pfun=obj.pfun; end
            obj.show(length(obj.isnaps),pfun);
        end
    end
end
