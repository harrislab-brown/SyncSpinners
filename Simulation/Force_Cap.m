function f = Force_Cap(rij,lc,Bo)
    f = besselk(1,rij ./ lc);

   