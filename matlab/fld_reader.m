function rdict = fld_reader(fname,ifbin)
    if nargin < 2; ifbin = true; end

    if ifbin
        rdict = bfld_reader(fname);
    else
        rdict = afld_reader(fname);
    end
end
