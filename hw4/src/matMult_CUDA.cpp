#include <stdio.h>
#include <random>
#include <time.h>
#include <math.h>

#define DIM 10
#define BlockSize 32

#include "kernel.cuh"

int main()
{
	srand(time(0));
	auto A = new long int[DIM][DIM];
	auto B = new long int[DIM][DIM];
	auto C = new long int[DIM][DIM];

	// Initialization of array with i+j and i*j 
	for (int i = 0; i<DIM; i++)
	{
		for (int j = 0; j < DIM; j++)
		{
			A[i][j] = (i+1)+(j+1);
			B[i][j] = (i+1)*(j+1);
		}
	}
	
	matMultCUDA(A,B,C);

	// Debug printing
	// for (int i=0; i<DIM; i++)
	// {
	// 	for (int j = 0; j < DIM; j++)
	// 	{
	// 		printf(" %ld ", C[i][j]);
	// 	}
	// 	printf("\n");	
	// }

	delete[]A;
	delete[]B;
	delete[]C;
}