matMult: matMult_OpenMP matMult_MPI matMult_CUDA

matMult_OpenMP: ./src/matMult_OpenMP.cpp
	mpic++ -pg -fopenmp -o OpenMP ./src/matMult_OpenMP.cpp

matMult_MPI: ./src/matMult_MPI.cpp
	mpic++ -pg -o MPI ./src/matMult_MPI.cpp

matMult_CUDA: kernel.o
	g++ -pg -std=c++11 -o CUDA -L/usr/local/cuda/lib64 -lcuda -lcudart src/matMult_CUDA.cpp  kernel.o 

kernel.o:
	nvcc -c -arch=sm_20 src/kernel.cu

clean:
	rm -rf CUDA OpenMP MPI kernel.o
