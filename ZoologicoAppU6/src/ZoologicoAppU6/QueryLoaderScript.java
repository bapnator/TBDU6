package ZoologicoAppU6;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import javax.swing.table.DefaultTableModel;

public class QueryLoaderScript {
    public class ColumnInfo {
        private String displayName;
        private String columnName;
        private String referencedTable;
        private String referencedColumn;

        public ColumnInfo(String displayName, String columnName, String referencedTable, String referencedColumn) {
            this.displayName = displayName;
            this.columnName = columnName;
            this.referencedTable = referencedTable;
            this.referencedColumn = referencedColumn;
        }
        public ColumnInfo(String displayName, String columnName) {
            this.displayName = displayName;
            this.columnName = columnName;
            this.referencedTable = this.referencedColumn = null;
        }

        public String getDisplayName() { return displayName; }
        public String getColumnName() { return columnName; }
        public String getReferencedTable() { return referencedTable; }
        public String getReferencedColumn() { return referencedColumn; }
    }
    
    private Map<String, ColumnInfo[]> columnasPorTabla = Map.of(
        "Alimentos", new ColumnInfo[] {
            new ColumnInfo("ID Alimento", "idAlimento"),
            new ColumnInfo("Nombre Alimento", "NombreAlimento"),
            new ColumnInfo("Tipo de Alimento", "TipoAlimento"),
            new ColumnInfo("Cantidad Disponible", "Cantidad")
        },
        "Empleados", new ColumnInfo[] {
            new ColumnInfo("ID Empleado", "idEmpleado"),
            new ColumnInfo("Nombre del Empleado", "NombreEmpleado"),
            new ColumnInfo("Cargo", "CargoEmpleado"),
            new ColumnInfo("Salario", "Salario")
        },
        "Atenciones", new ColumnInfo[] {
            new ColumnInfo("ID Atención", "idAtencion"),
            new ColumnInfo("Animal", "idAnimal", "Animales", "NombreAnimal"),
            new ColumnInfo("Empleado", "idEmpleado", "Empleados", "NombreEmpleado"),
            new ColumnInfo("Fecha de Atención", "FechaAtencion"),
            new ColumnInfo("Diagnóstico", "Diagnostico"),
            new ColumnInfo("Costo", "Costo")
        },
        "Dietas", new ColumnInfo[] {
            new ColumnInfo("ID Dieta", "idDieta"),
            new ColumnInfo("Animal", "idAnimal", "Animales", "NombreAnimal"),
            new ColumnInfo("Alimento", "idAlimento", "Alimentos", "NombreAlimento"),
            new ColumnInfo("Cantidad Diaria", "CantidadDiaria")
        },
        "Animales", new ColumnInfo[] {
            new ColumnInfo("ID Animal", "idAnimal"),
            new ColumnInfo("Especie", "idEspecie", "Especies", "NombreEspecie"),
            new ColumnInfo("Nombre del Animal", "NombreAnimal"),
            new ColumnInfo("Sexo", "SexoAnimal"),
            new ColumnInfo("Fecha de Ingreso", "FechaIngreso"),
            new ColumnInfo("Fecha de Nacimiento", "FechaNacimiento"),
            new ColumnInfo("Hábitat", "idHabitat", "Habitat", "NombreHabitat")
        },
        "Habitat", new ColumnInfo[] {
            new ColumnInfo("ID Hábitat", "idHabitat"),
            new ColumnInfo("Nombre del Hábitat", "NombreHabitat")
        },
        "Especies", new ColumnInfo[] {
            new ColumnInfo("ID Especie", "idEspecie"),
            new ColumnInfo("Nombre de la Especie", "NombreEspecie"),
            new ColumnInfo("Tipo de Especie", "TipoEspecie")
        }
    );

    public class SQLQuery {
        private String queryText;
        private String[] columnNames;
        private String[] displayNames;
        
