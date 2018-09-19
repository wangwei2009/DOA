#include<stdio.h>
#include<stdlib.h>
#include<stdint.h>
#include"wave.h"
#include"DelaySum.h"
#include "kiss_fftr.h"
#include "kiss_fft.h"
#include "kiss_fftr.h"
int main()
{
    kiss_fftr_cfg cfg = kiss_fftr_alloc( 8 ,1 ,0,0 );


	kiss_fft_cpx cx_in[5];
	kiss_fft_scalar cx_out[8];

    for(int i=0;i<5;i++)
    {
        cx_in[i].i=-1*i;
        cx_in[i].r=i*i*5.6+1.4*i+3;
        printf("cx_in[%d]=%f\n", i,cx_in[i].r);
    }

    kiss_fftri( cfg , cx_in,cx_out);
    for(int i=0;i<8;i++)
    {
		printf("cx_out[%d]=%f\n", i, cx_out[i]);
        //printf("cx_out[%d]=%f + %f \n", i,cx_out[i].r,cx_out[i].i);
    }
	free(cfg);

    Wav wav;

    const char *mic1 = "../../../TestAudio/respeaker/mic1-4/2.wav";
    const char *mic2 = "../../../TestAudio/respeaker/mic1-4/3.wav";
    const char *mic3 = "../../../TestAudio/respeaker/mic1-4/4.wav";
    const char *mic4 = "../../../TestAudio/respeaker/mic1-4/5.wav";


    float *data[Nele];

    wavread(&wav,mic1);
    data[0] = wav.dataf;

    wavread(&wav,mic2);
    data[1] = wav.dataf;

    wavread(&wav,mic3);
    data[2] = wav.dataf;

    wavread(&wav,mic4);
    data[3] = wav.dataf;
    printf("fs= \t%d\n", wav.wav_info.fmt.SampleRate);
    printf("L= \t%d\n", wav.samples_per_ch);

    float r = 0.0457;

    uint16_t fs = wav.fs;

    uint32_t DataLen = wav.samples_per_ch;

	float *yout = (float *)malloc(DataLen * sizeof(float));

	float E[360];

	for (uint16_t i = 0; i < 360; i++)
	{
		DelaySumURA(data, yout, fs, DataLen, N_FFT, WinLen, 256, r, i);
		for (uint16_t j = 0; j < DataLen; j++)
		{
			E[j] = E[j] + yout[j] * yout[j];
		}
	}

    //DelaySumURA(data, yout,fs, DataLen,N_FFT, WinLen, 256, r, 30);

	free(yout);



    return 0;

}
