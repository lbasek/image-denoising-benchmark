function  A   =  Set_blur_matrix( par )

s          =   par.scale;
[lh lw ch] =   size( par.LR );
hh         =   lh*s;
hw         =   lw*s;
M          =   lh*lw;
N          =   hh*hw;

ws         =   size( par.psf, 1 );
t          =   (ws-1)/2;
cen        =   ceil(ws/2);
ker        =   par.psf;

nv         =   ws*ws;
nt         =   (nv)*M;
R          =   zeros(nt,1);
C          =   zeros(nt,1);
V          =   zeros(nt,1);
cnt        =   1;

pos     =  (1:hh*hw);
pos     =  reshape(pos, [hh hw]);

for lrow = 1:lh
    for lcol = 1:lw
        
        row        =   (lrow-1)*s + 1;
        col        =   (lcol-1)*s + 1;
        
        row_idx    =   (lcol-1)*lh + lrow;
        
        
        rmin       =  max( row-t, 1);
        rmax       =  min( row+t, hh);
        cmin       =  max( col-t, 1);
        cmax       =  min( col+t, hw);
        sup        =  pos(rmin:rmax, cmin:cmax);
        col_ind    =  sup(:);
        
        r1         =  row-rmin;
        r2         =  rmax-row;
        c1         =  col-cmin;
        c2         =  cmax-col;
        
        ker2       =  ker(cen-r1:cen+r2, cen-c1:cen+c2);
        ker2       =  ker2(:);

        nn         =  size(col_ind,1);
        
        R(cnt:cnt+nn-1)  =  row_idx;
        C(cnt:cnt+nn-1)  =  col_ind;
        V(cnt:cnt+nn-1)  =  ker2/sum(ker2);
        
        cnt              =  cnt + nn;
    end
end

R   =  R(1:cnt-1);
C   =  C(1:cnt-1);
V   =  V(1:cnt-1);
A   =  sparse(R, C, V, M, N);