package com.skillmatch.dao;

import com.skillmatch.model.Project;
import com.skillmatch.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.*;

public class ProjectDAO {

    public int createProject(Project project) throws SQLException {
        String sql = "INSERT INTO projects (client_id, title, description, budget, deadline, status) " +
                     "VALUES (?, ?, ?, ?, ?, 'OPEN')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, project.getClientId());
            stmt.setString(2, project.getTitle());
            stmt.setString(3, project.getDescription());
            stmt.setBigDecimal(4, project.getBudget());
            stmt.setDate(5, project.getDeadline());

            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }

    public boolean updateProject(Project project) throws SQLException {
        String sql = "UPDATE projects SET title = ?, description = ?, budget = ?, deadline = ?, status = ? " +
                     "WHERE id = ? AND client_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, project.getTitle());
            stmt.setString(2, project.getDescription());
            stmt.setBigDecimal(3, project.getBudget());
            stmt.setDate(4, project.getDeadline());
            stmt.setString(5, project.getStatus());
            stmt.setInt(6, project.getId());
            stmt.setInt(7, project.getClientId());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteProject(int projectId, int clientId) throws SQLException {
        String sql = "DELETE FROM projects WHERE id = ? AND client_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, projectId);
            stmt.setInt(2, clientId);
            return stmt.executeUpdate() > 0;
        }
    }

    public Project getProjectById(int projectId) throws SQLException {
        String sql = "SELECT p.*, u.name as client_name, u.email as client_email, " +
                     "(SELECT COUNT(*) FROM applications WHERE project_id = p.id) as app_count, " +
                     "(SELECT a.freelancer_id FROM applications a WHERE a.project_id = p.id AND a.status = 'ACCEPTED' LIMIT 1) as accepted_f_id, " +
                     "(SELECT u2.name FROM applications a JOIN users u2 ON a.freelancer_id = u2.id WHERE a.project_id = p.id AND a.status = 'ACCEPTED' LIMIT 1) as accepted_f_name " +
                     "FROM projects p " +
                     "JOIN users u ON p.client_id = u.id " +
                     "WHERE p.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, projectId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToProject(rs);
                }
            }
        }
        return null;
    }

    public List<Project> getProjectsByClientId(int clientId) throws SQLException {
        List<Project> list = new ArrayList<>();
        String sql = "SELECT p.*, u.name as client_name, u.email as client_email, " +
                     "(SELECT COUNT(*) FROM applications WHERE project_id = p.id) as app_count, " +
                     "(SELECT a.freelancer_id FROM applications a WHERE a.project_id = p.id AND a.status = 'ACCEPTED' LIMIT 1) as accepted_f_id, " +
                     "(SELECT u2.name FROM applications a JOIN users u2 ON a.freelancer_id = u2.id WHERE a.project_id = p.id AND a.status = 'ACCEPTED' LIMIT 1) as accepted_f_name " +
                     "FROM projects p " +
                     "JOIN users u ON p.client_id = u.id " +
                     "WHERE p.client_id = ? " +
                     "ORDER BY p.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, clientId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToProject(rs));
                }
            }
        }
        return list;
    }

    public List<Project> getOpenProjects() throws SQLException {
        List<Project> list = new ArrayList<>();
        String sql = "SELECT p.*, u.name as client_name, u.email as client_email, " +
                     "(SELECT COUNT(*) FROM applications WHERE project_id = p.id) as app_count, " +
                     "NULL as accepted_f_id, NULL as accepted_f_name " +
                     "FROM projects p " +
                     "JOIN users u ON p.client_id = u.id " +
                     "WHERE p.status = 'OPEN' " +
                     "ORDER BY p.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToProject(rs));
            }
        }
        return list;
    }

    public boolean updateStatus(int projectId, int clientId, String status) throws SQLException {
        String sql = "UPDATE projects SET status = ? WHERE id = ? AND client_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, projectId);
            stmt.setInt(3, clientId);
            return stmt.executeUpdate() > 0;
        }
    }

    public Map<String, Integer> getClientStatistics(int clientId) throws SQLException {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("total", 0);
        stats.put("open", 0);
        stats.put("inProgress", 0);
        stats.put("completed", 0);

        String sql = "SELECT " +
                     "COUNT(*) as total, " +
                     "SUM(CASE WHEN status = 'OPEN' THEN 1 ELSE 0 END) as open_cnt, " +
                     "SUM(CASE WHEN status = 'IN_PROGRESS' THEN 1 ELSE 0 END) as in_progress_cnt, " +
                     "SUM(CASE WHEN status = 'COMPLETED' THEN 1 ELSE 0 END) as completed_cnt " +
                     "FROM projects WHERE client_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, clientId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("total", rs.getInt("total"));
                    stats.put("open", rs.getInt("open_cnt"));
                    stats.put("inProgress", rs.getInt("in_progress_cnt"));
                    stats.put("completed", rs.getInt("completed_cnt"));
                }
            }
        }
        return stats;
    }

    private Project mapResultSetToProject(ResultSet rs) throws SQLException {
        Project p = new Project();
        p.setId(rs.getInt("id"));
        p.setClientId(rs.getInt("client_id"));
        p.setTitle(rs.getString("title"));
        p.setDescription(rs.getString("description"));
        p.setBudget(rs.getBigDecimal("budget"));
        p.setDeadline(rs.getDate("deadline"));
        p.setStatus(rs.getString("status"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        p.setClientName(rs.getString("client_name"));
        p.setClientEmail(rs.getString("client_email"));
        p.setApplicationCount(rs.getInt("app_count"));
        p.setAcceptedFreelancerId(rs.getInt("accepted_f_id"));
        p.setAcceptedFreelancerName(rs.getString("accepted_f_name"));
        return p;
    }
}
