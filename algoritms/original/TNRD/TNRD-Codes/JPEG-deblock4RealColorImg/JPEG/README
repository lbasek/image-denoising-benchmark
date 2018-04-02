Matlab JPEG Toolbox
===================
This distribution contains routines for manipulating files formatted
according to the Joint Photographic Experts Group (JPEG) standard.
Matlab's built-in IMREAD and IMWRITE functions provide basic
conversion between JPEG files and image arrays. The routines in this
package provide additional functionality for directly accessing the
contents of JPEG files from Matlab, including the Discrete Cosine
Transform (DCT) coefficients, quantization tables, Huffman coding
tables, color space information, and comment markers.  It is assumed
that the user of this software has a good understanding of both the
JPEG compression standard and Matlab data structures.

This software is based in part on the work of the Independent JPEG
Group (IJG), as it makes use of IJG's free JPEG code library.  If the
MEX file binaries provided in this distribution are not the ones you
need for your system, you will need to download IJG's code library and
install it on your system before compiling the source code.  See
"Installing" for more details.

If you find this software useful, or if you would like to contribute
to the project, please send me email.

Phil Sallee 9/2003  <sallee@cs.ucdavis.edu>


Copyright Notice
================
Copyright (c) 2003 The Regents of the University of California. 
All Rights Reserved. 

Permission to use, copy, modify, and distribute this software and its
documentation for educational, research and non-profit purposes,
without fee, and without a written agreement is hereby granted,
provided that the above copyright notice, this paragraph and the
following three paragraphs appear in all copies.

Permission to incorporate this software into commercial products may
be obtained by contacting the University of California.  Contact Jo Clare
Peterman, University of California, 428 Mrak Hall, Davis, CA, 95616.

This software program and documentation are copyrighted by The Regents
of the University of California. The software program and
documentation are supplied "as is", without any accompanying services
from The Regents. The Regents does not warrant that the operation of
the program will be uninterrupted or error-free. The end-user
understands that the program was developed for research purposes and
is advised not to rely exclusively on the program for any reason.

IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY
FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES,
INCLUDING LOST PROFITS, ARISING OUT OF THE USE OF THIS SOFTWARE AND
ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF CALIFORNIA HAS BEEN
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. THE UNIVERSITY OF
CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE. THE SOFTWARE PROVIDED HEREUNDER IS ON AN "AS IS"
BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATIONS TO PROVIDE
MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.


Installing
==========
Copy all of the files into a new directory.  Add this directory to the
Matlab startup path, if desired.  Compile the MEX routines, if
necessary.

Compiled MEX routines with the extension .dll, are provided for
Windows 9x/NT/2000 systems.  These were compiled for Matlab
6.5.0.180913a (R13) using the Microsoft Visual C++ compiler.  If you
have a different version of Matlab, they may not work on your system.
For use on other platforms, you will need to take the following steps
to compile the MEX routines.

In order to compile the MEX routines, you must first build IJG's JPEG Tools
code library, available at ftp://ftp.uu.net/graphics/jpeg/jpegsrc.v6b.tar.gz.
Download and build the libjpeg library using the make files and instructions
contained in the IJG JPEG distribution.  

Once the IJG libjpeg library has been built, execute the following commands
from the command shell or from inside a Matlab window, depending on your
Matlab configuration:

mex -I<IJGPATH> jpeg_read.c <LIBJPEG>
mex -I<IJGPATH> jpeg_write.c <LIBJPEG>

Replace <IJGPATH> with the path to the IJG jpeg-6b directory, and
<LIBJPEG> with the full path to the IJG code library file, generally
saved as libjpeg.a or libjpeg.lib depending on the operating system.


Files contained in this distribution
====================================
README
bdct.m
bdctmtx.m
dequantize.m
ibdct.m
im2vec.m
jpeg_qtable.m
jpeg_read.c
jpeg_read.dll
jpeg_read.m
jpeg_write.c
jpeg_write.dll
jpeg_write.m
quantize.m
vec2im.m


Matlab Functions
================
The following Matlab functions are included in this distribution:

jpeg_read     	Read a JPEG file into a JPEG object struct
jpeg_write    	Write a JPEG object struct to a JPEG file
jpeg_qtable   	Generate standard JPEG quantization tables
bdct          	Blocked discrete cosine transform
ibdct         	Inverse blocked discrete cosine transform
bdctmtx        	Blocked discrete cosine transform matrix (2D, full transform)
quantize      	Quantize BDCT coefficients (using a quantization table)
dequantize    	Dequantize BDCT coefficients, using center bin estimates
im2vec          Reshape 2D image blocks into an array of column vectors
vec2im          Reshape and combine column vectors into a 2D image

The following routines may be added in a future version of this toolbox:

jpeg_info     	Display pertinent information about a JPEGOBJ struct
jpeg2im       	Convert a JPEGOBJ struct to an image
im2jpeg       	Convert an IMAGE to a JPEGOBJ struct
huff_encode   	Huffman encode coefficients into a bitstream
huff_decode   	Huffman decode a bitstream into coefficients
bitpack       	Repack array of bits into an array of bytes, or vice versa


Release Notes
=============
 9/08/03  v1.0  Initial release
 9/24/03  v1.1  Fixed problem with bdct/ibdct and non-square images
 9/25/03  v1.2  Corrected warnings in jpeg_read/jpeg_write
		Workaround for incompatibility with older Matlab versions
10/14/03  v1.3  Fixed seg faults caused by warnings in jpeg_read, jpeg_write
                Added error checking for quantization table entries
                Added force_baseline option to jpeg_qtable
10/30/03  v1.4  Added basic support for progressive mode JPEG


