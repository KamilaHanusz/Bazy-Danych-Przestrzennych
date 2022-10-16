CREATE EXTENSION postgis; 

CREATE DATABASE Zajecia_1

CREATE TABLE Buildings(id INTEGER, geom GEOMETRY, name VARCHAR, height INTEGER); 
INSERT INTO buildings VALUES(1, ST_GeomFromText('POLYGON((8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4))',0), 'BuildingA', 2);
INSERT INTO buildings VALUES(2, ST_GeomFromText('POLYGON((4 7, 6 7, 6 5, 4 5, 4 7))',0), 'BuildingB', 4);
INSERT INTO buildings VALUES(3, ST_GeomFromText('POLYGON((3 8, 5 8, 5 6, 3 6, 3 8))',0), 'BuildingC', 3);
INSERT INTO buildings VALUES(4, ST_GeomFromText('POLYGON((9 9, 10 9, 10 8, 9 8, 9 9))',0), 'BuildingD', 7);
INSERT INTO buildings VALUES(5, ST_GeomFromText('POLYGON((1 2, 2 2, 2 1, 1 1, 1 2))',0), 'BuildingF', 9);


CREATE TABLE Roads(id INTEGER, geom GEOMETRY, name VARCHAR);
INSERT INTO roads VALUES(1, ST_GeomFromText('LINESTRING(0 4.5, 12 4.5)',0), 'roadX');
INSERT INTO roads VALUES(2, ST_GeomFromText('LINESTRING(7.5 10.5, 7.5 0)',0), 'roadY');


CREATE TABLE Pktinfo(id INTEGER, geom GEOMETRY, name VARCHAR, liczprac INTEGER);
INSERT INTO pktinfo VALUES(1, ST_GeomFromText('POINT(1 3.5)',0), 'G', 1);
INSERT INTO pktinfo VALUES(2, ST_GeomFromText('POINT(5.5 1.5)',0), 'H', 1);
INSERT INTO pktinfo VALUES(3, ST_GeomFromText('POINT(9.5 6)',0), 'I', 1);
INSERT INTO pktinfo VALUES(4, ST_GeomFromText('POINT(6.5 6)',0), 'J', 1);
INSERT INTO pktinfo VALUES(5, ST_GeomFromText('POINT(6 9.5)',0), 'K', 1);


-- Zadanie 1
SELECT SUM(ST_Length(geom)) AS totalLength FROM roads;


--Zadanie 2
SELECT ST_AsText(geom) as WKT, ST_Area(geom) as Area, ST_Perimeter(geom) as Perimeter
FROM buildings WHERE name='BuildingA';


--Zadanie 3
SELECT name, ST_Area(geom) as Area FROM buildings ORDER BY name;


--Zadanie 4
SELECT name, ST_Perimeter(geom) as Perimeter FROM buildings ORDER BY ST_Area(geom) DESC limit 2;


--Zadanie 5 - Wykonane na 2 sposoby:
--1:
SELECT ST_Distance(b.geom, p.geom)
FROM (SELECT geom FROM Buildings WHERE name = 'BuildingC') AS b,
(SELECT geom FROM Pktinfo WHERE name = 'G') AS p
--2:
SELECT ST_Distance(b.geom, p.geom)
FROM Buildings AS b,
Pktinfo AS p
WHERE b.name='BuildingC' AND p.name='G'


--Zadanie 6
SELECT ST_Area(d.Difference) 
FROM (SELECT ST_Difference(b2.geom, b.BufferedArea) AS Difference
FROM (SELECT ST_Buffer(geom, 0.5) AS BufferedArea FROM Buildings WHERE name='BuildingB') AS b,
(SELECT geom FROM Buildings WHERE name='BuildingC') AS b2) AS d


--Zadanie 7
SELECT b.name, ST_Y(b.Centroid) AS Y_coord 
FROM (SELECT name, ST_Centroid(geom) AS Centroid FROM Buildings) AS b 
WHERE ST_Y(b.Centroid) > 4.5


--Zadanie 8
SELECT ST_Area(s.Symmetric_difference) AS Area 
FROM (SELECT ST_SymDifference(b.geom, ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))')) AS Symmetric_difference
FROM (SELECT geom FROM Buildings WHERE name='BuildingC') AS b) AS s




