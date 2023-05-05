-- $manifold$

-- define τ and π
-- PI is built into Manifold 9
VALUE @τ FLOAT64 = PI*2;
VALUE @π FLOAT64 = PI;
VALUE @tau FLOAT64 = PI*2;

-- Shorter aliases for creating Vectors 
FUNCTION v2(@x FLOAT64, @y FLOAT64) FLOAT64X2 AS VectorMakeX2(@x, @y) END ;
FUNCTION v3(@x FLOAT64, @y FLOAT64, @z FLOAT64) FLOAT64X3 AS VectorMakeX3(@x, @y, @z) END ;
FUNCTION v4(@x FLOAT64, @y FLOAT64, @z FLOAT64, @w FLOAT64) FLOAT64X4 AS VectorMakeX4(@x, @y, @z, @w) END ;

-- Short accessors of vector components
FUNCTION x2(@v FLOAT64X2) FLOAT64 AS VectorValue(@v, 0) END ;
FUNCTION y2(@v FLOAT64X2) FLOAT64 AS VectorValue(@v, 1) END ;
	

FUNCTION x3(@v FLOAT64X3) FLOAT64 AS VectorValue(@v, 0) END ;
FUNCTION y3(@v FLOAT64X3) FLOAT64 AS VectorValue(@v, 1) END ;
FUNCTION z3(@v FLOAT64X3) FLOAT64 AS VectorValue(@v, 2) END ;


FUNCTION x4(@v FLOAT64X4) FLOAT64 AS VectorValue(@v, 0) END ;
FUNCTION y4(@v FLOAT64X4) FLOAT64 AS VectorValue(@v, 1) END ;
FUNCTION z4(@v FLOAT64X4) FLOAT64 AS VectorValue(@v, 2) END ;
FUNCTION w4(@v FLOAT64X4) FLOAT64 AS VectorValue(@v, 3) END ;


-- Short setters of vector components
FUNCTION setx2(@v FLOAT64X2, @x FLOAT64) FLOAT64X2 AS v2(@x, y2(@v)) END ;
FUNCTION sety2(@v FLOAT64X2, @y FLOAT64) FLOAT64X2 AS v2(x2(@v), @y) END ;

FUNCTION setx3(@v FLOAT64X3, @x FLOAT64) FLOAT64X3 AS v3(@x, y4(@v), z4(@v) ) END ;
FUNCTION sety3(@v FLOAT64X3, @y FLOAT64) FLOAT64X3 AS v3(x4(@v), @y, z4(@v) ) END ;
FUNCTION setz3(@v FLOAT64X3, @z FLOAT64) FLOAT64X3 AS v3(x4(@v), y4(@v), @z ) END ;

FUNCTION setx4(@v FLOAT64X4, @x FLOAT64) FLOAT64X4 AS v4(@x, y4(@v), z4(@v), w4(@v) ) END ;
FUNCTION sety4(@v FLOAT64X4, @y FLOAT64) FLOAT64X4 AS v4(x4(@v), @y, z4(@v), w4(@v) ) END ;
FUNCTION setz4(@v FLOAT64X4, @z FLOAT64) FLOAT64X4 AS v4(x4(@v), y4(@v), @z, w4(@v) ) END ;
FUNCTION setw4(@v FLOAT64X4, @w FLOAT64) FLOAT64X4 AS v4(x4(@v), y4(@v), z4(@v), @w ) END ;

-- drop 3rd and/or 4th dimension
FUNCTION v2f3(@v FLOAT64X3) FLOAT64X2 AS v2( x3(@v), y3(@v) ) END ;
FUNCTION v2f4(@v FLOAT64X4) FLOAT64X2 AS v2( x4(@v), y4(@v) ) END ;
FUNCTION v3f4(@v FLOAT64X4) FLOAT64X3 AS v3( x4(@v), y4(@v), z4(@v) ) END ;

-- add 3rd and/or 4th dimension
FUNCTION v3f2(@v FLOAT64X2) FLOAT64X3 AS v3( x2(@v), y2(@v), 0 ) END ;
FUNCTION v4f2(@v FLOAT64X2) FLOAT64X4 AS v4( x2(@v), y2(@v), 0, 0 ) END ;
FUNCTION v4f3(@v FLOAT64X3) FLOAT64X4 AS v4( x3(@v), y3(@v), z3(@v), 0 ) END ;

