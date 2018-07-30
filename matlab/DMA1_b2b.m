function [ y ] = DMA1_b2b( x,y,frameLength,inc,omega,Hb,Hf,HL,fs,N,tao0,alpha,beta)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
    for i = 1:inc:length(x(:,1))-frameLength
        for k = 2:N/2+1
            omega(k) = 2*pi*(k-1)*fs/N;    
%             if k<16
%                 H(:,k) = 1j/(omega(k)*tao0*(alpha-1))*[1-beta*exp(-1j*omega(k)*tao0*(1-alpha));...
%                                                             -(1-beta)*exp(1j*omega(k)*tao0*alpha)];
%             else
            %         H(:,k) = 1j/((alpha-1)*tao0*omega(k))*[1;-exp(1j*omega(k)*tao0*alpha)];
%             H(:,k) = 1/(1-exp(1j*omega(k)*tao0*(alpha-1)))*[1;-exp(1j*omega(k)*tao0*alpha)];
            Hf(:,k) = [1;
                       -1*exp(-1j*omega(k)*tao0)];
            Hb(:,k) = [-1*exp(-1j*omega(k)*tao0);
                       1;];
            if k<=66
                HL(k) = 1/(2*sin(omega(k)*tao0));
            else
                HL(k) = 0.5;
            end
%             HL(k) = 1/(1-exp(1j*omega(k)*tao0*(alpha-1)));
%             end
        end
         d = fft(x(i:i+frameLength-1,:).*hann(frameLength));
         Cf = sum(d(1:N/2+1,:).*Hf',2);
         Cb = sum(d(1:N/2+1,:).*Hb',2);
         C = (Cf - beta*Cb).*HL';
%          yd = sum(d(1:129,:),2);
         fftd = [C;conj(flipud(C(1:N/2-1)))];
         y(i:i+frameLength-1) = y(i:i+frameLength-1)+(ifft(fftd));
    end

end

