%% GCC Estimate of Direction of Arrival at Microphone Array
% Estimate the direction of arrival of a signal using the GCC-PHAT
% algorithm. 
%%

fs=16000;        % sampling frequency (arbitrary)
D=2;            % duration in seconds

L = ceil(fs*D)+1; % signal duration (samples)
n = 0:L-1;        % discrete-time axis (samples)
t = n/fs;         % discrete-time axis (sec)
x = chirp(t,0,D,fs/2)';   % sine sweep from 0 Hz to fs/2 Hz
[x0,fs]=audioread('speech.wav');
x = filter(Num,1,x0);
c = 340.0;
%%
% Create the 5-by-5 microphone URA.
d = 0.25;
N = 2;
mic = phased.OmnidirectionalMicrophoneElement;
array = phased.ULA(N,d,'Element',mic);
% array = phased.URA([N,N],[d,d],'Element',mic);

%%
% Simulate the incoming signal using the |WidebandCollector| System
% object(TM).
arrivalAng = [38;0];
collector = phased.WidebandCollector('Sensor',array,'PropagationSpeed',c,...
    'SampleRate',fs,'ModulatedInput',false);
signal = collector(x,arrivalAng);
% signal = signal(1:4800,:);
%%
% Estimate the direction of arrival.
estimator = phased.GCCEstimator('SensorArray',array,...
    'PropagationSpeed',c,'SampleRate',fs);
ang = estimator(signal)

%%
max_lag = d/c*fs;

% xcorr length
N = (length(signal(:,1))+length(signal(:,2)))-1;

NFFT = 2^nextpow2(N);
interp = 1;

% valid lag index
range = NFFT/2+1-round(max_lag):NFFT/2+1+round(max_lag);
center = round(max_lag)+1;

% cross-spectrum
Pxx = bsxfun(@times, fft(signal(:,1),NFFT),conj(fft(signal(:,2),NFFT)));

%%
% GCC
xcorr13 = fftshift(ifft(Pxx,NFFT));
xcorr13 = xcorr13(range);
[m,index] = max(xcorr13);
ang_gcc13 = asin(((index-center)/fs*c)/d)/pi*180

% GCC-PHAT
xcorr13_phat = fftshift(ifft(Pxx./(abs(Pxx)),NFFT*interp));
xcorr13_phat = xcorr13_phat(range);
[m,index] = max(xcorr13_phat);
ang_gcc13_phat = asin(((index-center)/(fs*interp)*c)/d)/pi*180

%%
frameLen = 0.03*fs;
hopSize = 0.015*fs;
win = hann(frameLen);
interp = 1;
NFFT = 2^nextpow2(2*frameLen*interp-1);
range = NFFT/2+1-round(max_lag)*interp:NFFT/2+1+round(max_lag)*interp;
center = (length(range)+1)/2;
alpha = 0.9;
I = 10;
P = zeros(NFFT,I);
for i=frameLen*I:hopSize:length(signal(:,1)+1)   
    for j=1:I
        x1 = resample(signal(i-hopSize*j-frameLen+1:i-hopSize*j,1).*win,interp,1);
        x2 = resample(signal(i-hopSize*j-frameLen+1:i-hopSize*j,2).*win,interp,1);
        P(:,j) = bsxfun(@times, fft(x1.*1,NFFT),conj(fft(x2.*1,NFFT)));
    end
%     x1 = resample(signal(i:i+frameLen-1,1).*win,interp,1);
%     x2 = resample(signal(i:i+frameLen-1,2).*win,interp,1);
%     Px1x2 = (1-alpha)*Px1x2+alpha*bsxfun(@times, fft(x1.*1,NFFT),conj(fft(x2.*1,NFFT)));
    Px1x2=mean(P,2);
    
    xcorr13_block_phat = fftshift(ifft(bsxfun(@rdivide, Px1x2,abs(Px1x2)),NFFT));
    xcorr13_block_phat = xcorr13_block_phat(range);
    [m,index] = max((xcorr13_block_phat));
    lag = index-center
    gcc_phat = asin(((lag)/(fs*interp)*c)/d)/pi*180
end

%%
% built-in function test
a = gccphat(signal(:,1),signal(:,2));
[m,index] = max(a);
asin((a/fs*c)/d)/pi*180