-- regular vector to homogeneous coordinates
FUNCTION v2thom(@v FLOAT64X2) FLOAT64X3 AS v3( x2(@v), y2(@v), 1 ) END ;
FUNCTION v3thom(@v FLOAT64X3) FLOAT64X4 AS v4( x3(@v), y3(@v), z3(@v), 1) END ;

-- regular vector from homogeneous coordinates
FUNCTION v2fhom(@v FLOAT64X3) FLOAT64X2 AS v2( x3(@v)/z3(@v), y3(@v)/z3(@v) ) END ;
FUNCTION v3fhom(@v FLOAT64X4) FLOAT64X3 AS v3( x4(@v)/w4(@v), y4(@v)/w4(@v), z4(@v)/w4(@v) ) END ;

-- flip (negate) vectors
FUNCTION neg2(@v FLOAT64X2) FLOAT64X2 AS v2( -x2(@v), -y2(@v) ) END ;
FUNCTION neg3(@v FLOAT64X3) FLOAT64X3 AS v3( -x3(@v), -y3(@v), -z3(@v) ) END ;
FUNCTION neg4(@v FLOAT64X4) FLOAT64X4 AS v4( -x4(@v), -y4(@v), -z4(@v), -w4(@v) ) END ;

-- Perpendicular in 2D (rotate τ/4)
FUNCTION perp2(@v FLOAT64X2) FLOAT64X2 AS v2( -y2(@v), x2(@v) ) END ;

-- Angle from "north"?
FUNCTION AzimuthAngleCCW2(@v FLOAT64X2) FLOAT64 AS Atan2( y2(@v), x2(@v) ) END ;
FUNCTION AzimuthAngleCW2(@v FLOAT64X2) FLOAT64 AS Atan2( x2(@v), y2(@v) ) END ;


-- Clamp a number by boundsX2
FUNCTION clamp(@x FLOAT64, @v FLOAT64X2) FLOAT64 AS 
	Bound(@x, x2(@v), y2(@v), FALSE)
END ;

-- Epsilon equality
FUNCTION EqualsEpsilon1(@v FLOAT64, @u FLOAT64, @epsilon FLOAT64) BOOLEAN AS 
(
	    Abs( @v - @u ) <= @epsilon
)
END ;

FUNCTION EqualsEpsilon2(@v FLOAT64X2, @u FLOAT64X2, @epsilon FLOAT64) BOOLEAN AS 
(
	    Abs( x2(@v) - x2(@u) ) <= @epsilon
	AND	Abs( y2(@v) - y2(@u) ) <= @epsilon	
)
END ;

FUNCTION EqualsEpsilon3(@v FLOAT64X3, @u FLOAT64X3, @epsilon FLOAT64) BOOLEAN AS 
(
	    Abs( x3(@v) - x3(@u) ) <= @epsilon
	AND	Abs( y3(@v) - y3(@u) ) <= @epsilon	
	AND	Abs( z3(@v) - z3(@u) ) <= @epsilon
)
END ;

FUNCTION EqualsEpsilon4(@v FLOAT64X4, @u FLOAT64X4, @epsilon FLOAT64) BOOLEAN AS 
(
	    Abs( x4(@v) - x4(@u) ) <= @epsilon
	AND	Abs( y4(@v) - y4(@u) ) <= @epsilon	
	AND	Abs( z4(@v) - z4(@u) ) <= @epsilon	
	AND	Abs( w4(@v) - w4(@u) ) <= @epsilon
)
END ;


-- Add vectors / also ShiftComponents
FUNCTION add2(@a FLOAT64X2, @b FLOAT64X2) FLOAT64X2 AS v2(x2(@a) + x2(@b), y2(@a) + y2(@b) ) END ;
FUNCTION add3(@a FLOAT64X3, @b FLOAT64X3) FLOAT64X3 AS v3(x3(@a) + x3(@b), y3(@a) + y3(@b), z3(@a) + z3(@b) ) END ;
FUNCTION add4(@a FLOAT64X4, @b FLOAT64X4) FLOAT64X4 AS v4(x4(@a) + x4(@b), y4(@a) + y4(@b), z4(@a) + z4(@b), w4(@a) + w4(@b) ) END ;

