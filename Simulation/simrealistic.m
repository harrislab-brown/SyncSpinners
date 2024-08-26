figure(2)
clump = 1;

colors = viridis(5);
yt = 1.5
s1 = colors(2,:);
s2 = colors(4,:);

points1 = constructspinnerskel(n,1);

x1 = points1(1,1);
x2 = points1(1,9);

y1 = points1(2,1);
y2 = points1(2,9);

ds = sqrt( (x2-x1).^2 + (y2-y1).^2);



R_fun = @(theta) ([cos(theta) -sin(theta); sin(theta) cos(theta)]);
for jj = 1:25:min(length(th(:,1)),1000)
     R_fun = @(theta) ([cos(theta) -sin(theta); sin(theta) cos(theta)]);
     origin = [0;0];

     xs = [];
     ys = [];
     thq = [];

     xs2 = [];
     ys2 = [];
     for pp = 1:size(loc,2)
    theta = th(jj,2*pp-1);


    points1 = constructspinnerskel(n,1);
    points1 = R_fun(theta)*points1;
    points1_xy = points1 + clump*loc(:,pp);
    xs = [xs points1_xy(1,:)];
    ys = [ys points1_xy(2,:)];

    points2 = constructspinnerskel(n,1);
    points2 = R_fun(theta)*points2;
    points2_xy = points2 + clump*loc(:,pp);
    xs2 = [xs2 points2_xy(1,:)];
    ys2 = [ys2 points2_xy(2,:)];


    end
    
    axis equal
    x1s = xs(1:npoints);
    y1s = ys(1:npoints);
    x2s = xs(npoints+1:end);
    y2s = ys(npoints+1:end);

    if omegaset(1) > 0
        %P1 = polyshape(x1s, y1s,'SolidBoundaryOrientation','cw');
    else
        %P1 = polyshape(x1s, y1s,'SolidBoundaryOrientation','ccw');
    end

    if omegaset(2) > 0
        %P2 = polyshape(x2s, y2s,'SolidBoundaryOrientation','cw');
    else
        %P2 = polyshape(x2s, y2s,'SolidBoundaryOrientation','ccw');
    end

    %plot(P1,'FaceColor',s1,'FaceAlpha',0.5,'EdgeColor',s1)   
    %plot(P2,'FaceColor',s2,'FaceAlpha',0.5,'EdgeColor',s2)

    scatter(xs2,ys2,50,'MarkerFaceColor','k','MarkerEdgeColor','k')
    hold on

    hold off
    axis equal  
    box on
    set(gca,'linewidth',3.0)
    set(gca,'Color','w')

    set(gca, 'FontName', 'Times New Roman', 'FontSize', 20)
    xlabel('$$x$$ (mm)', 'Interpreter', 'Latex', 'FontSize', 20)
    ylabel('$$y$$ (mm)', 'Interpreter', 'Latex', 'FontSize', 20)
    ylim([-l-0.1,l+0.1])
          set(gcf,'color','w');
    if clump == 0
        xlim([-dist-2*l,dist+2*l])
    else
        xlim([-0-yt*l,dist+yt*l])
       ylim([-yt*l,yt*l])
    end
    drawnow()
   %frame = getframe(gcf); %get frame
   %writeVideo(myVideo, frame);
end
%close(myVideo)

