function OUTIMG=smobjdet_mb(INPIMG,Obj)INPIMG = double(INPIMG);% Simulation of optimal filtering for detection of small objects% OUTIMG=conv(INPIMG,OPTFILTR)% Obj is an array that defines (roughly) objects to be detected% (for instance ones(size(Obj)) can be a model of an object)% Call OUTIMG=smobjdet(INPIMG,Obj);imgsp=fft2(INPIMG);imgsp2=fftshift((abs(imgsp)).^2);imgsp2=conv2(imgsp2,ones(3)/9,'same');imgsp2=fftshift(imgsp2);OUTIMG=real(ifft2(imgsp./imgsp2));OUTIMG=conv2(OUTIMG,Obj,'same');mn=min(min(OUTIMG));mx=max(max(OUTIMG));OUTIMG = uint8(255*(OUTIMG-mn)/(mx-mn));end