% BDCTMTX Blocked discrete cosine transform matrix
%
%    M = BDCTMTX(N) generates a N^2xN^2 DCT2 transform matrix which, when
%    multiplied by NxN image blocks, shaped as N^2x1 vectors, returns the
%    2D DCT transform of each image block vector.

%  Phil Sallee 9/03

function m = bdctmtx(n)

[c,r] = meshgrid(0:n-1);
[c0,r0] = meshgrid(c);
[c1,r1] = meshgrid(r);

x = sqrt(2 / n) * cos(pi * (2*c + 1) .* r / (2 * n));
x(1,:) = x(1,:) / sqrt(2);

m = x(r0+c0*n+1) .* x(r1+c1*n+1);

