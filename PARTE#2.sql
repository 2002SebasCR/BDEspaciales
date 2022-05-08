------------------------------------------------------------------------------------------
--------------------------------CRUD Calles ------------------------------------
------------------------------------------------------------------------------------------

CREATE PROCEDURE CRUD_Calles
	@IdCalle INT = 1,
	@IdCiudad INT = 1,
	@Numero VARCHAR(32) = '#DummyCalle-F',
	@Ubicacion VARCHAR(55) = 'POLYGON((1 1, 1 1.2, 6 1.2, 6 1, 1 1))',
	@Modo CHAR(1)
AS
  BEGIN TRY   -- statements that may cause exceptions
	DECLARE @ubicacionGeometry GEOMETRY
	
	IF @Modo = 'R'
	BEGIN
		SELECT *
		FROM dbo.calle as c
		WHERE (c.Numero = @Numero OR c.Numero IS NOT NULL )
	END

	IF @Modo = 'I'
	BEGIN
		SET @ubicacionGeometry = geometry::STGeomFromText(@Ubicacion, 4326)
		INSERT dbo.calle VALUES (@IdCiudad, @Numero, @ubicacionGeometry)
	END

	IF @Modo='U'
	BEGIN
		SET @ubicacionGeometry = geometry::STGeomFromText(@Ubicacion, 4326)
		UPDATE dbo.calle SET idCiudad=@IdCiudad, numero=@Numero, ubicacion=@ubicacionGeometry WHERE idCalle=@IdCalle
	END

	IF @Modo= 'D'
	BEGIN
		DELETE FROM dbo.calle WHERE idCalle=@IdCalle
	END;

END TRY  

BEGIN CATCH  -- statements that handle exception
			 SELECT  
            ERROR_NUMBER() AS ErrorNumber  
            ,ERROR_SEVERITY() AS ErrorSeverity  
            ,ERROR_STATE() AS ErrorState  
            ,ERROR_PROCEDURE() AS ErrorProcedure  
            ,ERROR_LINE() AS ErrorLine  
            ,ERROR_MESSAGE() AS ErrorMessage;

END CATCH  

 -- Reset identity seed
	declare @max int
	select @max=max(IdCalle) from dbo.calle
	if @max IS NULL   --check when max is returned as null
	SET @max = 0
	DBCC CHECKIDENT ('calle', RESEED, @max)

	GO

	EXECUTE CRUD_Calles @Modo='I', @IdCalle=1, @IdCiudad=1, @Numero='#calle-Z' , @Ubicacion = 'POLYGON((1 1, 1 1.2, 6 1.2, 6 1, 1 1))'
	Select * from dbo.calle

------------------------------------------------------------------------------------------
--------------------------------CRUD Inventario ------------------------------------
------------------------------------------------------------------------------------------

CREATE PROCEDURE CRUD_Inventario
	@IdComercio INT,
	@IdProducto INT,
	@Cantidad INT = 1,
	@Precio MONEY = 1,
	@Modo CHAR(1)
AS
  BEGIN TRY   -- statements that may cause exceptions	
	IF @Modo = 'R'
	BEGIN
		SELECT *
		FROM dbo.inventario as i
		WHERE (i.idComercio = @IdComercio OR i.idComercio IS NOT NULL) AND
			  (i.idProducto = @IdComercio OR i.idProducto IS NOT NULL)
	END

	IF @Modo = 'I'
	BEGIN
		INSERT dbo.inventario VALUES (@IdComercio, @IdProducto, @Cantidad, @Precio)
	END

	IF @Modo='U'
	BEGIN
		UPDATE dbo.inventario SET cantidad=@Cantidad, precio=@Precio WHERE idComercio=@IdComercio AND idProducto=@IdProducto
	END

	IF @Modo= 'D'
	BEGIN
		DELETE FROM dbo.inventario WHERE idComercio=@IdComercio AND idProducto=@IdProducto
	END;

END TRY  

BEGIN CATCH  -- statements that handle exception
			 SELECT  
            ERROR_NUMBER() AS ErrorNumber  
            ,ERROR_SEVERITY() AS ErrorSeverity  
            ,ERROR_STATE() AS ErrorState  
            ,ERROR_PROCEDURE() AS ErrorProcedure  
            ,ERROR_LINE() AS ErrorLine  
            ,ERROR_MESSAGE() AS ErrorMessage;

END CATCH  

	EXECUTE CRUD_Inventario @Modo='I', @IdComercio=2, @IdProducto=0, @Cantidad=10, @Precio=1200
	Select * from dbo.inventario

------------------------------------------------------------------------------------------
--------------------------------CRUD Casas ------------------------------------
------------------------------------------------------------------------------------------

CREATE PROCEDURE CRUD_Casas
	@IdCasa INT = 1,
	@IdCiudad INT = 1,
	@Numero VARCHAR(35) = '#Dummy-casa-T',
	@Ubicacion VARCHAR(55) = 'POLYGON((0 0, 0 1, 1 1, 1 0, 0 0))',
	@Modo CHAR(1)
