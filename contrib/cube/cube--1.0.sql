/* contrib/cube/cube--1.0.sql */

-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION cube" to load this file. \quit

-- Create the user-defined type for N-dimensional boxes

CREATE FUNCTION cube_in(cstring, oid, integer)
RETURNS cube
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION cube_out(cube)
RETURNS cstring
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION cube_type_in(cstring[])
RETURNS integer
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

-- CREATE FUNCTION cube_type_out(integer)
-- RETURNS cstring
-- AS 'MODULE_PATHNAME'
-- LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION cube(cube, integer, boolean)
RETURNS cube
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

CREATE TYPE cube (
	INTERNALLENGTH = variable,
	INPUT = cube_in,
	OUTPUT = cube_out,
	TYPMOD_IN = cube_type_in,
	-- TYPMOD_OUT = cube_type_out,
	ALIGNMENT = float
);

CREATE CAST (cube AS cube)
    WITH FUNCTION cube(cube, integer, boolean);

COMMENT ON TYPE cube IS 'multi-dimensional cube ''(FLOAT-1, FLOAT-2, ..., FLOAT-N), (FLOAT-1, FLOAT-2, ..., FLOAT-N)''';

-- Cube creation with types

CREATE FUNCTION cube(float8[])
	RETURNS cube AS 'MODULE_PATHNAME', 'cube_arr_FLOAT8' LANGUAGE C IMMUTABLE STRICT;
CREATE FUNCTION cube(float8[], float8[])
	RETURNS cube AS 'MODULE_PATHNAME', 'cube_arr_arr_FLOAT8' LANGUAGE C IMMUTABLE STRICT;
CREATE FUNCTION cube(float8)
	RETURNS cube AS 'MODULE_PATHNAME', 'cube_num_FLOAT8' LANGUAGE C IMMUTABLE STRICT;
CREATE FUNCTION cube(float8, float8)
	RETURNS cube AS 'MODULE_PATHNAME', 'cube_num_num_FLOAT8' LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION cube_f4(float8[])
	RETURNS cube AS 'MODULE_PATHNAME', 'cube_arr_FLOAT4' LANGUAGE C IMMUTABLE STRICT;
CREATE FUNCTION cube_f4(float8[], float8[])
	RETURNS cube AS 'MODULE_PATHNAME', 'cube_arr_arr_FLOAT4' LANGUAGE C IMMUTABLE STRICT;
CREATE FUNCTION cube_f4(float8)
	RETURNS cube AS 'MODULE_PATHNAME', 'cube_num_FLOAT4' LANGUAGE C IMMUTABLE STRICT;
CREATE FUNCTION cube_f4(float8, float8)
	RETURNS cube AS 'MODULE_PATHNAME', 'cube_num_num_FLOAT4' LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION cube_i4(float8[])
	RETURNS cube AS 'MODULE_PATHNAME', 'cube_arr_INT4' LANGUAGE C IMMUTABLE STRICT;
CREATE FUNCTION cube_i4(float8[], float8[])
	RETURNS cube AS 'MODULE_PATHNAME', 'cube_arr_arr_INT4' LANGUAGE C IMMUTABLE STRICT;
CREATE FUNCTION cube_i4(float8)
	RETURNS cube AS 'MODULE_PATHNAME', 'cube_num_INT4' LANGUAGE C IMMUTABLE STRICT;
CREATE FUNCTION cube_i4(float8, float8)
	RETURNS cube AS 'MODULE_PATHNAME', 'cube_num_num_INT4' LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION cube_i2(float8[])
	RETURNS cube AS 'MODULE_PATHNAME', 'cube_arr_INT2' LANGUAGE C IMMUTABLE STRICT;
CREATE FUNCTION cube_i2(float8[], float8[])
	RETURNS cube AS 'MODULE_PATHNAME', 'cube_arr_arr_INT2' LANGUAGE C IMMUTABLE STRICT;
CREATE FUNCTION cube_i2(float8)
	RETURNS cube AS 'MODULE_PATHNAME', 'cube_num_INT2' LANGUAGE C IMMUTABLE STRICT;
CREATE FUNCTION cube_i2(float8, float8)
	RETURNS cube AS 'MODULE_PATHNAME', 'cube_num_num_INT2' LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION cube_i1(float8[])
	RETURNS cube AS 'MODULE_PATHNAME', 'cube_arr_INT1' LANGUAGE C IMMUTABLE STRICT;
