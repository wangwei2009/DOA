M=8;                 % 阵元数
c=340;                         % 声速
f = 2125;                      % 信号频率
r = 0.08;                      % 阵元间距
phi=linspace(0,2*pi,360);% 入射信号方位角范围

theta = linspace(0,pi/2,90);% 入射信号俯仰角范围

gamma = (0:360/M:360-360/M)*pi/180;%麦克风位置


phi0=130*pi/180;                      % 注视方向
theta0 = 80*pi/180;

w=exp(1j*2*pi*f*r*cos(phi0-gamma)*sin(theta0)/c);       % 导向向量
p = zeros(length(1:length(phi)),length(theta));
for i = 1:length(theta)
    for  j=1:length(phi)                                     % 角度扫描
        a=exp(-1j*2*pi*f*r*cos(phi(j)-gamma)*sin(theta(i))/c);% 入射信号方向向量
        p(j,i)=sum(a.*w)/M;                                        % 延时-求和
    end
end
% 画图
% figure;
% plot(phi/pi*180,abs(p)),grid on
% xlabel('degree')
% ylabel('amplitude')
% title('均匀圆阵方向图')
figure,mesh(abs(p))
