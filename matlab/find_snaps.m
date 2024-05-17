function isnaps = find_snaps(cname,ftype);
    if nargin < 2
        ftype = 'BINARY';
    end

    if strcmp(ftype,'BINARY')
        searchPattern = fullfile('.',[cname,'0.f*']);
        files = dir(searchPattern);
        isnaps = arrayfun(@(x) str2double(x.name(end-4:end)), files);
    else
        searchPattern = fullfile('.',[cname,'.fld*']);
        plen = length([cname,'.fld']);
        files = dir(searchPattern);
        isnaps = arrayfun(@(x) str2double(x.name(plen+1:end)), files);
    end
    isnaps = sort(isnaps);
end
