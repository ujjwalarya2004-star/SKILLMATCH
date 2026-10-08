package com.skillmatch.dao;

import com.skillmatch.model.Application;
import com.skillmatch.model.Skill;
import com.skillmatch.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.*;

public class ApplicationDAO {

    public boolean apply(int projectId, int freelancerId, String proposal, BigDecimal proposedBudget) throws SQLException {
        String sql = "INSERT INTO applications (project_id, freelancer_id, proposal, proposed_budget, status) " +
                     "VALUES (?, ?, ?, ?, 'PENDING')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, projectId);
            stmt.setInt(2, freelancerId);
            stmt.setString(3, proposal);
            stmt.setBigDecimal(4, proposedBudget);

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean hasApplied(int projectId, int freelancerId) throws SQLException {
        String sql = "SELECT id FROM applications WHERE project_id = ? AND freelancer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, projectId);
            stmt.setInt(2, freelancerId);

            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public List<Application> getApplicationsByProjectId(int projectId) throws SQLException {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.*, u.name as freelancer_name, u.email as freelancer_email, " +
                     "fp.experience as freelancer_exp, fp.portfolio_url as freelancer_portfolio, " +
                     "p.title as project_title, p.budget as project_budget, p.status as project_status " +
                     "FROM applications a " +
                     "JOIN users u ON a.freelancer_id = u.id " +
                     "LEFT JOIN freelancer_profiles fp ON u.id = fp.user_id " +
                     "JOIN projects p ON a.project_id = p.id " +
                     "WHERE a.project_id = ? " +
                     "ORDER BY a.applied_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, projectId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Application app = mapResultSetToApplication(rs);
                    app.setFreelancerSkills(getFreelancerSkills(conn, app.getFreelancerId()));
                    list.add(app);
                }
            }
        }
        return list;
    }

    public List<Application> getApplicationsByFreelancerId(int freelancerId) throws SQLException {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.*, u.name as freelancer_name, u.email as freelancer_email, " +
                     "fp.experience as freelancer_exp, fp.portfolio_url as freelancer_portfolio, " +
                     "p.title as project_title, p.budget as project_budget, p.status as project_status " +
                     "FROM applications a " +
                     "JOIN users u ON a.freelancer_id = u.id " +
                     "LEFT JOIN freelancer_profiles fp ON u.id = fp.user_id " +
                     "JOIN projects p ON a.project_id = p.id " +
                     "WHERE a.freelancer_id = ? " +
                     "ORDER BY a.applied_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, freelancerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToApplication(rs));
                }
            }
        }
        return list;
    }

    /**
     * Atomically accepts an application:
     * 1. Confirms the client owns the project
     * 2. Sets chosen application to 'ACCEPTED'
     * 3. Sets other applications for this project to 'REJECTED'
     * 4. Updates project status to 'IN_PROGRESS'
     */
    public boolean acceptApplication(int applicationId, int projectId, int clientId) throws SQLException {
        String verifySql = "SELECT id FROM projects WHERE id = ? AND client_id = ?";
        String acceptSql = "UPDATE applications SET status = 'ACCEPTED' WHERE id = ? AND project_id = ?";
        String rejectOthersSql = "UPDATE applications SET status = 'REJECTED' WHERE project_id = ? AND id != ?";
        String updateProjectSql = "UPDATE projects SET status = 'IN_PROGRESS' WHERE id = ?";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Verify project ownership
            try (PreparedStatement vStmt = conn.prepareStatement(verifySql)) {
                vStmt.setInt(1, projectId);
                vStmt.setInt(2, clientId);
                try (ResultSet rs = vStmt.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return false;
                    }
                }
            }

            // 2. Accept target application
            try (PreparedStatement aStmt = conn.prepareStatement(acceptSql)) {
                aStmt.setInt(1, applicationId);
                aStmt.setInt(2, projectId);
                int updated = aStmt.executeUpdate();
                if (updated == 0) {
                    conn.rollback();
                    return false;
                }
            }

            // 3. Reject other applications
            try (PreparedStatement rStmt = conn.prepareStatement(rejectOthersSql)) {
                rStmt.setInt(1, projectId);
                rStmt.setInt(2, applicationId);
                rStmt.executeUpdate();
            }

            // 4. Update project status to IN_PROGRESS
            try (PreparedStatement pStmt = conn.prepareStatement(updateProjectSql)) {
                pStmt.setInt(1, projectId);
                pStmt.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    public boolean rejectApplication(int applicationId, int projectId, int clientId) throws SQLException {
        String verifySql = "SELECT id FROM projects WHERE id = ? AND client_id = ?";
        String rejectSql = "UPDATE applications SET status = 'REJECTED' WHERE id = ? AND project_id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement vStmt = conn.prepareStatement(verifySql)) {
                vStmt.setInt(1, projectId);
                vStmt.setInt(2, clientId);
                try (ResultSet rs = vStmt.executeQuery()) {
                    if (!rs.next()) return false;
                }
            }

            try (PreparedStatement rStmt = conn.prepareStatement(rejectSql)) {
                rStmt.setInt(1, applicationId);
                rStmt.setInt(2, projectId);
                return rStmt.executeUpdate() > 0;
            }
        }
    }

    public Map<String, Integer> getFreelancerStatistics(int freelancerId) throws SQLException {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("total", 0);
        stats.put("pending", 0);
        stats.put("accepted", 0);
        stats.put("rejected", 0);
        stats.put("activeProjects", 0);

        String sql = "SELECT " +
                     "COUNT(*) as total, " +
                     "SUM(CASE WHEN a.status = 'PENDING' THEN 1 ELSE 0 END) as pending_cnt, " +
                     "SUM(CASE WHEN a.status = 'ACCEPTED' THEN 1 ELSE 0 END) as accepted_cnt, " +
                     "SUM(CASE WHEN a.status = 'REJECTED' THEN 1 ELSE 0 END) as rejected_cnt, " +
                     "SUM(CASE WHEN a.status = 'ACCEPTED' AND p.status = 'IN_PROGRESS' THEN 1 ELSE 0 END) as active_cnt " +
                     "FROM applications a " +
                     "JOIN projects p ON a.project_id = p.id " +
                     "WHERE a.freelancer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, freelancerId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("total", rs.getInt("total"));
                    stats.put("pending", rs.getInt("pending_cnt"));
                    stats.put("accepted", rs.getInt("accepted_cnt"));
                    stats.put("rejected", rs.getInt("rejected_cnt"));
                    stats.put("activeProjects", rs.getInt("active_cnt"));
                }
            }
        }
        return stats;
    }

    private List<Skill> getFreelancerSkills(Connection conn, int freelancerId) throws SQLException {
        List<Skill> list = new ArrayList<>();
        String sql = "SELECT s.id, s.skill_name " +
                     "FROM skills s " +
                     "JOIN freelancer_skills fs ON s.id = fs.skill_id " +
                     "WHERE fs.freelancer_id = ? " +
                     "ORDER BY s.skill_name ASC";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, freelancerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(new Skill(rs.getInt("id"), rs.getString("skill_name")));
                }
            }
        }
        return list;
    }

    private Application mapResultSetToApplication(ResultSet rs) throws SQLException {
        Application a = new Application();
        a.setId(rs.getInt("id"));
        a.setProjectId(rs.getInt("project_id"));
        a.setFreelancerId(rs.getInt("freelancer_id"));
        a.setProposal(rs.getString("proposal"));
        a.setProposedBudget(rs.getBigDecimal("proposed_budget"));
        a.setStatus(rs.getString("status"));
        a.setAppliedAt(rs.getTimestamp("applied_at"));
        a.setFreelancerName(rs.getString("freelancer_name"));
        a.setFreelancerEmail(rs.getString("freelancer_email"));
        a.setFreelancerExperience(rs.getString("freelancer_exp"));
        a.setFreelancerPortfolioUrl(rs.getString("freelancer_portfolio"));
        a.setProjectTitle(rs.getString("project_title"));
        a.setProjectBudget(rs.getBigDecimal("project_budget"));
        a.setProjectStatus(rs.getString("project_status"));
        return a;
    }
}