-- Makes Vector ab === Subtracts @a from @b 
FUNCTION ab2(@a FLOAT64X2, @b FLOAT64X2) FLOAT64X2 AS v2(x2(@b) - x2(@a), y2(@b) - y2(@a) ) END ;
FUNCTION ab3(@a FLOAT64X3, @b FLOAT64X3) FLOAT64X3 AS v3(x3(@b) - x3(@a), y3(@b) - y3(@a), z3(@b) - z3(@a) ) END ;
FUNCTION ab4(@a FLOAT64X4, @b FLOAT64X4) FLOAT64X4 AS v4(x4(@b) - x4(@a), y4(@b) - y4(@a), z4(@b) - z4(@a), w4(@b) - w4(@a) ) END ;

-- Scale vectors
FUNCTION scale2(@a FLOAT64X2, @b FLOAT64) FLOAT64X2 AS v2(@b*x2(@a), @b*y2(@a)) END ;
FUNCTION scale3(@a FLOAT64X3, @b FLOAT64) FLOAT64X3 AS v3(@b*x3(@a), @b*y3(@a), @b*z3(@a)) END ;
FUNCTION scale4(@a FLOAT64X4, @b FLOAT64) FLOAT64X4 AS v4(@b*x4(@a), @b*y4(@a), @b*z4(@a), @b*w4(@a)) END ;

-- Scale vector components by another vector
FUNCTION scaleComponents2(@a FLOAT64X2, @b FLOAT64X2) FLOAT64X2 AS v2( x2(@a) * x2(@b), y2(@a) * y2(@b) ) END ;
FUNCTION scaleComponents3(@a FLOAT64X3, @b FLOAT64X3) FLOAT64X3 AS v3( x3(@a) * x3(@b), y3(@a) * y3(@b), z3(@a) * z3(@b) ) END ;
FUNCTION scaleComponents4(@a FLOAT64X4, @b FLOAT64X4) FLOAT64X4 AS v4( x4(@a) * x4(@b), y4(@a) * y4(@b), z4(@a) * z4(@b), w4(@a) * w4(@b) ) END ;

-- MostOrthogonalAxis
FUNCTION MostOrthogonalAxis2(@v FLOAT64X2) FLOAT64X2 AS 
(
	CASE
		WHEN Abs(x2(@v)) < Abs(y2(@v)) THEN v2(1,0)
		ELSE v2(0,1)
	END 
)
END ;

FUNCTION MostOrthogonalAxis3(@v FLOAT64X3) FLOAT64X3 AS 
(
	CASE
		WHEN Abs(x3(@v)) < Abs(y3(@v)) AND Abs(x3(@v)) < Abs(z3(@v)) THEN v3(1,0,0)
		WHEN Abs(y3(@v)) < Abs(x3(@v)) AND Abs(y3(@v)) < Abs(z3(@v)) THEN v3(0,1,0)
		ELSE v3(0,0,1)
	END 
)
END ;

FUNCTION MostOrthogonalAxis4(@v FLOAT64X4) FLOAT64X4 AS 
(
	CASE
		WHEN Abs(x4(@v)) < Abs(y4(@v)) AND Abs(x4(@v)) < Abs(z4(@v)) AND Abs(x4(@v)) < Abs(w4(@v)) THEN v4(1,0,0,0)
		WHEN Abs(y4(@v)) < Abs(x4(@v)) AND Abs(y4(@v)) < Abs(z4(@v)) AND Abs(y4(@v)) < Abs(w4(@v)) THEN v4(0,1,0,0)
		WHEN Abs(z4(@v)) < Abs(x4(@v)) AND Abs(z4(@v)) < Abs(y4(@v)) AND Abs(z4(@v)) < Abs(w4(@v)) THEN v4(0,0,1,0)
		ELSE v4(0,0,0,1)
	END 
)
END ;

--- 
--MinimumComponent
FUNCTION MinimumComponent2(@v FLOAT64X4) FLOAT64 AS 
(
	CASE
		WHEN x4(@v) < y4(@v) THEN x4(@v)
		ELSE y4(@v)
	END 
)
END
; 

FUNCTION MinimumComponent3(@v FLOAT64X4) FLOAT64 AS 
(
	CASE
		WHEN x4(@v) < y4(@v) AND x4(@v) < z4(@v) THEN x4(@v)
		WHEN y4(@v) < x4(@v) AND y4(@v) < z4(@v) THEN y4(@v)
		ELSE z4(@v)
	END 
)
END
;

