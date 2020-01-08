function [ angSpectrum] = srp(x,r)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%frequency-domain delay-sum beamformer using circular array
%   
%      input :
%          x : input signal ,samples * channel
%          fs: sample rate
%          N : fft length,frequency bin number
%frameLength : frame length,usually same as N
%        inc : step increment
%          r : array element radius
%      angle : incident angle
%
%     output :
%         DS : delay-sum output
%         x1 : presteered signal,same size as x
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

c = 340;
% r = 0.032;
fs = 16000;

N_FFT = 1024;
frameLength = 1024;
inc = frameLength/2;

X = stft(x,N_FFT,frameLength);

frameNum = size(X,1);
Nele = size(x,2);
half_bin = size(X,3);
N_FFT = (size(X,3)-1)*2;

freRange = [200,3400];
binRange = fix(freRange*N_FFT/fs);
binSlice = binRange(1):binRange(2);

omega = zeros(frameLength,1);
H = ones(half_bin,Nele);
M = Nele;
theta = 90*pi/180; %固定一个俯仰角
gamma = linspace(0,360-360/M,M)'*pi/180;
tao = -r*sin(theta)*cos(angle(1)-gamma)/c;     %方位角 0 < angle <360
yds = zeros(length(x(:,1)),1);
x1 = zeros(size(x));

angSpectrum = zeros(360,frameNum);
% spec = zeros(half_bin,frameNum);

h = waitbar(0,'Please wait...');
fr = 0  ;  
for i = 1:inc:length(x(:,1))-frameLength
    fr = fr + 1;
    for ang = 1:1:360
        tao = -r*sin(theta)*cos(ang*pi/180-gamma)/c;     %方位角 0 < angle <360
         for k = binRange(1):1:binRange(2)
            omega(k) = 2*pi*(k-1)*fs/N_FFT;   
            % steering vector
            H(k,:) = exp(-1j*omega(k)*tao);
         end
        d = fft(bsxfun(@times, x(i:i+frameLength-1,:),hamming(frameLength)));
        x_fft=bsxfun(@times, d(binSlice,:),conj(H(binSlice,:)));
        % phase transformed
        x_fft = bsxfun(@rdivide, x_fft,abs(d(binSlice,:)));
        yf = sum(x_fft,2);
          
        angSpectrum(ang,fr) = yf'*yf;
    end
    waitbar(fr / frameNum)
end
close(h) 
% DS = yds/Nele;  


end