CREATE FUNCTION cube_i1(float8[], float8[])
	RETURNS cube AS 'MODULE_PATHNAME', 'cube_arr_arr_INT1' LANGUAGE C IMMUTABLE STRICT;
CREATE FUNCTION cube_i1(float8)
	RETURNS cube AS 'MODULE_PATHNAME', 'cube_num_INT1' LANGUAGE C IMMUTABLE STRICT;
CREATE FUNCTION cube_i1(float8, float8)
	RETURNS cube AS 'MODULE_PATHNAME', 'cube_num_num_INT1' LANGUAGE C IMMUTABLE STRICT;

--
-- External C-functions for R-tree methods
--

-- Comparison methods

CREATE FUNCTION cube_eq(cube, cube)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

COMMENT ON FUNCTION cube_eq(cube, cube) IS 'same as';

CREATE FUNCTION cube_ne(cube, cube)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

COMMENT ON FUNCTION cube_ne(cube, cube) IS 'different';

CREATE FUNCTION cube_lt(cube, cube)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

COMMENT ON FUNCTION cube_lt(cube, cube) IS 'lower than';

CREATE FUNCTION cube_gt(cube, cube)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

COMMENT ON FUNCTION cube_gt(cube, cube) IS 'greater than';

CREATE FUNCTION cube_le(cube, cube)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

COMMENT ON FUNCTION cube_le(cube, cube) IS 'lower than or equal to';

CREATE FUNCTION cube_ge(cube, cube)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

COMMENT ON FUNCTION cube_ge(cube, cube) IS 'greater than or equal to';

CREATE FUNCTION cube_cmp(cube, cube)
RETURNS int4
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

COMMENT ON FUNCTION cube_cmp(cube, cube) IS 'btree comparison function';

CREATE FUNCTION cube_contains(cube, cube)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

COMMENT ON FUNCTION cube_contains(cube, cube) IS 'contains';

CREATE FUNCTION cube_contained(cube, cube)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

COMMENT ON FUNCTION cube_contained(cube, cube) IS 'contained in';

CREATE FUNCTION cube_overlap(cube, cube)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

COMMENT ON FUNCTION cube_overlap(cube, cube) IS 'overlaps';

-- support routines for indexing

CREATE FUNCTION cube_union(cube, cube)
RETURNS cube
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION cube_inter(cube, cube)
RETURNS cube
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION cube_size(cube)
RETURNS float8
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;


-- Misc N-dimensional functions

CREATE FUNCTION cube_subset(cube, int4[])
RETURNS cube
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

-- proximity routines

CREATE FUNCTION cube_distance(cube, cube)
RETURNS float8
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

-- Extracting elements functions

CREATE FUNCTION cube_dim(cube)
RETURNS int4
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION cube_ll_coord(cube, int4)
RETURNS float8
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION cube_ur_coord(cube, int4)
RETURNS float8
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION cube(cube, float8) RETURNS cube
AS 'MODULE_PATHNAME', 'cube_c_f8'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION cube(cube, float8, float8) RETURNS cube
AS 'MODULE_PATHNAME', 'cube_c_f8_f8'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION cube_sort_by(cube, int4) RETURNS float8
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

-- Test if cube is also a point

CREATE FUNCTION cube_is_point(cube)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

-- Increasing the size of a cube by a radius in at least n dimensions

CREATE FUNCTION cube_enlarge(cube, float8, int4)
RETURNS cube
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

--
-- OPERATORS
--

CREATE OPERATOR < (
	LEFTARG = cube, RIGHTARG = cube, PROCEDURE = cube_lt,
	COMMUTATOR = '>', NEGATOR = '>=',
	RESTRICT = scalarltsel, JOIN = scalarltjoinsel
);

CREATE OPERATOR > (
	LEFTARG = cube, RIGHTARG = cube, PROCEDURE = cube_gt,
	COMMUTATOR = '<', NEGATOR = '<=',
	RESTRICT = scalargtsel, JOIN = scalargtjoinsel
);

