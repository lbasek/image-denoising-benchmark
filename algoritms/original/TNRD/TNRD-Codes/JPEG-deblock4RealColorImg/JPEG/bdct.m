% BDCT Blocked discrete cosine transform
%
%    B = BDCT(A) computes DCT2 transform of A in 8x8 blocks.  B is
%    the same size as A and contains the cosine transform coefficients for
%    each block.  This transform can be inverted using IBDCT.
%
%    B = BDCT(A,N) computes DCT2 transform of A in blocks of size NxN.

% Phil Sallee 9/03

function b = bdct(a,n)

if (nargin < 2)
  n = 8;
end

% generate the matrix for the full 2D DCT transform (both directions)
dctm = bdctmtx(n);

% reshape image into blocks, multiply, and reshape back
[v,r,c] = im2vec(a,n);
b = vec2im(dctm*v,0,n,r,c);
