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
	 *  bits 28-30: cube coord type;
	 *  bit  31   : point flag. If set, then NDBOX stores
	 *              n dimensions instead of 2*n;
	 */
	unsigned int header;

	union
	{
		double	coord_f8[1];
		float 	coord_f4[1];
		int 	coord_i4[1];
		short 	coord_i2[1];
		char	coord_i1[1];
	};
	
} NDBOX;


// если делаем union, то появляется отступ в 3 байта
// с union:
//         RawDataBody:
//           30 00 00 00 09 00 00 00
//           03 04 05 06 00 00 00 00
// без union:
//        RawDataBody:
//          24 00 00 00 09 03 04 05
//          06 00 00 00 00 00 00 00
typedef struct COMPRESSED_NDBOX
{
	int32 vl_len_;
	unsigned char point      :1;
	unsigned char type       :3;
	union 
	{
		float 	coord_f4[1];
		int 	coord_i4[1];
		short 	coord_i2[1];
		char	coord_i1[1];
	};
} COMPRESSED_NDBOX;

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
#define TYPE(cube) ( (cube->header & 0x70000000) >> 28 )

#define SET_POINT_BIT(cube) ( cube->header |= 0x80000000 )
#define IS_POINT(cube) ( (cube->header & 0x80000000) >> 31 )

#define POINT_SIZE(_dim) (offsetof(NDBOX, coord_f8[0]) + sizeof(double)*_dim)
#define CUBE_SIZE(_dim)  (offsetof(NDBOX, coord_f8[0]) + sizeof(double)*_dim*2)

#define LL_COORD(cube, i) ( get_coord(cube, i) )
#define UR_COORD(cube, i) ( IS_POINT(cube) ? get_coord(cube, i) : get_coord(cube, i + DIM(cube)) )


/*
 *	Macroses for generating wrappers over cube creation functions.
 *	That mocroses set type to cube header for further comperession.
 *  For example CUBE_TYPE_WRAPPER2(cube_a_f8_f8, INT4) generates
 *  function _FLOAT4_cube_a_f8_f8(double[], double[]) that toggles FLOAT4
 *  type to created cube.
 *  
 *  	CUBE_TYPE_WRAPPER1 for single argument functions
 *  	CUBE_TYPE_WRAPPER2 for functions with two arguments
 */
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

/*
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
*/





