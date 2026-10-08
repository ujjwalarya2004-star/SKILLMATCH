package com.skillmatch.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Centralized Database Connection Utility for JDBC.
 * Reads connection settings from System properties or defaults to localhost MySQL.
 */
public class DBConnection {

    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/skillmatch_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASSWORD = "root";

    private static String dbUrl = DEFAULT_URL;
    private static String dbUser = DEFAULT_USER;
    private static String dbPassword = DEFAULT_PASSWORD;

    static {
        try {
            // Load MySQL Connector/J driver class
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("[DBConnection] MySQL JDBC Driver not found: " + e.getMessage());
        }

        // 1) Optional classpath file: src/main/resources/db.properties
        try (InputStream in = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (in != null) {
                Properties props = new Properties();
                props.load(in);
                configure(props.getProperty("db.url"), props.getProperty("db.user"), props.getProperty("db.password"));
            }
        } catch (Exception e) {
            System.err.println("[DBConnection] Could not read db.properties: " + e.getMessage());
        }

        // 2) Environment variables override everything (used by Docker / cloud)
        String envUrl = System.getenv("DB_URL");
        if (envUrl != null && !envUrl.trim().isEmpty()) {
            dbUrl = envUrl.trim();
        }
        String envUser = System.getenv("DB_USER");
        if (envUser != null && !envUser.trim().isEmpty()) {
            dbUser = envUser.trim();
        }
        String envPass = System.getenv("DB_PASSWORD");
        if (envPass != null) {
            dbPassword = envPass;
        }
    }

    public static void configure(String url, String user, String password) {
        if (url != null && !url.trim().isEmpty()) dbUrl = url.trim();
        if (user != null && !user.trim().isEmpty()) dbUser = user.trim();
        if (password != null) dbPassword = password;
    }

    /**
     * Obtains a new database connection.
     * @return Connection instance
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(dbUrl, dbUser, dbPassword);
    }

    /**
     * Safely closes an AutoCloseable resource (Connection, Statement, ResultSet).
     */
    public static void close(AutoCloseable resource) {
        if (resource != null) {
            try {
                resource.close();
            } catch (Exception e) {
                // Suppressed
            }
        }
    }
}
