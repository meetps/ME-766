#include <stdio.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#define DIM 10
#define BlockSize 32

__global__ void multiplyKernel(long int* A, long int* B, long int* C) 
{
	int WIDTH = DIM;
    long int CValue = 0;

	const int TILE_WIDTH = BlockSize;

    int Row = blockIdx.y*TILE_WIDTH + threadIdx.y;
    int Col = blockIdx.x*TILE_WIDTH + threadIdx.x;

    // Shared memory allocation for storing the values in a tile window
    __shared__ long int As[TILE_WIDTH][TILE_WIDTH];
    __shared__ long int Bs[TILE_WIDTH][TILE_WIDTH];

    for (int k = 0; k < (TILE_WIDTH + WIDTH - 1)/TILE_WIDTH; k++) 
    {
        if (k*TILE_WIDTH + threadIdx.x < WIDTH && Row < WIDTH)
            As[threadIdx.y][threadIdx.x] = A[Row*WIDTH + k*TILE_WIDTH + threadIdx.x];
        else                                                   
         	As[threadIdx.y][threadIdx.x] = 0.0;

        if (k*TILE_WIDTH + threadIdx.y < WIDTH && Col < WIDTH)   
         	Bs[threadIdx.y][threadIdx.x] = B[(k*TILE_WIDTH + threadIdx.y)*WIDTH + Col];
        else                                                   
         	Bs[threadIdx.y][threadIdx.x] = 0.0;
        __syncthreads();

        for (int n = 0; n < TILE_WIDTH; ++n)
        {
        	CValue += As[threadIdx.y][n] * Bs[n][threadIdx.x];
        } 
        __syncthreads();
    }
    if (Row < WIDTH && Col < WIDTH)
    	C[((blockIdx.y * blockDim.y + threadIdx.y)*WIDTH)+(blockIdx.x*blockDim.x)+threadIdx.x]=CValue;
}

void matMultCUDA(long int A[][DIM],long int B[][DIM],long int C[][DIM])
{
	// Pointers to arrays
	long int *dev_a, *dev_b, *dev_c;

	// Events to calculate time taken by kernel
	cudaEvent_t start, stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);

	// Allocate device memory for the arrays
	cudaError_t err = cudaMalloc((void**)&dev_a, ((DIM)*(DIM))*sizeof(long int));
	printf("Cuda malloc A:%s \n", cudaGetErrorString(err));
	err = cudaMalloc((void**)&dev_b, ((DIM)*(DIM))*sizeof(long int));
	printf("Cuda malloc B:%s \n", cudaGetErrorString(err));
	err = cudaMalloc((void**)&dev_c, ((DIM)*(DIM))*sizeof(long int));
	printf("Cuda malloc C:%s \n", cudaGetErrorString(err));


	//Copy array A and B on device allocated memory
	err = cudaMemcpy(dev_a, A, ((DIM*DIM))*sizeof(long int), cudaMemcpyHostToDevice);
	printf("Cuda memcpy to device A:%s \n", cudaGetErrorString(err));
	err = cudaMemcpy(dev_b, B, ((DIM*DIM))*sizeof(long int), cudaMemcpyHostToDevice);
	printf("Cuda memcpy to device B:%s \n", cudaGetErrorString(err));

	dim3 dimBlock(BlockSize, BlockSize);
	dim3 dimGrid((DIM + dimBlock.x - 1) / dimBlock.x, (DIM + dimBlock.y - 1) / dimBlock.y);

	// Record Time 	
	cudaEventRecord(start);
	multiplyKernel << < dimGrid, dimBlock >> >(dev_a, dev_b, dev_c);
	cudaEventRecord(stop);

	// Retrieve array C from device memory
	err = cudaMemcpy(C, dev_c, ((DIM*DIM))*sizeof(long int), cudaMemcpyDeviceToHost);
	printf("Cuda memcpy to HOST C:%s \n", cudaGetErrorString(err));
	cudaEventSynchronize(stop);
	float milliseconds = 0;
	cudaEventElapsedTime(&milliseconds, start, stop);
	printf("Elapsed time is %f ms\n", milliseconds);

	// Free the device memory
	cudaFree(dev_a);
	cudaFree(dev_b);
	cudaFree(dev_c);
}
