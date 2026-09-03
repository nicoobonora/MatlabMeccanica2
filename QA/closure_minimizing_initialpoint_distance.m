
function out = closure_minimizing_initialpoint_distance (theta1,l1,l2,l3,l4,Origin,frame_angle,Lp,tp,P,upbranch)

%INPUT
%INPUT
%theta1=  angolo membro 1 rispetto alla direzione X del SDR fisso
%l1= lunghezza membro 1 O-A
%l2= lunghezza membro 2 A-B
%l3= lunghezza membro 3 Q-B
%l4= lunghezza membro 4 O-Q

[theta2, theta3] = position_analysis_byth1(theta1,l1,l2,l3,l4,upbranch);

P_biella(1) = Origin(1)+l1*cosd(theta1+frame_angle)+Lp*cosd(theta2+frame_angle+tp);
P_biella(2) = Origin(2)+l1*sind(theta1+frame_angle)+Lp*sind(theta2+frame_angle+tp);

out = norm(P_biella-P);

end