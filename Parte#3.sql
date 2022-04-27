------------------------------------------------------------------------------------------
--------------------------------Identificar Vecinos ------------------------------------
------------------------------------------------------------------------------------------


CREATE PROCEDURE GetVecinos
	@Id1 INT,
	@EsID1Casa BIT
	
AS
  BEGIN TRY   -- statements that may cause exceptions
	DECLARE @vecinos TABLE(ubcacion GEOMETRY)
	DECLARE @lugar GEOMETRY

	IF @EsID1Casa = 1
		BEGIN
			SELECT @lugar = c.ubicacion FROM dbo.casa c WHERE c.idCasa = @Id1
		END
	ELSE
        BEGIN
            SELECT @lugar = c.ubicacion FROM dbo.comercio c WHERE c.idComercio = @Id1
        END
    
    INSERT INTO @vecinos(ubcacion)
    SELECT c.ubicacion FROM dbo.casa c WHERE @lugar.STDistance(c.ubicacion) = 0

    INSERT INTO @vecinos(ubcacion)
    SELECT c.ubicacion FROM dbo.comercio c WHERE @lugar.STDistance(c.ubicacion) = 0

    SELECT ubcacion FROM @vecinos

    
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


EXECUTE GetVecinos @Id1=1, @EsID1Casa=1
EXECUTE GetVecinos @Id1=3, @EsID1Casa=1
EXECUTE GetVecinos @Id1=6, @EsID1Casa=1
EXECUTE GetVecinos @Id1=2, @EsID1Casa=0
EXECUTE GetVecinos @Id1=3, @EsID1Casa=0


------------------------------------------------------------------------------------------
--------------------------------BuscarDisponibles ------------------------------------
------------------------------------------------------------------------------------------

CREATE PROCEDURE BuscarDisponibles
	@IdCasa INT,
	@IdProducto INT,
    @Hora TIME
	
AS
  BEGIN TRY   -- statements that may cause exceptions
    
    DECLARE @lugar GEOMETRY
    SELECT @lugar = c.ubicacion FROM casa c WHERE idCasa = @IdCasa

    SELECT c.nombre,c.numero,i.precio,@lugar.STDistance(c.ubicacion) as distancia,c.ubicacion
    FROM dbo.comercio c
    INNER JOIN inventario i on i.idComercio = c.idComercio AND i.idProducto = @IdProducto
    INNER JOIN tipoComercio t on t.idTipoComercio = c.idTipo
    WHERE @Hora > t.horario_apertura AND @Hora < t.horario_cierre
          AND i.cantidad > 0
    ORDER BY distancia DESC
    
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


EXECUTE BuscarDisponibles @IdCasa = 3,@IdProducto = 1,@Hora = '08:00:00' 
EXECUTE BuscarDisponibles @IdCasa = 3,@IdProducto = 3,@Hora = '08:00:00' 
EXECUTE BuscarDisponibles @IdCasa = 3,@IdProducto = 3,@Hora = '06:00:00' 