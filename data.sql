insert into [dbo].[ciudad](nombre)
values('CiudadTarea')

--- MANTENER LAS DIMENSIONES DE LAS CASAS Y COMERCIOS EN 1
--- POLYGON HACE UNA FIGURA CON LOS PUNTOS QUE SE LE DAN
--- EJEMPLO: 'POLYGON((0 0, 0 1, 1 1, 1 0, 0 0))' - Nota: EL PRIMER Y EL ULTIMO PUNTO DEBEN DE SER EL MISMO
--- EL PRIMER PUNTO ES EL DE ABAJO A LA IZQUIERDA, EL SEGUNDO ES ARRIBA IZQUIERDA, EL TERCERO ES ARRIBA DERECHA, 
---     EL CUARTO ES ABAJO DERECHA, EL ULTIMO PUNTO DEBE CALZAR CON EL PRIMERO 

insert into [dbo].[casa](idCiudad, numero, ubicacion)
values(1, '#casa-A', geometry::STGeomFromText('POLYGON((0 0, 0 1, 1 1, 1 0, 0 0))', 4326)), --- Horizontal
	  (1, '#casa-B', geometry::STGeomFromText('POLYGON((1 0, 1 1, 2 1, 2 0, 1 0))', 4326)), --- Horizontal
      (1, '#casa-C', geometry::STGeomFromText('POLYGON((4 0, 4 1, 5 1, 5 0, 4 0))', 4326)), --- Horizontal
	  (1, '#casa-D', geometry::STGeomFromText('POLYGON((0 2, 0 3, 1 3, 1 2, 0 2))', 4326)), --- Vertical
	  (1, '#casa-E', geometry::STGeomFromText('POLYGON((0 3, 0 4, 1 4, 1 3, 0 3))', 4326)), --- Vertical
      (1, '#casa-E', geometry::STGeomFromText('POLYGON((0 4, 0 5, 1 5, 1 4, 0 4))', 4326)) --- Vertical


insert into [dbo].[calle](idCiudad, numero, ubicacion)
values(1, '#calle-A', geometry::STGeomFromText('POLYGON((1 1, 1 1.2, 6 1.2, 6 1, 1 1))', 4326)), -- calle horizontal
	  (1, '#calle-A', geometry::STGeomFromText('POLYGON((1 1, 1 6, 1.2 6, 1.2 1, 1 1))', 4326)) -- calle vertical

insert into tipoComercio (nombre)
values('#tipo1'),
	  ('#tipo2')

insert into [dbo].[comercio](idTipo, idCiudad, nombre, numero, ubicacion)
values(1, 1, 'Comercio1', '#comercio-A', geometry::STGeomFromText('POLYGON((0 1, 0 2, 1 2, 1 1, 0 1))', 4326)), --- Vertical
      (1, 1, 'Comercio2', '#comercio-B', geometry::STGeomFromText('POLYGON((2 0, 2 1, 3 1, 3 0, 2 0))', 4326)), --- Horizontal
      (1, 1, 'Comercio3', '#comercio-C', geometry::STGeomFromText('POLYGON((3 0, 3 1, 4 1, 4 0, 3 0))', 4326)), --- Horizontal
	  (2, 1, 'Comercio4', '#comercio-D', geometry::STGeomFromText('POLYGON((5 0, 5 1, 6 1, 6 0, 5 0))', 4326)), --- Horizontal
	  (2, 1, 'Comercio5', '#comercio-E', geometry::STGeomFromText('POLYGON((0 5, 0 6, 1 6, 1 5, 0 5))', 4326))  --- Vertical


insert into dbo.producto(nombre)
values('Carne'),
	  ('Paracetamol'),
	  ('Pan')

insert into dbo.inventario (idComercio,idProducto,cantidad,precio)
values(1,1,10,5000),
	  (2,2,5,100),
	  (3,3,0,1000),
	  (4,1,8,8000),
	  (5,2,10,50)

update tipoComercio
set horario_apertura= '07:00:00',
	horario_cierre= '20:00:00'

SELECT l.ubicacion.STUnion(c.ubicacion.STUnion(ca.ubicacion)) AS UnionT
FROM [dbo].[casa] as c
inner join [dbo].[calle] as ca on c.idCiudad = ca.idCiudad
inner join [dbo].[comercio] as l on c.idCiudad = l.idCiudad