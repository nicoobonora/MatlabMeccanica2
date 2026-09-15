function show_comparison(QA_3, QA_5, QA_7, QA_9, F3, F5, F7, F9, exitflag_3, exitflag_5, exitflag_7, exitflag_9, time_3, time_5, time_7, time_9)

    nomi = ["3 punti"; "5 punti"; "7 punti"; "9 punti"];

    geometrie = [
        QA_3(1:9)
        QA_5(1:9)
        QA_7(1:9)
        QA_9(1:9)
    ];

    risultati = array2table(geometrie, ...
        "VariableNames", ...
        ["xa","ya","xd","yd","L1","L2","L3","Lp","tk"]);
    
    risultati.Caso = nomi;
    risultati = movevars(risultati, "Caso", "Before", 1);
    
    risultati.Residuo = [
        norm(F3,inf)
        norm(F5,inf)
        norm(F7,inf)
        norm(F9,inf)
    ];
    
    risultati.Exitflag = [
        exitflag_3
        exitflag_5
        exitflag_7
        exitflag_9
    ];
    
    risultati.Tempo = [
        time_3
        time_5
        time_7
        time_9
    ];
    disp(risultati);

end