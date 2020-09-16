#pragma once

#include <iostream>
#include <fstream>
#include <sstream>
#include <cstdlib>
#include <cstring>
#include <ctime>

#ifdef USE_CILK_PLUS
#include <cilk/cilk.h>
#include <cilk/cilk_api.h>
#include <cilk/reducer_opadd.h>
#endif

#include "mcsl_util.hpp"

#include "tpalrts_fiber.hpp"

using kmeans_input_type = struct kmeans_input_struct {
  int nObj;
  int nFeat;
  float** attributes;
};

// Features are integers from 0 to 255 by default
auto kmeans_inputgen(int nObj, int nFeat = 34) -> kmeans_input_type {
  int numObjects = nObj;
  int numAttributes = nFeat;
  float** attributes;
  attributes    = (float**)malloc(numObjects*             sizeof(float*));
  attributes[0] = (float*) malloc(numObjects*numAttributes*sizeof(float));
  for (int i=1; i<numObjects; i++) {
    attributes[i] = attributes[i-1] + numAttributes;
  }
  for ( int i = 0; i < nObj; i++ ) {
    attributes[0][i] = (float)rand() / (float)RAND_MAX;
  }
  kmeans_input_type in = { nObj, nFeat, attributes };
  return in;
}

#define RANDOM_MAX 2147483647

#ifndef FLT_MAX
#define FLT_MAX 3.40282347e+38
#endif

/*----< euclid_dist_2() >----------------------------------------------------*/
/* multi-dimensional spatial Euclid distance square */
__inline
float euclid_dist_2(float *pt1,
                    float *pt2,
                    int    numdims)
{
  int i;
  float ans=0.0;

  for (i=0; i<numdims; i++)
    ans += (pt1[i]-pt2[i]) * (pt1[i]-pt2[i]);

  return(ans);
}

__inline
int find_nearest_point(float  *pt,          /* [nfeatures] */
                       int     nfeatures,
                       float **pts,         /* [npts][nfeatures] */
                       int     npts)
{
  int index, i;
  float min_dist=FLT_MAX;

  /* find the cluster center id with min distance to pt */
  for (i=0; i<npts; i++) {
    float dist;
    dist = euclid_dist_2(pt, pts[i], nfeatures);  /* no need square root */
    if (dist < min_dist) {
      min_dist = dist;
      index    = i;
    }
  }
  return(index);
}

float** kmeans_cilk(float **feature,    /* in: [npoints][nfeatures] */
		      int     nfeatures,
		      int     npoints,
		      int     nclusters,
		      float   threshold,
		      int    *membership) /* out: [npoints] */
{

  int      i, j, n=0, index, loop=0;
  int     *new_centers_len; /* [nclusters]: no. of points in each cluster */
  cilk::reducer_opadd<float> delta(0.0);
  float  **clusters;   /* out: [nclusters][nfeatures] */
  float  **new_centers;     /* [nclusters][nfeatures] */

#if defined(USE_CILK_PLUS)

  /* allocate space for returning variable clusters[] */
  clusters    = (float**) malloc(nclusters *             sizeof(float*));
  clusters[0] = (float*)  malloc(nclusters * nfeatures * sizeof(float));
  for (i=1; i<nclusters; i++)
    clusters[i] = clusters[i-1] + nfeatures;

  cilk::reducer_opadd<int>* partial_new_centers_len = new cilk::reducer_opadd<int>[nclusters];
  cilk::reducer_opadd<float>** partial_new_centers = new cilk::reducer_opadd<float>*[nclusters];
  for (int i = 0; i < nclusters; i++) {
    partial_new_centers[i] = new cilk::reducer_opadd<float>[nfeatures];
  }

  /* randomly pick cluster centers */
  for (i=0; i<nclusters; i++) {
    //n = (int)rand() % npoints;
    for (j=0; j<nfeatures; j++)
      clusters[i][j] = feature[n][j];
    n++;
  }

  for (i=0; i<npoints; i++)
    membership[i] = -1;

  /* need to initialize new_centers_len and new_centers[0] to all 0 */
  new_centers_len = (int*) calloc(nclusters, sizeof(int));

  new_centers    = (float**) malloc(nclusters *            sizeof(float*));
  new_centers[0] = (float*)  calloc(nclusters * nfeatures, sizeof(float));
  for (i=1; i<nclusters; i++)
    new_centers[i] = new_centers[i-1] + nfeatures;
  
  do {
		
    delta.set_value(0.0);

    cilk_for (int i=0; i<npoints; i++) {
      /* find the index of nestest cluster centers */
      index = find_nearest_point(feature[i], nfeatures, clusters, nclusters);
      /* if membership changes, increase delta by 1 */
      if (membership[i] != index) delta += 1.0;

      /* assign the membership to object i */
      membership[i] = index;

      /* update new cluster centers : sum of objects located within */
      partial_new_centers_len[index]++;
      for (j=0; j<nfeatures; j++)          
	partial_new_centers[index][j] += feature[i][j];
    }

    /* let the main thread perform the array reduction */
    for (i=0; i<nclusters; i++) {
      new_centers_len[i] = partial_new_centers_len[i].get_value();
      partial_new_centers_len[i].set_value(0);
      for (j=0; j<nfeatures; j++) {
	new_centers[i][j] = partial_new_centers[i][j].get_value();
	partial_new_centers[i][j].set_value(0.0);
      }
    }

    /* replace old cluster centers with new_centers */
    for (i=0; i<nclusters; i++) {
      for (j=0; j<nfeatures; j++) {
	if (new_centers_len[i] > 0)
	  clusters[i][j] = new_centers[i][j] / new_centers_len[i];
	new_centers[i][j] = 0.0;   /* set back to 0 */
      }
      new_centers_len[i] = 0;   /* set back to 0 */
    }
            
    //delta /= npoints;
  } while (delta.get_value() > threshold);

  delete [] partial_new_centers_len;
  for (int i = 0; i < nclusters; i++) {
    delete [] partial_new_centers[i];
  }
  delete [] partial_new_centers;
  free(new_centers[0]);
  free(new_centers);
  free(new_centers_len);
#endif
  return clusters;
}

/*---< cluster() >-----------------------------------------------------------*/
int cluster_cilk(int      numObjects,      /* number of input objects */
		 int      numAttributes,   /* size of attribute of each object */
		 float  **attributes,      /* [numObjects][numAttributes] */
		 int      num_nclusters,
		 float    threshold,       /* in:   */
		 float ***cluster_centres /* out: [best_nclusters][numAttributes] */
    
		 )
{
  int     nclusters;
  int    *membership;
  float **tmp_cluster_centres;

  membership = (int*) malloc(numObjects * sizeof(int));

  nclusters=num_nclusters;

  srand(7);
	
  tmp_cluster_centres = kmeans_cilk(attributes,
				    numAttributes,
				    numObjects,
				    nclusters,
				    threshold,
				    membership);

  if (*cluster_centres) {
    free((*cluster_centres)[0]);
    free(*cluster_centres);
  }
  *cluster_centres = tmp_cluster_centres;

   
  free(membership);

  return 0;
}

