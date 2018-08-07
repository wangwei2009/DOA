function [ z ] = postprocessing( x,DS0,fs,angle)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  General post-filter based on noise filed coherence  
%
%  Author: wangwei
%  Data  : 12/5/2017
%  env   : test in matlab 2012b
%  refer to:
%  "Microphone Array Post-Filter Based on Noise Field Coherence" IEEE 2003
%  "MICROPHONE ARRAY POST-FILTER FOR DIFFUSE NOISE FIELD"  IEEE 2002
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DEBUG = 0;
%%
Nele = size(x,2);
% x = s;
N = 256;
inc = 128;
frameLength = 256;
% angle = [80;0];
% angle = [-31.9500;-45.7377];
angle = angle*pi/180;
d = 0.0457;
% [ DS0, x1] = DelaySumURA(x,fs,N,frameLength,inc,d,angle);
x = real(x);
% DS0 = sum(x,2)/Nele;
% x = x;
% compute input SNR
% noiseDS = sum(noise,2);
% SNR_input = 10*log10(sum(speech.^2)/sum(noiseDS.^2))


%% 
N = Nele;
L = 256;                   %32 ms

% window = hamming(L);
window = triang(L);
% window = ones(L,1);
% window = repmat(ham,1,N)';

P_len = 129;


z = zeros(1,length(x(:,1)));
% z = y;

t = 1;
%%


%the distance between two adjacent microphone,XMOS microphone array board
%was used
r = 0.0457; 

% the distance between two microphone
dij = [r,sqrt(2)*r,r,...
       r,r*sqrt(2),...
       r
       ];
%    dij = [r,2*r,r];
f = 0:fs/256:fs/2;
c = 343;
    
% T = T0;
Inc = 64;  
tic
%hwt = waitbar(0,'general poster filter');
%   Wiener post-filter transfer function
%           Pss
%   h = -------------
%       Pss  +  Pnn
%
frame_len = 256;
fft_len = frameLength;
inc = 128;
nchs = Nele;
x0 = enframe(x(:, 1), rectwin(frame_len), inc,'z');
DS = enframe(DS0, window, inc,'z')';
DS_FFT = fft(DS);
frameNum = size(x0, 1);
X = zeros(nchs,fft_len,size(x0, 1)); 
Pxii = zeros(nchs, fft_len/2+1 , size(x0, 1)); 
Pxij = zeros(Nele*(Nele-1)/2, fft_len/2+1 , size(x0, 1)); 
Pss_e = zeros(Nele*(Nele-1)/2, fft_len/2+1 , size(x0, 1)); 

% 计算自功率谱
for ch = 1:nchs
    X(ch,:, :) = enframe(x(:, ch), hann(frame_len)', inc,'z')';
    Pxii(ch, :, :) = cpsd(squeeze(X(ch,:, :)),squeeze(X(ch,:, :)), hanning(128), 64);
end
Pssnn = sum(Pxii)/Nele;
Pssnn = squeeze(Pssnn);
% T = sin(2*pi*f*dij(t)*2/c)./(2*pi*f*dij(t)*2/c);T(1) = 0.998;%T(2) = 0.996;
% T = repmat(T',1,size(x0, 1));
% T = repmat(T,1,size(x0, 1));
% 计算互功率谱
for i = 1:Nele-1
    for j = i+1:Nele
        Pxij(t,:,:) = cpsd(squeeze(X(i,:, :)),squeeze(X(j,:, :)),hanning(128),64);
        T = sin(2*pi*f*dij(t)*1.8/c)./(2*pi*f*dij(t)*1.8/c);T(1) = 0.999;%T(2) = 0.996;
        T = repmat(T',1,size(x0, 1));
        Pss_e(t,:,:) = (real(squeeze(Pxij(t,:,:))) - 0.5*real(T).*(squeeze(Pxii(i,:,:))+squeeze(Pxii(j,:,:))))...
                         ./...
                         (ones(P_len,frameNum) - real(T));
        t = t+1;
    end
end
% take the average of multichanel signal to improve robustness
if N==2
    Pss = squeeze(Pss_e); 
else
    Pss = sum(Pss_e,1)*2/(N*N-1); 
    Pss = squeeze(Pss);
end
for frameIndex = 1:frameNum-1
    % take the average of multichanel signal to improve robustness
%     if N==2
%         Pss = Pss_e(:,:,frameIndex); 
%     else
%         Pss = sum(Pss_e(:,:,frameIndex))*2/(N*N-1); 
%     end
        
    
    % handle the indeterminite soulution when MSC≈1
    Pss(Pss<0) = 0;
    
    % calculate the frequency domain filter coefficient
    W_e = real(Pss(:,frameIndex))./Pssnn(:,frameIndex);
    W_e = W_e.';
    % interpolate filter to match the length of the signal
%     W_e_i = interp1(1:length(W_e),W_e,1:.5:length(W_e));

    % get the final filter coefficient,matlab CPSD function we used above only get the
    % oneside PSD,but fft(signal) is twoside,so we add the conjugate side
    W = [W_e,conj(fliplr(W_e(2:128)))];
%     W = [W_e_i,conj(fliplr(W_e_i(2:256)))];

    % transfor the signal to frequency domain
%     Xds = fft([DS(p:p+L-1)'].*window');
    
    % filter the signal 
    DS_filtered = W.*(DS_FFT(:,frameIndex).');
    
    % get the time domain signal
    iX = ifft(DS_filtered);
    s_est = iX(1:L);
    
    % keep the signal
%     z(p:p+L-1) = z(p:p+L-1) + s_est;
%     frameIndex
    z((frameIndex-1)*inc+1:(frameIndex-1)*inc+fft_len) = ...
    z((frameIndex-1)*inc+1:(frameIndex-1)*inc+fft_len) + s_est;
    

%     waitbar(frameIndex/frameNum);
end
% close(hwt);
% toc
z = real(z);
% compute output SNR
% SNR_output = 10*log10(sum(zspeech.^2)/sum(znoise.^2))

% figure,plot(z)
% sound(z)





end

