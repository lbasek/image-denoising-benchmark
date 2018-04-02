function im_o   =  Add_noise( im, v )

seed  =  0;
randn( 'state', seed );
noise     =  randn( size(im) );
% noise     =  noise/sqrt(mean2(noise.^2));
im_o      =  double(im) + v*noise;