
function [theta2, theta3] = position_analysis_byth1(theta1,l1,l2,l3,l4,upbranch)
%compute theta2 and theta3, given theta1.
%the frame is considered to be horizontal; in case of a different
%orientation, the angle of the the frame must be added to all the angles
%the boolean upbranch allow to set the considered assembly configuration

%INPUT
%theta1=  angle of member 1 wrt the x direction of the of the ground reference system
%l1= Lenght of member 1 1 O-A
%l2= Lenght of member 1 A-B
%l3= Lenght of member 1 Q-B
%l4= Lenght of member 1 O-Q

%OUTPUT
%theta2=  angle of member 2 wrt the x direction of the of the ground reference system
%theta3=  angle of member 3 wrt the x direction of the of the ground reference system

theta1=theta1*pi/180;

a=sin(theta1);
b=cos(theta1)-l4/l1;
c=(l4^2+l1^2-l2^2+l3^2)/(2*l1*l3)-l4*cos(theta1)/l3;

if upbranch == true
    t3=(a-sqrt(a^2+b^2-c^2))/(b+c);
else
    t3=(a+sqrt(a^2+b^2-c^2))/(b+c);
end
theta3=2*atan(t3);
if(imag(t3) == 0)
    cos2=(l4-l1*cos(theta1)+l3*cos(theta3))/l2;
    sin2=(-l1*sin(theta1)+l3*sin(theta3))/l2;
    theta2=atan2(sin2,cos2);
    
    theta3 = theta3*180/pi;
    theta2 = theta2*180/pi;
else
    theta3 = NaN;
    theta2 = NaN;
end

end