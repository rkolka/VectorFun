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
FUNCTION xy1(@g GEOM) FLOAT64X2 AS GeomCoordXY(@g, 1) END ;
-- 2nd coord of any 3D geom to vector
FUNCTION xyz1(@g GEOM) FLOAT64X3 AS GeomCoordXYZ(@g, 1) END ;


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


-- given geom @g, make vector from first to last coord,
-- Return coords of P Along and Across of G
-- Can call FUNCTION PAlongAcrossG(@g GEOM, @p GEOM) FLOAT64X2 AS 
FUNCTION CoordsInGeomsSystem(@g GEOM, @p GEOM) FLOAT64X2 AS 
(
	RotateBase2(
		ab2(xy0(@g),xy0(@p)), 
		v2fg(@g)
		)	
)
END
;

-- "Project" P on G (segment from 1st to last coord), snap to endpoints of G if P is farther
FUNCTION GeomProjectOntoSegment(@g GEOM, @p GEOM) FLOAT64X2 AS 
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


-- Project P along G (segment from 1st to last coord), 
FUNCTION GeomProjectAlongSegment(@g GEOM, @p GEOM) FLOAT64X2 AS 
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


-- Take line or area geometry @g and point @p (first point if area, line or multipoint).
-- Project to nearest segment of @g. 
-- Return, 
-- I does not return overall lin-ref measure.
-- but it does return the coord/segment number and distance along the segment ([along])
-- and also distance from the segment (or line if [along] ) ([across]) 
-- 
FUNCTION ProjectOntoGeom(@g GEOM, @p GEOM) TABLE AS 
(
SELECT 
	SPLIT (COLLECT [Coord], p, projection_line, along, across, len ORDER BY GeomLength(projection_line,0) ASC FETCH 1)
FROM
	(
	SELECT
		[Coord],
		GeomProjectOntoSegment(GeomMakeSegment([XY], [XYNext]), @p) as p,
		GeomMakeSegment(xy0(@p), GeomProjectOntoSegment(GeomMakeSegment([XY], [XYNext]), @p)) as projection_line,
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

FUNCTION GeomProjectionLineToSegment(@g GEOM, @p GEOM) GEOM AS
(
	GeomMakeSegment(xy0(@p), GeomProjectOntoSegment(@g, @p))
)
END
;


FUNCTION GeomProjectionLineToGeom(@g GEOM, @p GEOM) GEOM AS
(
	GeomMakeSegment(xy0(@p), GeomProjectOntoSegment(@g, @p))
)
END
;


-- Point at 
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

  
FUNCTION GeomAzimuthSegment(@g GEOM) FLOAT64 AS 
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


FUNCTION LineToSegVecs2(@geom GEOM ) TABLE AS 
(
	SELECT 	
		[Branch],
		[Coord],
		[CoordInBranch],
		[XY],
		[XYNext],
		norm2(ab2([XY], [XYNext])) as len,
		hat2(ab2([XY], [XYNext])) as vec_hat
	FROM
		CALL GeomToSegments(@geom)
)
END
;



FUNCTION SmallestMisShoots(@endpoint FLOAT64X2, @endvec FLOAT64X2, @misShootBounds FLOAT64X2, @geom GEOM, @numres INT64) TABLE AS 
(
	SELECT 
		@endpoint as [EndPoint], @endvec as [EndVec], [Branch], [Coord], [CoordInBranch], [XY], [XYNext], [len], [vec], [vec_hat], [αβ] 
	FROM
		(
		SELECT
			[s1].*
			,
			αβOfIntersection(@endpoint, @endvec, [XY], [vec_hat]) as [αβ]
		FROM	
			(
			SELECT 	
				[Branch],
				[Coord],
				[CoordInBranch],
				[XY],
				[XYNext],
				norm2(ab2([XY], [XYNext])) as [len],
				ab2([XY], [XYNext]) as [vec],
				hat2(ab2([XY], [XYNext])) as [vec_hat]
			FROM
				CALL GeomToSegments(@geom)
			) as [s1]
		) as [s2]
	WHERE
		y2([αβ]) BETWEEN 0 AND [len]
		AND
		x2([αβ]) BETWEEN x2(@misShootBounds) AND y2(@misShootBounds)
	ORDER BY 
		Abs(x2([αβ]))
	FETCH 
		@numres
)
END
;


--- VARIABLES FOR DEBUGGING --- 
--VALUE @geom GEOM = StringWktGeom('LINESTRING(0 0, 23 54, 65 88)');
--VALUE @tab TABLE = [Roads];
--VALUE @SectionWidth FLOAT64 = 4;
--VALUE @SectionDepth FLOAT64 = 0.5;
--VALUE @SectionStep FLOAT64 = 0.5;
--- VARIABLES FOR DEBUGGING --- 

FUNCTION GeomCrossSections(@geom GEOM, @SectionStep FLOAT64, @SectionWidth FLOAT64, @SectionDepth FLOAT64) TABLE AS
(

	SELECT
		[FromM], [ToM], [GeomAlong]
		,
		[vec], [xy0], [xyz0], [vec_hat], [perp_hat], [GeomAcross]
		,	
		GeomBoundsRectRotated(INLINE GeomMergePoints(
			g2(add2(add2([xy0], scale2(neg2([perp_hat]), @SectionWidth/2)), scale2(neg2([vec_hat]), @SectionDepth/2)))
			,
			g2(add2(add2([xy0], scale2(neg2([perp_hat]), @SectionWidth/2)), scale2(     [vec_hat] , @SectionDepth/2)))
			,
			g2(add2(add2([xy0], scale2(     [perp_hat] , @SectionWidth/2)), scale2(     [vec_hat] , @SectionDepth/2)))
			,
			g2(add2(add2([xy0], scale2(     [perp_hat] , @SectionWidth/2)), scale2(neg2([vec_hat]), @SectionDepth/2)))

		), 0) as [section_rect]
	FROM 
	(
	SELECT
		[FromM], [ToM], [GeomAlong]
		,
		[vec], [xy0], [xyz0]
		,
		[vec_hat], [perp_hat]
		,
		s2(	add2([xy0], scale2(neg2([perp_hat]), @SectionWidth/2)),
			add2([xy0], scale2([perp_hat], @SectionWidth/2))
		) as [geomAcross]
	FROM
		(
		SELECT
			[FromM], [ToM], [GeomAlong]
			,
			[vec], [xy0], [xyz0]
			,
			hat2([vec]) as [vec_hat]          -- unitvector along geom
			,
			perp2(hat2([vec])) as [perp_hat]  -- unitvector perpendicular to geom
		FROM	
			(
			SELECT
				[FromM], [ToM], [GeomAlong]
				,
				ab2(xy0([geomAlong]), xy1([geomAlong])) as [vec]   -- vec from first to second point
				,
				xy0([geomAlong]) as [xy0]    -- v2fg: xy of first point
				,
				v3f2(xy0([geomAlong])) as [xyz0]	-- v3f2: 3d vector of 2d vector, with z=0
			FROM 
				(
				SELECT
					[ValueMin] as [FromM], 
					[ValueMax] as [ToM], 
					[Geom] as [GeomAlong]
				FROM
					CALL GeomToPartsLineSequence(@geom, 0, GeomLength(@geom, 0), @SectionStep)
				)
			)
		)
	)
)
END
;



--VALUE @line GEOM = StringWktGeom('Linestring(1 2, 3 7, 4 3, 6 6)');
--VALUE @len FLOAT64 = 2.3;
--VALUE @ratio FLOAT64 = 0.8;

-- "Linear referencing" by units of measure. Accepts negative and returns endpoints if out of bounds
FUNCTION point_at_line_len(@line GEOM, @len FLOAT64) GEOM AS
(
	GeomMakePoint(
	CASE 
		WHEN @len >= 0 THEN GeomCoordLine(@line, Bound(@len, 0, GeomLength(@line, 0), true))
		ELSE GeomCoordLine(@line, Bound(GeomLength(@line, 0)-@len, 0, GeomLength(@line, 0), true))
	END
	)
)
END;

-- "Linear referencing" by ratio (0.5 is midpoint). Accepts negative and returns endpoints if out of bounds
FUNCTION point_at_line_ratio(@line GEOM, @ratio FLOAT64) GEOM AS
(
	GeomMakePoint(
	CASE 
		WHEN @ratio >= 0 THEN GeomCoordLine(@line, Bound(@ratio, 0, 1, true) * GeomLength(@line, 0))
		ELSE GeomCoordLine(@line, Bound(1 - @ratio, 0, 1, true) * GeomLength(@line, 0))
	END
	)
)
END;



-- splits line at @len.
FUNCTION split_line_at_len(@line GEOM, @len FLOAT64) TABLE AS
(
SELECT 
	CASE 
		WHEN [half] = 0 THEN GeomPartLine(@line, 0, [split_len])
		ELSE 				 GeomPartLine(@line, [split_len], [geom_len])
	END as [split_line]
FROM
	(
	SELECT
		[geom_len]
		,
		CASE
			WHEN @len >= 0 THEN Bound(@len,              0, [geom_len], true)
			ELSE                Bound([geom_len] - @len, 0, [geom_len], true) 
		END as [split_len]
	FROM
		(VALUES ( GeomLength(@line, 0) ) AS ([geom_len])) as [gl] 
	) AS [lengths]
	CROSS JOIN
	(VALUES (0), (1) as ([half])) as [halfs]

)
END;


-- splits line at @ratio.
FUNCTION split_line_at_ratio(@line GEOM, @ratio FLOAT64) TABLE AS
(
SELECT 
	CASE 
		WHEN [half] = 0 THEN GeomPartLine(@line, 0, [split_len])
		ELSE 				 GeomPartLine(@line, [split_len], [geom_len])
	END as [split_line]
FROM
	(
	SELECT
		[geom_len]
		,
		CASE
			WHEN @ratio >= 0 THEN Bound([geom_len]*@ratio,     0, [geom_len], true)
			ELSE                  Bound([geom_len]*(1-@ratio), 0, [geom_len], true) 
		END as [split_len]
	FROM
		(VALUES ( GeomLength(@line, 0) ) AS ([geom_len])) as [gl] 
	) AS [lengths]
	CROSS JOIN
	(VALUES (0), (1) as ([half])) as [halfs]

)
END;


FUNCTION GeomToSegmentsBetter(@g GEOM) TABLE AS 
(
SELECT
	[Branch], 
	[Coord], 
	First([xy]) as [xy], 
	First([xyNext]) as [xyNext], 
	First([seg_vec]) as [seg_vec], 
	First([seg_len]) as [seg_len],
	Sum(Coalesce([len], 0)) as [prev_len]
FROM

	(
	SELECT
		[Branch], [Coord], [xy], [xyNext],
		ab2([xy], [xyNext]) as [seg_vec],
		norm2(ab2([xy], [xyNext])) as [seg_len]
	FROM	
		CALL GeomToSegments(@g)
	)
	LEFT JOIN
	(
	SELECT
		[Coord] as [bCoord], norm2(ab2([xy], [xyNext])) as [len]
	FROM	
		CALL GeomToSegments(@g)
	) 
	ON [bCoord] < [Coord]
GROUP BY
	[Branch], 
	[Coord]
)
END
;



-- ~~ ST_LineLocatePoint * ST_Length ~~ 
FUNCTION ProjectOntoGeomBetter(@g GEOM, @p GEOM) TABLE AS 
(
SELECT 
	SPLIT (COLLECT [Coord], p, projection_line, along, across, seg_len, [prev_len] + [along] ORDER BY GeomLength(projection_line,0) ASC FETCH 1)
FROM
	(
	SELECT
		[Coord],
		GeomProjectOntoSegment(GeomMakeSegment([XY], [XYNext]), @p) as p,
		GeomMakeSegment(xy0(@p), GeomProjectOntoSegment(GeomMakeSegment([XY], [XYNext]), @p)) as projection_line,
		x2(CoordsInGeomsSystem(GeomMakeSegment([XY], [XYNext]), @p)) as along,
		y2(CoordsInGeomsSystem(GeomMakeSegment([XY], [XYNext]), @p)) as across,
		[prev_len],
		[seg_len]
	FROM
		CALL GeomToSegmentsBetter(@g)
	)
)
END
;




-- == ST_LineLocatePoint * ST_Length == 
FUNCTION LineLocatePointLen(@g GEOM, @p GEOM) FLOAT64 AS 
(
SELECT First([result]) 
FROM 
(
SELECT 
	SPLIT (COLLECT [prev_len] + [along] ORDER BY GeomLength(projection_line,0) ASC FETCH 1)
FROM
	(
	SELECT
		GeomMakeSegment(xy0(@p), GeomProjectOntoSegment(GeomMakeSegment([XY], [XYNext]), @p)) as projection_line,
		x2(CoordsInGeomsSystem(GeomMakeSegment([XY], [XYNext]), @p)) as along,
		[prev_len]
	FROM
		CALL GeomToSegmentsBetter(@g)
	)
)
)
END
;


FUNCTION LineMakeSplitLine(@g GEOM, @p GEOM, @len FLOAT64) GEOM AS 
(
SELECT 
	 GeomMakeSegment( 	
		add2([result], scale2([unit_perp_vec], -@len) ),
		add2([result], scale2([unit_perp_vec],  @len) )
		)
FROM 
(
SELECT 
	SPLIT (COLLECT [XY], [unit_perp_vec], add2([XY], scale2([unit_seg_vec], [along])) ORDER BY [along] ASC FETCH 1)
FROM
	(
	SELECT
		[XY], 
		perp2(hat2([seg_vec])) as [unit_perp_vec],
		hat2([seg_vec]) as [unit_seg_vec],
		ProjectOntoSegment2([XY], [XYNext], xy0(@p) ) as [projected_point],
		x2(AlongAcross2( [XY], [XYNext], xy0(@p) )) as [along],
		y2(AlongAcross2( [XY], [XYNext], xy0(@p) )) as [accross],
		[prev_len]
	FROM
		CALL GeomToSegmentsBetter(@g)
	)
)
)
END
;
