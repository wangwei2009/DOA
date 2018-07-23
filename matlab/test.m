x1 = [1,2,3,7,9,8,3,7]';
x2 = [4,5,6,5,4,3,8,2]';

[tau,R,lag] = gccphat(x1,x2) 

P = (fft(x1,16).*conj(fft(x2,16)));
A = 1./abs(P);
R_est1 = fftshift(ifft(A.*P));
R_est1 = R_est1(2:16);

R_est2 = fftshift(ifft(exp(1i*angle(P))));
R_est2 = R_est2(2:16);

R_est3 = fftshift(ifft(exp(1i*angle((fft(x1,16).*conj(fft(x2,16)))))));
R_est3 = R_est3(2:16);