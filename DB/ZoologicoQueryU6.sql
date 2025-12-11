USE Zoologico;
GO

CREATE LOGIN zoo WITH PASSWORD = 'zoo';
CREATE USER zoo FOR LOGIN zoo;
ALTER ROLE db_owner ADD MEMBER zoo;

DROP TABLE Habitat;
CREATE TABLE Habitat (
	idHabitat TINYINT PRIMARY KEY NOT NULL,
	NombreHabitat VARCHAR(100)
);
GO

EXEC sp_help 'Animales';
GO

CREATE OR ALTER PROC sp_InsertarAlimentos(
    @NombreAlimento VARCHAR(100),
    @TipoAlimento VARCHAR(30),
    @Cantidad INT
) AS BEGIN
    BEGIN TRY
        BEGIN TRANSACTION InsertTransaccion;
            INSERT INTO Alimentos(
                NombreAlimento,
                TipoAlimento,
                Cantidad
            ) VALUES (
                @NombreAlimento,
                @TipoAlimento,
                @Cantidad
            );
            SELECT 'Inserción realizada.' AS Resultado;
        COMMIT TRANSACTION InsertTransaccion;
    END TRY
    BEGIN CATCH
        SELECT 'Error capturado: ' + ERROR_MESSAGE() + ', Número de error: ' + CAST(ERROR_NUMBER() AS VARCHAR) + '.' AS Resultado;
        ROLLBACK TRANSACTION InsertTransaccion;
    END CATCH
    RETURN
END;
GO

CREATE OR ALTER PROC sp_InsertarAnimales(
	@idEspecie TINYINT,
	@NombreAnimal VARCHAR(100),
	@SexoAnimal CHAR(1),
	@FechaIngreso DATE,
	@FechaNacimiento DATE,
	@idHabitat TINYINT
) AS BEGIN
	BEGIN TRY
		BEGIN TRANSACTION InsertTransaccion;
			INSERT INTO Animales(
				idEspecie,
				NombreAnimal,
				SexoAnimal,
				FechaIngreso,
				FechaNacimiento,
				idHabitat
			) VALUES (
				@idEspecie,
				@NombreAnimal,
				@SexoAnimal,
				@FechaIngreso,
				@FechaNacimiento,
				@idHabitat
			);
            SELECT 'Inserción realizada.' AS Resultado;
        COMMIT TRANSACTION InsertTransaccion;
    END TRY
    BEGIN CATCH
        SELECT 'Error capturado: ' + ERROR_MESSAGE() + ', Número de error: ' + CAST(ERROR_NUMBER() AS VARCHAR) + '.' AS Resultado;
        ROLLBACK TRANSACTION InsertTransaccion;
    END CATCH
    RETURN
END;
GO

CREATE OR ALTER PROC sp_InsertarAtenciones(
    @idAnimal SMALLINT,
    @idEmpleado SMALLINT,
    @FechaAtencion DATE,
    @Diagnostico VARCHAR(200),
    @Costo DECIMAL(8, 2)
) AS BEGIN
    BEGIN TRY
        BEGIN TRANSACTION InsertTransaccion;
            INSERT INTO Atenciones(
                idAnimal,
                idEmpleado,
                FechaAtencion,
                Diagnostico,
                Costo
            ) VALUES (
                @idAnimal,
                @idEmpleado,
                @FechaAtencion,
                @Diagnostico,
                @Costo
            );
            SELECT 'Inserción realizada.' AS Resultado;
        COMMIT TRANSACTION InsertTransaccion;
    END TRY
    BEGIN CATCH
        SELECT 'Error capturado: ' + ERROR_MESSAGE() + ', Número de error: ' + CAST(ERROR_NUMBER() AS VARCHAR) + '.' AS Resultado;
        ROLLBACK TRANSACTION InsertTransaccion;
    END CATCH
    RETURN
END;
GO

CREATE OR ALTER PROC sp_InsertarDietas(
    @idAnimal SMALLINT,
    @idAlimento SMALLINT,
    @CantidadDiaria INT
) AS BEGIN
    BEGIN TRY
        BEGIN TRANSACTION InsertTransaccion;
            INSERT INTO Dietas(
                idAnimal,
                idAlimento,
                CantidadDiaria
            ) VALUES (
                @idAnimal,
                @idAlimento,
                @CantidadDiaria
            );
            SELECT 'Inserción realizada.' AS Resultado;
        COMMIT TRANSACTION InsertTransaccion;
    END TRY
    BEGIN CATCH
        SELECT 'Error capturado: ' + ERROR_MESSAGE() + ', Número de error: ' + CAST(ERROR_NUMBER() AS VARCHAR) + '.' AS Resultado;
        ROLLBACK TRANSACTION InsertTransaccion;
    END CATCH
    RETURN
