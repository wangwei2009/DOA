%% SRP Estimate of Direction of Arrival at Microphone Array
% Frequency-domain delay-and-sum test
%  
%%

% x = filter(Num,1,x0);
c = 340.0;

% XMOS circular microphone array radius
d = 0.0457;
%%
% more test audio file in ../../TestAudio/ folder
path = '../../TestAudio/respeaker/mic1-4_2/';
[s1,fs] = audioread([path,'“ÙπÏ-2.wav']);
s5 = audioread([path,'“ÙπÏ-3.wav']);
s4 = audioread([path,'“ÙπÏ-4.wav']);
s2 = audioread([path,'“ÙπÏ-5.wav']);
signal = [s1,s5,s4,s2];
M = size(signal,2);
%%
t = 0;

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
% figure,plot(0:step:360-step,P/max(P))
% ang = (index)*step

ang = 319;

% [ DS, x1] = DelaySumURA(signal,fs,1024,1024,512,d,ang/180*pi);

%% diffuse noise field MSC
N = 256;
f = (1:129)*fs/N;
Fvv = zeros(129,M,M);
for i = 1:M
    for j = 1:M   
        if i == j
            Fvv(:,i,j) = ones(1,N/2+1);
        else
            if(mod(abs(i-j),2)==0)
                dij = d*2;
            else
                dij = d*sqrt(2);
            end
            Fvv(:,i,j) = sin(2*pi*f*dij*1/c)./(2*pi*f*dij*1/c);%T(1) = 0.999;%T(2) = 0.996;
%             Fvv(1,i,j) = 0.99;
%             Fvv(2,i,j) = 0.99;
        end
    end
end

[ DS, x1,~,DI] = superdirectiveMVDR(signal,fs,256,256,128,d,ang/180*pi,Fvv);
% audiowrite('super2.wav',DS,fs)
% audiowrite('DS7.wav',real(DS),fs)
% audiowrite('signal1.wav',signal(:,1),fs)

% [ z ] = postprocessing(signal,0,fs,(index)*step);
% audiowrite('z1.wav',z,fs)






