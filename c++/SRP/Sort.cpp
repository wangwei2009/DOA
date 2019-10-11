#include "Sort.h"
#include "Sort.h"
sort_result findMaxIndex(int *data, int len)
{
	sort_result result;

	result.Maxindex = 0;

	for (int i = 0; i < len-1; i++)
	{
		if (data[i] < data[i + 1])
		{
			result.MaxVal = data[i + 1];
			result.Maxindex = i + 1;
		}
			
	}
	return result;

}
sort_result BubbleSort(int * data, int len)
{
	sort_result result;

	result.Maxindex = 0;
	
	int t = 0;
	for (int i = 0; i < len - 1; i++)
	{
		for (int j = 0; j < len - i - 1; j++)
		{
			if (data[j]<data[j + 1])
			{
				t = data[j + 1];
				data[j + 1] = data[j];
				data[j] = t;;
			}
		}
	}
	return result;
}

int * QuickSort(int * data, int len)
{
	if (len == 1)
	{
		return data;
	}
	if (len == 2)
	{
		int t = data[0];
		if (data[0] > data[1])
		{
			t = data[0];
			data[0] = data[1];
			data[1] = t;
		}
		return data;
	}

	int pivot = data[0];
	int hole = 0;
	int p = 1;
	int q = len - 1;

	while (q!=hole)
	{
		for (int j = q; j > 0; j--)
		{
			if (data[j] < pivot)
			{
				data[hole] = data[j];
				hole = j;
				p++;
				break;
			}
			else
			{
				q--;
			}

		}
		for (int i = p-1; i < q; i++)
		{
			if (data[i] > pivot)
			{
				data[hole] = data[i];
				hole = i;
				q--;
				break;
			}
		}
	}
	data[hole] = pivot;

	QuickSort(data, hole + 1);
	QuickSort(data+hole+1, len-hole-1);


	return data;
}
