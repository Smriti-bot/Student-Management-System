package com.yourorg.sms.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {

    private static final String URL = "jdbc:mysql://localhost:3306/sms_db?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";  // update if different
    private static final String PASS = "root";  // update if different

    static {
        try {
            // correct driver class name
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            // log or rethrow as runtime if you want the app to fail fast
            e.printStackTrace();
        }
    }

    // Return SQLException so callers that already expect SQLException can reuse it
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
