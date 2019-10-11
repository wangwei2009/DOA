#pragma once
#ifdef __cplusplus
extern "C" {
#endif

	typedef struct
	{
		int MaxVal;
		int Maxindex;
	}sort_result;

	sort_result findMaxIndex(int *data, int len);
	sort_result BubbleSort(int *data, int len);
	int *QuickSort(int *data,int len);



#ifdef __cplusplus
}
#endif // __cplusplus