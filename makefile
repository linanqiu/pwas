all: cov_matrix

clean:
	- rm cov_matrix

cov_matrix: cov_matrix.cu
	nvcc cov_matrix.cu -o cov_matrix
