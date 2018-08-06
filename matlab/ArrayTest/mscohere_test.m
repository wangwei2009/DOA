close all

path = '../../TestAudio/respeaker/mic1-4_2/';
[s1,fs] = audioread([path,'“ÙπÏ-2.wav']);
s5 = audioread([path,'“ÙπÏ-3.wav']);
s4 = audioread([path,'“ÙπÏ-4.wav']);
s2 = audioread([path,'“ÙπÏ-5.wav']);
signal = [s1,s5,s4,s2];

P11 = cpsd(signal(1:8000,1),signal(1:8000,1),hanning(256),128,256);
P22 = cpsd(signal(1:8000,2),signal(1:8000,2),hanning(256),128,256);
P12 = cpsd(signal(1:8000,1),signal(1:8000,2),hanning(256),128,256);

d = 0.0457;
k = 2.8;
% coherence
msc12 = P12./sqrt((P11.*P22));

% find optimal k
f = 0:fs/256:fs/2;
c = 340;
E0 = 100;
k_optimal = 0;
for k = 0.5:0.01:1.5
    T = sin(2*pi*f*d*k/c)./(2*pi*f*d*k/c);T(1) = 0.998;
    E = sum((real(msc12)'-T).^2);
    if(E<E0)
        k_optimal = k;
        E0 = E;
    end
end
% k_optimal = 0.98;
T = sin(2*pi*f*d*k_optimal/c)./(2*pi*f*d*k_optimal/c);T(1) = 0.998;

% error
E = sum((real(msc12)'-T).^2)

figure,plot(real(msc12))
hold on,plot(T)