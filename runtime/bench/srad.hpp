#pragma once
// srad.cpp : Defines the entry point for the console application.
//

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#ifdef USE_CILK_PLUS
#include <cilk/cilk.h>
#include <cilk/cilk_api.h>
#include <cilk/reducer_opadd.h>
#endif

#include "mcsl_util.hpp"

#include "tpalrts_fiber.hpp"
#include "srad_rollforward_decls.hpp"

void random_matrix(float *I, int rows, int cols);
/*
  128 //number of rows in the domain
  128 //number of cols in the domain
  0	//y1 position of the speckle
  31	//y2 position of the speckle
  0	//x1 position of the speckle
  31	//x2 position of the speckle
  4	//number of threads
  0.5	//Lambda value
  2	//number of iterations
*/

int rows=4000;
int cols=4000, size_I, size_R;
float *I, *J, q0sqr, sum, sum2, tmp, meanROI,varROI ;
int *iN,*iS,*jE,*jW;
float *dN,*dS,*dW,*dE;
int r1, r2, c1, c2;
float *c, D;
float lambda;

extern
void srad_interrupt_1(int rows, int cols, int rows_lo, int rows_hi, int size_I, int size_R, float* I, float* J, float q0sqr, float *dN, float *dS, float *dW, float *dE, float* c, int* iN, int* iS, int* jE, int* jW, float lambda, void* _p);

extern
void srad_interrupt_inner_1(int rows, int cols, int rows_lo, int rows_hi, int cols_lo, int cols_hi, int size_I, int size_R, float* I, float* J, float q0sqr, float *dN, float *dS, float *dW, float *dE, float* c, int* iN, int* iS, int* jE, int* jW, float lambda, void* _p);

extern
void srad_interrupt_2(int rows, int cols, int rows_lo, int rows_hi, int cols_lo, int cols_hi, int size_I, int size_R, float* I, float* J, float q0sqr, float *dN, float *dS, float *dW, float *dE, float* c, int* iN, int* iS, int* jE, int* jW, float lambda, void* _p);

extern
void srad_interrupt_inner_2(int rows, int cols, int rows_lo, int rows_hi, int cols_lo, int cols_hi, int size_I, int size_R, float* I, float* J, float q0sqr, float *dN, float *dS, float *dW, float *dE, float* c, int* iN, int* iS, int* jE, int* jW, float lambda, void* _p);

int srad_handler(int rows, int cols, int rows_lo, int rows_hi, int cols_lo, int cols_hi, int size_I, int size_R, float* I, float* J, float q0sqr, float *dN, float *dS, float *dW, float *dE, float* c, int* iN, int* iS, int* jE, int* jW, float lambda, void* _p) {
  tpalrts::promotable* p = (tpalrts::promotable*)_p;
  auto nb_rows = rows_hi - rows_lo;
  if (nb_rows <= 1) {
    return 0;
  }
  auto rf = [=] (tpalrts::promotable* p2) {
    srad_interrupt_inner_1(rows, cols, rows_lo, rows_hi, cols_lo, cols_hi, size_I, size_R, I, J, q0sqr, dN, dS, dW, dE, c, iN, iS, jE, jW, lambda, p2);
  };
  rows_lo++;
  if (nb_rows == 2) {
    p->fork_join_promote2(rf, [=] (tpalrts::promotable* p2) {
      srad_interrupt_1(rows, cols, rows_lo, rows_hi, size_I, size_R, I, J, q0sqr, dN, dS, dW, dE, c, iN, iS, jE, jW, lambda, p2);
    }, [=] (tpalrts::promotable* p2) {
      srad_interrupt_2(rows, cols, rows_lo, rows_hi, 0, 0, size_I, size_R, I, J, q0sqr, dN, dS, dW, dE, c, iN, iS, jE, jW, lambda, p2);
    });
  } else {
    auto rows_mid = (rows_lo + rows_hi) / 2;
    p->fork_join_promote3(rf, [=] (tpalrts::promotable* p2) {
      srad_interrupt_1(rows, cols, rows_lo, rows_mid, size_I, size_R, I, J, q0sqr, dN, dS, dW, dE, c, iN, iS, jE, jW, lambda, p2);
    }, [=] (tpalrts::promotable* p2) {
      srad_interrupt_1(rows, cols, rows_mid, rows_hi, size_I, size_R, I, J, q0sqr, dN, dS, dW, dE, c, iN, iS, jE, jW, lambda, p2);
    }, [=] (tpalrts::promotable* p2) {
      srad_interrupt_2(rows, cols, 0, rows, 0, 0, size_I, size_R, I, J, q0sqr, dN, dS, dW, dE, c, iN, iS, jE, jW, lambda, p2);
    });    
  }
  return 1;
}