CREATE OPERATOR <= (
	LEFTARG = cube, RIGHTARG = cube, PROCEDURE = cube_le,
	COMMUTATOR = '>=', NEGATOR = '>',
	RESTRICT = scalarltsel, JOIN = scalarltjoinsel
);

CREATE OPERATOR >= (
	LEFTARG = cube, RIGHTARG = cube, PROCEDURE = cube_ge,
	COMMUTATOR = '<=', NEGATOR = '<',
	RESTRICT = scalargtsel, JOIN = scalargtjoinsel
);

CREATE OPERATOR && (
	LEFTARG = cube, RIGHTARG = cube, PROCEDURE = cube_overlap,
	COMMUTATOR = '&&',
	RESTRICT = areasel, JOIN = areajoinsel
);

CREATE OPERATOR = (
	LEFTARG = cube, RIGHTARG = cube, PROCEDURE = cube_eq,
	COMMUTATOR = '=', NEGATOR = '<>',
	RESTRICT = eqsel, JOIN = eqjoinsel,
	MERGES
);

CREATE OPERATOR <> (
	LEFTARG = cube, RIGHTARG = cube, PROCEDURE = cube_ne,
	COMMUTATOR = '<>', NEGATOR = '=',
	RESTRICT = neqsel, JOIN = neqjoinsel
);

CREATE OPERATOR @> (
	LEFTARG = cube, RIGHTARG = cube, PROCEDURE = cube_contains,
	COMMUTATOR = '<@',
	RESTRICT = contsel, JOIN = contjoinsel
);

CREATE OPERATOR <@ (
	LEFTARG = cube, RIGHTARG = cube, PROCEDURE = cube_contained,
	COMMUTATOR = '@>',
	RESTRICT = contsel, JOIN = contjoinsel
);

CREATE OPERATOR <*> (
	LEFTARG = cube, RIGHTARG = int4, PROCEDURE = cube_sort_by,
	COMMUTATOR = '<*>'
);

-- these are obsolete/deprecated:
CREATE OPERATOR @ (
	LEFTARG = cube, RIGHTARG = cube, PROCEDURE = cube_contains,
	COMMUTATOR = '~',
	RESTRICT = contsel, JOIN = contjoinsel
);

CREATE OPERATOR ~ (
	LEFTARG = cube, RIGHTARG = cube, PROCEDURE = cube_contained,
	COMMUTATOR = '@',
	RESTRICT = contsel, JOIN = contjoinsel
);


-- define the GiST support methods
CREATE FUNCTION g_cube_consistent(internal,cube,int,oid,internal)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION g_cube_compress(internal)
RETURNS internal
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION g_cube_decompress(internal)
RETURNS internal
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION g_cube_penalty(internal,internal,internal)
RETURNS internal
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION g_cube_picksplit(internal, internal)
RETURNS internal
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION g_cube_union(internal, internal)
RETURNS cube
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION g_cube_same(cube, cube, internal)
RETURNS internal
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION g_cube_distance(internal, cube, smallint, oid)
RETURNS float8
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;


-- Create the operator classes for indexing

CREATE OPERATOR CLASS cube_ops
    DEFAULT FOR TYPE cube USING btree AS
        OPERATOR        1       < ,
        OPERATOR        2       <= ,
        OPERATOR        3       = ,
        OPERATOR        4       >= ,
        OPERATOR        5       > ,
        FUNCTION        1       cube_cmp(cube, cube);

CREATE OPERATOR CLASS gist_cube_ops
    DEFAULT FOR TYPE cube USING gist AS
	OPERATOR	3	&& ,
	OPERATOR	6	= ,
	OPERATOR	7	@> ,
	OPERATOR	8	<@ ,
	OPERATOR	13	@ ,
	OPERATOR	14	~ ,
	OPERATOR	15	<*> (cube, int) FOR ORDER BY float_ops,
	FUNCTION	1	g_cube_consistent (internal, cube, int, oid, internal),
	FUNCTION	2	g_cube_union (internal, internal),
	FUNCTION	3	g_cube_compress (internal),
	FUNCTION	4	g_cube_decompress (internal),
	FUNCTION	5	g_cube_penalty (internal, internal, internal),
	FUNCTION	6	g_cube_picksplit (internal, internal),
	FUNCTION	7	g_cube_same (cube, cube, internal),
	FUNCTION	8	g_cube_distance (internal, cube, smallint, oid);
