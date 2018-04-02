function  par  =  NCSR_Deblurring_Par( nSig, blur_type )
if blur_type==1
    if nSig<2        
        par.t1        =   0.21*nSig^2;
        par.c1        =   0.65*nSig^2;
    else
        par.t1        =   0.17*nSig^2;
        par.c1        =   0.5*nSig^2;
    end
else
    par.t1        =   0.13*nSig^2;
    par.c1        =   0.41*nSig^2;
end
par.nSig      =   nSig;                                % Std variance of Gassian noise
par.iters     =   120;
par.nblk      =   13;
par.sigma     =   1.6;    
par.eps       =   0.30;
par.method    =   1;
par.eps2      =   0.3;
