//int hex_char_value(char ss);
//int hex_to_decimal(const char* s);
#ifndef WAVREAD_H
#define WAVREAD_H
struct wav_struct
{
    unsigned int file_size;        //文件大小
	unsigned short channel;            //通道数
    unsigned int frequency;        //采样频率
	unsigned long Bps;                //Byte率
	unsigned short sample_num_bit;    //一个样本的位数
    unsigned int data_size;        //数据大小
    unsigned int num_per_channel;
    char *data;            //音频数据 ,复制char数据
	double *wavdata;                //存储转换后的浮点数
};

int GetWavArgu(const char *Filename,wav_struct* arg );
int wavread(const char *Filename, wav_struct* arg,int pos);

#endif // WAVREAD_H
