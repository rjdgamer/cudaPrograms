/*Goal of Program
Create two arrays
-- I need an array that stays in the main as the header, h_
-- I need an array that goes into the thread/device, d_

Put the array into a thread
Call the Thread
The thread will only have one line of code, and that will be squaring itself
will it have to read itself? Will it matter? It should not matter
Have each piece of data in the thread cube itself
Free the memory
*/


#include <device_launch_parameters.h>
#include <cuda_runtime.h>
#include <stdio.h>
__global__
void cube(float *d_out, float *d_in) {
	int idx = threadIdx.x; 
	float f = d_in[idx]; 
	d_out[idx] = f * f * f; 
}
//Create the main file
int main() {
	//The size of the array
	const int arrSize = 50; 
	const int arrBytes = arrSize * sizeof(float);
	float h_in[arrSize], h_out[arrSize];
	float *d_in, *d_out; 
	//Allocate memory for d_in. Does not need & because d_in is already an address
	cudaMalloc((void**) &d_in, arrBytes); 
	cudaMalloc((void**) &d_out, arrBytes);
	//Initialize the h_in array, may remove later
	for (int i = 0; i < arrSize; i++) {
		h_in[i] = (float)i;
		
	}
	//Copy information from d_in to h_in
	cudaMemcpy(d_in, h_in, arrBytes, cudaMemcpyHostToDevice);
	cube <<<1, arrSize>>> (d_out, d_in);
	cudaMemcpy(h_out, d_out, arrBytes, cudaMemcpyDeviceToHost); 
	for (int i = 0; i < arrSize; i++) {
		printf("%f ", h_out[i]);
		printf((i % 4 == 3)?"\n":"\t"); 
	}
	cudaFree(d_in);
	cudaFree(d_out);

	
	return 0;

}