AS
  BEGIN TRY   -- statements that may cause exceptions
	DECLARE @ubicacionGeometry GEOMETRY

	IF @Modo = 'R'
	BEGIN
		SELECT *
		FROM dbo.casa as c
		WHERE (c.Numero = @Numero OR c.Numero IS NOT NULL )
	END

	IF @Modo = 'I'
	BEGIN
		SET @ubicacionGeometry = geometry::STGeomFromText(@Ubicacion, 4326)
		INSERT dbo.casa VALUES (@IdCiudad, @Numero, @ubicacionGeometry)
	END

	IF @Modo='U'
	BEGIN
		SET @ubicacionGeometry = geometry::STGeomFromText(@Ubicacion, 4326)
		UPDATE dbo.casa SET idCiudad=@IdCiudad, numero=@Numero, ubicacion=@ubicacionGeometry WHERE idCasa=@IdCasa
	END

	IF @Modo= 'D'
	BEGIN
		DELETE FROM dbo.casa WHERE idCasa=@IdCasa
	END;

END TRY  

BEGIN CATCH  -- statements that handle exception
			 SELECT  
            ERROR_NUMBER() AS ErrorNumber  
            ,ERROR_SEVERITY() AS ErrorSeverity  
            ,ERROR_STATE() AS ErrorState  
            ,ERROR_PROCEDURE() AS ErrorProcedure  
            ,ERROR_LINE() AS ErrorLine  
            ,ERROR_MESSAGE() AS ErrorMessage;

END CATCH  

 -- Reset identity seed
	declare @max int
	select @max=max(idCasa) from dbo.casa
	if @max IS NULL   --check when max is returned as null
	SET @max = 0
	DBCC CHECKIDENT ('casa', RESEED, @max)

	GO

	EXECUTE CRUD_Casas @Modo='I', @idCasa=1, @IdCiudad=1, @Numero='#casa-A' , @Ubicacion = 'POLYGON((0 0, 0 1, 1 1, 1 0, 0 0))'
	Select * from dbo.casa

------------------------------------------------------------------------------------------
--------------------------------CRUD Distancia ------------------------------------
------------------------------------------------------------------------------------------

CREATE PROCEDURE CRUD_Distancia_Entre_Lugares
	@Id1 INT,
	@EsID1Casa BIT,
	@Id2 VARCHAR(55),
	@EsID2Casa BIT
AS
  BEGIN TRY   -- statements that may cause exceptions
	DECLARE @casa1 GEOMETRY
	DECLARE @casa2 GEOMETRY
	DECLARE @comercio1 GEOMETRY
	DECLARE @comercio2 GEOMETRY

	IF @EsID1Casa = 1
		BEGIN
			IF @EsID2Casa = 1
				BEGIN
					SELECT @casa1 = c.ubicacion FROM dbo.casa c WHERE c.idCasa = @Id1
					SELECT @casa2 = c.ubicacion FROM dbo.casa c WHERE c.idCasa = @Id2

					SELECT @casa1.STDistance(@casa2) as DistanceInMeters
				END
			ELSE
				BEGIN
					
					SELECT @casa1 = c.ubicacion FROM dbo.casa c WHERE c.idCasa = @Id1
					SELECT @comercio1 = c.ubicacion FROM dbo.comercio c WHERE idComercio = @Id2

					SELECT @casa1.STDistance(@comercio1) as DistanceInMeters
				END
		END
	ELSE
			IF @EsID2Casa = 1
				BEGIN
					SELECT @comercio1 = c.ubicacion FROM dbo.comercio c WHERE c.idComercio = @Id1
					SELECT @casa2 = c.ubicacion FROM dbo.casa c WHERE c.idCasa = @Id2

					SELECT @comercio1.STDistance(@casa2) as DistanceInMeters
				END
			ELSE
				BEGIN
					
					SELECT @comercio1 = c.ubicacion FROM dbo.comercio c WHERE c.idComercio = @Id1
					SELECT @comercio2 = c.ubicacion FROM dbo.comercio c WHERE idComercio = @Id2

					SELECT @comercio1.STDistance(@comercio2) as DistanceInMeters
				END
END TRY  

BEGIN CATCH  -- statements that handle exception
			 SELECT  
            ERROR_NUMBER() AS ErrorNumber  
            ,ERROR_SEVERITY() AS ErrorSeverity  
            ,ERROR_STATE() AS ErrorState  
            ,ERROR_PROCEDURE() AS ErrorProcedure  
            ,ERROR_LINE() AS ErrorLine  
            ,ERROR_MESSAGE() AS ErrorMessage;

END CATCH

	EXECUTE CRUD_Distancia_Entre_Lugares @Id1=1, @EsID1Casa=1, @Id2=3, @EsID2Casa=0