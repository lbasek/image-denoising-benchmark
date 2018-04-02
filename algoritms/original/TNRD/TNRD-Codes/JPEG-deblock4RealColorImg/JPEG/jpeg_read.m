% JPEG_READ  Read a JPEG file into a JPEG object struct
%
%    JPEGOBJ = JPEG_READ(FILENAME) Returns a Matlab struct containing the
%    contents of the JPEG file FILENAME, including JPEG header information,
%    the quantization tables, Huffman tables, and the DCT coefficients.
%
%    This software is based in part on the work of the Independent JPEG Group.
%
%    See also JPEG_WRITE.

% Phil Sallee 6/2003

error("Mex routine jpeg_read.c not compiled\n");
