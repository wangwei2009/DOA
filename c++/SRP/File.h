#pragma once
#include "Eigen/Core"
#include<string>
#include <iostream>
using namespace Eigen;
void Read_File(float *Indata, int size,const char *FileName);
void Read_File(MatrixXf &para, std::string  FileName);
void Read_File(float *Indata, int size, std::string  FileName);
void Write_File(float *OutData, int L, const char *FileName);
