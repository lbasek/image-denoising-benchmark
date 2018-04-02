% QUANTIZE  Dequantize BDCT coefficients, using center bin estimates
%
%    ECOEF = DEQUANTIZE(QCOEF,QTABLE) computes a center bin estimate of the
%    coefficients given the quantizer indices (quantized coefficients) and a
%    quantization table QTABLE.
%
%    QTABLE is applied to each coefficient block in QCOEF (shaped as an image)
%    as follows: new value = old value * table value

function coef = dequantize(qcoef,qtable)

blksz = size(qtable);
[v,r,c] = im2vec(qcoef,blksz);

coef = vec2im(v.*repmat(qtable(:),1,size(v,2)),0,blksz,r,c);
