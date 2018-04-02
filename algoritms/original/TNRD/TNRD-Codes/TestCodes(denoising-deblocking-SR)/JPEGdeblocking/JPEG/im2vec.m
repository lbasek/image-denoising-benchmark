% IM2VEC  Reshape 2D image blocks into an array of column vectors
%
%    V=IM2VEC(IM,BLKSIZE[,PADSIZE])
%
%    [V,ROWS,COLS]=IM2VEC(IM,BLKSIZE[,PADSIZE])
%
%    IM is an image to be separated into non-overlapping blocks and
%    reshaped into an MxN array containing N blocks reshaped into Mx1
%    column vectors.  IM2VEC is designed to be the inverse of VEC2IM.
%
%    BLKSIZE is a scalar or 1x2 vector indicating the size of the blocks.
%
%    PADSIZE is a scalar or 1x2 vector indicating the amount of vertical
%    and horizontal space to be skipped between blocks in the image.
%    Default is [0 0].  If PADSIZE is a scalar, the same amount of space
%    is used for both directions.  PADSIZE must be non-negative (blocks
%    must be non-overlapping).
%
%    ROWS indicates the number of rows of blocks found in the image.
%    COLS indicates the number of columns of blocks found in the image.
%
%    See also VEC2IM.

% Phil Sallee 5/03

function [v,rows,cols]=im2vec(im,bsize,padsize)

bsize = bsize + [0 0];

if (nargin < 3)
  padsize = 0;
end
padsize = padsize + [0 0];
if (any(padsize<0))
  error('Pad size must not be negative.');
end

imsize = size(im);
y=bsize(1)+padsize(1);
x=bsize(2)+padsize(2);
rows = floor((imsize(1)+padsize(1))/y);
cols = floor((imsize(2)+padsize(2))/x);

t = zeros(y*rows,x*cols);
imy=y*rows-padsize(1);
imx=x*cols-padsize(2);
t(1:imy,1:imx)=im(1:imy,1:imx);
t = reshape(t,y,rows,x,cols);
t = reshape(permute(t,[1,3,2,4]),y,x,rows*cols);
v = t(1:bsize(1),1:bsize(2),1:rows*cols);
v = reshape(v,y*x,rows*cols);
