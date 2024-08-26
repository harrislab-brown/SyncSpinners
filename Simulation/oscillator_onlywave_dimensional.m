function dydt = oscillator_onlywave_dimensional(t,th,loc,kc,eps,beta,F_coeff,that,omegaset,I,kjvec,n,lc,Bo,F_coeff_cap)
%% Function to invoke a simple rotation about the COM.
R_fun = @(theta) ([cos(theta) -sin(theta); sin(theta) cos(theta)]);
%% Preallocation
npoints = size(constructspinnerskel(n,1),2);
xs = zeros(1,npoints*size(loc,2) );
ys = zeros(1,npoints*size(loc,2) );
xs_cent = zeros(1,npoints*size(loc,2) );
ys_cent = zeros(1,npoints*size(loc,2) );
%% Setting up each spinner
for pp = 1:size(loc,2)
    theta = th(2*pp-1);
    points1 = R_fun(theta)*constructspinnerskel(n,sign(omegaset(pp)));
    xs_cent( 1, (pp-1)*npoints+1 : (pp)*npoints ) = [points1(1,:)];
    ys_cent( 1, (pp-1)*npoints+1 : (pp)*npoints ) = [points1(2,:)];
    points1_xy = points1 + loc(:,pp);
    xs( 1, (pp-1)*npoints+1 : (pp)*npoints ) = [points1_xy(1,:)];
    ys( 1, (pp-1)*npoints+1 : (pp)*npoints ) = [points1_xy(2,:)];
end
xs_cent = xs_cent';
ys_cent = ys_cent';
xs =  xs';
ys =  ys';
Xs = ( xs' - xs );
Ys = ( ys' - ys );
Rs = ( Xs.^2 + Ys.^2).^(1/2);
%% Stopping Self-Interactions
Ones_Mat = ones(size(Rs));
%Make a block diagonal matrix that is a block of (1 1 ; 1 1) repeated
%n times if there are n disks/ellipses
A = ones(npoints,npoints);
Blocks = kron(eye(size(loc,2)),A);
%Now, we make the matrix which is one everywhere
%Except on the blocks where the self interaction occurs
Final_block = Ones_Mat - Blocks ; 
%Make the distance between self interacting terms super far away.
%This should kill the forces and avoid infintie blowups or something.
%we'll set forces on these blocks to zero in another line of code.
Rs( Final_block < 1) = 1e12 ;
%% Force and Torque Computations
Fmat = Force_Ds(Rs,kc,eps,beta,kjvec).*F_coeff + F_coeff_cap.*Force_Cap(Rs,lc,Bo);
Fmat( Final_block < 1) = 0;
Fx = Xs ./ Rs .*Fmat;
Fy = Ys ./ Rs .*Fmat;
%%Make a mass vector that is the number of point source which is num of
%%spinner * num of points sources per spinner
massvec = ones(npoints*size(loc,2),1);
Fxvec = Fx*massvec;
Fyvec = Fy*massvec;
taus = xs_cent.*Fyvec - ys_cent.*Fxvec;
tau_spin = reshape(taus,[length(xs_cent)/size(loc,2),size(loc,2)]);
tauspin = sum(tau_spin,1);
%% ODE Solving
dydt = zeros(2*size(loc,2),1);
for qq = 1:size(loc,2)
dydt(2*qq-1:2*qq,1) = [th(2*qq) ; 1/I.*(  ( omegaset(qq)-th(2*qq) ).*I/that  + tauspin(qq) ) ];
end