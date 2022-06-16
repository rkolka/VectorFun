-- $manifold$
-- $include$ [VectorFunBase.sql]

-- GEOM -> FLOAT64
-- Short accessors of individual coord values. First Coord of any geom.
FUNCTION x(@g GEOM) FLOAT64 AS VectorValue( GeomCoordXY(@g, 0), 0) END ;
FUNCTION y(@g GEOM) FLOAT64 AS VectorValue( GeomCoordXY(@g, 0), 1) END ;
FUNCTION z(@g GEOM) FLOAT64 AS VectorValue( GeomCoordXYZ(@g, 0), 2) END ;

-- Center coords of geom, analogous to M8 CentroidX/CentroidX
FUNCTION cx(@g GEOM) FLOAT64 AS VectorValue( GeomCenter(@g, 0), 0) END ;
FUNCTION cy(@g GEOM) FLOAT64 AS VectorValue( GeomCenter(@g, 0), 1) END ;



-- GEOM -> FLOAT64XN

-- center coord of any 2D geom to vector
FUNCTION cxy(@g GEOM) FLOAT64X2 AS VectorMakeX2( VectorValue(GeomCenter(@g, 0), 0), VectorValue(GeomCenter(@g, 0), 1) ) END ;

-- 1st coord of any 2D geom to vector
FUNCTION xy0(@g GEOM) FLOAT64X2 AS GeomCoordXY(@g, 0) END ;
-- 1st coord of any 3D geom to vector
FUNCTION xyz0(@g GEOM) FLOAT64X3 AS GeomCoordXYZ(@g, 0) END ;

-- 2nd coord of any 2D geom to vector
FUNCTION xy2(@g GEOM) FLOAT64X2 AS GeomCoordXY(@g, 1) END ;
-- 2nd coord of any 3D geom to vector
FUNCTION xyz2(@g GEOM) FLOAT64X3 AS GeomCoordXYZ(@g, 1) END ;


-- 2nd to last coord of any 2D geom to vector
FUNCTION xyN1(@g GEOM) FLOAT64X2 AS GeomCoordXY(@g, GeomCoordCount(@g)-2) END ;
-- 2nd to last coord of any 3D geom to vector
FUNCTION xyzN1(@g GEOM) FLOAT64X3 AS GeomCoordXYZ(@g, GeomCoordCount(@g)-2) END ;

-- Last coord of any 2D geom to vector
FUNCTION xyN(@g GEOM) FLOAT64X2 AS GeomCoordXY(@g, GeomCoordCount(@g)-1) END ;
-- Last coord of any 3D geom to vector
FUNCTION xyzN(@g GEOM) FLOAT64X3 AS GeomCoordXYZ(@g, GeomCoordCount(@g)-1) END ;


-- First coord of 2D geom(1) as origin, vector to last coord of geom(2)
FUNCTION v2fgg(@g1 GEOM, @g2 GEOM) FLOAT64X2 AS ab2(xy0(@g1), xyN(@g2)) END ;
-- First coord of 3D geom(1) as origin, vector to last coord of geom(2)
FUNCTION v3fgg(@g1 GEOM, @g2 GEOM) FLOAT64X3 AS ab3(xyz0(@g1), xyzN(@g2)) END ;

-- First coord of 2D geom as origin, vector to last coord of geom
FUNCTION v2fg(@g GEOM) FLOAT64X2 AS v2fgg(@g, @g) END ;
-- First coord of 3D geom as origin, vector to last coord of geom
FUNCTION v3fg(@g GEOM) FLOAT64X3 AS v3fgg(@g, @g) END ;


---- Short version for creating points

-- From individual values
FUNCTION p2(@x FLOAT64, @y FLOAT64) GEOM AS GeomMakePoint(VectorMakeX2(@x, @y)) END
FUNCTION p3(@x FLOAT64, @y FLOAT64, @z FLOAT64) GEOM AS GeomMakePoint3(VectorMakeX3(@x, @y, @z)) END

-- Points from vector values
FUNCTION g2(@xy FLOAT64X2) GEOM AS GeomMakePoint(@xy) END
FUNCTION g3(@xyz FLOAT64X3) GEOM AS GeomMakePoint3(@xyz) END

