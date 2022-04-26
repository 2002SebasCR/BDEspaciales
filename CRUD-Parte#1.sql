--  CRUD tipo comercio, productos, local
--  Asignar/consultar horarios
--  Sebastian Obando Paniagua



------------------------------------------------------------------------------------------
--------------------------------CRUD Tipo de Comercio-------------------------------------
------------------------------------------------------------------------------------------


CREATE PROCEDURE CRUD_TipoComercio
	@Id INT,
	@Nombre VARCHAR(50),
	@Apertura TIME,
	@Cierre TIME,
	@Modo CHAR(1)
AS
  BEGIN TRY   -- statements that may cause exceptions
	IF @Modo = 'I'
	BEGIN 
		INSERT dbo.tipoComercio VALUES ( @Nombre, @Apertura, @Cierre)
	END

	IF @Modo='U'
	BEGIN 
		UPDATE dbo.tipoComercio SET   Nombre=@Nombre , horario_apertura = @Apertura, horario_cierre = @Cierre WHERE idTipoComercio=@Id
	END

	IF @Modo= 'D'
	BEGIN
		DELETE FROM dbo.tipoComercio WHERE idTipoComercio=@Id
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
	select @max=max(idTipoComercio) from dbo.tipoComercio
	if @max IS NULL   --check when max is returned as null
	SET @max = 0
	DBCC CHECKIDENT ('tipoComercio', RESEED, @max)

	GO

	EXECUTE CRUD_TipoComercio @Modo='U', @Id= 6,@Nombre = '#tipo3', @Apertura='07:00:00'  ,@Cierre= '20:00:00'
	Select * from dbo.tipoComercio




------------------------------------------------------------------------------------------
--------------------------------CRUD Productos--------------------------------------------
------------------------------------------------------------------------------------------



CREATE PROCEDURE CRUD_Producto
	@Id INT,
	@Nombre VARCHAR(50),
	@Modo CHAR(1)
AS
  BEGIN TRY   -- statements that may cause exceptions
	IF @Modo = 'I'
	BEGIN 
		INSERT dbo.producto VALUES ( @Nombre)
	END

	IF @Modo='U'
	BEGIN 
		UPDATE dbo.producto SET   Nombre=@Nombre WHERE idProducto=@Id
	END

	IF @Modo= 'D'
	BEGIN
		DELETE FROM dbo.producto WHERE idProducto=@Id
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
	select @max=max(idProducto) from dbo.producto
	if @max IS NULL   --check when max is returned as null
	SET @max = 0
	DBCC CHECKIDENT ('producto', RESEED, @max)

	GO

	EXECUTE CRUD_Producto @Modo='I', @Id= 1,@Nombre = 'Atun'
	Select * from dbo.producto




	
------------------------------------------------------------------------------------------
--------------------------------CRUD Comercios/Locales------------------------------------
------------------------------------------------------------------------------------------



CREATE PROCEDURE CRUD_Comercios
	@IdComercio INT,
	@IdTipo INT,
	@IdCiudad INT,
	@Nombre VARCHAR(32),
	@Numero VARCHAR(32),
	@Ubicacion VARCHAR(55), 
	@Modo CHAR(1)
AS
  BEGIN TRY   -- statements that may cause exceptions
	DECLARE @ubicacionGeometry GEOMETRY
	
	IF @Modo = 'I'
	BEGIN
		SET @ubicacionGeometry = geometry::STGeomFromText(@Ubicacion, 4326)
		INSERT dbo.comercio VALUES (@IdTipo, @IdCiudad, @Nombre, @Numero, @ubicacionGeometry)
	END

	IF @Modo='U'
	BEGIN
		SET @ubicacionGeometry = geometry::STGeomFromText(@Ubicacion, 4326)
		UPDATE dbo.comercio SET  idTipo=@IdTipo, idCiudad=@IdCiudad ,nombre=@Nombre, numero=@Numero , ubicacion=@ubicacionGeometry WHERE idComercio=@IdComercio
	END

	IF @Modo= 'D'
	BEGIN
		DELETE FROM dbo.comercio WHERE idComercio=@IdComercio
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
	select @max=max(idComercio) from dbo.comercio
	if @max IS NULL   --check when max is returned as null
	SET @max = 0
	DBCC CHECKIDENT ('comercio', RESEED, @max)

	GO

	EXECUTE CRUD_Comercios @Modo='I', @IdComercio= 1 ,@IdTipo=2 , @IdCiudad=1 ,@Nombre='Comercio6', @Numero='#comercio-F' , @Ubicacion = 'POLYGON((0 6, 0 7, 1 7, 1 6, 0 6))'
	Select * from dbo.comercio


-- duda sobre como insertar la ubicacion como geometry::STGeomFromText**




------------------------------------------------------------------------------------------
---------------------------- Asignar/consultar horarios-----------------------------------
------------------------------------------------------------------------------------------


CREATE PROCEDURE Consultar_Asignar_Horarios
	@IdComercio INT,
	@IdTipo INT,
	@Modo CHAR(1)
AS
  BEGIN TRY   -- statements that may cause exceptions
	IF @Modo = 'C' -- consult a store and its hours of operation
	BEGIN 
		SELECT idTipo, comercio.nombre , horario_apertura, horario_cierre
		FROM dbo.comercio
				INNER JOIN dbo.tipoComercio
				ON comercio.idTipo = tipoComercio.idTipoComercio
		WHERE comercio.idComercio = @IdComercio
	END

	IF @Modo='A' -- assign a schedule
	BEGIN 
		UPDATE dbo.comercio SET idTipo = @IdTipo  
			WHERE comercio.idComercio = @IdComercio
		SELECT idTipo, comercio.nombre , horario_apertura, horario_cierre
			FROM dbo.comercio
					INNER JOIN dbo.tipoComercio
					ON comercio.idTipo = tipoComercio.idTipoComercio
						WHERE comercio.idComercio = @IdComercio
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

	GO


	-- If set to mode C, it queries, and in mode A, it assigns a schedule.
	EXECUTE Consultar_Asignar_Horarios @Modo='A', @IdComercio= 1,@IdTipo=3 
	

	