% JPEG_QTABLE  Generate standard JPEG quantization tables
%
%   T=JPEG_QTABLE(QUALITY,TNUM,FORCE_BASELINE)
%
%   Returns a quantization table T given in JPEG spec, section K.1 and scaled
%   using a quality factor.  The scaling method used is the same as that used
%   by the IJG (Independent JPEG Group) code library.
% 
%   QUALITY values should range from 1 (terrible) to 100 (very good), the
%   scale recommended by IJG.  Default is 50, which represents the tables
%   defined by the standard used without scaling.
%
%   TNUM should be a valid table number, either 0 (used primarily for
%   luminance channels), or 1 (used for chromatic channels). Default is 0.
%
%   FORCE_BASELINE clamps the quantization table entries to have values
%   between 1..255 to ensure baseline compatibility with all JPEG decoders.
%   By default, values are clamped to a range between 1..32767.  These are
%   the same ranges used by the IJG code library for generating standard
%   quantization tables.

function t = jpeg_qtable(quality, tnum, force_baseline)

if (nargin < 1)
  quality = 50;  % default to no scaling
end

if (nargin < 2)
  tnum = 0;
end

if (nargin < 3)
  force_baseline=0;
end

% convert to linear quality scale
if (quality <= 0) quality = 1; end
if (quality > 100) quality = 100; end
if (quality < 50)
  quality = 5000 / quality;
else
  quality = 200 - quality*2;
end


switch(tnum)
  case 0

    % This is table 0 (the luminance table):
    t = [ 16  11  10  16  24  40  51  61 ; ...
	    12  12  14  19  26  58  60  55 ; ...
	    14  13  16  24  40  57  69  56 ; ...
	    14  17  22  29  51  87  80  62 ; ...
	    18  22  37  56  68 109 103  77 ; ...
	    24  35  55  64  81 104 113  92 ; ...
	    49  64  78  87 103 121 120 101 ; ...
	    72  92  95  98 112 100 103  99 ];

  case 1

    % This is table 1 (the chrominance table):
    t = [ 17  18  24  47  99  99  99  99 ; ...
	    18  21  26  66  99  99  99  99 ; ...
	    24  26  56  99  99  99  99  99 ; ...
	    47  66  99  99  99  99  99  99 ; ...
	    99  99  99  99  99  99  99  99 ; ...
	    99  99  99  99  99  99  99  99 ; ...
	    99  99  99  99  99  99  99  99 ; ...
	    99  99  99  99  99  99  99  99 ];

  otherwise
    error('Table number must be 0 or 1');
end

t = floor((t * quality + 50)/100);
t(t<1)=1;

t(t>32767)=32767;  % max quantizer needed for 12 bits
if (force_baseline)
  t(t>255)=255;
end

