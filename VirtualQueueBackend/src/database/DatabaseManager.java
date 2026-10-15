package database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class DatabaseManager {

    private static final String URL =
            "jdbc:mysql://localhost:3306/virtual_queue";

    private static final String USER = "root";

    private static final String PASSWORD = "root@123";

    public static Connection getConnection() {

        try {
            Connection connection =
                    DriverManager.getConnection(URL, USER, PASSWORD);

            return connection;

        } catch (SQLException e) {

            System.out.println("Database connection failed!");
            e.printStackTrace();

            return null;
        }
    }

    public static void saveUser(int tokenNumber, String userName, String status) {

        String sql =
                "INSERT INTO queue_users (token_number, user_name, status) VALUES (?, ?, ?)";

        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, tokenNumber);
            statement.setString(2, userName);
            statement.setString(3, status);

            statement.executeUpdate();

            System.out.println("User saved to database!");

        } catch (SQLException e) {

            System.out.println("Failed to save user!");
            e.printStackTrace();
        }
    }

    public static void updateStatus(int tokenNumber, String status) {

    String sql =
            "UPDATE queue_users SET status = ? WHERE token_number = ?";

    try (Connection connection = getConnection();
         PreparedStatement statement = connection.prepareStatement(sql)) {

        statement.setString(1, status);
        statement.setInt(2, tokenNumber);

        statement.executeUpdate();

        System.out.println(
            "Database updated: Token " + tokenNumber
            + " → " + status
        );

    } catch (SQLException e) {

        System.out.println("Failed to update status!");
        e.printStackTrace();
    }
}

public static int getNextToken() {

    String sql =
            "SELECT COALESCE(MAX(token_number), 100) + 1 AS next_token FROM queue_users";

    try (Connection connection = getConnection();
         PreparedStatement statement = connection.prepareStatement(sql);
         var result = statement.executeQuery()) {

        if (result.next()) {
            return result.getInt("next_token");
        }

    } catch (SQLException e) {

        System.out.println("Failed to get next token!");
        e.printStackTrace();
    }

    return 101;
}
}