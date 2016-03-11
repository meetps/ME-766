/***********************************************************
/ File : Matrix Multiplication using OpemMP
/ Auth ; Meet Pragnesh Shah
/ Mail : meetshah1995@gmail.com
/ Desc : HW 2 solution for ME 766  
/***********************************************************/ 

#include <iostream>
#include <cstdlib>
#include <omp.h>
#include <mpi.h>
#include <time.h>

#define N 2000               // Size of the matrix

using namespace std;

int main(int argc, char* argv[])
{
	float *A, *B, *C;         // Pointers to matrix A,B,C
	int max_threads;		  // Max number of threads
	double start, end;		  // Endpoints for time calc
	size_t matrix_size = N;   // Size for square matrix
	
	// Matrix Initialization
	A = new float[N*N];
	B = new float[N*N];
	C = new float[N*N];
	
	for(int i=0; i<(N*N); i++)
	{
		A[i] = rand()%100;
		B[i] = rand()%100;
	}

	start=MPI_Wtime();		   			            // Start stopwatch
	max_threads = omp_get_max_threads();   			// Get Max threads

	cout<<"Max threads available :"<<max_threads<<endl;
	
	//Pragma to parallelize the computation
	#pragma omp parallel for shared (A, B, C, matrix_size) 
	
	//Standard Matrix Multiplication Routine
	for(int i = 0; i < N; i++)
	{
		for(int j = 0; j < N; j++)
		{
			C[j + i*N] = 0;
			for(int k = 0; k < N; k++)
			{
				C[j + i*N] += A[i*N + k]*B[j + N*k];
			}    
		} 
	}
	
	end=MPI_Wtime();				 			    // Stop stopwatch
	
	cout<<"Time Taken : "<< (end-start) <<" seconds"<<endl;
}
