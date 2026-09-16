% Restituisce y' a seconda della legge di moto scelta (y' = derivata
% rispetto a theta)

% para -> moto parabolico
% poli -> polinomiale di quinto grado
% ci -> cicloidale

function dy = select_derivative_function(choice, H, theta_deg, beta_deg)

u = theta_deg / beta_deg;
beta_rad = deg2rad(beta_deg);

switch choice
    case "para"
        if u <= 0.5
            dy = 4*H*u / beta_rad;
        else
            dy = 4*H*(1-u) / beta_rad;
        end

    case "poli"
        dy = H/beta_rad * ...
            (30*u^2 - 60*u^3 + 30*u^4);

    case "ci"
        dy = H/beta_rad * ...
            (1 - cos(2*pi*u));
end

end