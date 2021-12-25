-- $include$ [VectorFunGeom.sql]
-- $include$ [VectorFunConstants.sql]



-- select one expression and use ALT-SHIFT-ENTER to evaluate.

v2(3,3)
v2(3,-3)

v3(4,3,1)
v3(-4,3,2)

v4(4,3,1,1)
v4(-4,3,2,-2)

dot2(v2(3,3), v2(3,-1))
dot3(v3(3,3,1), v3(3,-3,-1))
dot4(v4(4,3,1,1), v4(-4,3,2,-2))

norm3(hat3(cross3(v3(3,3,1), v3(3,-3,-1))))


add3(v3(5,7,8), v3(3,2,1))

scale3(v3(6,4,2), 0.21)

x2(v2(34,35))

xy(p2(34,35))


xy(@p00)
xyz(@p000)

-- for VALUES ... use ALT-ENTER to evaluate
VALUES  
( 'dummy', 1),
( 'x2 x', x2(v2(4545.9999999, 8.9999)) ) ,
( 'x2 y', y2(v2(4545.9999999, 8.9999)) ) ,

( 'x3 x', x3(v3(4545.9999999, 8.439, 4334.43434334)) ) ,
( 'x3 y', y3(v3(4545.9999999, 8.439, 4334.43434334)) ) ,
( 'x3 z', z3(v3(4545.9999999, 8.439, 4334.43434334)) ) ,

( 'x4 x', x4(v4(4545.9999999, 8.439, 63.43434334, 45.3)) ) ,
( 'x4 y', y4(v4(4545.9999999, 8.439, 63.43434334, 45.3)) ) ,
( 'x4 z', z4(v4(4545.9999999, 8.439, 63.43434334, 45.3)) ) ,
( 'x4 w', w4(v4(4545.9999999, 8.439, 63.43434334, 45.3)) ) 
AS
 ([desc], [Value])
;


VALUES  
( V2(4545.9999999, 8.439)  ,
  V3(4545.9999999, 8.439, 63.43434334)  ,
  V4(4545.9999999, 8.439, 63.43434334, 45.3) 
)
as ([V2], [V3], [V4] )
;


xy(StringWktGeom('POINT(45 23)'))

-- find slope in degrees
Rad2Deg(acos(dot3(
	v3(0,0,1),
	hat3(cross3(
			ab3(v3(7290.41, 116.5, 483.52), v3(7291.87, 115.47, 390.59))
			,
			ab3(v3(7290.41, 116.5, 483.52), v3(7289.92, 113.62, 389.58))
	))
)))

TriangleInclineRatio(v3(0,0,35), v3(4,2,0), v3(4,-2,0))

Rad2Deg(TriangleAspect(v3(0,0,35), v3(4,-2,0), v3(4,2,0)))

cross3( ab3(v3(0,0,35), v3(4,2,0)) , ab3(v3(0,0,35), v3(4,-2,0)) )

TriangleInclineRatio(v3(90.41, 6.5, 483.52), v3(91.87, 5.47, 390.59), v3(90, 3.62, 389.58))

Rad2Deg(TriangleAspect(v3(90.41, 6.5, 483.52), v3(91.87, 5.47, 390.59), v3(90, 3.62, 389.58)))

Rad2Deg(TriangleAspect(v3(1, 1, 1), v3(2, 2, -2), v3(-2, 2, -2)))

Rad2Deg(AngleBetween3(v3(1,2,3), v3(-2,-1,-3)))

norm3(RotateAroundAxis3(v3(1000,-2000,3000), v3(-12040060606,-888,-60346234463), Deg2Rad(-475754)))
norm3(v3(1000,-2000,3000))

Rad2Deg(AngleBetween3(v3(1,1,1), v3(-1,1,1)))
RotateTowards3(v3(1,1,1), v3(-1,1,1), Deg2Rad(90))




Rad2Deg(AngleBetween3(v3(1,1,1), v3(-1,1,1)))
+
Rad2Deg(AngleBetween3(v3(-1,1,1),
RotateTowards3(v3(1,1,1), v3(-1,1,1), Deg2Rad(90)) ))



AffineTransform1(6, 0.5, 2)
AffineTransform1(-6, 0.5, 2)

AffineTransform2(v2(-1,-1), v2(2, -1), v2(2, 1), v2(2, 2))


setz3(v2(5,6),7)