END;
GO

CREATE OR ALTER PROC sp_InsertarEmpleados(
    @NombreEmpleado VARCHAR(100),
    @CargoEmpleado VARCHAR(30),
    @Salario DECIMAL(10, 2)
) AS BEGIN
    BEGIN TRY
        BEGIN TRANSACTION InsertTransaccion;
            INSERT INTO Empleados(
                NombreEmpleado,
                CargoEmpleado,
                Salario
            ) VALUES (
                @NombreEmpleado,
                @CargoEmpleado,
                @Salario
            );
            SELECT 'Inserción realizada.' AS Resultado;
        COMMIT TRANSACTION InsertTransaccion;
    END TRY
    BEGIN CATCH
        SELECT 'Error capturado: ' + ERROR_MESSAGE() + ', Número de error: ' + CAST(ERROR_NUMBER() AS VARCHAR) + '.' AS Resultado;
        ROLLBACK TRANSACTION InsertTransaccion;
    END CATCH
    RETURN
END;
GO

CREATE OR ALTER PROC sp_InsertarEspecies(
    @NombreEspecie VARCHAR(100),
    @TipoEspecie VARCHAR(30)
) AS BEGIN
    BEGIN TRY
        BEGIN TRANSACTION InsertTransaccion;
            INSERT INTO Especies(
                NombreEspecie,
                TipoEspecie
            ) VALUES (
                @NombreEspecie,
                @TipoEspecie
            );
            SELECT 'Inserción realizada.' AS Resultado;
        COMMIT TRANSACTION InsertTransaccion;
    END TRY
    BEGIN CATCH
        SELECT 'Error capturado: ' + ERROR_MESSAGE() + ', Número de error: ' + CAST(ERROR_NUMBER() AS VARCHAR) + '.' AS Resultado;
        ROLLBACK TRANSACTION InsertTransaccion;
    END CATCH
    RETURN
END;
GO

CREATE OR ALTER PROC sp_InsertarHabitat(
    @NombreHabitat VARCHAR(100)
) AS BEGIN
    BEGIN TRY
        BEGIN TRANSACTION InsertTransaccion;
            INSERT INTO Habitat(
                NombreHabitat
            ) VALUES (
                @NombreHabitat
            );
            SELECT 'Inserción realizada.' AS Resultado;
        COMMIT TRANSACTION InsertTransaccion;
    END TRY
    BEGIN CATCH
        SELECT 'Error capturado: ' + ERROR_MESSAGE() + ', Número de error: ' + CAST(ERROR_NUMBER() AS VARCHAR) + '.' AS Resultado;
        ROLLBACK TRANSACTION InsertTransaccion;
    END CATCH
    RETURN
END;
GO

EXEC sp_InsertarHabitat 'Doméstico';
GO

EXEC sp_InsertarEspecies 'Felis catus', 'Mamífero';
GO

EXEC sp_InsertarAnimales 1,
    @NombreAnimal = 'Michi',
	@SexoAnimal = 'M',
	@FechaIngreso = '2023-10-15',
	@idHabitat = 1;
GO

SELECT * FROM Habitat;
SELECT * FROM Especies;
SELECT * FROM Animales;

EXEC sp_help sp_InsertarAlimentos;
EXEC sp_help sp_InsertarAnimales;
EXEC sp_help sp_InsertarAtenciones;
EXEC sp_help sp_InsertarDietas;
EXEC sp_help sp_InsertarEmpleados;
EXEC sp_help sp_InsertarEspecies;
EXEC sp_help sp_InsertarHabitat;
GO

CREATE OR ALTER PROC sp_EliminarAnimales(
    @idAnimal SMALLINT
) AS BEGIN
    BEGIN TRY
        BEGIN TRANSACTION DeleteTransaccion;
            DELETE FROM Animales WHERE idAnimal = @idAnimal;
            SELECT 'Eliminación realizada. Filas afectadas: ' + CAST(@@ROWCOUNT AS VARCHAR) AS Resultado;
        COMMIT TRANSACTION DeleteTransaccion;
    END TRY
    BEGIN CATCH
        SELECT 'Error capturado: ' + ERROR_MESSAGE() + ', Número de error: ' + CAST(ERROR_NUMBER() AS VARCHAR) + '.' AS Resultado;
        ROLLBACK TRANSACTION DeleteTransaccion;
    END CATCH
    RETURN
