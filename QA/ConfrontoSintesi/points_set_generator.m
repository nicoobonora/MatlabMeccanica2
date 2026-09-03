% Genera 9 punti (9 coordinate x,y)
function set = points_set_generator()
    % Matrice random 9x2 con punti con x e y compresi tra 0 e 10
    set = rand(9, 2) * 10;
end