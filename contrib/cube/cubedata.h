/* contrib/cube/cubedata.h */

#define CUBE_MAX_DIM (100)

typedef struct NDBOX
{
	int32 vl_len_;		/* varlena header (do not touch directly!) */
	unsigned int dim;
  unsigned short info;
	double x[1];
} NDBOX;

#define DatumGetNDBOX(x)	((NDBOX*)DatumGetPointer(x))
#define PG_GETARG_NDBOX(x)	DatumGetNDBOX( PG_DETOAST_DATUM(PG_GETARG_DATUM(x)) )
#define PG_RETURN_NDBOX(x)	PG_RETURN_POINTER(x)


#define IS_POINT(cube) ( cube->dim >> 31 )
#define NDIMS(cube) ( cube->dim & 0x7fffffff )
#define GET_COORD(cube, i) ( IS_POINT(cube) ? cube->x[i % NDIMS(cube)] : cube->x[i] )

