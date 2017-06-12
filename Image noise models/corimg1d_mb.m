function corr=corimg1d_mb(INPIMG)

INPIMG = double(INPIMG);

% 1D autocorrelation function of an image: 

% inverse FFT of averaged spectra of image columns

% Call corr=corimg1d(INPIMG);



INPIMG=INPIMG-mean(mean(INPIMG))*ones(size(INPIMG));

spimg=(abs(fft(INPIMG))).^2;



meansp=mean(spimg');

corr=fftshift(abs(ifft(meansp)));

%plotnorm(corr,1,1,1);