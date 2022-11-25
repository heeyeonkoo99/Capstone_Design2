This codebase implements the algorithm proposed in: 
"Efficient Multiscale Phase Unwrapping Methodology with Modulo Wavelet Transform"
currently submitted to Optics Express.

A demonstration of the code can be found in "main.m". The four tested wrapped phase images are included in the cell matrix found in "testimages.mat" with entries.

The amount of levels of the modulo wavelet transform can be set with the "levels" parameter. When set to 0, the orignal unaccelerated version of the algorithm is used. The amount of dilation applied on the aliasing masks is b y default set to K=1, and can be modified.

Currently two algorihms have been accelerated (see "accel_unwrapping.m"):
	* M. A. Herraez, D. R. Burton, M. J. Lalor, and M. A. Gdeisat, "Fast two-dimensional phase-unwrapping algorithm based on sorting by reliability following a noncontinuous path," Appl. Opt. 41, 7437–7444 (2002).
	* Bioucas-Dias, J.M.; Valadao, G., "Phase Unwrapping via Graph Cuts," in Image Processing, IEEE Transactions on, vol.16, no.3, pp.698-709, March 2007
	
More details can be found in the comments of the provided source code.

Author: David Blinder
Contact: dblinder@etro.vub.ac.be

July 2016