END;
GO

CREATE OR ALTER PROC sp_EliminarEmpleados(
    @idEmpleado SMALLINT
) AS BEGIN
    BEGIN TRY
        BEGIN TRANSACTION DeleteTransaccion;
            DELETE FROM Empleados WHERE idEmpleado = @idEmpleado;
            SELECT 'Eliminación realizada. Filas afectadas: ' + CAST(@@ROWCOUNT AS VARCHAR) AS Resultado;
        COMMIT TRANSACTION DeleteTransaccion;
    END TRY
    BEGIN CATCH
        SELECT 'Error capturado: ' + ERROR_MESSAGE() + ', Número de error: ' + CAST(ERROR_NUMBER() AS VARCHAR) + '.' AS Resultado;
        ROLLBACK TRANSACTION DeleteTransaccion;
    END CATCH
    RETURN
END;
GO

CREATE OR ALTER PROC sp_EliminarAtenciones(
    @idAtencion SMALLINT
) AS BEGIN
    BEGIN TRY
        BEGIN TRANSACTION DeleteTransaccion;
            DELETE FROM Atenciones WHERE idAtencion = @idAtencion;
            SELECT 'Eliminación realizada. Filas afectadas: ' + CAST(@@ROWCOUNT AS VARCHAR) AS Resultado;
        COMMIT TRANSACTION DeleteTransaccion;
    END TRY
    BEGIN CATCH
        SELECT 'Error capturado: ' + ERROR_MESSAGE() + ', Número de error: ' + CAST(ERROR_NUMBER() AS VARCHAR) + '.' AS Resultado;
        ROLLBACK TRANSACTION DeleteTransaccion;
    END CATCH
    RETURN
END;
GO

CREATE OR ALTER PROC sp_EliminarAlimentos(
    @idAlimento SMALLINT
) AS BEGIN
    BEGIN TRY
        BEGIN TRANSACTION DeleteTransaccion;
            DELETE FROM Alimentos WHERE idAlimento = @idAlimento;
            SELECT 'Eliminación realizada. Filas afectadas: ' + CAST(@@ROWCOUNT AS VARCHAR) AS Resultado;
        COMMIT TRANSACTION DeleteTransaccion;
    END TRY
    BEGIN CATCH
        SELECT 'Error capturado: ' + ERROR_MESSAGE() + ', Número de error: ' + CAST(ERROR_NUMBER() AS VARCHAR) + '.' AS Resultado;
        ROLLBACK TRANSACTION DeleteTransaccion;
    END CATCH
    RETURN
END;
GO

CREATE OR ALTER PROC sp_EliminarDietas(
    @idDieta SMALLINT
) AS BEGIN
    BEGIN TRY
        BEGIN TRANSACTION DeleteTransaccion;
            DELETE FROM Dietas WHERE idDieta = @idDieta;
            SELECT 'Eliminación realizada. Filas afectadas: ' + CAST(@@ROWCOUNT AS VARCHAR) AS Resultado;
        COMMIT TRANSACTION DeleteTransaccion;
    END TRY
    BEGIN CATCH
        SELECT 'Error capturado: ' + ERROR_MESSAGE() + ', Número de error: ' + CAST(ERROR_NUMBER() AS VARCHAR) + '.' AS Resultado;
        ROLLBACK TRANSACTION DeleteTransaccion;
    END CATCH
    RETURN
END;
GO

CREATE OR ALTER PROC sp_EliminarEspecies(
    @idEspecie TINYINT
) AS BEGIN
    BEGIN TRY
        BEGIN TRANSACTION DeleteTransaccion;
            DELETE FROM Especies WHERE idEspecie = @idEspecie;
            SELECT 'Eliminación realizada. Filas afectadas: ' + CAST(@@ROWCOUNT AS VARCHAR) AS Resultado;
        COMMIT TRANSACTION DeleteTransaccion;
    END TRY
    BEGIN CATCH
        SELECT 'Error capturado: ' + ERROR_MESSAGE() + ', Número de error: ' + CAST(ERROR_NUMBER() AS VARCHAR) + '.' AS Resultado;
        ROLLBACK TRANSACTION DeleteTransaccion;
    END CATCH
    RETURN
