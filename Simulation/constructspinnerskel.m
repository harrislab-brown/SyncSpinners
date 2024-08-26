function h1 = constructspinner(n,sign)

    R_fun = @(theta) ([cos(theta) -sin(theta); sin(theta) cos(theta)]);

    origin = [0;0];
    longarm = 5.7;
    th = 20*pi/180;
    lx = longarm.*cos(th);
    xx = linspace(0,lx,n);
    yy = tan(th).*abs(xx);

    %xx(end) = [];
    %yy(end) = [];

    %xx(1) = [];
    %yy(1) = [];

    newpoints = R_fun(-2.5*pi/180)*[xx ; yy] ;
    xx = newpoints(1,:);
    yy = newpoints(2,:);

    xs = xx - 1.622;
    ys = yy + 1.752/2;
    %ys = -ys;
    xs = -sign.*xs;

    %fp = [xs(1) ; ys(1)];
    wedge1 = [xs ; ys];
    wedge2 = R_fun(sign*4*pi/3)*wedge1;
    wedge3 = R_fun(sign*2*pi/3)*wedge1;

    h1 = [wedge1 wedge2 wedge3];

    %h1 = [wedge1];
    

   