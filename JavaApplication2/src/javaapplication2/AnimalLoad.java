/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package javaapplication2;

/**
 *
 * @author bapna
 */
import java.sql.*;
import java.util.Calendar;
import java.util.Vector;
import javax.swing.table.DefaultTableModel;

public class AnimalLoad {

    // NOTA: Se ha eliminado la declaración del logger
    // Método 1: Carga los datos para la JTable (jTable1)
    public DefaultTableModel cargarModeloAnimales() {
        String[] columnNames = {"ID", "Nombre", "Sexo", "Especie Común", "Habitat"};
        DefaultTableModel model = new DefaultTableModel(columnNames, 0);

        String SQL_CONSULTA
                = "SELECT A.AnimalID, A.Nombre, A.Sexo, E.NombreComun, H.NombreHabitat "
                + "FROM Animales A "
                + "INNER JOIN Especies E ON A.EspecieID = E.EspecieID "
                + "INNER JOIN Habitat H ON A.HabitatID = H.HabitatID";

        try (Connection con = Conexion.getConexion(); Statement stmt = con.createStatement(); ResultSet rs = stmt.executeQuery(SQL_CONSULTA)) {

            while (rs.next()) {
                Object[] rowData = {
                    rs.getInt("AnimalID"),
                    rs.getString("Nombre"),
                    rs.getString("Sexo"),
                    rs.getString("NombreComun"),
                    rs.getString("NombreHabitat")
                };
                model.addRow(rowData);
            }

        } catch (SQLException e) {
            // 🔑 REEMPLAZO DEL LOGGER
            System.err.println("Error al cargar datos de Animales.");
            e.printStackTrace();
        }
        return model;
    }

    // Método 2: Carga los nombres para los ComboBox (cmbEspecie)
    public Vector<String> cargarNombresEspecies() {
        Vector<String> especies = new Vector<>();
        especies.add("Selecciona Especie");

        String SQL_CONSULTA = "SELECT NombreComun FROM Especies ORDER BY NombreComun";

        try (Connection con = Conexion.getConexion(); Statement stmt = con.createStatement(); ResultSet rs = stmt.executeQuery(SQL_CONSULTA)) {

            while (rs.next()) {
                especies.add(rs.getString("NombreComun"));
            }

        } catch (SQLException e) {
            // 🔑 REEMPLAZO DEL LOGGER
            System.err.println("Error al cargar Especies.");
            e.printStackTrace();
        }
        return especies;
    }

    // Método 3: Carga los nombres para los ComboBox (cmbHabitat)
    public Vector<String> cargarNombresHabitat() {
        Vector<String> habitats = new Vector<>();
        habitats.add("Selecciona Habitat");

        String SQL_CONSULTA = "SELECT NombreHabitat FROM Habitat ORDER BY NombreHabitat";

        try (Connection con = Conexion.getConexion(); Statement stmt = con.createStatement(); ResultSet rs = stmt.executeQuery(SQL_CONSULTA)) {

            while (rs.next()) {
                habitats.add(rs.getString("NombreHabitat"));
            }

        } catch (SQLException e) {
            // 🔑 REEMPLAZO DEL LOGGER
            System.err.println("Error al cargar Hábitats.");
            e.printStackTrace();
        }
        return habitats;
    }

private int obtenerIdPorNombre(String tableName, String columnName, String nameValue, String idColumnName) {
    int id = -1;
    String SQL_CONSULTA = "SELECT " + idColumnName + " FROM " + tableName + " WHERE " + columnName + " = ?";

    try (Connection con = Conexion.getConexion();
         PreparedStatement pstmt = con.prepareStatement(SQL_CONSULTA)) {

        pstmt.setString(1, nameValue);
        
        try (ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                id = rs.getInt(idColumnName);
            }
        }
    } catch (SQLException e) {
        System.err.println("Error al obtener el ID de " + tableName + ": " + e.getMessage());
        e.printStackTrace();
    }
    return id;
}

    // MÉTODO PRINCIPAL DE INSERCIÓN 
// Dentro de AnimalLoad.java

public boolean insertarAnimal(String nombre, String sexo, java.util.Calendar fechaNacimiento, 
                              java.util.Calendar fechaRegistro, String especieNombre, String habitatNombre) {
    
    // NOTA: La lógica de buscar IDs y la inserción se maneja AHORA en el Stored Procedure.

    // 1. Definir la llamada al SP
    String SQL_CALL = "{CALL SP_InsertarAnimal(?, ?, ?, ?, ?, ?)}"; // 6 parámetros de entrada

    try (Connection con = Conexion.getConexion();
         CallableStatement cstmt = con.prepareCall(SQL_CALL)) {

        // 2. Conversión de Fechas (Calendar a java.sql.Date)
        java.sql.Date sqlFechaNac = new java.sql.Date(fechaNacimiento.getTime().getTime());
        java.sql.Date sqlFechaReg = new java.sql.Date(fechaRegistro.getTime().getTime());

        // 3. Asignar parámetros al CallableStatement
        cstmt.setString(1, nombre);
        cstmt.setString(2, sexo);
        cstmt.setDate(3, sqlFechaNac);
        cstmt.setDate(4, sqlFechaReg);
        cstmt.setString(5, especieNombre);
        cstmt.setString(6, habitatNombre);

        // 4. Ejecutar la consulta (el SP devuelve un ResultSet con el resultado)
        try (ResultSet rs = cstmt.executeQuery()) {
            if (rs.next()) {
                int resultado = rs.getInt("Resultado");
                if (resultado == 1) {
                    System.out.println("Inserción de animal exitosa vía SP.");
                    return true;
                } else {
                    System.err.println("Falló la inserción: Especie o Hábitat no encontrado.");
                    return false;
                }
            }
        }
    } catch (SQLException e) {
        System.err.println("Error SQL al insertar animal con : " + e.getMessage());
        e.printStackTrace();
    }
    return false;
}