END;
GO

CREATE OR ALTER PROC sp_EliminarHabitat(
    @idHabitat TINYINT
) AS BEGIN
    BEGIN TRY
        BEGIN TRANSACTION DeleteTransaccion;
            DELETE FROM Habitat WHERE idHabitat = @idHabitat;
            SELECT 'Eliminación realizada. Filas afectadas: ' + CAST(@@ROWCOUNT AS VARCHAR) AS Resultado;
        COMMIT TRANSACTION DeleteTransaccion;
    END TRY
    BEGIN CATCH
        SELECT 'Error capturado: ' + ERROR_MESSAGE() + ', Número de error: ' + CAST(ERROR_NUMBER() AS VARCHAR) + '.' AS Resultado;
        ROLLBACK TRANSACTION DeleteTransaccion;
    END CATCH
    RETURN
END;
GO

EXEC sp_help sp_EliminarAlimentos;
EXEC sp_help sp_EliminarAnimales;
EXEC sp_help sp_EliminarAtenciones;
EXEC sp_help sp_EliminarDietas;
EXEC sp_help sp_EliminarEmpleados;
EXEC sp_help sp_EliminarEspecies;
EXEC sp_help sp_EliminarHabitat;
GO

CREATE OR ALTER PROC sp_ModificarAlimentos(
    @idAlimento SMALLINT,
    @NombreAlimento VARCHAR(100),
    @TipoAlimento VARCHAR(30),
    @Cantidad INT
) AS BEGIN
    BEGIN TRY
        BEGIN TRANSACTION UpdateTransaccion;
            UPDATE Alimentos SET
                NombreAlimento = @NombreAlimento,
                TipoAlimento = @TipoAlimento,
                Cantidad = @Cantidad
            WHERE idAlimento = @idAlimento;
            SELECT 'Modificación realizada.' AS Resultado;
        COMMIT TRANSACTION UpdateTransaccion;
    END TRY
    BEGIN CATCH
        SELECT 'Error capturado: ' + ERROR_MESSAGE() + ', Número de error: ' + CAST(ERROR_NUMBER() AS VARCHAR) + '.' AS Resultado;
        ROLLBACK TRANSACTION UpdateTransaccion;
    END CATCH
    RETURN
END;
GO

CREATE OR ALTER PROC sp_ModificarAnimales(
    @idAnimal SMALLINT,
	@idEspecie TINYINT,
	@NombreAnimal VARCHAR(100),
	@SexoAnimal CHAR(1),
	@FechaIngreso DATE,
	@FechaNacimiento DATE,
	@idHabitat TINYINT
) AS BEGIN
    BEGIN TRY
        BEGIN TRANSACTION UpdateTransaccion;
			Update Animales SET
				idEspecie = @idEspecie,
				NombreAnimal = @NombreAnimal,
				SexoAnimal = @SexoAnimal,
				FechaIngreso = @FechaIngreso,
				FechaNacimiento = @FechaNacimiento,
				idHabitat = @idHabitat
			WHERE idAnimal = @idAnimal;
            SELECT 'Modificación realizada.' AS Resultado;
        COMMIT TRANSACTION UpdateTransaccion;
    END TRY
    BEGIN CATCH
        SELECT 'Error capturado: ' + ERROR_MESSAGE() + ', Número de error: ' + CAST(ERROR_NUMBER() AS VARCHAR) + '.' AS Resultado;
        ROLLBACK TRANSACTION UpdateTransaccion;
    END CATCH
    RETURN
END;
GO

CREATE OR ALTER PROC sp_ModificarAtenciones(
    @idAtencion SMALLINT,
    @idAnimal SMALLINT,
    @idEmpleado SMALLINT,
    @FechaAtencion DATE,
    @Diagnostico VARCHAR(200),
    @Costo DECIMAL(8, 2)
) AS BEGIN
    BEGIN TRY
        BEGIN TRANSACTION UpdateTransaccion;
            UPDATE Atenciones SET
                idAnimal = @idAnimal,
                idEmpleado = @idEmpleado,
                FechaAtencion = @FechaAtencion,
                Diagnostico = @Diagnostico,
                Costo = @Costo
            WHERE idAtencion = @idAtencion;
            SELECT 'Modificación realizada.' AS Resultado;
        COMMIT TRANSACTION UpdateTransaccion;
    END TRY
    BEGIN CATCH
        SELECT 'Error capturado: ' + ERROR_MESSAGE() + ', Número de error: ' + CAST(ERROR_NUMBER() AS VARCHAR) + '.' AS Resultado;
        ROLLBACK TRANSACTION UpdateTransaccion;
    END CATCH
    RETURN
