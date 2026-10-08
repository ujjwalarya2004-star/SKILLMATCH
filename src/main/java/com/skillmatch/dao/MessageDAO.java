package com.skillmatch.dao;

import com.skillmatch.model.Message;
import com.skillmatch.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MessageDAO {

    public boolean sendMessage(int projectId, int senderId, int receiverId, String text) throws SQLException {
        String sql = "INSERT INTO messages (project_id, sender_id, receiver_id, message_text) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, projectId);
            stmt.setInt(2, senderId);
            stmt.setInt(3, receiverId);
            stmt.setString(4, text);

            return stmt.executeUpdate() > 0;
        }
    }

    public List<Message> getMessagesByProject(int projectId) throws SQLException {
        List<Message> list = new ArrayList<>();
        String sql = "SELECT m.*, u_snd.name as sender_name, u_snd.role as sender_role, " +
                     "u_rcv.name as receiver_name, p.title as project_title " +
                     "FROM messages m " +
                     "JOIN users u_snd ON m.sender_id = u_snd.id " +
                     "JOIN users u_rcv ON m.receiver_id = u_rcv.id " +
                     "JOIN projects p ON m.project_id = p.id " +
                     "WHERE m.project_id = ? " +
                     "ORDER BY m.sent_at ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, projectId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Message m = new Message();
                    m.setId(rs.getInt("id"));
                    m.setProjectId(rs.getInt("project_id"));
                    m.setSenderId(rs.getInt("sender_id"));
                    m.setReceiverId(rs.getInt("receiver_id"));
                    m.setMessageText(rs.getString("message_text"));
                    m.setSentAt(rs.getTimestamp("sent_at"));
                    m.setRead(rs.getBoolean("is_read"));
                    m.setSenderName(rs.getString("sender_name"));
                    m.setSenderRole(rs.getString("sender_role"));
                    m.setReceiverName(rs.getString("receiver_name"));
                    m.setProjectTitle(rs.getString("project_title"));
                    list.add(m);
                }
            }
        }
        return list;
    }

    public boolean isUserParticipantInProject(int projectId, int userId) throws SQLException {
        // Participant is client of project OR freelancer with ACCEPTED application
        String sql = "SELECT 1 FROM projects WHERE id = ? AND client_id = ? " +
                     "UNION " +
                     "SELECT 1 FROM applications WHERE project_id = ? AND freelancer_id = ? AND status = 'ACCEPTED'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, projectId);
            stmt.setInt(2, userId);
            stmt.setInt(3, projectId);
            stmt.setInt(4, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public int getOtherParticipantId(int projectId, int currentUserId) throws SQLException {
        // If current user is client, get accepted freelancer
        // If current user is freelancer, get project client
        String sql = "SELECT client_id, " +
                     "(SELECT freelancer_id FROM applications WHERE project_id = ? AND status = 'ACCEPTED' LIMIT 1) as accepted_freelancer " +
                     "FROM projects WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, projectId);
            stmt.setInt(2, projectId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int clientId = rs.getInt("client_id");
                    int freelancerId = rs.getInt("accepted_freelancer");
                    if (currentUserId == clientId) {
                        return freelancerId;
                    } else {
                        return clientId;
                    }
                }
            }
        }
        return -1;
    }
}
