
close all
path = 'rec1/';
% path = '../../TestAudio/respeaker/rec3-mic1/';
% interval = 40000:160000;
[s1,fs] = audioread([path,'“ÙπÏ-2.wav']);
s5 = audioread([path,'“ÙπÏ-3.wav']);
s4 = audioread([path,'“ÙπÏ-4.wav']);
s2 = audioread([path,'“ÙπÏ-5.wav']);
x = [s1,s5,s4,s2];

tic
angSpectrum = srp(x,0.032);
toc
figure,mesh(10*log10(angSpectrum)),title('angel spectrum');
[ma,in] = max(10*log10(angSpectrum));
pt(in),ylim([1,360]);
in_med = medfilt1(in,5);
pt(in_med),ylim([1,360]);
pt(mean(angSpectrum,2)/max(mean(angSpectrum,2)))
[ma,in] = max(mean(angSpectrum,2)/max(mean(angSpectrum,2)))

% angSpectrum_sum = sum(angSpectrum(1:180,:));
% angSpectrum_norm = angSpectrum(1:180,:)./angSpectrum_sum;
% angSpectrum_incident = sum(angSpectrum_norm(60:120,:));