#include<stdio.h>
#include<stdlib.h>
#include<stdint.h>
#include"wave.h"
#include"DelaySum.h"
#include"win.h"
int main()
{
    Wav wav;

    const char *mic1 = "../../../../TestAudio/respeaker/mic1-4/音轨-2.wav";
    const char *mic2 = "../../../../TestAudio/respeaker/mic1-4/音轨-3.wav";
    const char *mic3 = "../../../../TestAudio/respeaker/mic1-4/音轨-4.wav";
    const char *mic4 = "../../../../TestAudio/respeaker/mic1-4/音轨-5.wav";

    int16_t *data1,*data2,*data3,*data4;

    wavread(&wav,mic1);
    data1 = wav.data;

    wavread(&wav,mic2);
    data2 = wav.data;

    wavread(&wav,mic3);
    data3 = wav.data;

    wavread(&wav,mic4);
    data4 = wav.data;
    printf("fs= \t%d\n", wav.wav_info.fmt.SampleRate);



    return 0;

}