        public SQLQuery(String tableName) {
            ColumnInfo[] columns = columnasPorTabla.get(tableName);
            if(columns != null) {
                columnNames = new String[columns.length];
                displayNames = new String[columns.length];
                char tableTag = tableName.charAt(0);

                List<String> SQL_DATA = new ArrayList<>();
                List<String> SQL_REFERENCIA = new ArrayList<>();
                for (int i = 0; i < columns.length; i++) {
                    String columnRefTable = columns[i].getReferencedTable();
                    displayNames[i] = columns[i].getDisplayName();

                    if(columnRefTable == null) {
                        columnNames[i] = columns[i].getColumnName();
                        SQL_DATA.add(tableTag + "." + columnNames[i]);
                    } else {
                        columnNames[i] = columns[i].getReferencedColumn();
                        SQL_DATA.add(columnRefTable.charAt(0) + "."  + columnNames[i]);

                        String columnRef = columns[i].getColumnName();
                        SQL_REFERENCIA.add(
                            "INNER JOIN " +
                            columnRefTable + " " + columnRefTable.charAt(0) + " ON " +
                            columnRefTable.charAt(0) + "." + columnRef + " = " +
                            tableTag + "." + columnRef
                        );
                    }
                }
                queryText =
                    "SELECT " +
                    String.join(", ", SQL_DATA) +
                    " FROM " + tableName + " " + tableTag + " " +
                    String.join(" ", SQL_REFERENCIA);
            }
        }
        
        public String GetQueryText() { return queryText; }
        public String[] GetColumnNames() { return columnNames; }
        public String[] GetDisplayNames() { return displayNames; }
        
        public boolean isNull() { return queryText == null; }
    };
    
    public DefaultTableModel CargarModeloDinamico(String tableName) {
        SQLQuery SQL_CONSULTA = new SQLQuery(tableName);
        if (SQL_CONSULTA.isNull()) return null;
        
        DefaultTableModel model = new DefaultTableModel(SQL_CONSULTA.GetDisplayNames(), 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false; // all cells non-editable
            }
        };

        try (Connection con = Conexion.getConexion(); Statement stmt = con.createStatement(); ResultSet rs = stmt.executeQuery(SQL_CONSULTA.GetQueryText())) {
            while (rs.next()) {
                List<Object> rowData = new ArrayList<Object>();
                
                for (String columnName: SQL_CONSULTA.GetColumnNames())
                    rowData.add(rs.getObject(columnName));
                
                model.addRow(rowData.toArray());
            }
        } catch (SQLException e) {
            System.err.print("Error al cargar '" + tableName + "': ");
            e.printStackTrace();
        }
        
