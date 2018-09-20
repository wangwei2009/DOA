#pragma once

//#include "Eigen/Core"
#include <fstream>
#include<string>
#include <iostream>
//using namespace Eigen;
void Read_File(float *Indata, int size,const char *FileName);
//void Read_File(MatrixXf &para, std::string  FileName);
//void Read_File(float *Indata, int size, std::string  FileName);
//void Write_File(float *OutData, int L, const char *FileName);


/* 模板函数的定义和声明需要放在一起 */
template<typename T>
void Write_File(T * OutData, int L, const char *FileName)
{
	using namespace std;
	ofstream ostrm;
	ostrm.open(FileName);

	if (ostrm.good())
	{
		cout << "successfully" << endl;
		for (int i = 0; i < L; i++)
		{
			ostrm << OutData[i] << ",";
			ostrm << endl;
		}

	}
	else
	{
		cout << "Failed!" << endl;

	}
	ostrm.close();

}
