function rdict = afld_reader(fname)
    % Open the file
    file = fopen(fname, 'r');
    debug=false;
    
    % Read metadata line and split into components
    metadata_line = fgetl(file);
    metadata = strsplit(strtrim(metadata_line));
    
    % Extract metadata information
    nel = str2double(metadata{1});
    nx = str2double(metadata{2});
    ny = str2double(metadata{3});
    nz = str2double(metadata{4});
    time = str2double(metadata{5});
    istep = str2double(metadata{6});
    
    % Initialize flags
    ifx = false;
    ify = false;
    ifu = false;
    ifp = false;
    ift = false;
    
    % Dimensionality
    ndim = 2;
    
    % Count fields
    nfld = 0;
    for i = 7:length(metadata)
        switch metadata{i}
            case 'X'
                ifx = true;
                nfld = nfld + 1;
            case 'Y'
                ify = true;
                nfld = nfld + 1;
            case 'U'
                ifu = true;
                nfld = nfld + ndim;
            case 'P'
                ifp = true;
                nfld = nfld + 1;
            case 'T'
                ift = true;
                nfld = nfld + 1;
        end
    end
    
    % Display metadata
    if debug
        fprintf('nel: %d\n', nel);
        fprintf('nx: %d\n', nx);
        fprintf('ny: %d\n', ny);
        fprintf('nz: %d\n', nz);
        fprintf('time: %f\n', time);
        fprintf('istep: %d\n', istep);
        fprintf('ifx: %d\n', ifx);
        fprintf('ify: %d\n', ify);
        fprintf('ifu: %d\n', ifu);
        fprintf('ifp: %d\n', ifp);
    end
    
    % Initialize data array
    nxyz=nx*ny
    if ndim == 3; nxyz = nxyz*nz; end

    data = zeros(nel*nxyz, nfld);
    
    % Skip lines
    nskip = floor(nel / 6);
    if mod(nel, 6) > 0
        nskip = nskip + 1;
    end
    
    for i = 1:nskip
        fgetl(file);
    end
    
    % Read data
%   for i = 1:(nel*nxyz)
%       line = fgetl(file);
%       % use fscanf instead of sscanf to read the entire file
%       data(i,:) = sscanf(line,'%f');
%   end
    data = fscanf(file, '%f', [nel*nxyz, nfld]);
    
    % Close the file
    fclose(file);
    
    % Prepare output dictionary
    rdict = struct('time', time, 'istep', istep);
    i = 1;
    
    % Reshape and assign data
    shape = [nx, nx, nel];
    
    if ifx
        rdict.x = reshape(data(:, i), shape);
        i = i + 1;
    end
    
    if ify
        rdict.y = reshape(data(:, i), shape);
        i = i + 1;
    end
    
    if ifu
        rdict.u = reshape(data(:, i), shape);
        rdict.v = reshape(data(:, i+1), shape);
        i = i + ndim;
    end
    
    if ifp
        rdict.p = reshape(data(:, i), shape);
        i = i + 1;
    end
    
    if ift
        rdict.t = reshape(data(:, i), shape);
        i = i + 1;
    end
end
