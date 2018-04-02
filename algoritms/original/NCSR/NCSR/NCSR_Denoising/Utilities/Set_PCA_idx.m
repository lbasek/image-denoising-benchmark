function  [PCA_idx, s_idx, seg]  =  Set_PCA_idx( im, par, codewords )

[h  w]     =  size(im);
cls_num    =  size( codewords, 2 );
LP_filter  =  fspecial('gaussian', 9, par.sigma);
lp_im      =  conv2( LP_filter, im );
lp_im      =  lp_im(4:h+3, 4:w+3);
hp_im      =  im - lp_im;


b       =  par.win;
s       =  par.step;
N       =  h-b+1;
M       =  w-b+1;

r       =  [1:s:N];
r       =  [r r(end)+1:N];
c       =  [1:s:M];
c       =  [c c(end)+1:M];
L       =  length(r)*length(c);
X       =  zeros(b*b, L, 'single');

% For the Y component
k    =  0;
for i  = 1:b
    for j  = 1:b
        k    =  k+1;
        blk  =  hp_im(r-1+i,c-1+j);
        X(k,:) =  blk(:)';
    end
end
PCA_idx   =  zeros(L, 1);

m     =  mean(X);
d     =  (X-repmat(m, size(X,1), 1)).^2;
v     =  sqrt( mean( d ) );

delta       =  sqrt(par.nSig^2+25);
[a, ind]    =  find( v<delta );

set         =  [1:L];
set(ind)    =  [];
L2          =  size(set,2);

for i = 1:L2
    
    wx            =   repmat( X(:,set(i)), 1, cls_num );
    dis           =   sum( (wx - codewords).^2 );        
    [md, idx]     =   min(dis);
    PCA_idx( set(i) )  =   idx;
    
end

[s_idx, seg] =   Proc_cls_idx( PCA_idx );
        