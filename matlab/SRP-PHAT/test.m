N_FFT = 512;
a = zeros(N_FFT,1);
for k = 1:N_FFT/2+1
    a(k) = k*k*5.6/8 + 1.4*k + 3 -1j*k;
end
for k = N_FFT/2+2:N_FFT
    a(k) = conj(a(N_FFT-k+2));
end

b = ifft(a)*512;