END;
GO

CREATE OR ALTER PROC sp_ModificarDietas(
    @idDieta SMALLINT,
    @idAnimal SMALLINT,
    @idAlimento SMALLINT,
    @CantidadDiaria INT
) AS BEGIN
    BEGIN TRY
        BEGIN TRANSACTION UpdateTransaccion;
            UPDATE Dietas SET
                idAnimal = @idAnimal,
                idAlimento = @idAlimento,
                CantidadDiaria = @CantidadDiaria
            WHERE idDieta = @idDieta;
            SELECT 'Modificación realizada.' AS Resultado;
        COMMIT TRANSACTION UpdateTransaccion;
    END TRY
    BEGIN CATCH
        SELECT 'Error capturado: ' + ERROR_MESSAGE() + ', Número de error: ' + CAST(ERROR_NUMBER() AS VARCHAR) + '.' AS Resultado;
        ROLLBACK TRANSACTION UpdateTransaccion;
    END CATCH
    RETURN
END;
GO

CREATE OR ALTER PROC sp_ModificarEmpleados(
    @idEmpleado SMALLINT,
    @NombreEmpleado VARCHAR(100),
    @CargoEmpleado VARCHAR(30),
    @Salario DECIMAL(10, 2)
) AS BEGIN
    BEGIN TRY
        BEGIN TRANSACTION UpdateTransaccion;
            UPDATE Empleados SET
                NombreEmpleado = @NombreEmpleado,
                CargoEmpleado = @CargoEmpleado,
                Salario = @Salario
            WHERE idEmpleado = @idEmpleado;
            SELECT 'Modificación realizada.' AS Resultado;
        COMMIT TRANSACTION UpdateTransaccion;
    END TRY
    BEGIN CATCH
        SELECT 'Error capturado: ' + ERROR_MESSAGE() + ', Número de error: ' + CAST(ERROR_NUMBER() AS VARCHAR) + '.' AS Resultado;
        ROLLBACK TRANSACTION UpdateTransaccion;
    END CATCH
    RETURN
END;
GO

CREATE OR ALTER PROC sp_ModificarEspecies(
    @idEspecie TINYINT,
    @NombreEspecie VARCHAR(100),
    @TipoEspecie VARCHAR(30)
) AS BEGIN
    BEGIN TRY
        BEGIN TRANSACTION UpdateTransaccion;
            UPDATE Especies SET
                NombreEspecie = @NombreEspecie,
                TipoEspecie = @TipoEspecie
            WHERE idEspecie = @idEspecie;
            SELECT 'Modificación realizada.' AS Resultado;
        COMMIT TRANSACTION UpdateTransaccion;
    END TRY
    BEGIN CATCH
        SELECT 'Error capturado: ' + ERROR_MESSAGE() + ', Número de error: ' + CAST(ERROR_NUMBER() AS VARCHAR) + '.' AS Resultado;
        ROLLBACK TRANSACTION UpdateTransaccion;
    END CATCH
    RETURN
END;
GO

CREATE OR ALTER PROC sp_ModificarHabitat(
    @idHabitat INT,
    @NombreHabitat VARCHAR(100)
) AS BEGIN
    BEGIN TRY
        BEGIN TRANSACTION UpdateTransaccion;
            UPDATE Habitat SET
                NombreHabitat = @NombreHabitat
            WHERE idHabitat = @idHabitat;
            SELECT 'Modificación realizada.' AS Resultado;
        COMMIT TRANSACTION UpdateTransaccion;
    END TRY
    BEGIN CATCH
        SELECT 'Error capturado: ' + ERROR_MESSAGE() + ', Número de error: ' + CAST(ERROR_NUMBER() AS VARCHAR) + '.' AS Resultado;
        ROLLBACK TRANSACTION UpdateTransaccion;
    END CATCH
    RETURN
END;
GO

EXEC sp_help sp_ModificarAlimentos;
EXEC sp_help sp_ModificarAnimales;
EXEC sp_help sp_ModificarAtenciones;
EXEC sp_help sp_ModificarDietas;
EXEC sp_help sp_ModificarEmpleados;
EXEC sp_help sp_ModificarEspecies;
EXEC sp_help sp_ModificarHabitat;
GO
