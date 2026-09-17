% Dato theta1 restituisce i corrispettivi angoli theta2 e theta3

function [theta2, theta3] = position_analysis_byth1(theta1, L1, L2, L3, L4, positive)

% Si isola theta2, si elevano entrambe le eq. di chiusura al quadrato, si
% sommano e si ottiene Asin(theta3) + Bcos(theta3) = C (Vedi slide 245 Meccanica 1)
b1 = L4 - L1 * cos(theta1);
b2 = -L1 * sin(theta1);
A = -2 * b1 * L3;
B = -2 * b2 * L3;
C = L2^2 - b1^2 - b2^2 -L3^2;

% Esplicitando, cos(theta3) = (C - A*sen(theta3)) / B
% Esplicitando, sin(theta3) = (C - B*sen(theta3)) / A
% Sappiamo inoltre (eq. canonica circonferenza) che sin(theta3)^2 +
% cos(theta3)^2 = 1 -> Sostituiamo cos(theta3) in questa
% sin(theta3)^2 + (C^2 + A^2*sen(theta3)^2 - 2*A*C*sin(theta3))/(B^2) = 1

% se sin(theta1) = 0 viene prodotto un NaN (B=0), per cui in tal caso
% isoliamo A

if(sin(theta1) < 0.001) % Caso B = 0 (approssimato a B<0.001 in quanto per B troppo piccoli dava problemi)
    K1 = (A^2+B^2)/(A^2);
    K2 = -(2*B*C)/(A^2);
    K3 = (C^2-A^2)/(A^2);

    delta = K2^2 - 4*K1*K3;

    if positive
        cos_theta3 = (-K2 + sqrt(delta))/(2*K1);
        sin_theta3 = sqrt(1 - cos_theta3^2);
    else
        cos_theta3 = (-K2 - sqrt(delta))/(2*K1);
        sin_theta3 = -sqrt(1 - cos_theta3^2);
    end

else % Caso B diverso da 0

    K1 = (A^2+B^2)/(B^2);
    K2 = -(2*A*C)/(B^2);
    K3 = (C^2-B^2)/(B^2);
    
    delta = K2^2 - 4*K1*K3;
    
    if positive
        sin_theta3 = (-K2 + sqrt(delta))/(2*K1);
        cos_theta3 = sqrt(1 - sin_theta3^2);
    else
        sin_theta3 = (-K2 - sqrt(delta))/(2*K1);
        cos_theta3 = -sqrt(1 - sin_theta3^2);
    end

end

% Con teta 3 risolviamo il sistema isolando teta 2
cos_theta2 = (b1 - L3*cos_theta3)/L2;
sin_theta2 = (b2 - L3*sin_theta3)/L2;

% Per risalire all'angolo da seno e coseno
theta2 = atan2(sin_theta2, cos_theta2);
theta3 = atan2(sin_theta3, cos_theta3);

end
