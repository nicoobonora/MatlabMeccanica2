
function [theta1, theta3] = position_analysis_byth2(theta2,l1,l2,l3,l4,upbranch)
%compute theta2 and theta3, given theta1.
%the frame is considered to be horizontal; in case of a different
%orientation, the angle of the the frame must be added to all the angles

%INPUT
%theta2=  angolo membro 1 rispetto alla direzione X del SDR fisso
%l1= lunghezza membro 1 O-A
%l2= lunghezza membro 2 A-B
%l3= lunghezza membro 3 Q-B
%l4= lunghezza membro 4 O-Q

theta2=theta2*pi/180;


a=sin(theta2);
b=cos(theta2)-l4/l2;
c=(l4^2+l2^2-l1^2+l3^2)/(2*l2*l3)-l4*cos(theta2)/l3;
if upbranch == true
    t3=(a-sqrt(a^2+b^2-c^2))/(b+c);
else
    t3=(a+sqrt(a^2+b^2-c^2))/(b+c);
end
theta3=2*atan(t3);

if(imag(t3) == 0)
    cos2=(l4-l2*cos(theta2)+l3*cos(theta3))/l1;
    sin2=(-l2*sin(theta2)+l3*sin(theta3))/l1;
    theta1=atan2(sin2,cos2);

    theta3 = theta3*180/pi;
    theta1 = theta1*180/pi;
else
    theta1 = NaN;
    theta3 = NaN;
end


end