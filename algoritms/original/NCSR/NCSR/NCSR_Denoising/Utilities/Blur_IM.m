function b_im = Blur_IM( im, H )

[h w ch]  =  size(im);

if ch==3
    m1  = im(:,:,1);
    m2  = im(:,:,2);
    m3  = im(:,:,3);    
    b_im(:,:,1)  =  reshape( H*m1(:), h, w );
    b_im(:,:,2)  =  reshape( H*m2(:), h, w );
    b_im(:,:,3)  =  reshape( H*m3(:), h, w );
else
    b_im  =  reshape( H*im(:), h, w );
end