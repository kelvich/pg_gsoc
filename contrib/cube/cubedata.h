/* contrib/cube/cubedata.h */

#define CUBE_MAX_DIM (100)

typedef struct NDBOX
{
	int32 vl_len_; /* varlena header (do not touch directly!) */
	unsigned int dim;
	double x[1];
} NDBOX;

#define DatumGetNDBOX(x) ((NDBOX*)DatumGetPointer(x))
#define PG_GETARG_NDBOX(x) DatumGetNDBOX( PG_DETOAST_DATUM(PG_GETARG_DATUM(x)) )
#define PG_RETURN_NDBOX(x) PG_RETURN_POINTER(x)

#define IS_POINT(cube) ( cube->dim >> 31 )
#define SET_POINT_BIT(cube) ( cube->dim = cube->dim + 0x80000000 )
#define DIM(cube) ( cube->dim & 0x7fffffff )

#define LL_COORD(cube, i) ( cube->x[i] )
#define UR_COORD(cube, i) ( IS_POINT(cube) ? cube->x[i] : cube->x[i + DIM(cube)] )

#define CUBE_SIZE(dim) (offsetof(NDBOX, x[0]) + 2*sizeof(double)*dim)
#define POINT_SIZE(dim) (offsetof(NDBOX, x[0]) + sizeof(double)*dim)

// #define TRACE
