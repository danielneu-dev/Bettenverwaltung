import java.sql.*;
import java.io.PrintWriter;
import java.io.IOException;

public class DBZugriff {
    Connection connection;
    String url = "jdbc:mysql://localhost:3306/bettenverwaltung?verifyServerCertificate=false&useSSL=true";
    public DBZugriff() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(url,"mitarbeiter","password");
            fillTest(10,9,Date.valueOf("2024-01-15"));
            showData();
        } catch (SQLException e) {
            System.out.println("*** SQLException:\n" + e);
            e.printStackTrace();
        } catch (IOException e) {
            System.out.println("*** IOException:\n" + e);
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("*** Exception:\n" + e);
            e.printStackTrace();
        }
    }

    public void fillTest(int p_personID, int p_bettID, Date p_datum) throws SQLException {
        CallableStatement callableStatement = connection.prepareCall("{CALL InsertData(?,?,?)}");
        callableStatement.setInt(1, p_personID);
        callableStatement.setInt(2, p_bettID);
        callableStatement.setDate(3, p_datum);
        int anzahl = callableStatement.executeUpdate();
        callableStatement.close();
    }

    public void showData() throws SQLException, IOException {
        String sqlCommand = "SELECT * from `Bett-Historie`";
        Statement statement = connection.createStatement();
        ResultSet resultSet = statement.executeQuery(sqlCommand);
        StringBuilder stringBuilder = new StringBuilder();

        while (resultSet.next()) {
            String bettID = Integer.toString(resultSet.getInt(1));
            String vorname = resultSet.getString(2);
            String nachname = resultSet.getString(3);
            String bezeichnung = resultSet.getString(4);
            Date datum = resultSet.getDate(5);
            stringBuilder.append(bettID + "," + vorname + "," + nachname + "," + bezeichnung + "," + datum + "\n");
        }
        writeFile(stringBuilder, "Bett-Historie.txt");
    }

    public void writeFile(StringBuilder list, String file) {
        try (PrintWriter printWriter = new PrintWriter(file)) {
            printWriter.println(list);
        } catch (IOException e) {
            System.out.println("*** IOException:\n" + e);
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        DBZugriff zugriff = new DBZugriff();
    }
}