FUNCTION MinimumComponent4(@v FLOAT64X4) FLOAT64 AS 
(
	CASE
		WHEN x4(@v) < y4(@v) AND x4(@v) < z4(@v) AND x4(@v) < w4(@v) THEN x4(@v)
		WHEN y4(@v) < x4(@v) AND y4(@v) < z4(@v) AND y4(@v) < w4(@v) THEN y4(@v)
		WHEN z4(@v) < x4(@v) AND z4(@v) < y4(@v) AND z4(@v) < w4(@v) THEN z4(@v)
		ELSE w4(@v)
	END 
)
END
;

--MaximumComponent
FUNCTION MaximumComponent2(@v FLOAT64X4) FLOAT64 AS 
(
	CASE
		WHEN x4(@v) > y4(@v) THEN x4(@v)
		ELSE y4(@v)
	END 
)
END
; 

FUNCTION MaximumComponent3(@v FLOAT64X4) FLOAT64 AS 
(
	CASE
		WHEN x4(@v) > y4(@v) AND x4(@v) > z4(@v) THEN x4(@v)
		WHEN y4(@v) > x4(@v) AND y4(@v) > z4(@v) THEN y4(@v)
		ELSE z4(@v)
	END 
)
END
;

FUNCTION MaximumComponent4(@v FLOAT64X4) FLOAT64 AS 
(
	CASE
		WHEN x4(@v) > y4(@v) AND x4(@v) > z4(@v) AND x4(@v) > w4(@v) THEN x4(@v)
		WHEN y4(@v) > x4(@v) AND y4(@v) > z4(@v) AND y4(@v) > w4(@v) THEN y4(@v)
		WHEN z4(@v) > x4(@v) AND z4(@v) > y4(@v) AND z4(@v) > w4(@v) THEN z4(@v)
		ELSE w4(@v)
	END 
)
END
;

-- dot products VectorDot(<valuexN>, <valuexN>)
-- VectorDot(<valuexN>, <valuexN>)

-- Cross product in 3D. Returns vector perpendicular to both @a and @b. 
-- VectorCross(<valuex3>, <valuex3>)

-- The length of vector, norm
FUNCTION norm2(@a FLOAT64X2) FLOAT64 AS
(
	Hypot( x2(@a), y2(@a) )
)
END 
;

FUNCTION norm3(@a FLOAT64X3) FLOAT64 AS
(
	sqrt( pow(x3(@a), 2) + pow(y3(@a), 2) + pow(z3(@a), 2) )
)
END 
;

FUNCTION norm4(@a FLOAT64X4) FLOAT64 AS
(
	sqrt( pow(x3(@a), 2) + pow(y3(@a), 2) + pow(z3(@a), 2) + pow(z3(@a), 2) )
)
END 
;

-- Unitvector in the same direction as @a - "hat" operator
FUNCTION hat2(@a FLOAT64X2) FLOAT64X2 AS
(
	v2( 
		x2(@a) / norm2(@a),
		y2(@a) / norm2(@a)
	) 
)
END 
;

FUNCTION hat3(@a FLOAT64X3) FLOAT64X3 AS
(
	v3( 
		x3(@a) / norm3(@a),
		y3(@a) / norm3(@a),
		z3(@a) / norm3(@a)
	) 
)
END 
;

FUNCTION hat4(@a FLOAT64X3) FLOAT64X3 AS
(
	v4( 
		x4(@a) / norm4(@a),
		y4(@a) / norm4(@a),
		z4(@a) / norm4(@a),
		w4(@a) / norm4(@a)
	) 
)
END 
;


-- Interpolate or mix vectors @a and @b by @q 
FUNCTION interpolate1(@a FLOAT64, @b FLOAT64, @q FLOAT64) FLOAT64X2 AS 
(
	@a * (1 - @q) + @b * @q 
)
END
;

FUNCTION interpolate2(@a FLOAT64X2, @b FLOAT64X2, @q FLOAT64) FLOAT64X2 AS 
(
	v2(
		x2(@a) * (1 - @q) + x2(@b) * @q , 
		y2(@a) * (1 - @q) + y2(@b) * @q 
	)
)
END
;

FUNCTION interpolate3(@a FLOAT64X3, @b FLOAT64X3, @q FLOAT64) FLOAT64X3 AS 
(
	v3(
		x3(@a) * (1 - @q) + x3(@b) * @q , 
		y3(@a) * (1 - @q) + y3(@b) * @q ,
		z3(@a) * (1 - @q) + z3(@b) * @q 
	)
)
END
;

