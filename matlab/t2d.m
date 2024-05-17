function LuR = t2d(L,u,R)
    [nl1, nl2] = size(L);
    [nr1, nr2] = size(R);
    [nu1,nu2,nu3]=size(u);

    if nl1 * nl2 == 0
        if nr1 * nr2 == 0;
            LuR = u;
        else
            LuR = pagemtimes(u,reshape(R,nr1,nr2,1));
        end
    elseif nr1 * nr2 == 0
        LuR = reshape(L*reshape(u,nu1,[]),nl1,nu2,nu3);
    else
        LuR = pagemtimes(reshape(L*reshape(u,nu1,[]),nl1,nu2,nu3),reshape(R,nr1,nr2,1));
    end
