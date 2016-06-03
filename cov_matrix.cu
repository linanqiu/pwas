/* *
 * Copyright 1993-2012 NVIDIA Corporation.  All rights reserved.
 *
 * Please refer to the NVIDIA end user license agreement (EULA) associated
 * with this source code for terms and conditions that govern your use of
 * this software. Any use, reproduction, disclosure, or distribution of
 * this software and related documentation outside the terms of the EULA
 * is strictly prohibited.
 */
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <fstream>

using namespace std;

int patient_count;
int icd_count;
int* patients_host;
int* icds_host;

/**
 * This macro checks return value of the CUDA runtime call and exits
 * the application if the call failed.
 */
#define CUDA_CHECK_RETURN(value) {											\
	cudaError_t _m_cudaStat = value;										\
	if (_m_cudaStat != cudaSuccess) {										\
		fprintf(stderr, "Error %s at line %d in file %s\n",					\
				cudaGetErrorString(_m_cudaStat), __LINE__, __FILE__);		\
		exit(1);															\
	} }

void free_all() {
  CUDA_CHECK_RETURN(cudaFreeHost(patients_host));
  CUDA_CHECK_RETURN(cudaFreeHost(icds_host));
}

void read_patients() {
  patient_count = 0;
  string line;
  ifstream file("csv_data/patients_sorted_short.csv");

  if (file.is_open()) {
    // skip first line
    getline(file, line);

    while (getline(file, line)) {
      patient_count ++;
    }
  }

  printf("%d patients read\n", patient_count);
  CUDA_CHECK_RETURN(cudaHostAlloc((void**) &patients_host, patient_count * 4 * sizeof(int), cudaHostAllocDefault));
  patient_count = 0;
  file.clear();
  file.seekg(0, ios::beg);

  if (file.is_open()) {
    // skip first line
    getline(file, line);

    while (getline(file, line)) {
      char * dup = strdup(line.c_str());
      char * record = strtok(dup, ",");

      for (int i = 0; i < 4; i++) {
        patients_host[patient_count * 4 + i] = atoi(record);
        record = strtok(NULL, ",");
      }

      patient_count++;
    }
  }
}

void read_icds() {
  icd_count = 0;
  string line;
  ifstream file("csv_data/icds.csv");

  if (file.is_open()) {
    // skip first line
    getline(file, line);

    while (getline(file, line)) {
      icd_count ++;
    }
  }

  printf("%d ICDs read\n", icd_count);
  CUDA_CHECK_RETURN(cudaHostAlloc((void**) &icds_host, icd_count * sizeof(int), cudaHostAllocDefault));
  icd_count = 0;
  file.clear();
  file.seekg(0, ios::beg);

  if (file.is_open()) {
    // skip first line
    getline(file, line);

    while (getline(file, line)) {
      char * dup = strdup(line.c_str());
      char * record = strtok(dup, ",");
      icds_host[icd_count] = atoi(record);
      icd_count++;
    }
  }
}

int main(int argc, char* argv[]) {
  read_patients();
  read_icds();
  free_all();
}
