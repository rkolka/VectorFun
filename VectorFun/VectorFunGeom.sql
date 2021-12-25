-- $manifold$
-- $include$ [VectorFun.sql]


-- Short accessors of individual coord values. First Coord of any geom.
FUNCTION x(@g GEOM) FLOAT64 AS VectorValue( GeomCoordXY(@g, 0), 0) END ;
FUNCTION y(@g GEOM) FLOAT64 AS VectorValue( GeomCoordXY(@g, 0), 1) END ;
FUNCTION z(@g GEOM) FLOAT64 AS VectorValue( GeomCoordXYZ(@g, 0), 2) END ;

-- Analogous to M8 CentroidX/CentroidX
FUNCTION cx(@g GEOM) FLOAT64 AS VectorValue( GeomCenter(@g, 0), 0) END ;
FUNCTION cy(@g GEOM) FLOAT64 AS VectorValue( GeomCenter(@g, 0), 1) END ;



---- Short version for creating points

-- From individual values
FUNCTION p2(@x FLOAT64, @y FLOAT64) GEOM AS GeomMakePoint(VectorMakeX2(@x, @y)) END
FUNCTION p3(@x FLOAT64, @y FLOAT64, @z FLOAT64) GEOM AS GeomMakePoint3(VectorMakeX3(@x, @y, @z)) END

-- From vector values
FUNCTION g2(@xy FLOAT64X2) GEOM AS GeomMakePoint(@xy) END
FUNCTION g3(@xyz FLOAT64X3) GEOM AS GeomMakePoint3(@xyz) END



-- 
FUNCTION StartPoint2(@g GEOM) GEOM AS GeomMakePoint(GeomCoordXY(@g, 0)) END ;
FUNCTION EndPoint2(@g GEOM) GEOM AS GeomMakePoint(GeomCoordXY(@g, GeomCoordCount(@g)-1)) END ;

FUNCTION StartPoint3(@g GEOM) GEOM AS GeomMakePoint3(GeomCoordXYZ(@g, 0)) END ;
FUNCTION EndPoint3(@g GEOM) GEOM AS GeomMakePoint3(GeomCoordXYZ(@g, GeomCoordCount(@g)-1)) END ;

-- GEOM -> FLOAT64XN

-- first coord of any 2D geom to vector
FUNCTION xy(@g GEOM) FLOAT64X2 AS GeomCoordXY(@g, 0) END ;
FUNCTION StartPointXY(@g GEOM) FLOAT64X2 AS GeomCoordXY(@g, 0) END ;
-- first coord of any 3D geom to vector
FUNCTION xyz(@g GEOM) FLOAT64X3 AS GeomCoordXYZ(@g, 0) END ;
FUNCTION StartPointXYZ(@g GEOM) FLOAT64X3 AS GeomCoordXYZ(@g, 0) END ;
-- Last coord of any 2D geom to vector
FUNCTION EndPointXY(@g GEOM) FLOAT64X2 AS GeomCoordXY(@g, GeomCoordCount(@g)-1) END ;
-- Last coord of any 3D geom to vector
FUNCTION EndPointXYZ(@g GEOM) FLOAT64X3 AS GeomCoordXYZ(@g, GeomCoordCount(@g)-1) END ;
-- center coord of any 2D geom to vector
FUNCTION cxy(@g GEOM) FLOAT64X2 AS VectorMakeX2( VectorValue(GeomCenter(@g, 0), 0), VectorValue(GeomCenter(@g, 0), 1) ) END ;

-- First coord of 2D geom(1) as origin, vector to last coord of geom(2)
FUNCTION abXY(@g1 GEOM, @g2 GEOM) FLOAT64X2 AS ab2(StartPointXY(@g1), EndPointXY(@g2)) END ;
-- First coord of 3D geom(1) as origin, vector to last coord of geom(2)
FUNCTION abXYZ(@g1 GEOM, @g2 GEOM) FLOAT64X3 AS ab3(StartPointXYZ(@g1), EndPointXYZ(@g2)) END ;

-- First coord of 2D geom as origin, vector to last coord of geom
FUNCTION GeomToXY(@g GEOM) FLOAT64X2 AS abXY(@g, @g) END ;
-- First coord of 3D geom as origin, vector to last coord of geom
FUNCTION GeomToXYZ(@g GEOM) FLOAT64X3 AS abXYZ(@g, @g) END ;


FUNCTION GeomIsRing(@g GEOM) BOOLEAN AS GeomCoordXY(@g,0) = GeomCoordXY(@g, GeomCoordCount(@g)-1) END ;


FUNCTION CoordsInGeomsSystem(@g GEOM, @p GEOM) FLOAT64X2 AS 
(
	RotateCoordTransform2(
		ab2(StartPointXY(@g),xy(@p)), 
		GeomToXY(@g)
		)	
)
END
;

FUNCTION ProjectOntoSegment(@g GEOM, @p GEOM) FLOAT64X2 AS 
(
	add2(StartPointXY(@g),
		scale2(
			GeomToXY(@g),
			Clamp(
				VectorDot(
					hat2(GeomToXY(@g)),
					ab2(StartPointXY(@g),xy(@p)) 
				) / norm2(GeomToXY(@g))
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
	add2(StartPointXY(@g),
		scale2(
			hat2(GeomToXY(@g)),
			VectorDot(
				hat2(GeomToXY(@g)),
				ab2(StartPointXY(@g),xy(@p)) 
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
		GeomMakeSegment(xy(@p), ProjectOntoSegment(GeomMakeSegment([XY], [XYNext]), @p)) as projection_line,
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
	GeomMakeSegment(xy(@p), ProjectOntoSegment(@g, @p))
)
END
;


FUNCTION ProjectionLineToGeom(@g GEOM, @p GEOM) GEOM AS
(
	GeomMakeSegment(xy(@p), ProjectOntoSegment(@g, @p))
)
END
;



FUNCTION GeomInterpolate(@g GEOM, @q FLOAT64) GEOM AS 
(
	GeomMakePoint(Interpolate2(StartPointXY(@g), EndPointXY(@g), @q))
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
	g3(SphericalToPixelDepth(@dims, SphericalCoordsCentered(xyz(@origin), xyz(@geom))))
END
;

