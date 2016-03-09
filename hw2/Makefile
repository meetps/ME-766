matMult: matMult_OpenMP matMult_MPI

matMult_OpenMP: ./src/matMult_OpenMP.cpp
	mpic++ -fopenmp -o OpenMP ./src/matMult_OpenMP.cpp

matMult_MPI: ./src/matMult_MPI.cpp
	mpic++ -o MPI ./src/matMult_MPI.cpp