-- Segment from vector values
FUNCTION s2(@xy0 FLOAT64X2, @xy1 FLOAT64X2) GEOM AS GeomMakeSegment(@xy0, @xy1) END
FUNCTION s3(@xyz0 FLOAT64X3, @xyz1 FLOAT64X3) GEOM AS GeomMakeSegment3(@xyz0, @xyz1) END

FUNCTION s3(@xyz0 FLOAT64X3, @xyz1 FLOAT64X3) GEOM AS GeomMakeSegment3(@xyz0, @xyz1) END


-- 
FUNCTION StartPoint2(@g GEOM) GEOM AS GeomMakePoint(GeomCoordXY(@g, 0)) END ;
FUNCTION EndPoint2(@g GEOM) GEOM AS GeomMakePoint(GeomCoordXY(@g, GeomCoordCount(@g)-1)) END ;

FUNCTION StartPoint3(@g GEOM) GEOM AS GeomMakePoint3(GeomCoordXYZ(@g, 0)) END ;
FUNCTION EndPoint3(@g GEOM) GEOM AS GeomMakePoint3(GeomCoordXYZ(@g, GeomCoordCount(@g)-1)) END ;

FUNCTION GeomIsRing(@g GEOM) BOOLEAN AS GeomCoordXY(@g,0) = GeomCoordXY(@g, GeomCoordCount(@g)-1) END ;


--VALUE @g GEOM = StringWktGeom('LINESTRING(658845 6489805, 630145 6463106, 626007 6449229, 614266 6437960)');

-- The unitvector at the start of geom
FUNCTION StartVec2(@g GEOM) FLOAT64X2 AS
(
	CASE
		WHEN GeomType(@g) = 1 THEN v2(0,0)
		ELSE hat2(ab2(
				GeomCoordXY(@g, 0),
				GeomCoordXY(@g, 1)
			))
	END
)
END
;


-- The unitvector at the end of geom
FUNCTION EndVec2(@g GEOM) FLOAT64X2 AS
	CASE
		WHEN GeomType(@g) = 1 THEN v2(0,0)
		ELSE hat2(ab2(
				GeomCoordXY(@g, GeomCoordCount(@g)-2),
				GeomCoordXY(@g, GeomCoordCount(@g)-1)
			))
	END
END
;

-- The unitvector at the start of geom, in the direction from 0 to @dist
FUNCTION StartVecDist2(@g GEOM, @dist FLOAT64) FLOAT64X2 AS
	CASE
		WHEN GeomType(@g) = 1 THEN v2(0,0)
		WHEN GeomType(@g) = 2 THEN
			hat2(v2fg(
				GeomPartLine(@g, 0, @dist)
			))
		WHEN GeomType(@g) = 3 THEN
			hat2(v2fg(
				GeomPartLine(GeomConvertToLine(@g), 0, @dist)
			))			
		ELSE
			v2(0,0) 
	END
END
;


-- The unitvector at the end of geom, in the direction from End-@dist to End
FUNCTION EndVecDist2(@g GEOM, @dist FLOAT64) FLOAT64X2 AS
	CASE
		WHEN GeomType(@g) = 1 THEN v2(0,0)
		WHEN GeomType(@g) = 2 THEN
			hat2(v2fg(
				GeomPartLine(@g, GeomLength(@g, 0)-@dist, GeomLength(@g, 0))
			))
		WHEN GeomType(@g) = 3 THEN
			hat2(v2fg(
				GeomPartLine(GeomConvertToLine(@g), GeomLength(@g, 0)-@dist, GeomLength(@g, 0))
			))			
		ELSE
			v2(0,0) 
	END
END
;



FUNCTION CoordsInGeomsSystem(@g GEOM, @p GEOM) FLOAT64X2 AS 
(
	RotateCoordTransform2(
		ab2(xy0(@g),xy0(@p)), 
		v2fg(@g)
		)	
)
END
;

-- 
FUNCTION ProjectOntoSegment(@g GEOM, @p GEOM) FLOAT64X2 AS 
(
	add2(xy0(@g),
		scale2(
			hat2(v2fg(@g)),
			clamp(
				VectorDot(
					hat2(v2fg(@g)),
					ab2(xy0(@g),xy0(@p)) 
				)
				,
				v2(0,1)
			)
		)
	)	
)
END
;


