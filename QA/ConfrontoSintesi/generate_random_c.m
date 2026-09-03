% Creiamo tre lati a caso equidistanti

function C = generate_random_c(B, L)


theta_0 = 0;
theta_1 = 0;
theta_2 = 0;

% Misura di sicurezza per evitare che esca lo stesso identico angolo e
% quindi la circonferenza collassi in un punto
while isequal(theta_0, theta_1, theta_2)
    theta_0 = rand() * 2 * pi; 
    theta_1 = rand() * 2 * pi; 
    theta_2 = rand() * 2 * pi;
end

C_1 = B(1) + L * [cos(theta_0); sin(theta_0)];
C_2 = B(2) + L * [cos(theta_1); sin(theta_1)];
C_3 = B(3) + L * [cos(theta_2); sin(theta_2)];

C = [C_1, C_2, C_3];

end