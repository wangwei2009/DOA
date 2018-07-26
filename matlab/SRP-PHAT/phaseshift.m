function [ DS, x1] = phaseshift( x,fs,N,frameLength,inc,d,angle)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%frequency-domain delay-sum beamformer
%   
%      input :
%          x : input signal ,samples * channel
%          fs: sample rate
%          N : fft length,frequency bin number
%frameLength : frame length,usually same as N
%        inc : step increment
%          d : array element spacing
%      angle : incident angle
%
%     output :
%         DS : delay-sum output
%         x1 : presteered signal,same size as x
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% N = 256;
% inc = 32;
% frameLength = 256;
c = 340;
Nele = size(x,2);
omega = zeros(frameLength,1);
H = zeros(N/2+1,Nele);
% tao = d*sin(angle(1))*cos(angle(2))*[0:Nele-1]/c;     %方位角 -90 < theta <90
tao = d*sin(angle(1))*[0:Nele-1]/c;     %方位角 -90 < theta <90
yds = zeros(length(x(:,1)),1);
x1 = zeros(size(x));
for i = 1:inc:length(x(:,1))-frameLength
    for k = 2:N/2+1
        omega(k) = 2*pi*(k-1)*fs/N;        
%         H(k,:) = [1;exp(-1j*omega(k)*tao);exp(-1j*omega(k)*2*tao)];
        %对齐向量，以第一个阵元为参考，
        %例如若第一个阵元最慢(theata>0),则将第2、3、....个阵元分别延迟exp(-j*w*m*tao)
%         H(k,:) = [1;exp(-1j*omega(k)*tao);exp(-1j*omega(k)*2*tao);];
        H(k,:) = exp(-1j*omega(k)*tao);
    end
    d = fft(bsxfun(@times, x(i:i+frameLength-1,:),hamming(frameLength)'));
%     d = fft(x(i:i+frameLength-1,:).*hamming(frameLength)');
%     x_fft = d(1:129,:).*H;%./abs(d(1:129,:));
    x_fft=bsxfun(@times, d(1:N/2+1,:),H);
    
    % phase transformed
    x_fft = bsxfun(@rdivide, x_fft,abs(d(1:N/2+1,:)));
    yf = sum(x_fft,2);
    Cf = [yf;conj(flipud(yf(1:N/2-1)))];
    
    % 恢复延时累加的信号
    yds(i:i+frameLength-1) = yds(i:i+frameLength-1)+(ifft(Cf));
    
    
    % 恢复各路对齐后的信号
    xf  = [x_fft;conj(flipud(x_fft(1:N/2-1,:)))];
    x1(i:i+frameLength-1,:) = x1(i:i+frameLength-1,:)+(ifft(xf));
end
DS = yds/Nele;  


end

