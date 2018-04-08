function g = Sigma(Reference,Target)

%ASSUMES THAT TARGET IMAGE IS NOT REFERENCE IMAGE OR CLEAN IMAGE

sumcn=0;

[m1,n1] = size(Reference);
[m2,n2] = size(Target);

r=[m1;m2];
c=[n1/3;n2/3];

rows=min(r);
cols=min(c);
for i=1:3

    x1=(Reference(1:rows,1:cols,i));
    y=(Target(1:rows,1:cols,i));

    diff=y-x1;
    
    vary = var(diff(:));
        
    g(:,i) = sqrt(vary);
    sumcn= sumcn+vary;         
         
end
sigmaNoisy = sqrt(sumcn/3);

g(:,4)=sigmaNoisy;
