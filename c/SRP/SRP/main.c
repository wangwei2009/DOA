#include<stdio.h>
#include<stdlib.h>
#include<stdint.h>
#include"wave.h"
#include"DelaySum.h"
#include "kiss_fftr.h"
#include "kiss_fft.h"
int main()
{
    kiss_fft_cfg cfg = kiss_fft_alloc( 8 ,0 ,NULL,NULL );

    kiss_fft_cpx cx_in[8];
    kiss_fft_cpx cx_out[8];
    for(int i=0;i<9;i++)
    {
        cx_in[i].i=0;
        cx_in[i].r=i*i+i+3;
        printf("cx_in[%d]=%f\n", i,cx_in[i].r);
    }

    kiss_fft( cfg , cx_in , cx_out );
    for(int i=0;i<8;i++)
    {
        printf("cx_out[%d]=%f + %f \n", i,cx_out[i].r,cx_out[i].i);
    }

    Wav wav;

    const char *mic1 = "../../../../TestAudio/respeaker/mic1-4/音轨-2.wav";
    const char *mic2 = "../../../../TestAudio/respeaker/mic1-4/音轨-3.wav";
    const char *mic3 = "../../../../TestAudio/respeaker/mic1-4/音轨-4.wav";
    const char *mic4 = "../../../../TestAudio/respeaker/mic1-4/音轨-5.wav";


    int16_t *data[Nele];

    wavread(&wav,mic1);
    data[0] = wav.data;

    wavread(&wav,mic2);
    data[1] = wav.data;

    wavread(&wav,mic3);
    data[2] = wav.data;

    wavread(&wav,mic4);
    data[3] = wav.data;
    printf("fs= \t%d\n", wav.wav_info.fmt.SampleRate);
    //printf("L= \t%d\n", wav.data_info.Subchunk2Size);

    float r = 0.0457;

    uint16_t fs = wav.fs;

    uint32_t DataLen = wav.samples_per_ch;

    DelaySumURA(data, fs, DataLen,512, 512, 256, r, 30);



    return 0;

}
