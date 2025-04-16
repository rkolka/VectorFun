-- $manifold$
-- $include$ [VectorFunGeom.sql]
-- $include$ [VectorFunComplex.sql]


FUNCTION pd_from_pair(@pos FLOAT64X2, @dir FLOAT64X2) FLOAT64X4 AS v4( x2(@pos), y2(@pos), x2(@dir), y2(@dir) ) END ;
FUNCTION pd_pos(@posdir FLOAT64X4) FLOAT64X2 AS v2( x4(@posdir), y4(@posdir) ) END ;
FUNCTION pd_dir(@posdir FLOAT64X4) FLOAT64X2 AS v2( z4(@posdir), w4(@posdir) ) END ;



VALUE @g GEOM = StringWktGeom('Linestring(1 2, 3 7, 4 3, 6 6)');
VALUE @ratio1 FLOAT64 = 0.3;
VALUE @ratio2 FLOAT64 = 0.8;

VALUE @normalize BOOLEAN = false;


-- The unitvector at the end of geom
FUNCTION GeomToPosDir(@g GEOM, @ratio1 FLOAT64, @ratio2 FLOAT64, @normalize BOOLEAN) FLOAT64X4 AS
(
SELECT
	CASE
		WHEN GeomType(@g) = 1 THEN pd_from_pair( xy0(@g), v2(0,0)     )
		WHEN @normalize       THEN pd_from_pair( [pos]  , hat2([dir]) )
		ELSE 				       pd_from_pair( [pos]  , [dir]       )
	END
FROM
	(
	SELECT	
		xy0([geom]) as [pos],
		v2fg([geom]) as [dir]
	FROM
		(
		SELECT
			line_part_by_ratio(@g, @ratio1, @ratio2) as [geom]
		FROM
			(VALUES 
				( GeomLength(@g, 0) ) 
				AS 
				( [geom_len] ) 
			) as [gl] 
		)
	)
)
END
;

GeomToPosDir(@g, 0.1, 0.2, true)

FUNCTION PosDirToGeom(@posdir FLOAT64x4) GEOM AS
	GeomMakeSegment( 
		pd_pos(@posdir),   
		add2( pd_pos(@posdir), pd_dir(@posdir) )
	)
END
;

VALUE @a FLOAT64x4 = v4(3,4, 2,1);
VALUE @b FLOAT64x4 = v4(4,3, 1,2);

-- 
FUNCTION PosDirAB(@a FLOAT64x4, @b FLOAT64x4) FLOAT64x4 AS
	pd_from_pair(
		ComplexDivCC( ab2( pd_pos(@a), pd_pos(@b) ), pd_dir(@a) ),
		ComplexDivCC(      pd_dir(@b)              , pd_dir(@a) )
	)
END
;

-- projects @p onto @g and returns geom's posdir at that point
FUNCTION PosDirOnGeom(@g GEOM, @p FLOAT64X2, @normalize BOOLEAN) FLOAT64X4 AS 
(
SELECT 
	SPLIT (COLLECT pd_from_pair([pos], [dir]) ORDER BY norm2(ab2([pos], @p)) ASC FETCH 1)
FROM
	(
	SELECT
		CASE WHEN @normalize THEN hat2(ab2([XY], [XYNext])) ELSE ab2([XY], [XYNext]) END AS [dir],
		ProjectOntoSegment2([XY], [XYNext], @p ) as [pos]
	FROM
		CALL GeomToSegments(@g)
	)
)
END
;
