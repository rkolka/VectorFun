-- $manifold$
-- $include$ [VectorFunBase.sql]


-- 2d vec as complex number
-- Cartesian from Polar
FUNCTION ComplexCfP(@a FLOAT64X2) FLOAT64X2 AS v2( x2(@a)*Cos(y2(@a)), x2(@a)*Sin(y2(@a)) ) END ;
-- Polar from Cartesian
FUNCTION ComplexPfC(@a FLOAT64X2) FLOAT64X2 AS v2( norm2(@a), Atan2(y2(@a), x2(@a)) ) END ;

FUNCTION ComplexInverseCC(@a FLOAT64X2) FLOAT64X2 AS v2( x2(@a) / x2(@a)*x2(@a) + y2(@a)*y2(@a),  y2(@a) / x2(@a)*x2(@a) + y2(@a)*y2(@a) ) END ;
FUNCTION ComplexMultCC(@a FLOAT64X2, @b FLOAT64X2) FLOAT64X2 AS v2( x2(@a)*x2(@b) - y2(@a)*y2(@b), x2(@a)*y2(@b) + y2(@a)*x2(@b) ) END ;
FUNCTION ComplexDivCC(@a FLOAT64X2, @b FLOAT64X2) FLOAT64X2 AS ComplexMultCC(@a, ComplexInverseCC(@b)) END ;


FUNCTION ComplexInversePP(@a FLOAT64X2) FLOAT64X2 AS v2( 1 / x2(@a), -y2(@a) ) END ;
FUNCTION ComplexMultPP(@a FLOAT64X2, @b FLOAT64X2) FLOAT64X2 AS v2( x2(@a)*x2(@b), y2(@b) + y2(@a) ) END ;
FUNCTION ComplexDivPP(@a FLOAT64X2, @b FLOAT64X2) FLOAT64X2  AS v2( x2(@a)/x2(@b), y2(@b) - y2(@a) ) END ;



FUNCTION ComplexXofP(@a FLOAT64X2) FLOAT64 AS x2(@a)*Cos(y2(@a)) END ;
FUNCTION ComplexYofP(@a FLOAT64X2) FLOAT64 AS x2(@a)*Sin(y2(@a)) END ;
FUNCTION ComplexRofC(@a FLOAT64X2) FLOAT64 AS norm2(@a) END ;
FUNCTION ComplexφofC(@a FLOAT64X2) FLOAT64 AS Atan2(y2(@a), x2(@a)) END ;

FUNCTION ComplexHatofC(@a FLOAT64X2) FLOAT64 AS v2( x2(@a)/norm2(@a), y2(@a)/norm2(@a) ) END ;
FUNCTION ComplexHatofP(@a FLOAT64X2) FLOAT64 AS v2( 1, y2(@a) ) END ;