// Dentro de AnimalLoad.java

public boolean eliminarAnimal(int animalID) {
    
    // 1. Definir la llamada al SP
    String SQL_CALL = "{CALL SP_EliminarAnimal(?)}"; // 1 parámetro de entrada

    try (Connection con = Conexion.getConexion();
         CallableStatement cstmt = con.prepareCall(SQL_CALL)) {

        // 2. Asignar el parámetro ID
        cstmt.setInt(1, animalID);

        // 3. Ejecutar la consulta (el SP devuelve un ResultSet con las filas eliminadas)
        try (ResultSet rs = cstmt.executeQuery()) {
            if (rs.next()) {
                int filasEliminadas = rs.getInt("FilasEliminadas");
                if (filasEliminadas > 0) {
                    System.out.println("Eliminación de animal exitosa ID: " + animalID);
                    return true;
                }
            }
        }
    } catch (SQLException e) {
        System.err.println("Error SQL al eliminar animal" + e.getMessage());
        e.printStackTrace();
    }
    return false;
}
// Dentro de AnimalLoad.java
// ...

public boolean modificarAnimal(int animalID, String nombre, String sexo, java.util.Calendar fechaNacimiento,
                               String especieNombre, String habitatNombre) {
    
    // 1. Convertir nombres a IDs usando el método auxiliar
    int especieID = obtenerIdPorNombre("Especies", "NombreComun", especieNombre, "EspecieID");
    int habitatID = obtenerIdPorNombre("Habitat", "NombreHabitat", habitatNombre, "HabitatID");

    if (especieID == -1 || habitatID == -1) {
        System.err.println("Advertencia: No se pudo encontrar el ID de la Especie o el Hábitat. Modificación abortada.");
        return false;
    }
    
    // 2. Sentencia SQL UPDATE
    String SQL_UPDATE = "UPDATE Animales SET Nombre = ?, Sexo = ?, FechaNacimiento = ?, EspecieID = ?, HabitatID = ? WHERE AnimalID = ?";

    try (Connection con = Conexion.getConexion();
         PreparedStatement pstmt = con.prepareStatement(SQL_UPDATE)) {

        // 3. Conversión de Fecha (Calendar a java.sql.Date)
        java.sql.Date sqlFechaNac = new java.sql.Date(fechaNacimiento.getTime().getTime());

        // 4. Asignar los parámetros
        pstmt.setString(1, nombre);
        pstmt.setString(2, sexo);
        pstmt.setDate(3, sqlFechaNac);
        pstmt.setInt(4, especieID);
        pstmt.setInt(5, habitatID);
        // El ID va al final para la cláusula WHERE
        pstmt.setInt(6, animalID); 

        // 5. Ejecutar la modificación (executeUpdate)
        int filasAfectadas = pstmt.executeUpdate();

        if (filasAfectadas > 0) {
            System.out.println("✅ Modificación de animal exitosa. ID: " + animalID);
            return true;
        }

    } catch (SQLException e) {
        System.err.println("❌ Error SQL al modificar animal: " + e.getMessage());
        e.printStackTrace();
    }
    return false;
}
// Dentro de AnimalLoad.java

/**
 * Obtiene todos los detalles de un animal específico usando su ID.
 * @param animalID El ID del animal a buscar.
 * @return Vector<Object> con los datos del animal: [Nombre, Sexo, FechaNac, Especie, Habitat]
 */
public Vector<Object> obtenerAnimalPorId(int animalID) {
    Vector<Object> datosAnimal = null;
    
    // Consulta SQL que usa INNER JOIN para obtener los nombres completos
    String SQL_SELECT = "SELECT A.Nombre, A.Sexo, A.FechaNacimiento, " +
                        "E.NombreComun AS Especie, H.NombreHabitat AS Habitat " +
                        "FROM Animales A " +
                        "INNER JOIN Especies E ON A.EspecieID = E.EspecieID " +
                        "INNER JOIN Habitat H ON A.HabitatID = H.HabitatID " +
                        "WHERE A.AnimalID = ?";

    try (Connection con = Conexion.getConexion();
         PreparedStatement pstmt = con.prepareStatement(SQL_SELECT)) {

        pstmt.setInt(1, animalID);
        
        try (ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                datosAnimal = new Vector<>();
                // 1. Nombre
                datosAnimal.add(rs.getString("Nombre")); 
                // 2. Sexo
                datosAnimal.add(rs.getString("Sexo")); 
                // 3. Fecha Nacimiento (java.sql.Date)
                datosAnimal.add(rs.getDate("FechaNacimiento")); 
                // 4. Especie (Nombre)
                datosAnimal.add(rs.getString("Especie")); 
                // 5. Hábitat (Nombre)
                datosAnimal.add(rs.getString("Habitat"));
            }
        }
    } catch (SQLException e) {
        System.err.println("❌ Error al obtener animal por ID: " + e.getMessage());
        e.printStackTrace();
    }
    return datosAnimal;
}
}