FUNCTION interpolate4(@a FLOAT64X4, @b FLOAT64X4, @q FLOAT64) FLOAT64X4 AS 
(
	v4(
		x4(@a) * (1 - @q) + x4(@b) * @q , 
		y4(@a) * (1 - @q) + y4(@b) * @q ,
		z4(@a) * (1 - @q) + z4(@b) * @q ,
		w4(@a) * (1 - @q) + w4(@b) * @q 
	)
)
END
;


FUNCTION AngleBetween2(@a FLOAT64X2, @b FLOAT64X2) FLOAT64 AS 
(
	Acos( VectorDot( hat2(@a), hat2(@b) ) ) 
)
END
;

FUNCTION AngleBetween3(@a FLOAT64X3, @b FLOAT64X3) FLOAT64 AS 
(
	Acos( VectorDot( hat3(@a), hat3(@b) ) ) 
)
END
;

-- use Rodrigues' formula.
FUNCTION RotateAroundAxis3(@v FLOAT64X3, @axis FLOAT64X3, @theta FLOAT64) FLOAT64X3 AS 
(
	add3(add3(
		scale3(hat3(@axis),  (1 - Cos(@theta)) * VectorDot(@v, hat3(@axis)))
		,  
		scale3(@v, Cos(@theta)))
		,
		scale3(VectorCross(@v, hat3(@axis)), Sin(@theta)))
)
END
;


FUNCTION RotateTowards3(@v FLOAT64X3, @b FLOAT64X3, @theta FLOAT64) FLOAT64X3 AS 
(
	RotateAroundAxis3(@v, VectorCross(@b, @v), @theta)
)
END
;

-- @igt i-hat goes to 
-- @jgt j-hat goes to
-- @kgt k-hat goes to
-- @lgt w-hat goes to
-- @Ogt Origin goes to

FUNCTION LinearTransform1(@v FLOAT64, @igt FLOAT64) FLOAT64 AS
(
	@igt * @v
)
END
;

FUNCTION LinearTransform2(@v FLOAT64X2, @igt FLOAT64X2, @jgt FLOAT64X2) FLOAT64X2 AS
(
	v2(
		x2(@igt) * x2(@v) + x2(@jgt) * y2(@v),
		y2(@igt) * x2(@v) + y2(@jgt) * y2(@v)
	)
)
END
;



FUNCTION LinearTransform3(@v FLOAT64X3, @igt FLOAT64X3, @jgt FLOAT64X3, @kgt FLOAT64X3) FLOAT64X3 AS
(
	v3(
		x3(@igt) * x3(@v) + x3(@jgt) * y3(@v) + x3(@kgt) * z3(@v) ,
		y3(@igt) * x3(@v) + y3(@jgt) * y3(@v) + y3(@kgt) * z3(@v) ,
		z3(@igt) * x3(@v) + z3(@jgt) * y3(@v) + z3(@kgt) * z3(@v) 		
	)
)
END
;




FUNCTION LinearCoordTransform3(@v FLOAT64X3, @igt FLOAT64X3, @jgt FLOAT64X3, @kgt FLOAT64X3) FLOAT64X3 AS
(
	v3(
		x3(@igt) * x3(@v) + x3(@jgt) * y3(@v) + x3(@kgt) * z3(@v) ,
		y3(@igt) * x3(@v) + y3(@jgt) * y3(@v) + y3(@kgt) * z3(@v) ,
		z3(@igt) * x3(@v) + z3(@jgt) * y3(@v) + z3(@kgt) * z3(@v) 		
	)
)
END
;


FUNCTION LinearTransform4(@v FLOAT64X4, @igt FLOAT64X4, @jgt FLOAT64X4, @kgt FLOAT64X4, @lgt FLOAT64X4) FLOAT64X4 AS
(
	v4(
		x4(@igt) * x4(@v) + x4(@jgt) * y4(@v) + x4(@kgt) * z4(@v) + x4(@lgt) * w4(@v) ,
		y4(@igt) * x4(@v) + y4(@jgt) * y4(@v) + y4(@kgt) * z4(@v) + y4(@lgt) * w4(@v) ,
		z4(@igt) * x4(@v) + z4(@jgt) * y4(@v) + z4(@kgt) * z4(@v) + z4(@lgt) * w4(@v) ,		
		w4(@igt) * x4(@v) + w4(@jgt) * y4(@v) + w4(@kgt) * z4(@v) + w4(@lgt) * w4(@v) 		
	)
)
END
;


