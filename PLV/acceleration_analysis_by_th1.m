function [th_ddot2, th_ddot3] = acceleration_analysis_by_th1(th_ddot1, th_dot1, th_dot2, th_dot3, theta1, theta2, theta3, L1,L2,L3,L4)

% Consideriamo il movente a velocità costante
% Pagina 263 Meccanica 1
% Ottenibile sempre riderivando le equazioni della velocità ed eliminando i
% termini che presentano una accelerazione di theta1 (presupposto a
% velocità costante e dunque ad accelerazione 0)

J = [-L2*sin(theta2), -L3*sin(theta3);
      L2*cos(theta2),  L3*cos(theta3)];

M = [L1*th_ddot1*sin(theta1) + L1*th_dot1^2*cos(theta1) + L2*th_dot2^2*cos(theta2) + L3*th_dot3^2*cos(theta3);
       -L1*th_ddot1*cos(theta1) + L1*th_dot1^2*sin(theta1) + L2*th_dot2^2*sin(theta2) + L3*th_dot3^2*sin(theta3)];

sol = J \ M;

th_ddot2 = sol(1);
th_ddot3 = sol(2);

end