M=8;                 % 阵元数
c=340;                         % 声速
f = 3000;                      % 信号频率
r = 0.0457;                      % 阵元间距
phi=linspace(0,2*pi,360);% 入射信号角度范围

theta = 80*pi/180; %固定一个俯仰角
gamma = (0:360/M:360-360/M)*pi/180;%麦克风位置

tao = r*sin(theta)*cos(angle(1)-gamma)/c;     %方位角 0 < angle <360

phi0=317*pi/180;                      % 注视方向
w=exp(1j*2*pi*f*r*cos(phi0-gamma)*sin(theta)/c);       % 导向向量
p = zeros(length(1:length(phi)),1);
for  j=1:length(phi)                                     % 角度扫描
    a=exp(-1j*2*pi*f*r*cos(phi(j)-gamma)*sin(theta)/c);% 入射信号方向向量
    p(j)=sum(w.*a)/M;                                        % 延时-求和
end
% 画图
figure;
plot(phi/pi*180,abs(p)),grid on
xlabel('degree')
ylabel('amplitude')
title('均匀圆阵方向图')

figure,polarplot(phi,abs(p))