FUNCTION AffineTransform1(@v FLOAT64, @igt FLOAT64, @Ogt FLOAT64) FLOAT64 AS
(
	x2(LinearTransform2(
		v2(@v, 1), v2(@igt, 0), v2(@Ogt, 1)
	))
)
END
;


FUNCTION AffineTransform2(@v FLOAT64X2, @igt FLOAT64X2, @jgt FLOAT64X2, @Ogt FLOAT64X2) FLOAT64X2 AS
(	
	v2f3(LinearTransform3(
		setz3(@v, 1), setz3(@igt, 0), setz3(@jgt, 0), setz3(@Ogt, 1)
	))
)
END
;

-- 
FUNCTION RotateCoordTransform2(@v FLOAT64X2, @igt FLOAT64X2) FLOAT64X2 AS
(	
	LinearTransform2(
		setz3(@v, 1), 
		-- transpose is the inverse if orhtonormal 
		v2(x2(hat2(@igt)), x2(perp2(hat2(@igt)))), 
		v2(y2(hat2(@igt)), y2(perp2(hat2(@igt))))
	)
)
END
;


FUNCTION AffineTransform3(@v FLOAT64X3, @igt FLOAT64X3, @jgt FLOAT64X3, @kgt FLOAT64X3, @Ogt FLOAT64X3) FLOAT64X3 AS
(	
	v3f4(LinearTransform4(
		setw4(@v, 1), setw4(@igt, 0), setw4(@jgt, 0), setw4(@kgt, 0), setw4(@Ogt, 1)
	))
)
END
;



FUNCTION PerspectiveDivision1(@v FLOAT64X2) FLOAT64 AS
(
	x2(@v) / y2(@v)
)
END
;



FUNCTION PerspectiveDivision2(@v FLOAT64X3) FLOAT64X2 AS
(
	v2f3(scale3(@v, 1/z3(@v)))
)
END
;




FUNCTION PerspectiveDivision3(@v FLOAT64X4) FLOAT64X3 AS
(
	v3f4(scale4(@v, 1/w4(@v)))
)
END
;

FUNCTION PerspectiveTransform1(@v FLOAT64, @igt FLOAT64, @Ogt FLOAT64, @p FLOAT64) FLOAT64 AS
(
	PerspectiveDivision1(LinearTransform2(
		v2(@v, 1), v2(@igt, @p), v2(@Ogt, 1)
	))
)
END
;


FUNCTION PerspectiveAffineTransform1(@v FLOAT64, @igt FLOAT64, @Ogt FLOAT64, @p FLOAT64) FLOAT64 AS
(
	PerspectiveDivision1(LinearTransform2(
		v2(@v, 1), v2(@igt, @p), v2(@Ogt, 1)
	))
)
END
;

FUNCTION PerspectiveTransform2(@v FLOAT64X2, @igt FLOAT64X2, @jgt FLOAT64X2, @Ogt FLOAT64X2, @p FLOAT64X2) FLOAT64X2 AS
(
	PerspectiveDivision2(LinearTransform3(
		setz3(@v, 1), setz3(@igt, x2(@p)), setz3(@jgt, y2(@p)), setz3(@Ogt, 1)
	))
)
END
;


FUNCTION PerspectiveTransform3(@v FLOAT64X3, @igt FLOAT64X3, @jgt FLOAT64X3, @kgt FLOAT64X3, @Ogt FLOAT64X3, @p FLOAT64X3) FLOAT64X3 AS
(
	PerspectiveDivision3(LinearTransform4(
		setw4(@v, 1), setw4(@igt, x3(@p)), setw4(@jgt, y3(@p)), setw4(@kgt, z3(@p)), setw4(@Ogt, 1)
	))
)
END
;





FUNCTION Deg2Rad(@d FLOAT64) FLOAT64 AS @d/180*PI END ;
FUNCTION Rad2Deg(@r FLOAT64) FLOAT64 AS @r/PI*180 END ;


FUNCTION Slope3(@v FLOAT64X3) FLOAT64 AS 
(
	 z3(@v) / Hypot(y3(@v), x3(@v))
)
END
;