int srad_handler_1(int rows, int cols, int rows_lo, int rows_hi, int cols_lo, int cols_hi, int size_I, int size_R, float* I, float* J, float q0sqr, float *dN, float *dS, float *dW, float *dE, float* c, int* iN, int* iS, int* jE, int* jW, float lambda, void* _p) {
  tpalrts::promotable* p = (tpalrts::promotable*)_p;
  auto nb_rows = rows_hi - rows_lo;
  if (nb_rows <= 1) {
    return 0;
  }
  auto rf = [=] (tpalrts::promotable* p2) {
    srad_interrupt_inner_1(rows, cols, rows_lo, rows_hi, cols_lo, cols_hi, size_I, size_R, I, J, q0sqr, dN, dS, dW, dE, c, iN, iS, jE, jW, lambda, p2);
  };
  rows_lo++;
  if (nb_rows == 2) {
    p->fork_join_promote2(rf, [=] (tpalrts::promotable* p2) {
      srad_interrupt_1(rows, cols, rows_lo, rows_hi, size_I, size_R, I, J, q0sqr, dN, dS, dW, dE, c, iN, iS, jE, jW, lambda, p2);
    }, [=] (tpalrts::promotable* p2) {

    });
  } else {
    auto rows_mid = (rows_lo + rows_hi) / 2;
    p->fork_join_promote3(rf, [=] (tpalrts::promotable* p2) {
      srad_interrupt_1(rows, cols, rows_lo, rows_mid, size_I, size_R, I, J, q0sqr, dN, dS, dW, dE, c, iN, iS, jE, jW, lambda, p2);
    }, [=] (tpalrts::promotable* p2) {
      srad_interrupt_1(rows, cols, rows_mid, rows_hi, size_I, size_R, I, J, q0sqr, dN, dS, dW, dE, c, iN, iS, jE, jW, lambda, p2);
    }, [=] (tpalrts::promotable* p2) {

    });    
  }
  return 1;
}

int srad_handler_inner_1(int rows, int cols, int rows_lo, int rows_hi, int cols_lo, int cols_hi, int size_I, int size_R, float* I, float* J, float q0sqr, float *dN, float *dS, float *dW, float *dE, float* c, int* iN, int* iS, int* jE, int* jW, float lambda, void* _p) {
  tpalrts::promotable* p = (tpalrts::promotable*)_p;
  if ((cols_hi - cols_lo) <= 1) {
    return 0;
  }
  auto cols_mid = (cols_lo + cols_hi) / 2;
  p->fork_join_promote2([=] (tpalrts::promotable* p2) {
    srad_interrupt_inner_1(rows, cols, rows_lo, rows_hi, cols_lo, cols_mid, size_I, size_R, I, J, q0sqr, dN, dS, dW, dE, c, iN, iS, jE, jW, lambda, p2);
  }, [=] (tpalrts::promotable* p2) {
    srad_interrupt_inner_1(rows, cols, rows_lo, rows_hi, cols_mid, cols_hi, size_I, size_R, I, J, q0sqr, dN, dS, dW, dE, c, iN, iS, jE, jW, lambda, p2);
  }, [=] (tpalrts::promotable*) {
    // nothing left to do
  });
  return 1;
}

