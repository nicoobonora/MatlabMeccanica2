
function [theta1, theta2] = position_analysis_byth3(theta3,l1,l2,l3,l4,upbranch)
%compute theta2 and theta3, given theta1.
%the frame is considered to be horizontal; in case of a different
%orientation, the angle of the the frame must be added to all the angles

%INPUT
%theta1=  angolo membro 1 rispetto alla direzione X del SDR fisso
%l1= lunghezza membro 1 O-A
%l2= lunghezza membro 2 A-B
%l3= lunghezza membro 3 Q-B
%l4= lunghezza membro 4 O-Q


theta3=theta3*pi/180;

a=sin(theta3);
b=cos(theta3)+l4/l3;
c=(l4^2+l3^2+l1^2-l2^2)/(2*l1*l3)+l4*cos(theta3)/l1;

if upbranch == true
    t1=(a-sqrt(a^2+b^2-c^2))/(b+c);
else
    t1=(a+sqrt(a^2+b^2-c^2))/(b+c);
end
theta1=2*atan(t1);
if(imag(t1) == 0)
    cos2=(l4+l3*cos(theta3)-l1*cos(theta1))/l2;
    sin2=(+l3*sin(theta3)-l1*sin(theta1))/l2;
    theta2=atan2(sin2,cos2);
    
    theta1 = theta1*180/pi;
    theta2 = theta2*180/pi;
else
    theta1 = NaN;
    theta2 = NaN
end

end