--- inclination from the zenith
FUNCTION PolarAngle3(@v FLOAT64X3) FLOAT64 AS 
(
	Atan2( Hypot(y3(@v), x3(@v)), z3(@v) )
)
END
;

-- elevation from the xy plane
FUNCTION ElevationAngle3(@v FLOAT64X3) FLOAT64 AS 
(
	Atan2( z3(@v), Hypot(y3(@v), x3(@v)) )
)
END
;

-- counter clock-wise (like in math)
FUNCTION AzimuthAngleCCW3(@v FLOAT64X3) FLOAT64 AS 
(
	Atan2( y3(@v), x3(@v) )
)
END
;

-- clock-wise (like in geo)
FUNCTION AzimuthAngleCW3(@v FLOAT64X3) FLOAT64 AS 
(
	Atan2( x3(@v), y3(@v) )
)
END
;

-- clock-wise (like in geo) with offset orientation - 
FUNCTION AzimuthAngleCWOffset3(@v FLOAT64X3, @offset FLOAT64X2) FLOAT64 AS 
(
	AzimuthAngleCW2( LinearTransform2( v2f3(@v), @offset, perp2(@offset)  ) )
)
END
;

FUNCTION TriangleInclineRatio(@a FLOAT64X3, @b FLOAT64X3, @c FLOAT64X3) FLOAT64 AS 
(
	Abs( 1 / Slope3(VectorCross( ab3(@a, @b), ab3(@a, @c) )))
)
END
;


FUNCTION TriangleAspect(@a FLOAT64X3, @b FLOAT64X3, @c FLOAT64X3) FLOAT64 AS 
(
	AzimuthAngleCCW3( VectorCross(ab3(@a, @b), ab3(@a, @c)) )
)
END
;




FUNCTION SphericalFromCartesian(@v FLOAT64X3) FLOAT64x3 AS
	v3( AzimuthAngleCW3(@v), ElevationAngle3(@v), norm3(@v) )
END
;

FUNCTION SphericalCoordsCentered(@origin FLOAT64X3, @v FLOAT64X3) FLOAT64x3 AS
	SphericalFromCartesian( ab3(@origin, @v) )
END
;


FUNCTION SphericalCoordsOriented(@orientation FLOAT64X2, @v FLOAT64X3) FLOAT64x3 AS
	v3( AzimuthAngleCWOffset3(@v, @orientation), ElevationAngle3(@v), norm3(@v) )
END
;
FUNCTION SphericalCoordsCenteredOriented(@origin FLOAT64X3, @orientation FLOAT64X2, @v FLOAT64X3) FLOAT64x3 AS
	SphericalCoordsOriented(@orientation, ab3(@origin, @v) )
END
;

FUNCTION SphericalToPixelDepth(@dims INT32X3, @v FLOAT64X3) INT32X3 AS
	add3(
		v3(x3(@dims)/2, y3(@dims)/2, 0),  
		v3(
			x3(@dims)*(1/(2*Pi))*x3(@v), 
			y3(@dims)*(1/Pi)*y3(@v),
			z3(@dims)*z3(@v)
		  )
	    )
END
;



-- given two points with (unit)vectors, return the coefficents where those vectors will meet.
-- first component < -1  -->  
FUNCTION αβOfIntersection(@point1 FLOAT64X2, @vec1 FLOAT64X2, @point2 FLOAT64X2, @vec2 FLOAT64X2) FLOAT64X2 AS 
(
	v2(
	--	VectorDot( hat2(perp2(@vec2)),  ab2(@point1, @point2) ) / VectorDot( @vec1, hat2(perp2(@vec2)) ) -- no need for expensive hat2
	--  hat2 of perp'd vec is both in numerator and in denominator and therefore cancels out :)	
		VectorDot( perp2(@vec2), ab2(@point1, @point2) ) / VectorDot( @vec1, perp2(@vec2) )
		,
	--  VectorDot( perp2(@vec1), ab2(@point2, @point1) ) / VectorDot( @vec2, perp2(@vec1) )  -- symmetric, but can be rewritten
	--  To have more common subexpressions but lose symmetry, switch baseline direction and swich perp in the denominator, both change the sign of VectorDot
		VectorDot( perp2(@vec1), ab2(@point1, @point2) ) / VectorDot( @vec1, perp2(@vec2) )
	)
)
END
;