int srad_handler_2(int rows, int cols, int rows_lo, int rows_hi, int cols_lo, int cols_hi, int size_I, int size_R, float* I, float* J, float q0sqr, float *dN, float *dS, float *dW, float *dE, float* c, int* iN, int* iS, int* jE, int* jW, float lambda, void* _p) {
  //  printf("rl=%lu rh=%lu cl=%lu ch=%lu\n",rows_lo,rows_hi,cols_lo,cols_hi);
  tpalrts::promotable* p = (tpalrts::promotable*)_p;
  auto nb_rows = rows_hi - rows_lo;
  if (nb_rows <= 1) {
    return 0;
  }
  auto rf = [=] (tpalrts::promotable* p2) {
    srad_interrupt_inner_2(rows, cols, rows_lo, rows_hi, cols_lo, cols_hi, size_I, size_R, I, J, q0sqr, dN, dS, dW, dE, c, iN, iS, jE, jW, lambda, p2);
  };
  rows_lo++;
  if (nb_rows == 2) {
    p->fork_join_promote2(rf, [=] (tpalrts::promotable* p2) {
      srad_interrupt_2(rows, cols, rows_lo, rows_hi, 0, 0, size_I, size_R, I, J, q0sqr, dN, dS, dW, dE, c, iN, iS, jE, jW, lambda, p2);
    }, [=] (tpalrts::promotable* p2) {

    });
  } else {
    auto rows_mid = (rows_lo + rows_hi) / 2;
    p->fork_join_promote3(rf, [=] (tpalrts::promotable* p2) {
      srad_interrupt_2(rows, cols, rows_lo, rows_mid, 0, 0, size_I, size_R, I, J, q0sqr, dN, dS, dW, dE, c, iN, iS, jE, jW, lambda, p2);
    }, [=] (tpalrts::promotable* p2) {
      srad_interrupt_2(rows, cols, rows_mid, rows_hi, 0, 0, size_I, size_R, I, J, q0sqr, dN, dS, dW, dE, c, iN, iS, jE, jW, lambda, p2);
    }, [=] (tpalrts::promotable* p2) {

    });    
  }
  return 1;
}

int srad_handler_inner_2(int rows, int cols, int rows_lo, int rows_hi, int cols_lo, int cols_hi, int size_I, int size_R, float* I, float* J, float q0sqr, float *dN, float *dS, float *dW, float *dE, float* c, int* iN, int* iS, int* jE, int* jW, float lambda, void* _p) {
  tpalrts::promotable* p = (tpalrts::promotable*)_p;
  if ((cols_hi - cols_lo) <= 1) {
    return 0;
  }
  auto cols_mid = (cols_lo + cols_hi) / 2;
  p->fork_join_promote2([=] (tpalrts::promotable* p2) {
    srad_interrupt_inner_2(rows, cols, rows_lo, rows_hi, cols_lo, cols_mid, size_I, size_R, I, J, q0sqr, dN, dS, dW, dE, c, iN, iS, jE, jW, lambda, p2);
  }, [=] (tpalrts::promotable* p2) {
    srad_interrupt_inner_2(rows, cols, rows_lo, rows_hi, cols_mid, cols_hi, size_I, size_R, I, J, q0sqr, dN, dS, dW, dE, c, iN, iS, jE, jW, lambda, p2);
  }, [=] (tpalrts::promotable*) {
    // nothing left to do
  });
  return 1;
}


extern
void srad_serial(int rows, int cols, int size_I, int size_R, float* I, float* J, float q0sqr, float *dN, float *dS, float *dW, float *dE, float* c, int* iN, int* iS, int* jE, int* jW, float lambda);

extern
void srad_interrupt(int rows, int cols, int size_I, int size_R, float* I, float* J, float q0sqr, float *dN, float *dS, float *dW, float *dE, float* c, int* iN, int* iS, int* jE, int* jW, float lambda, void* _p);

void srad_cilk() {
#if defined(USE_CILK_PLUS)
  cilk_for (int i = 0 ; i < rows ; i++) {
    cilk_for (int j = 0; j < cols; j++) { 
		
      int k = i * cols + j;
      float Jc = J[k];
 
      // directional derivates
      dN[k] = J[iN[i] * cols + j] - Jc;
      dS[k] = J[iS[i] * cols + j] - Jc;
      dW[k] = J[i * cols + jW[j]] - Jc;
      dE[k] = J[i * cols + jE[j]] - Jc;
			
      float G2 = (dN[k]*dN[k] + dS[k]*dS[k] 
		  + dW[k]*dW[k] + dE[k]*dE[k]) / (Jc*Jc);

      float L = (dN[k] + dS[k] + dW[k] + dE[k]) / Jc;

      float num  = (0.5*G2) - ((1.0/16.0)*(L*L)) ;
      float den  = 1 + (.25*L);
      float qsqr = num/(den*den);
 
      // diffusion coefficent (equ 33)
      den = (qsqr-q0sqr) / (q0sqr * (1+q0sqr)) ;
      c[k] = 1.0 / (1.0+den) ;
                
      // saturate diffusion coefficent
      if (c[k] < 0) {c[k] = 0;}
      else if (c[k] > 1) {c[k] = 1;}
   
    }
  
  }
  cilk_for (int i = 0; i < rows; i++) {
    cilk_for (int j = 0; j < cols; j++) {        

      // current index
      int k = i * cols + j;
                
      // diffusion coefficent
      float cN = c[k];
      float cS = c[iS[i] * cols + j];
      float cW = c[k];
      float cE = c[i * cols + jE[j]];

      // divergence (equ 58)
      float D = cN * dN[k] + cS * dS[k] + cW * dW[k] + cE * dE[k];
                
      // image update (equ 61)
      J[k] = J[k] + 0.25*lambda*D;
    }
  }
#endif
}

