%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%
%   superdirective beamformer 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
% clear all;
close all;
imag=sqrt(-1);
element_num=5;%阵元数
% d_lamda=1/2;%阵元间距d与波长lamda的关系
theta=linspace(-pi/2,pi/2,180);    %扫描范围
theta0=90;                    %注视方向
theta0 = theta0*pi/180;
% w=exp(-1j*2*pi*d_lamda*sin(theta0)*[0:element_num-1]');
k = 64;
y1 = zeros(128,length(theta));
omega = zeros(1,128);
fs = 8000;
N = 256;
d = 0.05;
c = 340;

% f = (0:fs/256:fs/2)';
f = (1:129)*fs/N;
Nele = element_num;

%% diffuse noise field MSC
Fvv = zeros(129,Nele,Nele);
for i = 1:Nele
    for j = 1:Nele   
        if i == j
            Fvv(:,i,j) = ones(1,N/2+1);
        else
            dij = abs(i-j)*d;
            Fvv(:,i,j) = sin(2*pi*f*dij*1/c)./(2*pi*f*dij*1/c);%T(1) = 0.999;%T(2) = 0.996;
%             Fvv(1,i,j) = 0.9999;
%             Fvv(2,i,j) = 0.9999;
        end
    end
end

%%
H = zeros(Nele,N/2+1);
% H = zeros(N/2+1,Nele);
DI_sdb = zeros(N/2+1,1);  % superdirective directive factor
DI_dsb = zeros(N/2+1,1);  % DS directive factor
y2 = zeros(128,length(theta));
for k = 1:129
% for k = 32:32
for  j=1:length(theta)
    omega(k) = 2*pi*(k-1)*fs/N;
    w0=exp(-1j*omega(k)*d*sin(theta0)/c*[0:element_num-1]');
    a =exp(-1j*omega(k)*d*sin(theta(j))/c*[0:element_num-1]');
    y1(k,j)=w0'*a;
    DI_dsb(k) = (abs(w0'*w0))^2 ...
                /(w0'*squeeze(Fvv(k,:,:))*w0);
    % MVDR soulution
    inv_Fvv = inv(squeeze(Fvv(k,:,:))+1e-6*eye(Nele));
    H(:,k) =    inv_Fvv*w0 ...
                 ./(w0'*inv_Fvv*w0);
    DI_sdb(k) = (abs(H(:,k)'*w0))^2 ...
                /(H(:,k)'*squeeze(Fvv(k,:,:))*H(:,k));
            
    y2(k,j)=H(:,k)'*(a);
    
end
end
figure;
plot(theta*180/pi,pow2db(abs(y2(32,:))/max(max(abs(y2(32,:)))))),grid on
ylim([-40 0]);


figure,mesh(theta*180/pi,(0:1:129-1)*fs/N,pow2db(abs(y1)/max(max(abs(y1)))))
zlim([-40 0]);
figure,mesh(theta*180/pi,(0:1:129-1)*fs/N,pow2db(abs(y2)/max(max(abs(y2)))))
zlim([-40 0]);

figure,plot(pow2db(abs(DI_dsb))),title('delaysum directivity index')
figure,plot(pow2db(abs(DI_sdb))),title('superdirective directivity index')