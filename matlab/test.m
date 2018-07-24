x1 = [1,2,3,7,9,8,3,7]';
x2 = [4,5,6,5,4,3,8,2]';

[tau,R,lag] = gccphat(x1,x2) 

N = length(x1)+length(x2)-1;
NFFT = 32;
P = (fft(x1,NFFT).*conj(fft(x2,NFFT)));
A = 1./abs(P);
R_est1 = fftshift(ifft(A.*P));
range = NFFT/2+1-(N-1)/2:NFFT/2+1+(N-1)/2;
R_est1 = R_est1(range);

R_est2 = fftshift(ifft(exp(1i*angle(P))));
R_est2 = R_est2(range);

x1 = [1,2,3,7,9,8,3,7]';
x2 = [4,5,6,5,4,3,8,2]';
N = length(x1)+length(x2)-1;
NFFT = 64;
range = NFFT/2+1-(N-1)/2:NFFT/2+1+(N-1)/2;
xcorr(x1,x2)
ifft(fft(x1,NFFT).*conj(fft(x2,NFFT)));
r = fftshift(ifft(fft(x1,NFFT).*conj(fft(x2,NFFT))));
r = r(range)
