%%writefile add.cu

#include <iostream>
#include <cuda_runtime.h>
using namespace std;

__global__ void add(int *A, int *B, int *C, int n)
{
    int i = threadIdx.x;

    if (i < n)
        C[i] = A[i] + B[i];
}

int main()
{
    int n = 5, size = n * sizeof(int);

    int A[5] = {1, 2, 3, 4, 5};
    int B[5] = {5, 4, 3, 2, 1};
    int C[5];

    int *d_A, *d_B, *d_C;

    cudaMalloc(&d_A, size);
    cudaMalloc(&d_B, size);
    cudaMalloc(&d_C, size);

    cudaMemcpy(d_A, A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, B, size, cudaMemcpyHostToDevice);

    add<<<1, n>>>(d_A, d_B, d_C, n);

    cudaMemcpy(C, d_C, size, cudaMemcpyDeviceToHost);

    for (int i = 0; i < n; i++)
        cout << C[i] << " ";

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    return 0;
}

!nvcc -o run add.cu

!./run
