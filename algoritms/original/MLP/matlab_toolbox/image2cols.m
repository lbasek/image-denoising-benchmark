%   Author: Harold Christopher Burger
%   Date:   March 19, 2012.

function res = image2cols(im, pSz, stride)


  range_y = 1:stride:(size(im,1)-pSz+1);
  range_x = 1:stride:(size(im,2)-pSz+1);
  if (range_y(end)~=(size(im,1)-pSz+1))
    range_y = [range_y (size(im,1)-pSz+1)];
  end
  if (range_x(end)~=(size(im,2)-pSz+1))
    range_x = [range_x (size(im,2)-pSz+1)];
  end
  sz = length(range_y)*length(range_x);

  res = zeros(pSz^2, sz);

  idx = 0;
  for y=range_y
    for x=range_x
      p = im(y:y+pSz-1,x:x+pSz-1);
      idx = idx + 1;
      res(:,idx) = p(:);
    end
  end

return

