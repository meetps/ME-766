/***********************************************************
/ File : Matrix Multiplication using MPI 
/ Auth ; Meet Pragnesh Shah
/ Mail : meetshah1995@gmail.com
/ Desc : HW 2 solution for ME 766  
/***********************************************************/ 

#include <iostream>
#include <cstdlib>
#include <mpi.h>
#include <time.h>

#define N 10

using namespace std;

// void display_matrices(int process_id, double* C, double* A, double* B);

int main(int argc, char* argv[])
{
	int process_id, no_of_threads;		// Process ID and No of threads
	int tag = 0;						// Endpoints for time calc
	double start, end;					// Endpoints for time calc
	MPI_Status status;    				// Message status
	
	double *A, *B, *C;					// Pointers to Matrices
	int submat_size;					// Size of submatrices
	int start_address;					// Start address for submatrix
	
	MPI_Init(&argc, &argv);								// Init MPI
	MPI_Comm_rank(MPI_COMM_WORLD, &process_id);			// Start comm chanel
	MPI_Comm_size(MPI_COMM_WORLD, &no_of_threads);		// Init threads

	
	submat_size = N/no_of_threads;		 // Sub matrices size 					
	
	// Matrix Initialization
	B = new double [N*N];					

	if(process_id == 0) 
	{
		cout << "No. of Threads : " << no_of_threads << endl;	
		A = new double [N*N];
		C = new double [N*N];
		for(int i=0; i<N*N; ++i) 
		{
			A[i] = rand()%100;
			B[i] = rand()%100;
		}
	}

	else 
	{
		A = new double [N*submat_size];
		C = new double [N*submat_size];
		for(int i=0; i<N*submat_size; ++i) 
		{
			C[i] = 0.0;
		}
	}
	
	
	start = MPI_Wtime();							// Start time
		
	if(process_id == 0) 
	{
		start_address = N*submat_size;
		for(int i=1; i<no_of_threads; ++i) 
		{
			// Send the input submatrix to salves
			MPI_Send(A + start_address, N*submat_size, MPI_DOUBLE, i, tag, MPI_COMM_WORLD);
			MPI_Send(B, N*N, MPI_DOUBLE, i, tag+1, MPI_COMM_WORLD);
			start_address += N*submat_size;
		}
	}
	else 
	{
		// Recceive the input submatrix from master 
		MPI_Recv(A, N*submat_size, MPI_DOUBLE, 0, tag, MPI_COMM_WORLD, &status);
		MPI_Recv(B, N*N, MPI_DOUBLE, 0, tag+1, MPI_COMM_WORLD, &status);
	}
	
	// Standard Matrix Multiplication Routine
	for(int i = 0; i < submat_size; i++)
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
	
	if(process_id == 0)									 
	{
		// Recceive the computed submatrix from slaves to the master 
		start_address = N*submat_size;
		for(int i=1; i<no_of_threads; ++i) 
		{
			// Send the computed submatrix to master from salves
			MPI_Recv(C + start_address, N*submat_size, MPI_DOUBLE, i, 2, MPI_COMM_WORLD, &status);
			start_address += N*submat_size;
		}
	}
	else 
	{
		MPI_Send(C, N*submat_size, MPI_DOUBLE, 0, 2, MPI_COMM_WORLD);
	}

	end = MPI_Wtime();				// Stop time
	cout << "Time Taken by :" << process_id << " = " << end-start << endl;
	MPI_Finalize();  		      	// Synchronie the threads
}