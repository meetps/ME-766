echo "###############################################"
echo "\n"
echo "\n"
echo "Running OpenMP Code"
echo "Threads = 4"
export OMP_NUM_THREADS=4
echo "Generating gmon.out file for Profiling"                          
./OpenMP
echo "Flat Profiling Code and Generating Call Graph" 
gprof OpenMP gmon.out > analysis/OpenMP_analysis_gprof.txt
rm gmon.out

echo "###############################################"
echo "\n"
echo "\n"
echo "###############################################"
echo "\n"
echo "\n"


echo "Running MPI Code"
echo "Threads = 4"
echo "Generating gmon.out file for Profiling"                          
mpirun -np 4 MPI
echo "Flat Profiling Code and Generating Call Graph" 
gprof MPI gmon.out > analysis/MPI_analysis_gprof.txt
rm gmon.out

echo "###############################################"
echo "\n"
echo "\n"
echo "###############################################"
echo "\n"
echo "\n"

echo "Running CUDA Code"
echo "BlockSize = 32"
echo "Generating gmon.out file for Profiling"                          
./CUDA
echo "Flat Profiling Code and Generating Call Graph" 
gprof CUDA gmon.out > analysis/CUDA_analysis_gprof.txt
rm gmon.out