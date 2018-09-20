
#ifndef DELAYSUM_H__
#define DELAYSUM_H__


#ifdef  __cplusplus
extern "C" {
#endif

#include<stdint.h>
#include<math.h>

#define Nele 4        //Number of array elements
#define N_FFT 512     //FFT point
#define WinLen 512
#define pi 3.1415926

typedef struct
{
    double real;
    double imag;
}Complex;


    int16_t	DelaySumURA(float **x, float * yout,uint16_t fs,uint32_t DataLen,int16_t N, int16_t frameLength, int16_t inc, float r, int16_t angle);
    int8_t Angle2Radian(float *gamma);
    float * CalculateTau(float *gamma,float angle);
	void srp_Init();
	void srp_destroy();


#ifdef  __cplusplus
}
#endif

#endif  /* OKAOCOMAPI_H__ */

