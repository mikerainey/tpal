#include <stdlib.h>

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

float** kmeans_serial(float **feature,    /* in: [npoints][nfeatures] */
                          int     nfeatures,
                          int     npoints,
                          int     nclusters,
                          float   threshold,
                          int    *membership) /* out: [npoints] */
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
  new_centers_len = (int*) calloc(nclusters, sizeof(int));

  new_centers    = (float**) malloc(nclusters *            sizeof(float*));
  new_centers[0] = (float*)  calloc(nclusters * nfeatures, sizeof(float));
  for (i=1; i<nclusters; i++)
    new_centers[i] = new_centers[i-1] + nfeatures;
 
  
  do {
		
    delta = 0.0;

    for (i=0; i<npoints; i++) {
      /* find the index of nestest cluster centers */
      index = find_nearest_point(feature[i], nfeatures, clusters, nclusters);
      /* if membership changes, increase delta by 1 */
      if (membership[i] != index) delta += 1.0;

      /* assign the membership to object i */
      membership[i] = index;

      /* update new cluster centers : sum of objects located within */
      new_centers_len[index]++;
      for (j=0; j<nfeatures; j++)          
	      new_centers[index][j] += feature[i][j];
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
  } while (delta > threshold);

  
  free(new_centers[0]);
  free(new_centers);
  free(new_centers_len);

  return clusters;
}
