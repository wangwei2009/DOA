function [ DS, x1,H,DI] = superdirectiveMVDR( x,fs,N,frameLength,inc,r,angle,Fvv)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% superdirective beamformer
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
H = ones(N/2+1,Nele)';

theta = 90*pi/180; %固定一个俯仰角
gamma = [0 90 180 270]*pi/180;%麦克风位置
tao = r*sin(theta)*cos(angle(1)-gamma)/c;     %方位角 0 < angle <360
yds = zeros(length(x(:,1)),1);
x1 = zeros(size(x));
DI = zeros(N/2+1,1);

for k = 1:N/2+1
%         inv_Fvv = inv(squeeze(Fvv(k,:,:)));
        omega(k) = 2*pi*(k-1)*fs/N;    
        
        % 方向向量
        d = exp(-1j*omega(k)*tao');
%         H(k,:) = [1;exp(-1j*omega(k)*tao);exp(-1j*omega(k)*2*tao)];
        %对齐向量，以第一个阵元为参考，
        %例如若第一个阵元最慢(theata>0),则将第2、3、....个阵元分别延迟exp(-j*w*m*tao)
%         H(k,:) = [1;exp(-1j*omega(k)*tao);exp(-1j*omega(k)*2*tao);];

        % MVDR soulution
%         Fvvk = diag(ones(1,Nele));%squeeze(Fvv(k,:,:));
        Fvv_k = (squeeze(Fvv(k,:,:))+1e-12*eye(Nele));
        if(1)%k~=31&&k~=20&&k~=16)
        H(:,k) =    Fvv_k\d ...
                 ./(d'/Fvv_k*d);
%         H(:,k) =   1;
        DI(k) = (abs(H(:,k)'*d))^2 ...
                /(H(:,k)'*squeeze(Fvv(k,:,:))*H(:,k));
        else
         H(:,k) = d;
        end
end
for i = 1:inc:length(x(:,1))-frameLength

%     d = zeros(N,Nele);
%     d(33,:) = 1;
    d = fft(x(i:i+frameLength-1,:).*hamming(frameLength));
%     x_fft = dot(H.',d(1:129,:),2);
    x_fft = H.'.*d(1:129,:);
    yf = sum(x_fft,2);
    Cf = [yf;conj(flipud(yf(2:128)))];
    
    % 恢复延时累加的信号
    yds(i:i+frameLength-1) = yds(i:i+frameLength-1)+(ifft(Cf));
    
    
    % 恢复各路对齐后的信号
    xf  = [x_fft;conj(flipud(x_fft(2:128,:)))];
    x1(i:i+frameLength-1,:) = x1(i:i+frameLength-1,:)+(ifft(xf));
end
DS = real(yds);  
% DI = pow2db(abs(DI));

end

