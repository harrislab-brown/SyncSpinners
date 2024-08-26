function f = Force_Ds(rij,kc,eps,beta,kjvec)
    f=0;
        for j = 1:4
            kj = kjvec(j);
       %Solving the height profile as derived in the theory for a point
       %source located at xp, yp
            f = f + real( kj.*(2/pi - StruveH1Y1(-kj.*kc.*rij) )./ ( 1+ (beta/3)/kj^2+ (4/3)*1i*eps/kj + (4/3)*eps^2*kj) ); 
        end
   