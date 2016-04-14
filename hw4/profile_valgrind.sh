echo "###############################################"
echo "\n"
echo "\n"
echo "Running OpenMP Code"
echo "Threads = 4"
export OMP_NUM_THREADS=4
echo "Generating hit/miss rate report"                          
valgrind --log-file="analysis/OpenMP_analysis_valgrind.txt" --tool=cachegrind ./OpenMP 

echo "###############################################"
echo "\n"
echo "\n"
echo "###############################################"
echo "\n"
echo "\n"


echo "Running MPI Code"
echo "Threads = 4"
echo "Generating hit/miss rate report"                          
valgrind --log-file="analysis/MPI_analysis_valgrind.txt" --tool=cachegrind mpirun -np 4 MPI 


echo "###############################################"
echo "\n"
echo "\n"
echo "###############################################"
echo "\n"
echo "\n"

echo "Running CUDA Code"
echo "BlockSize = 32"
echo "Generating hit/miss rate report"                          
valgrind --log-file="analysis/CUDA_analysis_valgrind.txt" --tool=cachegrind ./CUDA

rm cache*
rm gmon.out
echo "Done Profiling"