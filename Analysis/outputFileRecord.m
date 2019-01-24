function outputFileRecord(x, y, totalIterations, glob, depos)

    fname = sprintf('modelOutput/vertSect%d_%d.dat',x,y);
    sectOut = fopen(fname, 'w');
    fname = 'modelOutput/supplyHistory.dat';
    supplyOut = fopen(fname, 'w');

    t = 2:totalIterations;
    fprintf(sectOut,'%5.4f 1\n', depos.transThickness(y,x,t)); % Write thickness data output, assuming all facies 1, in strataWorkbench format
    fprintf(supplyOut,'%5.4f 1\n', glob.supplyHistory(t)); % Write sediment supply history output, assuming all facies 1, in strataWorkbench format
    
    fclose(sectOut);
    fclose(supplyOut);
end