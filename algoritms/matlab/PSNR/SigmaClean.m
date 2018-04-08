function g = SigmaClean(Reference,Clean)

sumcf=0;

[m1,n1] = size(Reference);
[m2,n2] = size(Clean);

r=[m1;m2;];
c=[n1/3;n2/3;];

rows=min(r);
cols=min(c);
for i=1:3

    x1=(Reference(1:rows,1:cols,i));
    x2=(Clean(1:rows,1:cols,i));

    diffFull=x1-x2;
    
    varx1 = var(diffFull(:))/2;
    
    %The sigma values of Target image RGB channels
   
    g(:,i) = sqrt(varx1);
    sumcf= sumcf+varx1;

                  
end

sigmaClean= sqrt(sumcf/3);

g(:,4) = sigmaClean;
