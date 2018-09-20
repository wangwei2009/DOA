#include<stdio.h>
#include<stdlib.h>
#include<stdint.h>
#include <fstream>
#include"DelaySum.h"
#include "kiss_fftr.h"
#include "kiss_fft.h"
#include "kiss_fftr.h"
#include "File.h"
#include "Sort.h"

#include<iostream>

#include<time.h>
using namespace std;

extern "C"
{
   #include"wave.h"

}

int main()
{
	kiss_fftr_cfg cfg = kiss_fftr_alloc(8, 1, 0, 0);


	kiss_fft_cpx cx_in[5];
	kiss_fft_scalar cx_out[8];

	for (int i = 0; i<5; i++)
	{
		cx_in[i].i = -1 * i;
		cx_in[i].r = i*i*5.6 + 1.4*i + 3;
		printf("cx_in[%d]=%f\n", i, cx_in[i].r);
	}

	kiss_fftri(cfg, cx_in, cx_out);
	for (int i = 0; i<8; i++)
	{
		printf("cx_out[%d]=%f\n", i, cx_out[i]);
		//printf("cx_out[%d]=%f + %f \n", i,cx_out[i].r,cx_out[i].i);
	}
	free(cfg);

	Wav wav;

	const char *mic1 = "../../TestAudio/respeaker/mic1-4/2.wav";
	const char *mic2 = "../../TestAudio/respeaker/mic1-4/3.wav";
	const char *mic3 = "../../TestAudio/respeaker/mic1-4/4.wav";
	const char *mic4 = "../../TestAudio/respeaker/mic1-4/5.wav";


	float *data[Nele];

	wavread(&wav, mic1);
	data[0] = wav.dataf;

	wavread(&wav, mic2);
	data[1] = wav.dataf;

	wavread(&wav, mic3);
	data[2] = wav.dataf;

	wavread(&wav, mic4);
	data[3] = wav.dataf;
	printf("fs= \t%d\n", wav.wav_info.fmt.SampleRate);
	printf("L= \t%d\n", wav.samples_per_ch);

	float r = 0.0457;

	uint16_t fs = wav.fs;

	uint32_t DataLen = wav.samples_per_ch;

	float *yout = (float *)malloc(DataLen * sizeof(float));
	//static float *yout = new float[DataLen];


	int E[360] = { 0 };

	clock_t start_time = clock();

	for (uint16_t i = 0; i < 360; i=i+1)
	{
		memset(yout, 0, DataLen * sizeof(yout));
		DelaySumURA(data, yout, fs, DataLen, N_FFT, WinLen, 256, r, i);
		//Write_File(yout, DataLen, "yout1.txt");
		for (uint32_t j = 0; j < DataLen; j++)
		{
			E[i] = E[i] + (int)(yout[j] * yout[j]);
		}
		
	}

	//Write_File<int>(E, 360, "E.txt");

	sort_result result = BubbleSort(E, 360);

	cout << "peak index = " << result.Maxindex << endl;

	clock_t end_time = clock();
	cout << "time cost:" << 1.0*(end_time - start_time) / CLOCKS_PER_SEC * 1000 << "ms" << endl;

	//result = BubbleSort(E, 360);

	free(yout);
	//delete []yout;



	return 0;

}
