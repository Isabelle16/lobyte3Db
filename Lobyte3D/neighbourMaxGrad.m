function [maxGrad, index, nbrGrads] = neighbourMaxGrad(glob, topog, i, j)

% Calculate gradients between i,j model cell and its eight neighbours 
% nbrGrads: gradient between cell(i,j) and east cell(i,j+1) and so on
% clockwise.

    nbrGrads = zeros(8,1);  
    nbrTopog = zeros(8,1);

        iPlus = i+1;
        iMinus = i-1;    
        jPlus = j+1;
        jMinus = j-1;

        if iPlus > glob.ySize
            iPlus = i;
        end
        if iMinus < 1
            iMinus = i;
        end       
        if jPlus > glob.ySize
            jPlus = j;
        end
        if jMinus < 1
            jMinus = j;
        end

      
     nbrTopog = [topog(i,jPlus); topog(iPlus,jPlus); topog(iPlus,j); topog(iPlus,jMinus);...
            topog(i,jMinus); topog(iMinus,jMinus); topog(iMinus,j); topog(iMinus,jPlus)]; %from E-cell clockwise

     rook = 1:2:7;
     bish = 2:2:8;

     nbrGrads(rook) = (nbrTopog(rook) - topog(i,j))/glob.dx;
     
     checkProcess=strcmp(glob.fun,'kinetic');
     if checkProcess==1
      nbrGrads(bish) = (nbrTopog(bish) - topog(i,j))/glob.dx; 
     else  
      nbrGrads(bish) = (nbrTopog(bish) - topog(i,j))/(sqrt(2)*glob.dx); 
     end
     
         
     nbrGrads = atan(nbrGrads)/pi*2;  % negative gradients indicate outflow 

    [maxGrad, index] = min(nbrGrads(nbrGrads ~= 0));
    
    if isempty(find(nbrGrads, 1)) == false
    
    index = find (nbrGrads==maxGrad);
    
    else
        
        index = glob.dir;
        maxGrad = 0;
        
    end
    
    
    
  
end