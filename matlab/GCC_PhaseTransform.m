function [r,tau] = gcc_phat( x, y, fs )
M = max(numel(x),numel(y));

%%Transform both vectors
% X = fft(x,2^nextpow2(2*M-1));
% Y = fft(y,2^nextpow2(2*M-1));
% 
% % Compute cross-correlation
% 
% R = X.*conj(Y);
% c = ifft(R./abs(R));

%%
N = 2*M-1; 
Nfft = 2^nextpow2(N);

R = bsxfun(@times, ...
        fft(y,Nfft), ...
        conj(fft(x,Nfft)));
rtmp = fftshift( ...
        ifft(exp(1i*angle(R))) ,1);
r = rtmp(Nfft/2+1-(M-1)/2:Nfft/2+1+(M-1)/2,:);

lags = (-(N-1)/2:(N-1)/2).';
lags = lags/fs;
[~,idx] = max(abs(r));
tau = N/(2*fs)+lags(idx);

end