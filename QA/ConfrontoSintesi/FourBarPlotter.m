function FourBarPlotter(A,D,B,C)
figure;hold('on');grid('on');axis('equal');
plot([A(1),D(1)],[A(2),D(2)],'r-','LineWidth',2.5);
X1=[A(1),B(1,1),C(1,1),D(1)];
Y1=[A(2),B(2,1),C(2,1),D(2)];
plot(X1,Y1,'c-o','LineWidth',2,'MarkerSize',6,'MarkerFaceColor','c');
X2=[A(1),B(1,2),C(1,2),D(1)];
Y2=[A(2),B(2,2),C(2,2),D(2)];
plot(X2,Y2,'b--o','LineWidth',1.5);
X3=[A(1),B(1,3),C(1,3),D(1)];
Y3=[A(2),B(2,3),C(2,3),D(2)];
plot(X3,Y3,'g-.o','LineWidth',1.5);
text(A(1),A(2)-0.3,'A','HorizontalAlignment','center','FontWeight','bold');
text(D(1),D(2)-0.3,'D','HorizontalAlignment','center','FontWeight','bold');
text(B(1,1),B(2,1)+0.3,'B','HorizontalAlignment','center');
text(C(1,1),C(2,1)+0.3,'C','HorizontalAlignment','center');
title('SintesiCinematica');xlabel('x');ylabel('y');legend('AD(Telaio)','Posa1','Posa2','Posa3');
end