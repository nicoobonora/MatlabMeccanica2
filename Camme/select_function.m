% para -> moto parabolico
% poli -> polinomiale di quinto grado
% ci -> cicloidale
% theta e betha in gradi, come nelle chiamate del profilo camma.

function chosen_function = select_function(choice, H, theta, betha)
    u = theta/betha;
    switch choice
        case "para"
            if u <= 0.5
                chosen_function = 2*H*u^2;
            else
                chosen_function = H*(1 - 2*(1-u)^2);
            end
        case "poli"
            chosen_function = H*(10*u^3 - 15*u^4 + 6*u^5);
        case "ci"
            chosen_function = H*(u - sin(2*pi*u)/(2*pi));
        % Para di default
        otherwise
            if u <= 0.5
                chosen_function = 2*H*u^2;
            else
                chosen_function = H*(1 - 2*(1-u)^2);
            end
    end
end
