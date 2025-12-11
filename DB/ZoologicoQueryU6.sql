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

EXEC sp_InsertarEmpleados 'Juan Pérez', 'Veterinario Jefe', 4500.00;
EXEC sp_InsertarEmpleados 'María Gómez', 'Veterinario', 3800.00;
EXEC sp_InsertarEmpleados 'Carlos López', 'Cuidador de Animales', 3200.00;
EXEC sp_InsertarEmpleados 'Ana Rodríguez', 'Nutricionista Animal', 4000.00;
EXEC sp_InsertarEmpleados 'Pedro Martínez', 'Veterinario', 3800.00;
EXEC sp_InsertarEmpleados 'Laura García', 'Cuidador de Animales', 3200.00;
EXEC sp_InsertarEmpleados 'Javier Sánchez', 'Administrador', 5000.00;
EXEC sp_InsertarEmpleados 'Sofía Fernández', 'Veterinario', 3900.00;
EXEC sp_InsertarEmpleados 'David Torres', 'Cuidador de Animales', 3300.00;
EXEC sp_InsertarEmpleados 'Elena Ruiz', 'Nutricionista Animal', 4100.00;
GO

EXEC sp_InsertarEspecies 'Panthera leo', 'Mamífero';
EXEC sp_InsertarEspecies 'Elephas maximus', 'Mamífero';
EXEC sp_InsertarEspecies 'Giraffa camelopardalis', 'Mamífero';
EXEC sp_InsertarEspecies 'Ursus arctos', 'Mamífero';
EXEC sp_InsertarEspecies 'Python regius', 'Reptil';
EXEC sp_InsertarEspecies 'Ara macao', 'Ave';
EXEC sp_InsertarEspecies 'Crocodylus niloticus', 'Reptil';
EXEC sp_InsertarEspecies 'Felis catus', 'Mamífero';
EXEC sp_InsertarEspecies 'Canis lupus familiaris', 'Mamífero';
EXEC sp_InsertarEspecies 'Equus ferus caballus', 'Mamífero';
GO

EXEC sp_InsertarHabitat 'Sabana Africana';
EXEC sp_InsertarHabitat 'Selva Tropical';
EXEC sp_InsertarHabitat 'Bosque Templado';
EXEC sp_InsertarHabitat 'Desierto';
EXEC sp_InsertarHabitat 'Tundra Ártica';
EXEC sp_InsertarHabitat 'Pantano';
EXEC sp_InsertarHabitat 'Montaña Rocosa';
EXEC sp_InsertarHabitat 'Doméstico';
EXEC sp_InsertarHabitat 'Pradera';
EXEC sp_InsertarHabitat 'Zona de Humedales';
GO

EXEC sp_InsertarAnimales 1, 'Simba', 'M', '2020-05-15', '2018-07-10', 1;
EXEC sp_InsertarAnimales 1, 'Nala', 'F', '2021-03-20', '2019-01-15', 1;
EXEC sp_InsertarAnimales 2, 'Dumbo', 'M', '2018-07-10', '2015-11-22', 2;
EXEC sp_InsertarAnimales 3, 'Jirafina', 'F', '2019-11-05', '2016-04-30', 1;
EXEC sp_InsertarAnimales 4, 'Baloo', 'M', '2017-09-12', '2014-03-08', 3;
EXEC sp_InsertarAnimales 5, 'Kaa', 'F', '2022-01-30', '2020-06-15', 4;
EXEC sp_InsertarAnimales 6, 'Guacamayo', 'M', '2020-08-25', '2018-12-05', 2;
EXEC sp_InsertarAnimales 7, 'Coco', 'M', '2019-04-18', '2017-08-20', 6;
EXEC sp_InsertarAnimales 8, 'Michi', 'M', '2023-10-15', '2022-05-12', 8;
EXEC sp_InsertarAnimales 9, 'Rex', 'M', '2022-12-03', '2021-07-25', 8;
GO

EXEC sp_InsertarAtenciones 1, 1, '2024-01-10', 'Revisión general y vacunación anual', 120.50;
EXEC sp_InsertarAtenciones 2, 2, '2024-01-12', 'Control de peso y nutrición', 95.00;
EXEC sp_InsertarAtenciones 3, 1, '2024-01-15', 'Corte de uñas y limpieza dental', 200.00;
EXEC sp_InsertarAtenciones 4, 3, '2024-01-18', 'Revisión de articulaciones', 85.50;
EXEC sp_InsertarAtenciones 5, 2, '2024-01-20', 'Tratamiento para resfriado', 150.75;
EXEC sp_InsertarAtenciones 6, 1, '2024-01-22', 'Desparasitación', 75.25;
EXEC sp_InsertarAtenciones 7, 3, '2024-01-25', 'Control de plumas y pico', 60.00;
EXEC sp_InsertarAtenciones 8, 2, '2024-01-28', 'Limpieza de escamas', 110.00;
EXEC sp_InsertarAtenciones 9, 1, '2024-02-01', 'Esterilización', 300.00;
EXEC sp_InsertarAtenciones 10, 3, '2024-02-05', 'Vacunación y chequeo general', 125.50;
GO

EXEC sp_InsertarAlimentos 'Carne de res', 'Proteína animal', 50;
EXEC sp_InsertarAlimentos 'Pollo', 'Proteína animal', 40;
EXEC sp_InsertarAlimentos 'Pescado', 'Proteína animal', 30;
EXEC sp_InsertarAlimentos 'Zanahorias', 'Vegetales', 100;
EXEC sp_InsertarAlimentos 'Manzanas', 'Frutas', 80;
EXEC sp_InsertarAlimentos 'Heno', 'Forraje', 200;
EXEC sp_InsertarAlimentos 'Granos mixtos', 'Cereales', 150;
EXEC sp_InsertarAlimentos 'Huevos', 'Proteína animal', 60;
EXEC sp_InsertarAlimentos 'Plátanos', 'Frutas', 70;
EXEC sp_InsertarAlimentos 'Lechuga', 'Vegetales', 90;
GO

EXEC sp_InsertarDietas 1, 1, 5;  -- Simba come 5kg de carne
EXEC sp_InsertarDietas 1, 6, 2;  -- Simba come 2kg de heno
EXEC sp_InsertarDietas 2, 1, 4;  -- Nala come 4kg de carne
EXEC sp_InsertarDietas 3, 6, 50; -- Dumbo come 50kg de heno
EXEC sp_InsertarDietas 3, 7, 10; -- Dumbo come 10kg de granos
EXEC sp_InsertarDietas 4, 4, 8;  -- Jirafina come 8kg de zanahorias
EXEC sp_InsertarDietas 4, 9, 12; -- Jirafina come 12kg de lechuga
EXEC sp_InsertarDietas 5, 1, 8;  -- Baloo come 8kg de carne
EXEC sp_InsertarDietas 5, 5, 3;  -- Baloo come 3kg de manzanas
EXEC sp_InsertarDietas 6, 2, 2;  -- Kaa come 2kg de pollo
GO