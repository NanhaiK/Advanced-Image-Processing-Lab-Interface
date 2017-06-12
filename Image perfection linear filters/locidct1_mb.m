function OUT=locidct1_mb(INP)

% Inverse local DCT for the central pixel of the window
% INP - local spectrum generated by locdct1.m
% Copyright L. Yaroslavsky (yaro@eng.tau.ac.il)  
% Call OUT=locidct1(INP);


[SzW SzT]=size(INP);
mask=((-1).^(0:(SzW-1)/2))';
mask=2*mask;mask(1)=1;

mask=kron(mask,[1;0]);
mask=mask(1:SzW);
mask=kron(mask,ones(1,SzT));

OUT=sum(INP.*mask,1)/sqrt(SzW);
% OUT = INP(1,:);