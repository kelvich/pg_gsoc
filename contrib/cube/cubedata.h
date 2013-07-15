/* contrib/cube/cubedata.h */

#define CUBE_MAX_DIM (100)

typedef struct NDBOX
{
	/* varlena header (do not touch directly!) */
	int32 vl_len_;

	/* 
	 * Header contains info about NDBOX. For binary
	 * compatibility with old versions it is defined
	 * as uint32.
	 * 
	 * Following information is stored:
	 *
	 *  bits 0-7  : number of cube dimensions;
	 *  bits 8-27 : not used;
	 *  bit  31   : point flag. If set, then NDBOX stores
	 *              n dimensions instead of 2*n;
	 */
	unsigned int header;
	double x[1];
} NDBOX;

enum cube_types 
{
	CUBE_FLOAT8,
	CUBE_FLOAT4,
	CUBE_INT4,
	CUBE_INT2,
	CUBE_INT1,
	CUBE_VARINT
};

#define DatumGetNDBOX(x)   ((NDBOX*)DatumGetPointer(x))
#define PG_GETARG_NDBOX(x) DatumGetNDBOX( PG_DETOAST_DATUM(PG_GETARG_DATUM(x)) )
#define PG_RETURN_NDBOX(x) PG_RETURN_POINTER(x)

#define SET_DIM(cube, _dim) ( cube->header = _dim )
#define DIM(cube) ( cube->header & 0x7f )

#define SET_TYPE(cube, type) ( cube->header |= (type << 28) )
#define TYPE(cube) ( cube->header & 0x70000000 )

#define SET_POINT_BIT(cube) ( cube->header |= 0x80000000 )
#define IS_POINT(cube) ( cube->header & 0x80000000 )

#define POINT_SIZE(_dim) (offsetof(NDBOX, x[0]) + sizeof(double)*_dim)
#define CUBE_SIZE(_dim)  (offsetof(NDBOX, x[0]) + sizeof(double)*_dim*2)

#define LL_COORD(cube, i) ( cube->x[i] )
#define UR_COORD(cube, i) ( IS_POINT(cube) ? cube->x[i] : cube->x[i + DIM(cube)] )

#define CUBE_TYPE_WRAPPER1(func, type) \
	PG_FUNCTION_INFO_V1( _## type ##_## func ); \
	Datum		_## type ##_## func (PG_FUNCTION_ARGS); \
	Datum \
	_## type ##_## func (PG_FUNCTION_ARGS) \
	{ \
		Datum		arg = PG_GETARG_DATUM(0); \
		NDBOX	   *result; \
		result = DatumGetNDBOX(DirectFunctionCall1(func, arg)); \
		SET_TYPE(result, CUBE_ ## type); \
		PG_RETURN_NDBOX(result); \
	}

#define CUBE_TYPE_WRAPPER2(func, type) \
	PG_FUNCTION_INFO_V1( _## type ##_## func ); \
	Datum		_## type ##_## func (PG_FUNCTION_ARGS); \
	Datum \
	_## type ##_## func (PG_FUNCTION_ARGS) \
	{ \
		Datum		arg1 = PG_GETARG_DATUM(0); \
		Datum		arg2 = PG_GETARG_DATUM(1); \
		NDBOX	   *result; \
		result = DatumGetNDBOX(DirectFunctionCall2(func, arg1, arg2)); \
		SET_TYPE(result, CUBE_ ## type); \
		PG_RETURN_NDBOX(result); \
	}

#define CUBE_OUT_WRAPPER(type) \
	PG_FUNCTION_INFO_V1( _## type ##_## cube_out ); \
	Datum		_## type ##_## cube_out (PG_FUNCTION_ARGS); \
	Datum \
	_## type ##_## cube_out (PG_FUNCTION_ARGS) \
	{ \
		PG_RETURN_CSTRING( \
			DatumGetCString( \
				DirectFunctionCall1(cube_out, PG_GETARG_DATUM(0)))); \
	}






