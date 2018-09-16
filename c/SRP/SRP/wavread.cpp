#include <iostream>
#include <fstream>
#include <string.h>
#include "wavread.h"
//#include<math.h>
//#include<cmath>
#include<stdlib.h>
//#include <bitset>
//#include <iomanip>
//要在int main()的前面加上函数的声明，因为你的函数写在main函数的后面
//int hex_char_value(char ss);
//int hex_to_decimal(const char* s);
//string hex_to_binary(char* szHex);
using namespace std;

//struct wav_struct
//{
//	unsigned long file_size;        //文件大小
//	unsigned short channel;            //通道数
//	unsigned long frequency;        //采样频率
//	unsigned long Bps;                //Byte率
//	unsigned short sample_num_bit;    //一个样本的位数
//	unsigned long data_size;        //数据大小
//	unsigned char *data;            //音频数据 ,这里要定义什么就看样本位数了，我这里只是单纯的复制数据
//};

int wavread(const char *Filename, wav_struct* WAV,int pos)
{
    fstream fs;
//	wav_struct WAV;

//	GetWavArgu(Filename, WAV);

    fs.open(Filename, ios::binary | ios::in);
    if (!fs.is_open())
    {
        cout << "File opended failed!";
        return 0;
    }

    //    fs.seekg(0x04);                //从文件数据中获取文件大小
    //    fs.read((char*)&WAV.file_size,sizeof(WAV.file_size));
    //    WAV.file_size+=8;

    fs.seekg(0, ios::end);        //用c++常用方法获得文件大小
    WAV->file_size = fs.tellg();

/*	fs.seekg(0x16);
    fs.read((char*)&WAV.channel, sizeof(WAV.channel));

    fs.seekg(0x18);
    fs.read((char*)&WAV.frequency, sizeof(WAV.frequency));

    fs.seekg(0x1c);
    fs.read((char*)&WAV.Bps, sizeof(WAV.Bps));

    fs.seekg(0x22);
    fs.read((char*)&WAV.sample_num_bit, sizeof(WAV.sample_num_bit));


    char temp;
    char t[3];
    char count = 0x24;
    //fs.read((char*)&WAV.sample_num_bit, sizeof(WAV.sample_num_bit));
    while (count<=128)
    {
        fs.seekg(count);
        fs.read((char*)&temp, 1);
        if (temp == 'd')
        {
            fs.read((char*)&t, 3);
            if (t[0] == 'a')
                if (t[1] == 't')
                {
                    if (t[2] == 'a')
                    {
                        count = count + 4;
                        break;
                    }
                }
        }
        else
            count++;
    }*/

    WAV->data = new char[WAV->data_size];
    fs.seekg(pos,ios::beg);
    fs.read((char *)WAV->data, sizeof(char)*WAV->data_size);


    /*
    fs.seekg(0x2c);
    fs.read((char *)WAV.data, sizeof(char)*WAV.data_size);

    cout << "文件大小为  ：" << WAV.file_size << endl;
    cout << "音频通道数  ：" << WAV.channel << endl;
    cout << "采样频率    ：" << WAV.frequency << endl;
    cout << "Byte率      ：" << WAV.Bps << endl;
    cout << "样本位数    ：" << WAV.sample_num_bit << endl;
    int N_PER_CHANNEL = (WAV.data_size / WAV.channel) / (WAV.sample_num_bit / 8);
    cout << "音频数据个数：" << N_PER_CHANNEL << "*" << WAV.channel << endl;//总大小除以通道数得单通道数据大小，再除以每个数据占的字节数得到每个通道数据个数
    cout << "音频数据大小：" << WAV.data_size  << endl;
    */
    unsigned int count = 0;
    //ofstream ostrm;
    //ostrm.open("wav2.txt");
    //if (ostrm.good())
    //if (1)
    {
        int sample_size = WAV->sample_num_bit / 8;
        cout << "successfully" << endl;
        for (int i = 0; i < WAV->data_size; i = i+ sample_size*WAV->channel)
        {

            //右边为大端
            unsigned long data_low = (unsigned char)WAV->data[i];
            unsigned long data_high = (unsigned char)WAV->data[i + 1];
            //double data_true = data_high <<8 + data_low;
            double data_true = data_high * 256 + data_low;
            //printf("%d ",data_true);
            long data_complement = 0;
            //取大端的最高位（符号位）
            int my_sign = (int)(data_high >>7);
            //int my_sign = (int)(data_high /128);
            //printf("%d ", my_sign);
            if (my_sign == 1)
            {
                data_complement = data_true - 65536;
            }
            else
            {
                data_complement = data_true;
            }
            //printf("%d ", data_complement);
            //setprecision(4);
            double float_data = (double)(data_complement / (double)32768);
            WAV->wavdata[count] = float_data;
            //cout << WAV->wavdata[count] << endl;
            //ostrm << WAV->wavdata[count];
            //printf("%f ", float_data);

            //for (int j = 0; j < c; j++)
            //{
            //	ostrm << OutData[i][j] << ",";

            //}
            //ostrm << endl;
            count++;
        }

    }
    //else
    //{
    //	cout << "Failed!" << endl;

    //}
    //ostrm.close();
    fs.close();


    //delete[] WAV->data;                          //内存回收

    //system("pause");
    return 0;

}
int GetWavArgu(const char *Filename,wav_struct* WAV)
{
    fstream fs;
    fs.open(Filename, ios::binary | ios::in);
    if (!fs.is_open())
    {
        cout << "File opended failed!";
        return -1;

    }

    //    fs.seekg(0x04);                //从文件数据中获取文件大小
    //    fs.read((char*)&WAV.file_size,sizeof(WAV.file_size));
    //    WAV.file_size+=8;

    fs.seekg(0, ios::end);        //用c++常用方法获得文件大小
    WAV->file_size = fs.tellg();

    fs.seekg(0x16);
    fs.read((char*)&WAV->channel, 2);

    fs.seekg(0x18);
    fs.read((char*)&WAV->frequency,4);

    fs.seekg(0x1c);
    fs.read((char*)&WAV->Bps, 4);

    fs.seekg(0x22);
    fs.read((char*)&WAV->sample_num_bit, 2);

    char temp;
    char t[3];
    int count = 0x24;
    //fs.read((char*)&WAV.sample_num_bit, sizeof(WAV.sample_num_bit));
    while (count <= 128)
    {
        fs.seekg(count);
        fs.read((char*)&temp, 1);
        if (temp == 'd')
        {
            fs.read((char*)&t, 3);
            if (t[0] == 'a')
                if (t[1] == 't')
                {
                    if (t[2] == 'a')
                    {
                        count = count + 4;
                        break;
                    }
                }
        }
        else
            count++;
    }

    fs.seekg(count);
    fs.read((char*)&WAV->data_size, sizeof(WAV->data_size));

    //WAV->data = new unsigned char[WAV->data_size];

    cout << "file_size      " << WAV->file_size << endl;
    cout << "channel        " << WAV->channel << endl;
    cout << "frequency      " << WAV->frequency << endl;
    cout << "Bps            " << WAV->Bps << endl;
    cout << "sample_num_bit " << WAV->sample_num_bit << endl;
    WAV->num_per_channel =  (WAV->data_size / WAV->channel) / (WAV->sample_num_bit / 8);
    cout << "num_per_channel" << WAV->num_per_channel << "*" << WAV->channel << endl;//总大小除以通道数得单通道数据大小，再除以每个数据占的字节数得到每个通道数据个数

    fs.close();
    return count+4;
}
//int hex_char_value(char c)
//{
//	if (c >= '0' && c <= '9')
//		return c - '0';
//	else if (c >= 'a' && c <= 'f')
//		return (c - 'a' + 10);
//	else if (c >= 'A' && c <= 'F')
//		return (c - 'A' + 10);
//	//assert(0);
//	return 0;
//}
//int hex_to_decimal(char* szHex)
//{
//	int len = 2;
//	int result = 0;
//	for (int i = 0; i < len; i++)
//	{
//		result += (int)pow((float)16, (int)len - i - 1) * hex_char_value(szHex[i]);
//	}
//	return result;
//}
/*
string hex_to_binary(char* szHex)
{
int len = 2;
string result;
for (int i = 0; i < len;i++)
}
*/
