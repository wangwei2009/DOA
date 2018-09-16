#include<stdio.h>
#include<stdlib.h>
#include<stdint.h>
#include"wave.h"
void main()
{
	FILE *fp = NULL;

	Wav wav;
	RIFF_t riff;
	FMT_t fmt;
	Data_t data;

	fp = fopen("test.wav", "rb");
	if (!fp) {
		printf("can't open audio file\n");
		exit(1);
	}

	fread(&wav, 1, sizeof(wav), fp);

	riff = wav.riff;
	fmt = wav.fmt;
	data = wav.data;

	printf("ChunkID \t%c%c%c%c\n", riff.ChunkID[0], riff.ChunkID[1], riff.ChunkID[2], riff.ChunkID[3]);
	printf("ChunkSize \t%d\n", riff.ChunkSize);
	printf("Format \t\t%c%c%c%c\n", riff.Format[0], riff.Format[1], riff.Format[2], riff.Format[3]);

	printf("\n");

	printf("Subchunk1ID \t%c%c%c%c\n", fmt.Subchunk1ID[0], fmt.Subchunk1ID[1], fmt.Subchunk1ID[2], fmt.Subchunk1ID[3]);
	printf("Subchunk1Size \t%d\n", fmt.Subchunk1Size);
	printf("AudioFormat \t%d\n", fmt.AudioFormat);
	printf("NumChannels \t%d\n", fmt.NumChannels);
	printf("SampleRate \t%d\n", fmt.SampleRate);
	printf("ByteRate \t%d\n", fmt.ByteRate);
	printf("BlockAlign \t%d\n", fmt.BlockAlign);
	printf("BitsPerSample \t%d\n", fmt.BitsPerSample);

	printf("\n");

	printf("blockID \t%c%c%c%c\n", data.Subchunk2ID[0], data.Subchunk2ID[1], data.Subchunk2ID[2], data.Subchunk2ID[3]);
	printf("blockSize \t%d\n", data.Subchunk2Size);

	printf("\n");

	printf("duration \t%d\n", data.Subchunk2Size / fmt.ByteRate);

}