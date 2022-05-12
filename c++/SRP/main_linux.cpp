#include<stdio.h>
#include<stdlib.h>
#include<stdint.h>
#include <fstream>
//#include <sys/unistd.h>

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

//#include <crtdbg.h>

#ifdef _DEBUG
#define New   new(_NORMAL_BLOCK, __FILE__, __LINE__)
#endif
#define _CRTDBG_MAP_ALLO

int main(int argc, char *argv[])
{
	//_CrtSetBreakAlloc(181);
	Wav wav;

    const char *mic1 = "../../../TestAudio/respeaker/mic1-4_2/2.wav";
    const char *mic2 = "../../../TestAudio/respeaker/mic1-4_2/3.wav";
    const char *mic3 = "../../../TestAudio/respeaker/mic1-4_2/4.wav";
    const char *mic4 = "../../../TestAudio/respeaker/mic1-4_2/5.wav";


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

	

	srp_Init();

	clock_t start_time = clock();

	for (uint16_t i = 0; i < 360; i=i+1)
	{
		memset(yout, 0, DataLen * sizeof(float));
		DelaySumURA(data, yout, fs, DataLen, N_FFT, WinLen, 256, r, i);
		//Write_File(yout, DataLen, "yout1.txt");
		for (uint32_t j = 0; j < DataLen; j++)
		{
			E[i] = E[i] + (int)(yout[j] * yout[j]);
		}
		
	}

	//Write_File<int>(E, 360, "E2.txt");

	sort_result result = findMaxIndex(E, 360);

	cout << "peak index = " << result.Maxindex << endl;

	clock_t end_time = clock();
	cout << "time cost:" << 1.0*(end_time - start_time) / CLOCKS_PER_SEC * 1000 << "ms" << endl;

	//result = BubbleSort(E, 360);

	srp_destroy();

	free(yout);
//	for (uint16_t i = 0; i < Nele; i++)
//	{
//		free(data[i]);
//	}





    //_CrtDumpMemoryLeaks();//�������е��ò�����������Ϣ


	return 0;

	

}
