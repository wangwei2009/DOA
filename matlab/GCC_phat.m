%% GCC Estimate of Direction of Arrival at Microphone Array
% Estimate the direction of arrival of a signal using the GCC-PHAT
% algorithm. The receiving array is a 5-by-5-element URA microphone array
% with elements spaced 0.25 meters apart. The arriving signal is a sequence
% of widebandand chirps. The signal arrives from 17&deg; azimuth and 0&deg;
% elevation. Assume the speed of sound in air is 340 m/s.
%
% *Note:* This example runs only in R2016b or later. If you are using an earlier
% release, replace each call to the function with the equivalent |step|
% syntax. For example, replace |myObject(x)| with |step(myObject,x)|.
%%

fs=8000;        % sampling frequency (arbitrary)
D=2;            % duration in seconds

L = ceil(fs*D)+1; % signal duration (samples)
n = 0:L-1;        % discrete-time axis (samples)
t = n/fs;         % discrete-time axis (sec)
x = chirp(t,0,D,fs/2)';   % sine sweep from 0 Hz to fs/2 Hz

% load chirp;
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
arrivalAng = [22;0];
collector = phased.WidebandCollector('Sensor',array,'PropagationSpeed',c,...
    'SampleRate',fs,'ModulatedInput',false);
signal = collector(x,arrivalAng);
%%
% Estimate the direction of arrival.
estimator = phased.GCCEstimator('SensorArray',array,...
    'PropagationSpeed',c,'SampleRate',fs);
ang = estimator(signal)

%%
center = length(signal(:,1)+1);

NFFT = 32768;
interp = 10;

% xcorr length
N = (length(signal(:,1))+length(signal(:,2)))-1;

% valid lag index
range = NFFT/2+1-(N-1)/2:NFFT/2+1+(N-1)/2;

% cross-spectrum
Pxx = fft(signal(:,1),NFFT).*conj(fft(signal(:,2),NFFT));

%%
% GCC
xcorr13 = fftshift(ifft(Pxx));
xcorr13 = xcorr13(range);
[m,index] = max(xcorr13);
ang_gcc13 = asin(((index-center)/fs*c)/d)/pi*180

% GCC-PHAT
xcorr13_phat = fftshift(ifft(Pxx./abs(Pxx),NFFT*interp));
% range = 4*(NFFT/2+1-(N-1)/2):4*(NFFT/2+1+(N-1)/2);
% xcorr13_phat = xcorr13_phat(range);
center = NFFT*interp/2;
[m,index] = max(xcorr13_phat);
ang_gcc13_phat = asin(((index-center)/(fs*interp)*c)/d)/pi*180

%%
a = gccphat(signal(:,1),signal(:,2));
[m,index] = max(a);
asin((a/fs*c)/d)/pi*180



