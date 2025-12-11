package ZoologicoAppU6;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
    public static Connection getConexion() {
        System.out.print("Intentando conectar a la base de datos... ");
        String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=Zoologico;encrypt=false;trustServerCertificate=true;";
        String USER = "zoo";
        String PASS = "zoo";
        Connection con = null; // Inicializamos la conexión a null
        try {
            con = DriverManager.getConnection(DB_URL, USER, PASS);
            System.out.println("Conexion exitosa a SQL Server.");
            return con; // Devolvemos la conexión abierta
        } catch (SQLException e) {
            System.err.println("Fallo la conexion a SQL Server.");
            System.err.println("Codigo de Error: " + e.getErrorCode());
            System.err.println("Mensaje: " + e.getMessage());
            return null;
        }
    }
}
