function output = MSE(Reference, Clean, Target)

mse_sum=0;

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
    
    err = immse(y, avg);

    mse_sum = mse_sum + err;
         
end

output = mse_sum/3;
