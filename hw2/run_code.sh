echo "Running OpenMP Code"
echo "Threads = 4"
export OMP_NUM_THREADS=4                          
./OpenMP 

echo "Running MPI Code"
echo "Threads = 4"
mpirun -np 4 MPI