function show_stats(n_punti, residuo, exit_flag, output)
    fprintf("\nCASO %d PUNTI\n", n_punti);
    fprintf("Residuo     = %.12e\n", residuo);
    fprintf("Exit flag   = %d\n", exit_flag);
    fprintf("Iterazioni  = %d\n", output.iterations);
    fprintf("Valutazioni = %d\n", output.funcCount);
    disp(output.message);
end