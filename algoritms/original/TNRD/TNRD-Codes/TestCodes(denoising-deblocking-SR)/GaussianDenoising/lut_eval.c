//LUT_EVAL - Evaluate RBFMIX function value and gradients via lookup table with linear interpolation.
//
//   Compiling:
//    Linux:   mex lut_eval.c CFLAGS="\$CFLAGS -Wall -std=c99 -mtune=native -O3 -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp"
//    Windows: mex lut_eval.c COMPFLAGS="$COMPFLAGS /Wall /TP" OPTIMFLAGS="$OPTIMFLAGS /openmp /O2"
//
//   Author: Uwe Schmidt, TU Darmstadt (uwe.schmidt@gris.tu-darmstadt.de)
//
//   This file is part of the implementation as described in the CVPR 2014 paper:
//   Uwe Schmidt and Stefan Roth. Shrinkage Fields for Effective Image Restoration.
//   Please see the file LICENSE.txt for the license governing this code.

#include "mex.h"
#include <math.h>
#include <omp.h>

void lookup(const int nargout, double *outP, double *outGW, double *outGX, double *outQ, const double *x, const double origin, const double step, const double *P, const double *GW, const double *GX, const double *Q, const int ndata, const int nbins, const int nmeans) {
  omp_set_num_threads(64);
  #pragma omp parallel for
  for (int i = 0; i < ndata; i++) {

    const double x_hit = (x[i] - origin) / step;
    int xl = (int) floor(x_hit), xh = (int) ceil(x_hit);

    // boundary checks
    if (xl < 0) xl = 0; if (xl >= nbins) xl = nbins-1;
    if (xh < 0) xh = 0; if (xh >= nbins) xh = nbins-1;    
    const double wh = x_hit - (double)xl;

    const double pl = P[xl], ph = P[xh];
    outP[i] = pl + (ph-pl) * wh;

    if (nargout >= 2) {
      const double *GWlow = GW + xl*nmeans, *GWhigh = GW + xh*nmeans;
      double *outGWoff = outGW + i*nmeans;
      for (int j = 0; j < nmeans; j++) {
        const double gwl = *GWlow++, gwh = *GWhigh++;
        *outGWoff++ = gwl + (gwh-gwl) * wh;
      }
      //
      if (nargout >= 3) {
        const double gxl = GX[xl], gxh = GX[xh];
        outGX[i] = gxl + (gxh-gxl) * wh;
        //
        if (nargout >= 4) {
          const double *Qlow = Q + xl*nmeans, *Qhigh = Q + xh*nmeans;
          double *outQoff = outQ + i*nmeans;
          for (int j = 0; j < nmeans; j++) {
            const double ql = *Qlow++, qh = *Qhigh++;
            *outQoff++ = ql + (qh-ql) * wh;
          }
        }
      }
    }

  }
}

mxArray* createUninitializedDoubleMatrix(const int M, const int N) {
  // mxArray *mxP = mxCreateNumericMatrix(M, N, mxDOUBLE_CLASS, mxREAL);
  mxArray *mxP = mxCreateNumericMatrix(0, 0, mxDOUBLE_CLASS, mxREAL);
  mxSetM(mxP, M); mxSetN(mxP, N);
  mxSetData(mxP, mxMalloc(sizeof(double) * (M*N)));
  return mxP;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  
  if (nlhs == 0) return;
  if (nrhs != 7) mexErrMsgTxt("Seven inputs expected: lut_eval(x, origin, step, P, GW, GX, Q)");
 
  const int ndata     = mxGetNumberOfElements(prhs[0]);
  const int nbins     = mxGetNumberOfElements(prhs[3]);
  const int nmeans    = mxGetM(prhs[4]);  
  const double *data  = (const double*) mxGetPr(prhs[0]);
  const double origin = mxGetScalar(prhs[1]);
  const double step   = mxGetScalar(prhs[2]);
  const double *P     = (const double*) mxGetPr(prhs[3]);
  const double *GW    = (const double*) mxGetPr(prhs[4]);
  const double *GX    = (const double*) mxGetPr(prhs[5]);
  const double *Q     = (const double*) mxGetPr(prhs[6]);

  double *outP=0, *outGW=0, *outGX=0, *outQ=0;
  if (nlhs > 0) {
    plhs[0] = createUninitializedDoubleMatrix(1, ndata);
    outP = (double*) mxGetPr(plhs[0]);
    if (nlhs > 1) {
      plhs[1] = createUninitializedDoubleMatrix(nmeans, ndata);
      outGW = (double*) mxGetPr(plhs[1]);
      if (nlhs > 2) {
        plhs[2] = createUninitializedDoubleMatrix(1, ndata);
        outGX = (double*) mxGetPr(plhs[2]);
        if (nlhs > 3) {
          plhs[3] = createUninitializedDoubleMatrix(nmeans, ndata);
          outQ = (double*) mxGetPr(plhs[3]);
        }
      }
    }
  }
  lookup(nlhs, outP, outGW, outGX, outQ, data, origin, step, P, GW, GX, Q, ndata, nbins, nmeans);
}