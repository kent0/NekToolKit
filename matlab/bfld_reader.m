function rdict = bfld_reader(filename);
    rdict=struct();

    fileID = fopen(filename);
%   header = split(char(fread(fileID,[1,132],'char')));
    header = strsplit(char(fread(fileID,[1,132],'char')));

    std=header{1};
    wdsize=str2num(header{2});

    nx=str2num(header{3});
    ny=str2num(header{4});
    nz=str2num(header{5});

    nel=str2num(header{6});
    nelg=str2num(header{7});

    time=str2num(header{8});
    istep=str2num(header{9});
    cfld=header{12};

    ifxyz=sum('X'==cfld);
    ifu=sum('U'==cfld);
    ifp=sum('P'==cfld);
    ift=sum('T'==cfld);

    sind=find('S'==cfld);
    ifs=~isempty(sind);
    npsc=0;
    if ifs; npsc=str2num(cfld(sind+1:end)); end

    bytetest=fread(fileID,1,'float32');
    test_pattern=6.54321;
    eps=0.00020;
    etest=abs(bytetest-test_pattern);
    bytetest=true;

%   swapbytes(X)

    inde=fread(fileID,nelg,'int32');

    if nel ~= nelg
        disp('nel != nelg not supported, exiting...');
        return
    end

    if nz > 1
        disp('3D (nz > 1) not supported, exiting...');
        return
    end

    rdict=struct('time',time,'istep',istep,'nel',nelg,'ifxyz',ifxyz,'ifu',ifu,'ifp',ifp,'ift',ift,'npsc',npsc,'bytetest',bytetest,'inde',inde);

    ndim=2;
    nxyz=nx*ny*nz;

    ftype='float32';
    if wdsize == 8
        ftype='float64';
    end

    fldshape=[nx,ny,nel];

    if ifxyz
        xyz=reshape(fread(fileID,nelg*nxyz*ndim,ftype),nxyz,ndim,nel);
        rdict.x=reshape(xyz(:,1,:),fldshape);
        rdict.y=reshape(xyz(:,2,:),fldshape);
    end
    if ifu
        uvw=reshape(fread(fileID,nelg*nxyz*ndim,ftype),nxyz,ndim,nel);
        rdict.u=reshape(uvw(:,1,:),fldshape);
        rdict.v=reshape(uvw(:,2,:),fldshape);
    end
    if ifp
        p=fread(fileID,nel*nxyz,ftype);
        rdict.p=reshape(p,fldshape);
    end
    if ift
        t=fread(fileID,nel*nxyz,ftype);
        rdict.t=reshape(t,fldshape);
    end
    for i=1:npsc
        s=fread(fileID,nel*nxyz,ftype);
        rdict.(['s',num2str(i)])=reshape(s,fldshape);
%       rdict.('s01')=reshape(s,fldshape);
    end

    fclose(fileID);
end
