/*-------------------------------------------------------------------*/
/*  Copyright(C) 2003-2012 by OMRON Corporation                      */
/*  All Rights Reserved.                                             */
/*                                                                   */
/*   This source code is the Confidential and Proprietary Property   */
/*   of OMRON Corporation.  Any unauthorized use, reproduction or    */
/*   transfer of this software is strictly prohibited.               */
/*                                                                   */
/*-------------------------------------------------------------------*/
/* 
    OKAO_SDK Library API
*/
#ifndef DELAYSUM_H__
#define DELAYSUM_H__


#ifdef  __cplusplus
extern "C" {
#endif

#define N_FFT 512
#define WinLen 512

	int16_t	DelaySumURA(int16_t *x, int16_t fs, int16_t N, int16_t frameLength, int16_t inc, int16_t r, int16_t angle);


#ifdef  __cplusplus
}
#endif

#endif  /* OKAOCOMAPI_H__ */

