#include<stdio.h>
#include<stdlib.h>
#include<stdint.h>
#include"wave.h"
int main()
{
    Wav wav;
    wavread(&wav,"room3.wav");
    printf("fs= \t%d\n", wav.wav_info.fmt.SampleRate);

    return 0;

}
