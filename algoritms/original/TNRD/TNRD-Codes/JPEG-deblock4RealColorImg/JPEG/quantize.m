% QUANTIZE  Quantize BDCT coefficients
%
% QCOEF = QUANTIZE(COEF,QTABLE) computes the quantizer indices (quantized
% coefficients) for coefficients COEF given quantization table QTABLE.  
%
% QTABLE is applied to each coefficient block in COEF (shaped as an image)
% as follows: new value = round(old value / table value)

% Phil Sallee 9/03

function qcoef = quantize(coef,qtable)

blksz = size(qtable);
[v,r,c] = im2vec(coef,blksz);

qcoef = vec2im(round(v./repmat(qtable(:),1,size(v,2))),0,blksz,r,c);
