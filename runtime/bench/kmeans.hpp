#pragma once

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

#include "kmeans_rollforward_decls.hpp"

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
    for ( int j = 0; j < numAttributes; j++ ) {
      attributes[i][j] = (float)mcsl::hash(j) / (float)RAND_MAX;
    }
  }
  kmeans_input_type in = { nObj, nFeat, attributes };
  return in;
}

extern
void* mycalloc(std::size_t szb);

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

extern
float** kmeans_serial(float **feature,    /* in: [npoints][nfeatures] */
                          int     nfeatures,
                          int     npoints,
                          int     nclusters,
                          float   threshold,
		      int    *membership);


/*---< cluster() >-----------------------------------------------------------*/
int cluster_serial(int      numObjects,      /* number of input objects */
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

  //srand(7);
	
  tmp_cluster_centres = kmeans_serial(attributes,
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


extern
void kmeans_inner(float **feature,
                  int     nfeatures,
                  int     npoints,
                  int     nclusters,
                  float   threshold,
                  int    *membership,
                  float*   delta_dst,
                  float  **clusters,
                  int     *new_centers_len,
                  float  **new_centers,
                  int      lo,
                  int      hi,
                  void    *p);

int kmeans_inner_handler(float **feature,
			 int     nfeatures,
			 int     npoints,
			 int     nclusters,
			 float   threshold,
			 int    *membership,
			 float*   delta_dst,
			 float  **clusters,
			 int     *new_centers_len,
			 float  **new_centers,
			 int      lo,
			 int      hi,
			 void* _p) {
  tpalrts::promotable* p = (tpalrts::promotable*)_p;
  if ((hi - lo) < 2) {
    return 0;
  }
  auto mid = (lo + hi) / 2;
  using dst_rec_type = void;
  dst_rec_type* dst_rec;
  tpalrts::arena_block_type* dst_blk;
  int float_szb = sizeof(float);
  int new_centers_len_szb = sizeof(int) * nclusters;
  int new_centers_szb = sizeof(float*) * nclusters;
  int new_centers0_szb = sizeof(float) * nclusters * nfeatures;
  std::tie(dst_rec, dst_blk) = tpalrts::alloc_arena_block(float_szb + new_centers_len_szb + new_centers_szb + new_centers0_szb);
  auto ptr = (char*)dst_rec;
  int szb = 0;
  auto delta_dst2 = (float*)&ptr[szb];
  szb += float_szb;
  auto new_centers_len2 = (int*)&ptr[szb];
  szb += new_centers_len_szb;
  auto new_centers2 = (float**)&ptr[szb];
  szb += new_centers_szb;
  *delta_dst2 = 0.0;
  new_centers2[0] = (float*)&ptr[szb];
  for (int i=1; i<nclusters; i++)
    new_centers2[i] = new_centers2[i-1] + nfeatures;
  for (int i=0; i<nclusters; i++) {
    new_centers_len2[i] = 0;
    for (int j=0; j<nfeatures; j++) {
      new_centers2[i][j] = 0.0;
    }
  }
  p->fork_join_promote2([=] (tpalrts::promotable* p2) {
    kmeans_inner(feature,
		 nfeatures,
		 npoints,
		 nclusters,
		 threshold,
		 membership,
		 delta_dst,
		 clusters,
		 new_centers_len,
		 new_centers,
		 lo,
		 mid,
		 p2);
  }, [=] (tpalrts::promotable* p2) {
    kmeans_inner(feature,
		 nfeatures,
		 npoints,
		 nclusters,
		 threshold,
		 membership,
		 delta_dst2,
		 clusters,
		 new_centers_len2,
		 new_centers2,
		 mid,
		 hi,
		 p2);    
  }, [=] (tpalrts::promotable* p2) {
    *delta_dst += *delta_dst2;
    for (int i = 0; i < nclusters; i++) {
      new_centers_len[i] += new_centers_len2[i];
      for (int j=0; j<nfeatures; j++) {
	new_centers[i][j] += new_centers2[i][j];
      }
    }
    decr_arena_block(dst_blk);
  });
  return 1;
}

extern
void kmeans_outer(float **feature,
                  int     nfeatures,
                  int     npoints,
                  int     nclusters,
                  float   threshold,
                  int    *membership,
                  float   delta,
                  float  **clusters,
                  int     *new_centers_len,
                  float  **new_centers,
                  void    *p);

int kmeans_outer_handler(float **feature,
			 int     nfeatures,
			 int     npoints,
			 int     nclusters,
			 float   threshold,
			 int    *membership,
			 float   delta,
			 float  **clusters,
			 int     *new_centers_len,
			 float  **new_centers,
			 int      lo,
			 int      hi,
			 void* _p) {
  tpalrts::promotable* p = (tpalrts::promotable*)_p;
  tpalrts::stats::increment(tpalrts::stats_configuration::nb_heartbeats);
  if ((hi - lo) < 2) {
    return 0;
  }
  using dst_rec_type = float;
  dst_rec_type* dst_rec;
  tpalrts::arena_block_type* dst_blk;
  std::tie(dst_rec, dst_blk) = tpalrts::alloc_arena<dst_rec_type>();
  *dst_rec = delta;
  p->fork_join_promote([=] (tpalrts::promotable* p2) {
    kmeans_inner(feature,
		 nfeatures,
		 npoints,
		 nclusters,
		 threshold,
		 membership,
		 dst_rec,
		 clusters,
		 new_centers_len,
		 new_centers,
		 lo,
		 hi,
		 p2);

  }, [=] (tpalrts::promotable* p2) {
    /* replace old cluster centers with new_centers */
    for (int i=0; i<nclusters; i++) {
      for (int j=0; j<nfeatures; j++) {
	if (new_centers_len[i] > 0)
	  clusters[i][j] = new_centers[i][j] / new_centers_len[i];
	  new_centers[i][j] = 0.0;   /* set back to 0 */
      }
      new_centers_len[i] = 0;   /* set back to 0 */
    }
    auto delta2 = *dst_rec;
    decr_arena_block(dst_blk);
    if (delta2 > threshold) {
      kmeans_outer(feature,
		   nfeatures,
		   npoints,
		   nclusters,
		   threshold,
		   membership,
		   0.0,
		   clusters,
		   new_centers_len,
		   new_centers,
		   p2);
    }
  });
  return 1;
}


/*----< kmeans_clustering() >---------------------------------------------*/
float** kmeans_interrupt(float **feature,    /* in: [npoints][nfeatures] */
			 int     nfeatures,
			 int     npoints,
			 int     nclusters,
			 float   threshold,
			 int    *membership,
			 tpalrts::promotable* p) /* out: [npoints] */
{

  int      i, j, n=0, index, loop=0;
  int     *new_centers_len; /* [nclusters]: no. of points in each cluster */
  float    delta;
  float  **clusters;   /* out: [nclusters][nfeatures] */
  float  **new_centers;     /* [nclusters][nfeatures] */
  

  /* allocate space for returning variable clusters[] */
  clusters    = (float**) malloc(nclusters *             sizeof(float*));
  clusters[0] = (float*)  malloc(nclusters * nfeatures * sizeof(float));
  for (i=1; i<nclusters; i++)
    clusters[i] = clusters[i-1] + nfeatures;

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
  new_centers_len = (int*) mycalloc(nclusters * sizeof(int));
  //  new_centers_len = (int*) calloc(nclusters, sizeof(int));

  new_centers    = (float**) malloc(nclusters *            sizeof(float*));
  //new_centers[0] = (float*)  calloc(nclusters * nfeatures, sizeof(float));
  new_centers[0] = (float*)  mycalloc((nclusters * nfeatures) * sizeof(float));
  for (i=1; i<nclusters; i++)
    new_centers[i] = new_centers[i-1] + nfeatures;
 
  p->fork_join_promote([=] (tpalrts::promotable* p2) {
    kmeans_outer(feature,
		 nfeatures,
		 npoints,
		 nclusters,
		 threshold,
		 membership,
		 delta,
		 clusters,
		 new_centers_len,
		 new_centers,
		 p2);

  }, [=] (tpalrts::promotable* p2) {
    free(new_centers[0]);
    free(new_centers);
    free(new_centers_len);
  });

  return clusters;
}

/*---< cluster() >-----------------------------------------------------------*/
int cluster_interrupt(int      numObjects,      /* number of input objects */
		      int      numAttributes,   /* size of attribute of each object */
		      float  **attributes,      /* [numObjects][numAttributes] */
		      int      num_nclusters,
		      float    threshold,       /* in:   */
		      float ***cluster_centres, /* out: [best_nclusters][numAttributes] */
		      tpalrts::promotable* p
		 )
{
  int     nclusters;
  int    *membership;
  //float **tmp_cluster_centres;

  membership = (int*) malloc(numObjects * sizeof(int));

  nclusters=num_nclusters;

  //srand(7);

  p->fork_join_promote([=] (tpalrts::promotable* p2) {
    auto tmp_cluster_centres = kmeans_interrupt(attributes,
					   numAttributes,
					   numObjects,
					   nclusters,
					   threshold,
					   membership,
					   p2);
  }, [=] (tpalrts::promotable* p2) {

    if (*cluster_centres) {
      free((*cluster_centres)[0]);
      free(*cluster_centres);
    }
    //*cluster_centres = tmp_cluster_centres;


    free(membership);
  });

  return 0;
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
  float  **clusters;   /* out: [nclusters][nfeatures] */
  float  **new_centers;     /* [nclusters][nfeatures] */

#if defined(USE_CILK_PLUS)
  cilk::reducer_opadd<float> delta(0.0);

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

  //srand(7);
	
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

/*---------------------------------------------------------------------*/

namespace kmeans {

using namespace tpalrts;

int numObjects = 1000000;
kmeans_input_type in;
float** attributes;
int numAttributes;
int nclusters=5;
float   threshold = 0.001;
float **cluster_centres=NULL;

auto bench_pre(promotable* p) {
  in = kmeans_inputgen(numObjects);
  attributes = in.attributes;
  numAttributes = in.nFeat;
};
  
auto bench_body_interrupt(promotable* p) {
  rollforward_table = {
    #include "kmeans_rollforward_map.hpp"
  };
  cluster_interrupt(numObjects, numAttributes, attributes, nclusters, threshold, &cluster_centres, p);
};
  
auto bench_body_software_polling(promotable* p) {

};
  
auto bench_body_serial(promotable* p) {
  cluster_serial(numObjects, numAttributes, attributes, nclusters, threshold, &cluster_centres);
};
  
auto bench_post(promotable* p){
  free(in.attributes[0]);
  free(in.attributes);
};

auto bench_body_cilk() {
  cluster_cilk(numObjects, numAttributes, attributes, nclusters, threshold, &cluster_centres);
};

  
}
