function g = SigmaNoisy(Reference,Target,Clean)

%ASSUMES THAT TARGET IMAGE IS NOT REFERENCE IMAGE OR CLEAN IMAGE

sumcn=0;

[m1,n1] = size(Reference);
[m2,n2] = size(Target);
[m3,n3] = size(Clean);

r=[m1;m2;m3;];
c=[n1/3;n2/3;n3/3;];

rows=min(r);
cols=min(c);
for i=1:3

    x1=(Reference(1:rows,1:cols,i));
    y=(Target(1:rows,1:cols,i));
    x2=(Clean(1:rows,1:cols,i));
       
    avg = (x1 + x2)/2;
    diffNoisy=y-avg;
    diffFull=x1-x2;
    
    varx1 = var(diffFull(:))/4;
    
    %The sigma values of Target image RGB channels
    vary= max(var(diffNoisy(:)) - varx1,0);
    
    g(:,i) = sqrt(vary);
    sumcn= sumcn+vary;         
         
end
sigmaNoisy = sqrt(sumcn/3);

g(:,4)=sigmaNoisy;
