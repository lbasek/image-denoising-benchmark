/*
 * Copyright (c) ICG. All rights reserved.
 *
 * Institute for Computer Graphics and Vision
 * Graz University of Technology / Austria
 *
 *
 * This software is distributed WITHOUT ANY WARRANTY; without even
 * the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
 * PURPOSE.  See the above copyright notices for more information.
 *
 *
 * Project     : 
 * Module      : 
 * Class       : $RCSfile$
 * Language    : C++
 * Description : 
 *
 * Author     : Yunjin Chen
 * EMail      : cheny@icg.tugraz.at
 *
 */
#include "mex.h"
#include <malloc.h>
#include <math.h>

///////////////////////////////////////////////////////////
// compile with: mex CXXFLAGS="\$CXXFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp" mex_convolution.cpp
///////////////////////////////////////////////////////////
// entry function
void mexFunction(int nlhs, mxArray *plhs[],int nrhs, const mxArray *prhs[]) {
    double *input,*output,*filter;
	int filter_size,nRow,nCol,N;
	if (nrhs !=4 ||  nlhs!=1)
		mexErrMsgTxt("Invalid number of input/output arguments!");
	input = mxGetPr(prhs[0]);
	filter = mxGetPr(prhs[1]);
	filter_size = mxGetM(prhs[1]);
	nRow = mxGetScalar(prhs[2]);
	nCol = mxGetScalar(prhs[3]);
	N = (filter_size - 1)/2;
	plhs[0] = mxCreateDoubleMatrix(nRow*nCol,1,mxREAL);
	output = mxGetPr(plhs[0]);
	if (filter_size != mxGetN(prhs[1]) || filter_size%2 != 1)
		mexErrMsgTxt("Invalid filter(only valid for square and odd size filter)!");
	//handle central region
	int col,row;
	for (col = N; col < nCol-N; col++)
	{
		for (row = N; row < nRow-N; row++)
		{
			int idx = 0;
			int idx_col,idx_row;
			double response = 0;
			for (int filter_col = -N; filter_col<=N; filter_col++)
			{
				for (int filter_row = -N; filter_row<=N; filter_row++)
				{
					idx_col = col + filter_col;
					idx_row = row + filter_row;
					response = response + input[idx_row + idx_col*nRow] * filter[idx];
					idx++;
				}
			}
			output[row + col*nRow] = response;
		}
	}
	// handle boundaries
	for (col = 0; col < N; col++)
	{
		for (row = 0; row < nRow; row++)
		{
			int idx = 0;
			int idx_col,idx_row;
			double response = 0;
			for (int filter_col = -N; filter_col<=N; filter_col++)
			{
				for (int filter_row = -N; filter_row<=N; filter_row++)
				{
					idx_col = col + filter_col;
					idx_row = row + filter_row;

					if (idx_col < 0)
						idx_col = -1 - idx_col;
					if (idx_row < 0)
						idx_row = -1 - idx_row;
					if (idx_row >= nRow)
						idx_row = 2*nRow - (idx_row+1);
					response = response + input[idx_row + idx_col*nRow] * filter[idx];
					idx++;
				}
			}
			output[row + col*nRow] = response;
		}
	}
	for (col = nCol-N; col < nCol; col++)
	{
		for (row = 0; row < nRow; row++)
		{
			int idx = 0;
			int idx_col,idx_row;
			double response = 0;
			for (int filter_col = -N; filter_col<=N; filter_col++)
			{
				for (int filter_row = -N; filter_row<=N; filter_row++)
				{
					idx_col = col + filter_col;
					idx_row = row + filter_row;

					if (idx_col >= nCol)
						idx_col = 2*nCol - (idx_col+1);
					if (idx_row < 0)
						idx_row = -1 - idx_row;
					if (idx_row >= nRow)
						idx_row = 2*nRow - (idx_row+1);
					response = response + input[idx_row + idx_col*nRow] * filter[idx];
					idx++;
				}
			}
			output[row + col*nRow] = response;
		}
	}
	for (col = N; col < nCol-N; col++)
	{
		for (row = 0; row < N; row++)
		{
			int idx = 0;
			int idx_col,idx_row;
			double response = 0;
			for (int filter_col = -N; filter_col<=N; filter_col++)
			{
				for (int filter_row = -N; filter_row<=N; filter_row++)
				{
					idx_col = col + filter_col;
					idx_row = row + filter_row;

					if (idx_row < 0)
						idx_row = -1 - idx_row;
					response = response + input[idx_row + idx_col*nRow] * filter[idx];
					idx++;
				}
			}
			output[row + col*nRow] = response;
		}
	}
	for (col = N; col < nCol-N; col++)
	{
		for (row = nRow-N; row < nRow; row++)
		{
			int idx = 0;
			int idx_col,idx_row;
			double response = 0;
			for (int filter_col = -N; filter_col<=N; filter_col++)
			{
				for (int filter_row = -N; filter_row<=N; filter_row++)
				{
					idx_col = col + filter_col;
					idx_row = row + filter_row;

					if (idx_row >= nRow)
						idx_row = 2*nRow - (idx_row+1);
					response = response + input[idx_row + idx_col*nRow] * filter[idx];
					idx++;
				}
			}
			output[row + col*nRow] = response;
		}
	}
}