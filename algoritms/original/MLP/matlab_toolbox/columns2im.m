%   Author: Harold Christopher Burger
%   Date:   March 19, 2012.

function res = columns2im(cols, im_sz, stride)

  pSz = sqrt(size(cols,1));

  res = zeros(im_sz(1), im_sz(2));
  w = zeros(im_sz(1), im_sz(2));

  range_y = 1:stride:(im_sz(1)-pSz+1);
  range_x = 1:stride:(im_sz(2)-pSz+1);
  if (range_y(end)~=(im_sz(1)-pSz+1))
    range_y = [range_y (im_sz(1)-pSz+1)];
  end
  if (range_x(end)~=(im_sz(2)-pSz+1))
    range_x = [range_x (im_sz(2)-pSz+1)];
  end

  idx = 0;
  for y=range_y
    for x=range_x
      idx = idx + 1;
      p = reshape(cols(:,idx), [pSz pSz]);
      res(y:y+pSz-1, x:x+pSz-1) = res(y:y+pSz-1, x:x+pSz-1) + p;
      w(y:y+pSz-1, x:x+pSz-1) = w(y:y+pSz-1, x:x+pSz-1) + 1;
      
    end
  end
  res = res./w;


return

