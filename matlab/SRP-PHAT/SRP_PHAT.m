%% SRP Estimate of Direction of Arrival at Microphone Array
% Estimate the direction of arrival of a signal using the SRP-PHAT
% algorithm. 
%%
close all
fs=16000;        % sampling frequency (arbitrary)
D=2;            % duration in seconds

L = ceil(fs*D)+1; % signal duration (samples)
n = 0:L-1;        % discrete-time axis (samples)
t = n/fs;         % discrete-time axis (sec)
x = chirp(t,0,D,fs/2)';   % sine sweep from 0 Hz to fs/2 Hz
[x,fs]=audioread('../speech.wav');
% x = filter(Num,1,x0);
c = 340.0;
%%
% Create the 5-by-5 microphone URA.
d = 0.05;
N = 8;
mic = phased.OmnidirectionalMicrophoneElement;
array = phased.ULA(N,d,'Element',mic);
% array = phased.URA([N,N],[d,d],'Element',mic);

%%
% Simulate the incoming signal using the |WidebandCollector| System
% object(TM).
arrivalAng = [46;0];
collector = phased.WidebandCollector('Sensor',array,'PropagationSpeed',c,...
    'SampleRate',fs,'ModulatedInput',false);
signal = collector(x,arrivalAng);
% signal = signal(1:4800,:);

%%
t = 0;
P = 0;
step = 1;
tic
for i = -90:step:90
    [ DS, x1] = phaseshift(signal,fs,256,256,128,d,i/180*pi);
    t = t+1;
    P(t) = DS'*DS;
end
toc
[m,index] = max(P);
figure,plot(-90:step:90,P/max(P))
(index-90)*step