namespace srad {

using namespace tpalrts;

char* name = "srad";

uint64_t hash64(uint64_t u) {
  uint64_t v = u * 3935559000370003845ul + 2691343689449507681ul;
  v ^= v >> 21;
  v ^= v << 37;
  v ^= v >>  4;
  v *= 4768777513237032717ul;
  v ^= v << 20;
  v ^= v >> 41;
  v ^= v <<  5;
  return v;
}

void random_matrix(float *I, int rows, int cols){

  for( int i = 0 ; i < rows ; i++){
    for ( int j = 0 ; j < cols ; j++){
      I[i * cols + j] = (float)hash64(i+j)/(float)RAND_MAX ;
    }
  }

}
  
auto bench_pre(promotable* p) {
  rollforward_table = {
    #include "srad_rollforward_map.hpp"
  };

  r1   = 0;
  r2   = 31;
  c1   = 0;
  c2   = 31;
  lambda = 0.5;

  size_I = cols * rows;
  size_R = (r2-r1+1)*(c2-c1+1);   

  I = (float *)malloc( size_I * sizeof(float) );
  J = (float *)malloc( size_I * sizeof(float) );
  c  = (float *)malloc(sizeof(float)* size_I) ;

  iN = (int *)malloc(sizeof(unsigned int*) * rows) ;
  iS = (int *)malloc(sizeof(unsigned int*) * rows) ;
  jW = (int *)malloc(sizeof(unsigned int*) * cols) ;
  jE = (int *)malloc(sizeof(unsigned int*) * cols) ;    


  dN = (float *)malloc(sizeof(float)* size_I) ;
  dS = (float *)malloc(sizeof(float)* size_I) ;
  dW = (float *)malloc(sizeof(float)* size_I) ;
  dE = (float *)malloc(sizeof(float)* size_I) ;    
    

  for (int i=0; i< rows; i++) {
    iN[i] = i-1;
    iS[i] = i+1;
  }    
  for (int j=0; j< cols; j++) {
    jW[j] = j-1;
    jE[j] = j+1;
  }
  iN[0]    = 0;
  iS[rows-1] = rows-1;
  jW[0]    = 0;
  jE[cols-1] = cols-1;
	
  random_matrix(I, rows, cols);

  for (int k = 0;  k < size_I; k++ ) {
    J[k] = (float)exp(I[k]) ;
  }

  sum=0; sum2=0;     
  for (int i=r1; i<=r2; i++) {
    for (int j=c1; j<=c2; j++) {
      tmp   = J[i * cols + j];
      sum  += tmp ;
      sum2 += tmp*tmp;
    }
  }
  meanROI = sum / size_R;
  varROI  = (sum2 / size_R) - meanROI*meanROI;
  q0sqr   = varROI / (meanROI*meanROI);
};

auto bench_body_interrupt(promotable* p) {
  srad_interrupt(rows, cols, size_I, size_R, I, J, q0sqr, dN, dS, dW, dE, c, iN, iS, jE, jW, lambda, p);
};
  
auto bench_body_software_polling(promotable* p) {

};

auto bench_body_serial(promotable* p) {
  srad_serial(rows, cols, size_I, size_R, I, J, q0sqr, dN, dS, dW, dE, c, iN, iS, jE, jW, lambda);
};

auto bench_post(promotable* p) {
  free(I);
  free(J);
  free(iN); free(iS); free(jW); free(jE);
  free(dN); free(dS); free(dW); free(dE);

  free(c);
};

auto bench_body_cilk() {
  srad_cilk();
};

}

