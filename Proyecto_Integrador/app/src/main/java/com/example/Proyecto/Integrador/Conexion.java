/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.example.Proyecto.Integrador;

/**
 *
 * @author bapna
 */
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=Zoologico;encrypt=false;trustServerCertificate=true;";
    private static final String USER = "sa";
    private static final String PASS = "1423";

    public static void main(String[] args) {
        
        System.out.println("Intentando conectar a la base de datos...");

        // 1. Usar DriverManager para obtener la conexión
        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS)) {
            
            System.out.println("✅ ¡Conexión exitosa a SQL Server!");
            
            // 2. Aquí puedes ejecutar una consulta simple para verificar
            // Por ejemplo: conn.createStatement().execute("SELECT 1");

        } catch (SQLException e) {
            // Manejo de errores si la conexión falla (credenciales incorrectas, servidor apagado, etc.)
            System.err.println("❌ Falló la conexión a SQL Server.");
            System.err.println("Código de Error: " + e.getErrorCode());
            System.err.println("Mensaje: " + e.getMessage());
            // Opcional: e.printStackTrace();
        }
    }
}