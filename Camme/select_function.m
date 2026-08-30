% para -> moto parabolico
% poli -> polinomiale di quinto grado
% ci -> cicloidale

function chosen_function = select_function(choice, H, theta, betha)
    switch choice
        case "para"
            chosen_function = 2*H*(theta/betha)^2;
        case "poli"
            chosen_function = H*(10*(theta/betha)^3 - 15*(theta/betha)^4 + 6*(theta/betha)^5);
        case "ci"
            chosen_function = H*((theta/betha) - (1/(2*pi))*sin(2*pi*theta/betha));
        % Para di default
        otherwise
            chosen_function = 2*H*(theta/betha)^2;
    end
end