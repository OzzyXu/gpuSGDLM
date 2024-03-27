/*
 * simPointers.cuh
 *
 *  Created on: Jul 22, 2015
 *      Author: lutz
 */

#ifndef SIMPOINTERS_CUH_
#define SIMPOINTERS_CUH_

namespace SGDLM {
template<typename DOUBLE, class memory_manager> struct simPointers {
	// ALL POINTERS RESIDE ON THE GPU

	// POINTERS FOR SGDLM OBJECTS
	
	// * These two pointers correspond to the adj_mat_vec of DlmModelParam::dlmParameters.hpp.
	// * gpuSGDLM has a different way to store the parental set.
	// ! Need a lof of modifications to adapt to cppSGDLM.
	// Entry point for the index array of the simultaneous parental set (sp).
	// The index array is a 1D array of unsigned integers and is used to locate an element in the sp.
	unsigned int* sp_indices;
	// Entry point for the index array of the time series.
	// The index array is a 1D array of unsigned integers and is used to access the data array of the time series.
	unsigned int* p;

	// * These are the parameters of the normal-gamma distributions. They will be automatically updated with the evolution of the algorithm.
	// * Correspond to the m_prior of DlmStateTParam::dlmParameters.hpp.
	// ! Need to input the initial values from cppSGDLM.
	// * Gamma part.
	DOUBLE* s_t;
	DOUBLE* n_t;
	// * Normal part.
	DOUBLE* data_m_t;
	DOUBLE** m_t;
	DOUBLE* data_m_t_buffer;
	DOUBLE** m_t_buffer;
	DOUBLE* data_C_t;
	DOUBLE** C_t;
	DOUBLE* data_C_t_buffer;
	DOUBLE** C_t_buffer;

	// Discount factors.
	// ! Not used by the program.
	DOUBLE* alpha;
	// This is the 1D array holding the volatility discount factors reading from R.
	// * Correspond to beta of DlmModelParam::dlmParameters.hpp.
	// ! Need to input from cppSGDLM. 
	DOUBLE* beta;
	// This is the 1D array holding discount factors reading from R. 
	// * Correspond to the delta_phi and delta_gamma of DlmModelParam::dlmParameters.hpp.
	// * In cppSGDLM, for time series j, we can set different discount factors for the external predictor part and the parental set part, which corresponds to delta_phi and delta_gamma. It seems that in gpuSGDLM, we only set one discount factor for the whole time series.
	// ! Need to input from cppSGDLM. 
	// ! Need to modify this part to adapt to cppSGDLM.
	DOUBLE* data_delta;
	// This is the 2D array holding discount factors on GPU.
	DOUBLE** delta;

	// This is the 1D array holding the evolution matrix.
	// * In both cppSGDLM and gpuSGDLM, users are not allowed to set the evolution matrix. The identity matrix is used as the default evolution matrix.
	// * Correspond to the G_state_vec of DlmModelParam::dlmParameters.hpp.
    // ! No need to input from cppSGDLM for now.
	// ! May need to modify this part in the future once a time-varying evolution matrix is allowed in cppSGDLM.
	DOUBLE* data_G_t;
	// This is the 2D array holding the evolution matrix on GPU.
	DOUBLE** G_t;

	DOUBLE* Q_t;
	DOUBLE** Q_t_ptrptr;
	DOUBLE* e_t;
	DOUBLE** e_t_ptrptr;
	DOUBLE* data_A_t;
	DOUBLE** A_t;

	// This is the 1D array holding the observations at time t.
	// * Correspond to the rows of obs of DlmModelParam::dlmParameters.hpp.
	// ! Need to input from cppSGDLM.
	// ! Need to modify this part to adapt to cppSGDLM.
	DOUBLE* y_t;

	// * Correspond to the F_t in UpdateNaivePostThread::onStart::dlmCore.
    // * Generated on-the-fly in R and readed from R.
	// ! Need to add the generation code.
	DOUBLE* data_F_t;
	// This is the 2D array holding the F_t on GPU.
	DOUBLE** F_t;

	DOUBLE* zero;
	DOUBLE* plus_one;
	DOUBLE* minus_one;

	// BEGIN SIMULATION GPU POINTERS
	// VB posterior simulation AND forecasting
	DOUBLE* data_lambdas;
	DOUBLE** lambdas;
	DOUBLE* data_randoms;
	DOUBLE* data_randoms_pt2;
	DOUBLE** randoms_nrepeat_ptr;
	DOUBLE* data_Gammas;
	DOUBLE** Gammas;
	int* LU_pivots;
	int* LU_infos;
	DOUBLE* data_chol_C_t;
	DOUBLE** chol_C_t;
	DOUBLE** chol_C_t_nrepeat_ptr;
	DOUBLE* data_thetas;
	DOUBLE** thetas;
	DOUBLE** thetas_nrepeat_ptr;

	// only VB posterior simulation
	DOUBLE* IS_weights;
	DOUBLE* sum_det_weights;
	DOUBLE* mean_lambdas;
	DOUBLE* mean_log_lambdas;
	DOUBLE* data_mean_m_t;
	DOUBLE* data_mean_C_t;
	DOUBLE** mean_m_t;
	DOUBLE** mean_C_t;
	int* INV_pivots;
	int* INV_infos;
	DOUBLE** lambdas_nrepeat_ptr;
	DOUBLE* mean_n_t;
	DOUBLE* mean_s_t;
	DOUBLE* mean_Q_t;

	// only forecasting
	DOUBLE* data_y;
	DOUBLE** y;
	DOUBLE* data_x_t;
	DOUBLE** x_t;
	DOUBLE* data_nus;
	DOUBLE** nus;
	DOUBLE* data_Gammas_inv;
	DOUBLE** Gammas_inv;

	// number of simulations
	// * A model parameter. Correspond to the num_sim of DlmModelParam::dlmParameters.hpp.
	// ! Need to input from cppSGDLM.
	size_t nsim;

	// memory manager
	memory_manager MEM;
	memory_manager MEM_evo;
	memory_manager MEM_sim;

	// Stream for asynchronous command execution
	cudaStream_t stream;

	// cuBlas
	cublasHandle_t CUBLAS;

	// cuRand
	curandGenerator_t CURAND;
};

}

#endif /* SIMPOINTERS_CUH_ */
