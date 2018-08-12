%% SRP Estimate of Direction of Arrival at Microphone Array
% Frequency-domain delay-and-sum test
%  
%%

% x = filter(Num,1,x0);
c = 340.0;

% XMOS circular microphone array radius
r = 0.0420;
%%
% more test audio file in ../../TestAudio/ folder
path = '../../../TestAudio/respeaker/mic1-4_2/';
[s1,fs] = audioread([path,'音轨-2.wav']);
s5 = audioread([path,'音轨-3.wav']);
s4 = audioread([path,'音轨-4.wav']);
s2 = audioread([path,'音轨-5.wav']);
signal = [s1,s5,s4,s2];
M = size(signal,2);

% more test audio file in ../../TestAudio/ folder
path = '../../../TestAudio/XMOS/room_mic5-2/';
[s1,fs] = audioread([path,'音轨-2.wav']);
s2 = audioread([path,'音轨-3.wav']);
s3 = audioread([path,'音轨-4.wav']);
s4 = audioread([path,'音轨-5.wav']);
s5 = audioread([path,'音轨-6.wav']);
s6 = audioread([path,'音轨-7.wav']);
signal = [s1,s2,s3,s4,s5,s6];
M = size(signal,2);
%%
t = 0;
N = 256;
frameLength=256;
inc=128;
% 利用无语音段段估计噪声功率谱密度
for i = 1:M
    frame(:,:,i) = enframe(signal(1:15000,i),hamming(N,'periodic'),N/2);
    fft_frame(i,:,:) = fft(squeeze(frame(:,:,i))');
end
for k = 1:N/2+1
    pzz(k,:,:) = squeeze(fft_frame(:,i,:))*squeeze(fft_frame(:,i,:))';
end



% minimal searching grid
% step = 1;
% 
% P = zeros(1,length(0:step:360-step));
% tic
% h = waitbar(0,'Please wait...');
% for i = 0:step:360-step
%     % Delay-and-sum beamforming
%     [ DS, x1] = DelaySumURA(signal,fs,512,512,256,d,i/180*pi);
%     t = t+1;
%     %beamformed output energy
%     P(t) = DS'*DS;
%     waitbar(i / length(step:360-step))
% end
% toc
% close(h) 
% [m,index] = max(P);
% figure,plot(0:step:360-step,P/max(P)),ylim([0.86 1])
% ang = (index)*step

ang = 233;

% [ DS0, x1] = DelaySumURA(signal,fs,1024,1024,512,d,ang/180*pi);
% DS = filter(HP_Num,1,DS0);
% audiowrite([path,'xmos-DS0.wav'],real(DS0),fs)
%% diffuse noise field MSC
N = 256;

c = 340;
Nele = size(x,2);
omega = zeros(frameLength,1);
W = ones(N/2+1,Nele);

theta = 90*pi/180; %固定一个俯仰角
gamma = [0 90 180 270]*pi/180;%麦克风位置

gamma = [30 90 150 210 270 330]*pi/180;%麦克风位置
tao = r*sin(theta)*cos(ang-gamma)'/c;     %方位角 0 < angle <360
yds = zeros(length(x(:,1)),1);
x1 = zeros(size(x));

% frequency bin weights
% for k = 2:1:N/2+1
for k = 10:1:N/2+1
    omega(k) = 2*pi*(k-1)*fs/N; 
    ak = exp(-1j*omega(k)*tao);
    % steering vector
    pzz_k = squeeze(pzz(k,:,:));
    W(k,:) = inv(pzz_k)*ak./...
             (ak'*inv(pzz_k)*ak);
end

for i = 1:inc:length(x(:,1))-frameLength

%     d = zeros(N,Nele);
%     d(33,:) = 1;
    d = fft(x(i:i+frameLength-1,:).*hamming(frameLength));
%     x_fft = dot(H.',d(1:129,:),2);
    x_fft = W.*d(1:N/2+1,:);
    yf = sum(x_fft,2);
    Cf = [yf;conj(flipud(yf(2:N/2)))];
    
    % 恢复延时累加的信号
    yds(i:i+frameLength-1) = yds(i:i+frameLength-1)+(ifft(Cf));
    
    
    % 恢复各路对齐后的信号
    xf  = [x_fft;conj(flipud(x_fft(2:N/2,:)))];
    x1(i:i+frameLength-1,:) = x1(i:i+frameLength-1,:)+(ifft(xf));
end






