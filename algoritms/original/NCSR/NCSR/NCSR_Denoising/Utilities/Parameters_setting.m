function  par  =  Parameters_setting( nSig )
par.method    =   1;
par.nSig      =   nSig;
par.iters     =   1;
par.eps       =   1e-8;
par.cls_num   =   70;  

if nSig<=30
    par.c1        =   0.64;         % 0.57
else    
    par.c1        =   0.64;     
end
par.lamada        =   0.23;  % 0.36
par.hh            =   12;

if nSig <= 10
    par.c1        =   0.56;   
    par.lamada    =   0.22;
    
    par.sigma     =   1.7;  
    par.win       =   6;
    par.nblk      =   13;           
    par.hp        =   75;
    par.K         =   3;
    par.m_num     =   240;
elseif nSig<=15
    par.c1        =   0.59;   
    par.lamada    =   0.22;
    
    par.sigma     =   1.8;
    par.win       =   6;
    par.nblk      =   13;           
    par.hp        =   75;
    par.K         =   3;
    par.m_num     =   240;    
elseif nSig <=30
    par.sigma     =   2.0;
    par.win       =   7;
    par.nblk      =   16;
    par.hp        =   80;       %  80
    par.K         =   3;
    par.m_num     =   250;
elseif nSig<=50
    par.c1        =   0.64;    
    
    par.sigma     =   2.4;
    par.win       =   9;
    par.nblk      =   18;
    par.hp        =   90;
    par.K         =   4;
    par.m_num     =   300;
    par.lamada    =   0.26;    
else
    par.sigma     =   2.4;
    par.win       =   8;
    par.nblk      =   20;
    par.hp        =   95;
    par.K         =   4;
    par.m_num     =   300;
    par.lamada    =   0.26;
end

