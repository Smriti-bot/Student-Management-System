package com.yourorg.sms;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class JdbcTest {
    public static void main(String[] args) throws Exception {
        String url = "jdbc:mysql://localhost:3306/sms_db?useSSL=false&serverTimezone=UTC";
        String user = "root";
        String pass = "root";

        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection c = DriverManager.getConnection(url, user, pass);
             Statement s = c.createStatement();
             ResultSet rs = s.executeQuery("SELECT COUNT(*) FROM students")) {

            if (rs.next())
                System.out.println("Count = " + rs.getInt(1));
        }
    }
}