        return model;
    }
    
    public List<String> CargarSeleccionDinamica(String tableName, String columnName) {
        List<String> selectList = new ArrayList<>();
        String SQL_CONSULTA =
            "SELECT " + columnName +
            " FROM " + tableName +
            " ORDER BY " + columnName;

        try (Connection con = Conexion.getConexion(); Statement stmt = con.createStatement(); ResultSet rs = stmt.executeQuery(SQL_CONSULTA)) {
            while (rs.next())
                selectList.add(rs.getObject(columnName).toString());
        } catch (SQLException e) {
            // REEMPLAZO DEL LOGGER
            System.err.println("Error al cargar '" + tableName + "'.");
            e.printStackTrace();
        }
        
        return selectList;
    }

    public Object TableMatch(String tableName, String matchColumn, String matchValue, String returnColumn) {
        Object returnObject = null;
        String SQL_CONSULTA = "SELECT " + returnColumn + " FROM " + tableName + " WHERE " + matchColumn + " = " + matchValue;

        try (Connection con = Conexion.getConexion(); Statement stmt = con.createStatement(); ResultSet rs = stmt.executeQuery(SQL_CONSULTA)) {
            if (rs.next())
                returnObject = rs.getObject(returnColumn);
        } catch (SQLException e) {
            System.err.print("Error al obtener el " + returnColumn + " de " + tableName + ": " + e.getMessage());
            e.printStackTrace();
        }
        return returnObject;
    }

    public boolean InsertIntoTable(String tableName, List<Object> values) {
        // Detener la ejecucion si los valores estan vacios
        if (values == null || tableName.isBlank()) return false;
        
        // Detener la ejecucion si no se encuentra la tabla o si la cantidad de valores recibidos no coincide con la tabla
        ColumnInfo[] columns = columnasPorTabla.get(tableName);
        if (columns == null || (columns.length - 1) != values.size()) return false;
        
        // Definir la llamada al SP
        String SQL_CALL = "{CALL sp_Insertar" + tableName + "(" + String.join(", ", Collections.nCopies(values.size(), "?")) + ")}";
        
        try (Connection con = Conexion.getConexion(); CallableStatement cstmt = con.prepareCall(SQL_CALL)) {
            // Asignar parámetros al CallableStatement
            int counter = 1;
            for (Object value : values)
                cstmt.setObject(counter++, value.toString());
            
            // Ejecutar la consulta (el SP devuelve un ResultSet con el resultado)
            try (ResultSet rs = cstmt.executeQuery()) {
                if (rs.next()) {
                    String resultado = rs.getString("Resultado");
                    System.out.println("SP devolvió: " + resultado);
                    return resultado.contains("realizada"); // or any logic you prefer
                }
            }
        } catch (SQLException e) {
            System.err.print("Error de conexion al insertar en la tabla " + tableName + " con mensaje: ");
            e.printStackTrace();
        }
        return true;
    }
    
    public boolean DeleteFromTable(String tableName, int identifier) {
        // Detener la ejecucion si los valores estan vacios
        if (identifier <= 0) return false;
        // Detener la ejecucion si no se encuentra la tabla
        if (columnasPorTabla.get(tableName) == null) return false;
        
        // Definir la llamada al SP
        String SQL_CALL = "{CALL sp_Eliminar" + tableName + "(?)}";
        
        try (Connection con = Conexion.getConexion(); CallableStatement cstmt = con.prepareCall(SQL_CALL)) {
            // Asignar parametro de identificador al CallableStatement
            cstmt.setInt(1, identifier);
            
            // Ejecutar la consulta (el SP devuelve un ResultSet con el resultado)
            try (ResultSet rs = cstmt.executeQuery()) {
                if (rs.next()) {
                    String resultado = rs.getString("Resultado");
                    System.out.println("SP devolvió: " + resultado);
                    return resultado.contains("realizada"); // or any logic you prefer
                }
            }
        } catch (SQLException e) {
            System.err.print("Error de conexion al eliminar en la tabla " + tableName + " con mensaje: ");
            e.printStackTrace();
        }
        return true;
    }
    
    public boolean ModifyFromTable(String tableName, int identifier, List<Object> values) {
        // Detener la ejecucion si los valores estan vacios
        if (values == null || tableName.isBlank()) return false;
        
        // Detener la ejecucion si no se encuentra la tabla o si la cantidad de valores recibidos no coincide con la tabla
        ColumnInfo[] columns = columnasPorTabla.get(tableName);
        if (columns == null || (columns.length - 1) != values.size()) return false;

        // Sentencia SQL UPDATE
        String SQL_CALL = "{CALL sp_Modificar" + tableName + "(" + String.join(", ", Collections.nCopies(values.size() + 1, "?")) + ")}";
        
        try (Connection con = Conexion.getConexion(); CallableStatement cstmt = con.prepareCall(SQL_CALL)) {
            // Asignar parámetros al CallableStatement
            cstmt.setInt(1, identifier);
            
            int counter = 2;
            for(Object value : values)
                cstmt.setObject(counter++, value.toString());
            
            // Ejecutar la consulta (el SP devuelve un ResultSet con el resultado)
            try (ResultSet rs = cstmt.executeQuery()) {
                if (rs.next()) {
                    String resultado = rs.getString("Resultado");
                    System.out.println("SP devolvió: " + resultado);
                    return resultado.contains("realizada"); // or any logic you prefer
                }
            }
        } catch (SQLException e) {
            System.err.print("Error de conexion al insertar en la tabla " + tableName + " con mensaje: ");
            e.printStackTrace();
        }
        return true;
    }
    
    public List<Object> GetFromIdentifier(String tableName, int identifier) {
        List<Object> rowData = null;

        // Consulta SQL
        SQLQuery SQL_CONSULTA = new SQLQuery(tableName);
        String identifierColumn = columnasPorTabla.get(tableName)[0].getColumnName();
        String SQL_SELECT = SQL_CONSULTA.GetQueryText() + " WHERE " + tableName.charAt(0) + "." + identifierColumn + " = ?";

        try (
            Connection con = Conexion.getConexion();
            PreparedStatement pstmt = con.prepareStatement(SQL_SELECT)) {

            pstmt.setInt(1, identifier);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    rowData = new ArrayList<Object>();
                    for (String columnName: SQL_CONSULTA.GetColumnNames())
                        rowData.add(rs.getObject(columnName));
                }
            }
        } catch (SQLException e) {
            System.err.print("Error al obtener " + tableName + " por ID en DAO: ");
            e.printStackTrace();
        }
        return rowData;
    }
}
