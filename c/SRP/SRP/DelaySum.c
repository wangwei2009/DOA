#include "DelaySum.h"
#include<stdint.h>
#include<math.h>
#include<stdlib.h>
#include"hamming.h"
#include "kiss_fft.h"

int16_t DelaySumURA(int16_t * * x, int16_t fs, uint32_t DataLen, int16_t N, int16_t frameLength, int16_t inc, float r, int16_t angle)
{

    int16_t half_bin = (N_FFT/2+1);

    // malloc normalized frequency bin
    double *omega = (double *)malloc(half_bin*sizeof(double));


    // malloc frequency bin weights
    complex **H = (complex **)malloc(half_bin*sizeof(complex *));
    for(int16_t i=0;i<half_bin;i++)
        H[i] = (complex *)malloc(Nele*sizeof(complex));

    // malloc frequency bin weights
    complex **xk = (complex **)malloc(half_bin*sizeof(complex *));
    for(int16_t i=0;i<half_bin;i++)
        xk[i] = (complex *)malloc(Nele*sizeof(complex));


    // gamma = [0 90 180 270]*pi/180;//麦克风位置
    float gamma[Nele] = {30,90,150,210,270,330};//麦克风位置

    /* calculate time delay tau*/
    float *tao = CalculateTau(gamma,angle);

    /*Euler's formula e^ix = cos(x)+i*sin(x)*/
    for(int16_t k=16;k<5000*N/fs;k++)
    {
        //Normalized frequency bin
        omega[k]=2*pi*(k-1)*fs/N;

        //steering vector
        for(int8_t i=0;i<Nele;i++)
        {
            double x = omega[k]*tao[i];
//           //H[k][i] = exp(-1*x);
            H[k][i].real = cos(x);
            H[k][i].imag = -1*sin(x);
        }
    }

    //float yds = zeros(length(x(:,1)),1);
    //float x1 = zeros(size(x));


    double *frame_bin ;//= (double *)malloc(frameLength*sizeof(double));

    kiss_fft_cpx cx_in[WinLen];
    kiss_fft_cpx cx_out[WinLen];
    kiss_fft_cfg cfg = kiss_fft_alloc( N_FFT ,0 ,NULL,NULL );


    for(int32_t i = 0;i<DataLen-WinLen;i=i+inc)
    {
        for(uint8_t n = 0;n<Nele;n++)
        {
            for(uint16_t l = i;l<WinLen+i;l++)
            {
                cx_in[l-i].r=x[n][l];
            }
            kiss_fft( cfg , cx_in , cx_out );

        }
        //frame_bin =

//        d = fft(bsxfun(@times, x(i:i+frameLength-1,:),hamming(frameLength)));
//    %     d = fft(x(i:i+frameLength-1,:).*hamming(frameLength)');
//    %     x_fft = d(1:129,:).*H;%./abs(d(1:129,:));
//        x_fft=bsxfun(@times, d(1:N/2+1,:),H);

//        % phase transformed
//        %x_fft = bsxfun(@rdivide, x_fft,abs(d(1:N/2+1,:)));
//        yf = sum(x_fft,2);
//        Cf = [yf;conj(flipud(yf(2:N/2)))];

//        % 恢复延时累加的信号
//        yds(i:i+frameLength-1) = yds(i:i+frameLength-1)+(ifft(Cf));


//        % 恢复各路对齐后的信号
//    %     xf  = [x_fft;conj(flipud(x_fft(2:N/2,:)))];
//    %     x1(i:i+frameLength-1,:) = x1(i:i+frameLength-1,:)+(ifft(xf));
//    end
    }


    //DS = yds/Nele;

    for (int16_t i = 0; i < half_bin; i++)
        free(H[i]);/*释放列*/

    free(H);/*释放行*/

    for (int16_t i = 0; i < half_bin; i++)
        free(xk[i]);/*释放列*/

    free(xk);/*释放行*/

    free(omega);

	return 0;
}

int8_t Angle2Radian(float *gamma)
{
    int8_t i=0;
    for(i=0;i<Nele;i++)
    {
        gamma[i]=gamma[i]*pi/180;
    }
    if(i==Nele)
        return 0;
    else
        return -1;
}
float * CalculateTau(float *gamma,float angle)
{
    int16_t c = 340;
    float r = 0.0457;
    double theta = 90*pi/180; //固定一个俯仰角

    Angle2Radian(gamma);

    for(int8_t i=0;i<Nele;i++)
    {
        double angle_diff = (angle-gamma[i]);

        gamma[i]=r*sin(theta)*cos(angle_diff)/c;
    }

    return gamma;

}
