all: matMult_CUDA

matMult_CUDA: kernel.o
	g++ -std=c++11 -o CUDA -L/usr/local/cuda/lib64 -lcuda -lcudart src/matMult_CUDA.cpp  kernel.o 

kernel.o:
	nvcc -c -arch=sm_20 src/kernel.cu 

clean: 
	rm -rf *o matMult_CUDA
