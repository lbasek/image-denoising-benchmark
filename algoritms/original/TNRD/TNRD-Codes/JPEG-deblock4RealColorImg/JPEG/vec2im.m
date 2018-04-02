% VEC2IM  Reshape and combine column vectors into a 2D image
%
%    IM=VEC2IM(V[,PADSIZE,BLKSIZE,ROWS,COLS])
%
%    V is an MxN array containing N Mx1 column vectors which will be reshaped
%    and combined to form image IM. 
%
%    PADSIZE is a scalar or a 1x2 vector indicating the amount of vertical and
%    horizontal space to be added as a border between the reshaped vectors.
%    Default is [0 0].  If PADSIZE is a scalar, the same amount of space is used
%    for both directions.
%
%    BLKSIZE is a scalar or a 1x2 vector indicating the size of the blocks.
%    Default is sqrt(M).
%
%    ROWS indicates the number of rows of blocks in the image. Default is
%    floor(sqrt(N)).
%
%    COLS indicates the number of columns of blocks in the image.  Default
%    is ceil(N/ROWS).
%
%    See also IM2VEC.

% Phil Sallee 5/03

function im=vec2im(v,padsize,bsize,rows,cols)

m = size(v,1);
n = size(v,2);

if (nargin < 2)
  padsize = [0 0];
end
padsize = padsize + [0 0];
if (any(padsize<0))
  error('Pad size must not be negative.');
end

if (nargin < 3)
  bsize = floor(sqrt(m));
end
bsize = bsize + [0 0];
if (prod(bsize) ~= m)
  error('Block size does not match size of input vectors.');
end

if (nargin < 4)
  rows = floor(sqrt(n));
end
if (nargin < 5)
  cols = ceil(n/rows);
end

% make image
y=bsize(1)+padsize(1);
x=bsize(2)+padsize(2);
t = zeros(y,x,rows*cols);
t(1:bsize(1),1:bsize(2),1:n) = reshape(v,bsize(1),bsize(2),n);
t = reshape(t,y,x,rows,cols);
t = reshape(permute(t,[1,3,2,4]),y*rows,x*cols);
im = t(1:y*rows-padsize(1),1:x*cols-padsize(2));

