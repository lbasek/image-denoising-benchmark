function  [alpha, beta, Tau1]    =  Cal_Parameters( im, par, Dict, blk_arr, wei_arr )
[h w ch]   =   size(im);
A          =   Dict.D0;
PCA_idx    =   Dict.cls_idx;
s_idx      =   Dict.s_idx;
seg        =   Dict.seg;

b          =   par.win;
b2         =   b*b*ch;
k          =   0;
s          =   par.step;

N     =  h-b+1;
M     =  w-b+1;
L     =  N*M;
r     =  [1:s:N];
r     =  [r r(end)+1:N];
c     =  [1:s:M]; 
c     =  [c c(end)+1:M];
X     =  zeros(b*b,L,'single');
for i  = 1:b
    for j  = 1:b
        k    =  k+1;
        blk  =  im(i:h-b+i,j:w-b+j);
        blk  =  blk(:);
        X(k,:) =  blk';                 
    end
end

m_X       =   zeros(length(r)*length(c),b*b,'single');
X1        =   X';

for i = 1:par.nblk
   v            =   wei_arr(:,i);
   m_X(:,:)     =   m_X(:,:) + X1(blk_arr(:,i),:) .*v(:, ones(1,b2));
end
m_X          =   m_X';

N            =   length(r);
M            =   length(c);
L            =   N*M;
ind          =   zeros(N,M);
ind(r,c)     =   1;

X1           =   X(:, ind~=0);

alpha        =   zeros(b2, L, 'single' );
beta         =   zeros(b2, L, 'single' );
s0           =   zeros(b2, L, 'single' );

idx            =   s_idx(seg(1)+1:seg(2));
L0             =   length(idx);
alpha(:,idx)   =   A*X1(:,idx);
beta(:,idx)    =   A*m_X(:,idx);
for  k  =  1 : L0
    i           =   idx(k);
    a           =   A*( X(:, blk_arr(i, 1:par.nblk)) - repmat( m_X(:, i), 1, par.nblk ));
    s0(:,i)     =   mean(a.^2, 2);
end

for   i  = 2:length(seg)-1   
    idx            =   s_idx(seg(i)+1:seg(i+1));    
    cls            =   PCA_idx(idx(1));
    P              =   reshape(Dict.PCA_D(:, cls), b2, b2);    
    alpha(:,idx)   =   P*X1(:,idx);
    beta(:,idx)    =   P*m_X(:,idx);
    for  j  =  1 : length(idx)
        k           =   idx(j);
        a           =   P*( X(:,blk_arr(k, 1:par.nblk)) - repmat( m_X(:, k), 1, par.nblk ));
        s0(:,k)     =   mean(a.^2, 2);
    end
end
s0       =   max(0, s0-par.nSig^2);
Tau1     =   (par.c1*sqrt(2)*par.nSig^2)./(sqrt(s0) + eps);
return;