FUNCTION ProjectAlongSegment(@g GEOM, @p GEOM) FLOAT64X2 AS 
(
	add2(xy0(@g),
		scale2(
			hat2(v2fg(@g)),
			VectorDot(
				hat2(v2fg(@g)),
				ab2(xy0(@g),xy0(@p)) 
			)
		)
	)	
)
END
;

FUNCTION ProjectOntoGeom(@g GEOM, @p GEOM) TABLE AS 
(
SELECT 
	SPLIT (COLLECT [Coord], p, projection_line, along, across, len ORDER BY GeomLength(projection_line,0) ASC FETCH 1)
FROM
	(
	SELECT
		[Coord],
		ProjectOntoSegment(GeomMakeSegment([XY], [XYNext]), @p) as p,
		GeomMakeSegment(xy0(@p), ProjectOntoSegment(GeomMakeSegment([XY], [XYNext]), @p)) as projection_line,
		x2(CoordsInGeomsSystem(GeomMakeSegment([XY], [XYNext]), @p)) as along,
		y2(CoordsInGeomsSystem(GeomMakeSegment([XY], [XYNext]), @p)) as across,
		norm2(ab2([XY], [XYNext])) as len
	FROM
		CALL GeomToSegments(@g)
	--WHERE
	--	x2(CoordsInGeomsSystem(GeomMakeSegment([XY], [XYNext]), @p)) BETWEEN (0 - 1e-15) AND (norm2(ab2([XY], [XYNext])) + 1e-15)
	)
)
END
;

FUNCTION ProjectionLineToSegment(@g GEOM, @p GEOM) GEOM AS
(
	GeomMakeSegment(xy0(@p), ProjectOntoSegment(@g, @p))
)
END
;


FUNCTION ProjectionLineToGeom(@g GEOM, @p GEOM) GEOM AS
(
	GeomMakeSegment(xy0(@p), ProjectOntoSegment(@g, @p))
)
END
;



FUNCTION GeomInterpolate(@g GEOM, @q FLOAT64) GEOM AS 
(
	GeomMakePoint(Interpolate2(xy0(@g), xyN(@g), @q))
)
END
;



FUNCTION GeomMidPoint(@g GEOM) GEOM AS 
(
	GeomInterpolate(@g, 0.5)
)
END
;


FUNCTION GeomToGrid(@g GEOM, @step FLOAT64) GEOM AS 
(
	GeomSnapToGrid(@g, VectorMakeX2(@step, @step))
)
END
;


FUNCTION GeomSmoothGrid(@g GEOM, @SmoothValue FLOAT64, @GridStep FLOAT64, @NormalizeValue FLOAT64) GEOM AS 
(
	GeomNormalize(GeomSnapToGrid(GeomSmooth(@g, @SmoothValue), VectorMakeX2(@GridStep, @GridStep)), @NormalizeValue)
)
END
;

FUNCTION GeomSmoothBuffer(@g GEOM, @BufferSize FLOAT64, @SmoothingSize FLOAT64) GEOM AS 
(
	GeomSmooth(GeomBuffer(GeomSmooth(@g, @SmoothingSize), @BufferSize, 0), @SmoothingSize)
)
END
;

  
FUNCTION AzimuthSegment(@g GEOM) FLOAT64 AS 
(
	57.2958 * Atan2((VectorValue(GeomCoordXY(@g, 1),0) - VectorValue(GeomCoordXY(@g, 0),0)), (VectorValue(GeomCoordXY(@g, 1),1) - VectorValue(GeomCoordXY(@g, 0),1)))
)
END
;




FUNCTION GeomScaleAt2(@g GEOM, @scale FLOAT64X2, @at FLOAT64X2) GEOM AS
(
	GeomScaleShift(@g, @scale, ab2(scaleComponents2(@at, @scale), @at))
)
END
;


FUNCTION GeomScaleAtCenter(@g GEOM, @scale FLOAT64X2) GEOM AS
(
	GeomScaleAt2(@g, @scale, cxy(@g))
)
END
;




FUNCTION GeomProjectZUp(@geom GEOM, @orientation FLOAT64x2) GEOM AS

	p2( x2(@orientation)*x(@geom) + y2(@orientation)*y(@geom), z(@geom) )

END
;





FUNCTION GeomToPixelDepth(@dims INT32X3, @origin GEOM, @geom GEOM ) GEOM AS
	g3(SphericalToPixelDepth(@dims, SphericalCoordsCentered(xyz0(@origin), xyz0(@geom))))
END
;

