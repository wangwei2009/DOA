%% 
% test superdirective beamformer with real recordings
%  
%%
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

% more test audio file in ../../TestAudio/ folder
path = '../../TestAudio/XMOS/room_mic5-2/';
[s1,fs] = audioread([path,'“ÙπÏ-2.wav']);
s2 = audioread([path,'“ÙπÏ-3.wav']);
s3 = audioread([path,'“ÙπÏ-4.wav']);
s4 = audioread([path,'“ÙπÏ-5.wav']);
s5 = audioread([path,'“ÙπÏ-6.wav']);
s6 = audioread([path,'“ÙπÏ-7.wav']);
signal = [s1,s2,s3,s4,s5,s6];
M = size(signal,2);
%% SRP
t = 0;
% minimal searching grid
step = 1;

P = zeros(1,length(0:step:360-step));
tic
h = waitbar(0,'Please wait...');
for i = 0:step:360-step
    % Delay-and-sum beamforming
    [ DS, x1] = DelaySumURA(signal,fs,512,512,256,d,i/180*pi);
    t = t+1;
    %beamformed output energy
    P(t) = DS'*DS;
    waitbar(i / length(step:360-step))
end
toc
close(h) 
[m,index] = max(P);
figure,plot(0:step:360-step,P/max(P)),ylim([0.86 1])
ang = (index)*step

% ang = 210;
bhi = fir1(512,0.01,'high'); %High-Pass
signal = filter(bhi,1,signal);

%% Delay-sum
[ DS0, x1] = DelaySumURA(signal,fs,1024,1024,512,d,ang/180*pi);
% audiowrite([path,'xmos-DS0.wav'],real(DS0),fs)
%% diffuse noise field MSC
N = 256;

f = (1:N/2+1)*fs/N;
% f(1) = 1e-8;
Fvv = zeros(N/2+1,M,M);
for i = 1:M
    for j = 1:M   
        if i == j
            Fvv(:,i,j) = ones(1,N/2+1);
        else
            if(abs(i-j)==1)
                dij = d;
            elseif(abs(i-j)==2)
                dij = d*sqrt(3);
            elseif(abs(i-j)==3)
                dij=d*2;
            end
            Fvv(:,i,j) = sin(2*pi*f*dij*1/c)./(2*pi*f*dij*1/c);%T(1) = 0.999;%T(2) = 0.996;
        end
    end
end

%% MVDR
[ super1, x1,~,DI] = superdirectiveMVDR(signal,fs,N,N,N/2,d,ang/180*pi,Fvv);
% audiowrite([path,'xmos-super12.wav'],super1,fs)







