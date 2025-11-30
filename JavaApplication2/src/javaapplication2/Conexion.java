/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package javaapplication2;

/**
 *
 * @author bapna
 */
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    public static Connection getConexion() {

        System.out.println("Intentando conectar a la base de datos...");
        String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=Zoologico;encrypt=false;trustServerCertificate=true;";
        String USER = "sa";
        String PASS = "1423";
        Connection con = null; // Inicializamos la conexión a null

        try {
            // 1. Intentar obtener la conexión sin usar try-with-resources
            con = DriverManager.getConnection(DB_URL, USER, PASS);
            System.out.println("✅ ¡Conexión exitosa a SQL Server!");
            return con; // Devolvemos la conexión abierta
            
        } catch (SQLException e) {
            System.err.println("❌ Falló la conexión a SQL Server.");
            System.err.println("Código de Error: " + e.getErrorCode());
            System.err.println("Mensaje: " + e.getMessage());
            // Si falla la conexión, la variable 'con' seguirá siendo null o ya se manejará el error.
            return null;
        }
    }
}