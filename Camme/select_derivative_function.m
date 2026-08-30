% Restituisce y' a seconda della legge di moto scelta (y' = derivata
% rispetto a theta)

% para -> moto parabolico
% poli -> polinomiale di quinto grado
% ci -> cicloidale

function derivative_function = select_derivative_function(choice, H, theta, betha)
    switch choice
        case "para"
            derivative_function = (4*H*theta) / (betha^2);
        case "poli"
            derivative_function = (H/betha) * (30*(theta/betha)^2 - 60*(theta/betha)^3 + 30*(theta/betha)^4);
        case "ci"
            derivative_function = (H/betha) * (1 - cos(2*pi*theta/betha));
        % Para di default
        otherwise
            derivative_function = (4*H*theta) / (betha^2);
    end
end