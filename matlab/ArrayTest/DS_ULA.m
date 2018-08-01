M=8;                 % 阵元数
c=340;                         % 声速
f = 2125;                      % 信号频率
d = 0.08;                      % 阵元间距
theta=linspace(-pi/2,pi/2,200);% 入射信号角度范围
theta0=30*pi/180;                      % 注视方向
w=exp(1j*2*pi*f*sin(theta0)*[0:M-1]'*d/c);       % 导向向量
p = zeros(length(1:length(theta)),1);
for  j=1:length(theta)                                     % 角度扫描
    a=exp(-1j*2*pi*f*sin(theta(j))*[0:M-1]'*d/c);% 入射信号方向向量
    p(j)=sum(w.*a)/M;                                        % 延时-求和
end
% 画图
figure;
plot(theta/pi*180,abs(p)),grid on
xlabel('degree')
ylabel('amplitude')
title('8阵元均匀线阵方向图')