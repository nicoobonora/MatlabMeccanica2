% Genera N angoli random
function angles = generate_random_angles(N)
    angles = zeros(1, N);
    for i=1:N
        angles(i) = rand() * 2 * pi;
    end
end