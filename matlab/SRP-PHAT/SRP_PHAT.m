%% SRP Estimate of Direction of Arrival at Microphone Array
% Estimate the direction of arrival of a signal using the SRP-PHAT
% algorithm. 
%%
%close all
fs=16000;        % sampling frequency (arbitrary)
D=2;            % duration in seconds

L = ceil(fs*D)+1; % signal duration (samples)
n = 0:L-1;        % discrete-time axis (samples)
t = n/fs;         % discrete-time axis (sec)
x = chirp(t,0,D,fs/2)';   % sine sweep from 0 Hz to fs/2 Hz

%% load recorded office noise audio
noisepath = '../../noise/';
[noise2,fs] = audioread([noisepath,'“ÙπÏ-2.wav']);
noise0 = audioread([noisepath,'“ÙπÏ.wav']);
noise5 = audioread([noisepath,'“ÙπÏ-5.wav']);
noise = [noise2,noise0,noise5];

%use a clean speech audio as desired signal
pathname = '../';
[speech ,fs] = audioread([pathname,'speech.wav']);
%scale source signal to obtain 0 dB input SNR    
speech = speech(1:length(noise0))/2;   


% x = filter(Num,1,x0);
c = 340.0;
%%
% Create the 5-by-5 microphone URA.
d = 0.042;
N = 3;
mic = phased.OmnidirectionalMicrophoneElement;
array = phased.ULA(N,d,'Element',mic);
% array = phased.URA([N,N],[d,d],'Element',mic);

%%
% Simulate the incoming signal using the |WidebandCollector| System
% object(TM).
arrivalAng = [15;0];
collector = phased.WidebandCollector('Sensor',array,'PropagationSpeed',c,...
    'SampleRate',fs,'ModulatedInput',false);
s = collector(speech,arrivalAng);
% signal = signal(1:4800,:);
signal = s+noise;

%%
path = '../../TestAudio/44100/';
[noise7,fs] = audioread([path,'“ÙπÏ-7.wav']);
noise0 = audioread([path,'“ÙπÏ.wav']);
noise4 = audioread([path,'“ÙπÏ-4.wav']);
signal = [noise7,noise0,noise4];
%%
t = 0;
P = zeros(1,length(-90:step:90-step));
step = 1;
tic
for i = -90:step:90-step
    [ DS, x1] = phaseshift(signal,fs,256,256,128,d,i/180*pi);
    t = t+1;
    P(t) = DS'*DS;
end
toc
[m,index] = max(P);
figure,plot(-90:step:90-step,P/max(P))
(index-90+step)*step






