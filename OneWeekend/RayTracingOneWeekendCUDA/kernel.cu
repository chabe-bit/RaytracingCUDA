#include <iostream>
#include <fstream>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

#define N 256

struct colors
{
    int r[N], g[N], b[N];

    void store(std::ostream& out)
    {
        for (int i = 0; i < N; i++)
        {
            out << r[i] << " " << g[i] << " " << b[i] << std::endl;
        }
        
    }
};

__global__ void render(std::ostream& out, int* width, int* height, colors* color)
{
    for (int j = 0; j < *height; ++j) {
        for (int i = 0; i < *width; ++i) {
            auto r = double(i) / (*width - 1);
            auto g = double(j) / (*height - 1);
            auto b = 0;

            color->r[N] = static_cast<int>(255.999 * r);
            color->g[N] = static_cast<int>(255.999 * g);
            color->b[N] = static_cast<int>(255.999 * b);

        }
    }
}

int main()
{
    std::ofstream myFile;
    myFile.open("image.ppm");
    // Image

    int image_width = 256;
    int image_height = 256;

    int* width, *height, *out;
    int* cu_width, *cu_height, *cu_out;
    /**
    *  Allocate memory to CPU vars first.
    *  Create GPU mem vars.
    *  Allocate memory to GPU mems.
    *  Then copy CPU mem in them.
    *  Make sure to create an output var that returns the mem from GPU to CPU
    * 
    */

    // CPU pointers
    width =     (int*)malloc(sizeof(float) * N);
    height =    (int*)malloc(sizeof(float) * N);
    out =       (int*)malloc(sizeof(float) * N);

    // GPU pointers
    cudaMalloc((void**)&cu_width,   sizeof(int) * N);
    cudaMalloc((void**)&cu_height,  sizeof(int) * N);
    cudaMalloc((void**)&cu_out,     sizeof(int) * N);

    // Copy CPU memory into GPU memory
    cudaMemcpy(cu_width, width, sizeof(int) * N, cudaMemcpyHostToDevice);
    cudaMemcpy(cu_height, height, sizeof(int) * N, cudaMemcpyHostToDevice);
    cudaMemcpy(cu_out, out, sizeof(int) * N, cudaMemcpyHostToDevice);

    // Render
    myFile << "P3\n" << image_width << ' ' << image_height << "\n255\n";

    colors* color = new colors[sizeof(int) * N];

    render<<<1,256>>>(myFile, cu_width, cu_height, color);
    color->store(myFile);

        
        //store(myFile);

    //myFile << color.r << " " << color.g << " " << color.b << std::endl;


    myFile.close();

    cudaFree(cu_width);
    cudaFree(cu_height);
    cudaFree(cu_out);

    free(width);
    free(height);
    free(out);

    return 0;

}