close all

%% SRP Estimate of Direction of Arrival at Microphone Array
% Frequency-domain delay-and-sum test
%  
%%

% x = filter(Num,1,x0);
c = 340.0;

% XMOS circular microphone array radius
d = 0.0420;
%%
% more test audio file in ../../TestAudio/ folder
path = '../../TestAudio/respeaker/mic1-4_2/';
[s1,fs] = audioread([path,'“ÙπÏ-2.wav']);
s5 = audioread([path,'“ÙπÏ-3.wav']);
s4 = audioread([path,'“ÙπÏ-4.wav']);
s2 = audioread([path,'“ÙπÏ-5.wav']);
signal = [s1,s5,s4,s2];
M = size(signal,2);

% % more test audio file in ../../TestAudio/ folder
% path = '../../TestAudio/XMOS/room_mic5-2/';
% [s1,fs] = audioread([path,'“ÙπÏ-2.wav']);
% s2 = audioread([path,'“ÙπÏ-3.wav']);
% s3 = audioread([path,'“ÙπÏ-4.wav']);
% s4 = audioread([path,'“ÙπÏ-5.wav']);
% s5 = audioread([path,'“ÙπÏ-6.wav']);
% s6 = audioread([path,'“ÙπÏ-7.wav']);
% signal = [s1,s2,s3,s4,s5,s6];

signal = filter(HP_Num,1,signal);
M = size(signal,2);
x = signal;
K = size(x,2);
N = K;
Lh = 128;

Wo = zeros(N*Lh,Lh);
Rvv = zeros(N*Lh,N*Lh);
tic
%% ¿˚”√æ≤“Ù∂Œπ¿º∆‘Î…˘œ‡πÿæÿ’Û
for i = Lh:7000
    n = reshape(x(i-Lh+1:i,:),[],1);
    Rvv = Rvv + n*n';
end
% for i = 52000:length(x(:,1))
%     n = reshape(x(i-Lh+1:i,:),[],1);
%     Rvv = Rvv + n*n';
% end
Rvv = Rvv/(7000-Lh);
Rv1v1 = Rvv(1:Lh,1:Lh);

%% ”Ô“Ù∂Œπ¿º∆–≈∫≈œ‡πÿæÿ’Û
Ryy = zeros(N*Lh,N*Lh);
for i = 20000:24000
    yy = reshape(x(i-Lh+1:i,:),[],1);
    Ryy = Ryy + yy*yy';
end
Ryy = Ryy/(4000);
Ry1y1 = Ryy(1:Lh,1:Lh);

%% º∆À„◊Ó”≈æÿ’Û
for i = 1:N
    Ryny1 = Ryy(i*Lh-Lh+1:i*Lh,1:Lh);
    Rvnv1 = Rvv(i*Lh-Lh+1:i*Lh,1:Lh);
%     Wo(i*Lh-Lh+1:i*Lh,:) = (Ryny1 - Rvnv1)*inv(Ry1y1 - Rv1v1);
    Wo(i*Lh-Lh+1:i*Lh,:) = (Ryny1 - Rvnv1)/(Ry1y1 - Rv1v1);
end

%% vad
block_length =Lh;
%vad = LSTvad(fs,block_length);

%% º∆À„◊Ó”≈»®œÚ¡ø
u = zeros(1,Lh);
u(1) = 1;
h = inv(Rvv)*Wo*inv(Wo'*inv(Rvv)*Wo)*u';
%h = Rvv\Wo*inv(Wo'*Rvv\Wo)*u';
toc
%% ¬À≤®
% hwt = waitbar(0,'please wait...');
ya = zeros(1,length(x(:,1)));
tic
for i = Lh+1:length(x(:,1))
    sig1 = x(i-Lh+1:i,1);
%    [vad,is_noise(i)]=vadProc(vad,sig1',i,length(x(:,1)));
%     decision(i) = vadG729(sig1, VAD_cst_param);
    xx = reshape(x(i-Lh+1:i,:),[],1);
    ya(i) = h'*xx;
%     waitbar(i/length(x(:,1)));
end
toc
% close(hwt);
%xcorr
writeFilePath = 'sound/';
% audiowrite([writeFilePath,'¬À≤®–≈∫≈Lh128_2.wav'],ya,fs);











