% Data la velocità angolare in ingresso th_dot1 restituisce la velocità
% degli altri due membri

function [th_dot2, th_dot3] = velocity_analysis_by_th1(th_dot1, theta1, theta2, theta3, L1, L2, L3)

if(theta2 == theta3)
    disp("Singolarità!")
elseif(theta2 == theta1)
    disp("Punto morto!")
end

% Sfruttiamo le formule gia risolte (pagina 252 Meccanica 1)
th_dot2 = th_dot1 * (L1*sin(theta1 - theta3))/(L2*sin(theta3 - theta2));
th_dot3 = th_dot1 * (L1*sin(theta1 - theta2))/(L3*sin(theta3 - theta2));

end