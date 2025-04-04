CREATE TABLE [convert_geometries] (
  [mfd_id] INT64,
  [Geom] GEOM,
  [wkt] NVARCHAR,
  [json] NVARCHAR,
  [geojson_from_geom] NVARCHAR
    AS [[ GeomJsonGeo([Geom],'EPSG:4326') ]],
  [wkt_from_geom] NVARCHAR
    AS [[ GeomWkt([Geom]) ]],
  [geom_from_geojson] GEOM
    AS [[ StringJsonGeoGeom([json]) ]],
  [geom_from_wkt] GEOM
    AS [[ StringWktGeom([wkt]) ]],
  INDEX [mfd_id_x] BTREE ([mfd_id]),
  INDEX [Geom_x] RTREE ([Geom]),
  INDEX [geom_from_wkt_x] RTREE ([geom_from_wkt]),
  PROPERTY 'FieldCoordSystem.Geom' '{ "Axes": "XYH", "Base": "World Geodetic 1984 (WGS84)", "Eccentricity": 0.08181919084262149, "MajorAxis": 6378137, "Name": "Latitude \\/ Longitude", "System": "Latitude \\/ Longitude", "Unit": "Degree", "UnitLatLon": true, "UnitScale": 1, "UnitShort": "deg" }',
  PROPERTY 'FieldCoordSystem.geom_from_geojson' '{ "Axes": "XYH", "Base": "World Geodetic 1984 (WGS84)", "Eccentricity": 0.08181919084262149, "MajorAxis": 6378137, "Name": "Latitude \\/ Longitude", "System": "Latitude \\/ Longitude", "Unit": "Degree", "UnitLatLon": true, "UnitScale": 1, "UnitShort": "deg" }',
  PROPERTY 'FieldCoordSystem.geom_from_wkt' '{ "Axes": "XYH", "Base": "World Geodetic 1984 (WGS84)", "Eccentricity": 0.08181919084262149, "MajorAxis": 6378137, "Name": "Latitude \\/ Longitude", "System": "Latitude \\/ Longitude", "Unit": "Degree", "UnitLatLon": true, "UnitScale": 1, "UnitShort": "deg" }'
);
CREATE DRAWING [convert_geometries D] (
  PROPERTY 'FieldGeom' 'Geom',
  PROPERTY 'Table' '[convert_geometries]'
);
CREATE DRAWING [convert_geometries geom_from_wkt] (
  PROPERTY 'FieldGeom' 'geom_from_wkt',
  PROPERTY 'Table' '[convert_geometries]'
);