Documentation
=============
Type 'help <command>' for documentation on a specific function.  At
this point, relatively little documentation is provided.  The tools
are simple, however.  The jpeg_read, and jpeg_write routines convert
information from a JPEG file into a Matlab struct, which I will also
refer to as a "jpeg object".  This Matlab struct contains all of the
critical information present in the JPEG file, in the form of arrays,
cell arrays and nested structs indexed by (hopefully intuitive) field
names.  The only information present in the JPEG file not contained in
the jpeg object are currently the Adobe markers.  I may add that
functionality in a future release.

The field names for the structs generally match the names used in the
JPEG standard and in the IJG code library.  These were chosen to be as
intuitive as possible.  If there are multiple color components in the
JPEG file, as is typical, the coefficient array for each component is
stored in a cell array indexed by the component number.  Information
specific to the component is stored in the field comp_info, an array
of structs indexed by the same component number.  The quantization
tables can be found in the field quant_tables, which contains a cell
array of tables.  The index of the quantization table used by for a
given component is stored in the quant_tbl_no in the comp_info struct.

For example, to read an image into a jpeg object named 'jobj'.

>> jobj = jpeg_read('myimage.jpg');

List the contents of jobj (which is really a Matlab struct):

>> jobj

jobj = 

          image_width: 227
         image_height: 149
     image_components: 0
    image_color_space: 2
      jpeg_components: 3
     jpeg_color_space: 3
             comments: {}
          coef_arrays: {[152x232 double]  [80x120 double]  [80x120 double]}
         quant_tables: {[8x8 double]  [8x8 double]}
       ac_huff_tables: [1x2 struct]
       dc_huff_tables: [1x2 struct]
      optimize_coding: 0
            comp_info: [1x3 struct]
     progressive_mode: 0

This gives us some basic information such as image size, number of
color components, etc.

To access the quantization table used by the first component:

>> jobj.quant_tables{jobj.comp_info(1).quant_tbl_no}

ans =

     8     6     5     8    12    20    26    31
     6     6     7    10    13    29    30    28
     7     7     8    12    20    29    35    28
     7     9    11    15    26    44    40    31
     9    11    19    28    34    55    52    39
    12    18    28    32    41    52    57    46
    25    32    39    44    52    61    60    51
    36    46    48    49    56    50    52    50

This corresponds to a luminance channel quantization table with a
quality of 75, which you can check using jpeg_qtable:

>> jpeg_qtable(75)

ans =

     8     6     5     8    12    20    26    31
     6     6     7    10    13    29    30    28
     7     7     8    12    20    29    35    28
     7     9    11    15    26    44    40    31
     9    11    19    28    34    55    52    39
    12    18    28    32    41    52    57    46
    25    32    39    44    52    61    60    51
    36    46    48    49    56    50    52    50

Note: The indices for quant_tbl_no, ac_huff_table, and dc_huff_table
stored in the actual JPEG file are 0-based, but in the jpeg object
struct these are converted to be 1-based so that they correspond to
Matlab's indexing convention for the cell arrays.  All other values
are directly copied to and from the JPEG file without conversion.

Setting jobj.optimize_coding to 1 before calling jpeg_write will cause
the compressor to optimize the huffman coding tables.  This usually
provides a small percentage decrease in file size.  Note that this
will case the huffman tables in the object to be ignored when the file
is written.

>> jobj.optimize_coding = 1;

To add a comment to the jpeg object:

>> jobj.comments = {'Comment: The huffman tables are optimized'};

Write out the jpeg file with the added comment, optimizing the huffman
tables:

>> jpeg_write(jobj,'myimage2.jpg');

If the file is read back into another jpeg object, the optimize_coding
field will not be set to 1 in the new object.  That is because this
information is not contained within the JPEG file.  It is merely a
code to the compression engine to optimize the tables.  A clever
program could look at the tables and take a guess as to whether they
have been optimized based on whether they match the standard tables,
but there is no saved value in the JPEG file that indicates if the
huffman tables were optimized.

The JPEG colorspace constants (found in IJG's jpeglib.h) are:
    0   JCS_UNKNOWN,      /* error/unspecified */
    1   JCS_GRAYSCALE,    /* monochrome */
    2   JCS_RGB,          /* red/green/blue */
    3   JCS_YCbCr,        /* Y/Cb/Cr (also known as YUV) */
    4   JCS_CMYK,         /* C/M/Y/K */
    5   JCS_YCCK          /* Y/Cb/Cr/K */

See the documentation in the IJG code library for more information on
image/jpeg colorspaces.  I plan to add a function jpeg_info at a later
date which will interpret some of the the raw data in a jpeg object
and display plain text descriptions of such things as the color space,
compression quality, and whether the huffman tables are generic or
optimized.

The BDCT and IBDCT routines convert between a single channel image and
the blocked DCT transform coefficients.  This can be useful for
interpreting the coefficient arrays.  The QUANTIZE and DEQUANTIZE
routines take a coefficient array and quantization table and convert
between the coefficient values and the quantization indices.

As of version 1.4 there is a field to indicate if the JPEG file was
stored in progressive_mode.  This flag can be modified to turn on/off
progressive mode when writing to a file.  Currently, the scan sequence
is not preserved.  If progressive mode is enabled, a default scan
sequence is used.  Also, turning on progressive mode results in using
optimized huffman tables, as the default huffman tables are unsuitable
for progressive files.

More information about the JPEG compression standard can be found 
at the following reference:

Wallace, Gregory K.  "The JPEG Still Picture Compression Standard",
Communications of the ACM, April 1991 (vol. 34 no. 4), pp. 30-44.
