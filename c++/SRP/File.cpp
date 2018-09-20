#include "File.h"
#include <iostream>
#include <fstream>
#include<string>
//using namespace std;
void Read_File(float * Indata, int length,const char * FileName)
{
	using namespace std;
	fstream Input_File;
	Input_File.open(FileName, ios::in);
	char ch;
	if (!Input_File)
	{
		cout << "Read "<< FileName<<" Failed" << endl;
		return;
	}
	else cout << "Read " << FileName << " successfully" << endl;

	for (int i = 0; i<length; i++)
	{
		Input_File >> Indata[i];
	    Input_File.get(ch);//>>OutData[i];
	}
	Input_File.close();
}
//void Read_File(MatrixXf &para, std::string  FileName)
//{
//	int r = para.rows();
//	int c = para.cols();
//	using namespace std;
//	fstream Input_File;
//	Input_File.open(FileName, ios::in);
//	char ch;
//	if (!Input_File)
//	{
//		cout << "Read " << FileName << " Failed" << endl;
//		return;
//	}
//	else cout << "Read " << FileName << " successfully" << endl;
//
//	for (int i = 0; i<r; i++)
//	{
//		for (int j = 0; j < c; j++)
//		{
//			if (!Input_File.eof())
//			{
//				Input_File >> para(i, j);
//				Input_File.get(ch);//>>OutData[i];
//			}
//
//		}
//		//cout << para(i, 0) << endl;
//	}
//	Input_File.close();
//}

void Read_File(float * Indata, int length, std::string FileName)
{
	using namespace std;
	fstream Input_File;
	Input_File.open(FileName, ios::in);
	char ch;
	if (!Input_File)
	{
		cout << "Read " << FileName << " Failed" << endl;
		return;
	}
	else cout << "Read " << FileName << " successfully" << endl;

	for (int i = 0; i<length; i++)
	{
		Input_File >> Indata[i];
		Input_File.get(ch);//>>OutData[i];
	}
	Input_File.close();
}


//void Write_File(double **OutData, int r, int c, const char *FileName)
//{
//	using namespace std;
//	ofstream ostrm;
//	ostrm.open(FileName);
//
//	if (ostrm.good())
//	{
//		cout << "successfully" << endl;
//		for (int i = 0; i < r; i++)
//		{
//			//for (int j = 0; j < c; j++)
//			//{
//			//	ostrm << OutData[i][j] << ",";
//
//			//}
//			//ostrm << endl;
//		}
//
//	}
//	else
//	{
//		cout << "Failed!" << endl;
//
//	}
//	ostrm.close();
//
//}
