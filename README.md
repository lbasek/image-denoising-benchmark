# Benchmarking Denoising Algorithms with Real Photographs

##  Task and results

In this benchmark we compare some algorithms to denoise the image. We compare the following algorithms: BM3D, KSVD, FOE, WNNM, NCSR, EPLL. We used the RENOIR dataset from Josue Anaya and Adrain Barbu and we measure the algorithm quality with the following metrics: MSE, PSNR, SSIM. Measurements is made on 20 images 512x512 and the results are not realistic. It's necessary to make a correction.

NOTE: The source code was taken from the original articles and adapted to our benchmark.

Contributors: 
- Luka Bašek - https://github.com/lbasek
- Ivan Gradečak - https://github.com/igradeca

## Diagrams

### Mean squared error
<img src="https://raw.githubusercontent.com/lbasek/image-denoising-benchmark/master/graphs/mse_one_image.png" width="600">

### Peak signal-to-noise ratio
<img src="https://raw.githubusercontent.com/lbasek/image-denoising-benchmark/master/graphs/psnr_one_image.png" width="600">

### Structural similarity
<img src="https://raw.githubusercontent.com/lbasek/image-denoising-benchmark/master/graphs/ssim_one_image.png" width="600">

### Time
<img src="https://raw.githubusercontent.com/lbasek/image-denoising-benchmark/master/graphs/time_one_image.png" width="600">


##  Literature

[1] T. Ploetz, S. Roth. Benchmarking Denoising Algorithms with Real Photographs. 2017

[2] J. Anaya, A. Barbu. RENOIR - A Dataset for Real Low-Light Image Noise Reduction. 2014

[3] Adrian Barbu's Research. RENOIR - A Dataset of Real Low-Light Images.
http://adrianbarburesearch.blogspot.pt/p/renoir-dataset.html. 2018

[4] T. Ploetz, S. Roth.. The Darmstadt Noise Dataset. https://noise.visinf.tu-darmstadt.de/. 2018

[5] K. Dabov, A. Foi, V. Katkovnik, and K. Egiazarian. Image denoising by sparse 3D transform-
domain collaborative fltering. 2007

[6] D. Zoran, Y. Weiss. From Learning Models of Natural Image Patches to Whole Image
Restoration. 2011

[7] S. Gu, L. Zhang, W. Zuo, X. Feng. Weighted Nuclear Norm Minimization with Application to
Image Denoising. 2014

[8] M. Aharon, M. Elad, A. Bruckstein. K-SVD: Design of Dictionaries for Sparse Representation.
2005

[9] S. Roth, M. J. Black, Fields of Experts. 2009

[10] W. Donga, L. Zhangb, G. Shia, X. Li. Nonlocally Centralized Sparse Representation for Image
Restoration. 2012

[11] H. C. Burger, C. J. Schuler, S. Harmeling. Image denoising: Can plain Neural Networks
compete with BM3D?. 2012

[12] Y. Chen, T. Pock. Trainable Nonlinear Reaction Diffusion: A Flexible Framework for Fast and
Effective Image Restoration. 2016
