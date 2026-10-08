package com.skillmatch.dao;

import com.skillmatch.model.FreelancerProfile;
import com.skillmatch.model.Skill;
import com.skillmatch.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FreelancerProfileDAO {

    public FreelancerProfile getProfileByUserId(int userId) throws SQLException {
        String sql = "SELECT p.*, u.name, u.email " +
                     "FROM users u " +
                     "LEFT JOIN freelancer_profiles p ON u.id = p.user_id " +
                     "WHERE u.id = ? AND u.role = 'FREELANCER'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    FreelancerProfile profile = new FreelancerProfile();
                    profile.setId(rs.getInt("id"));
                    profile.setUserId(userId);
                    profile.setFreelancerName(rs.getString("name"));
                    profile.setFreelancerEmail(rs.getString("email"));
                    profile.setBio(rs.getString("bio") != null ? rs.getString("bio") : "");
                    profile.setExperience(rs.getString("experience") != null ? rs.getString("experience") : "");
                    profile.setPhone(rs.getString("phone") != null ? rs.getString("phone") : "");
                    profile.setLocation(rs.getString("location") != null ? rs.getString("location") : "");
                    profile.setPortfolioUrl(rs.getString("portfolio_url") != null ? rs.getString("portfolio_url") : "");
                    profile.setExpertise(rs.getString("expertise") != null ? rs.getString("expertise") : "");
                    profile.setPastProjects(rs.getString("past_projects") != null ? rs.getString("past_projects") : "");

                    profile.setSkills(getFreelancerSkills(conn, userId));
                    return profile;
                }
            }
        }
        return null;
    }

    public boolean updateProfile(FreelancerProfile profile) throws SQLException {
        // Check if record exists
        String checkSql = "SELECT id FROM freelancer_profiles WHERE user_id = ?";
        String updateSql = "UPDATE freelancer_profiles SET bio = ?, experience = ?, phone = ?, location = ?, portfolio_url = ?, expertise = ?, past_projects = ? WHERE user_id = ?";
        String insertSql = "INSERT INTO freelancer_profiles (bio, experience, phone, location, portfolio_url, expertise, past_projects, user_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection()) {
            boolean exists = false;
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setInt(1, profile.getUserId());
                try (ResultSet rs = checkStmt.executeQuery()) {
                    exists = rs.next();
                }
            }

            String execSql = exists ? updateSql : insertSql;
            try (PreparedStatement stmt = conn.prepareStatement(execSql)) {
                stmt.setString(1, profile.getBio());
                stmt.setString(2, profile.getExperience());
                stmt.setString(3, profile.getPhone());
                stmt.setString(4, profile.getLocation());
                stmt.setString(5, profile.getPortfolioUrl());
                stmt.setString(6, profile.getExpertise());
                stmt.setString(7, profile.getPastProjects());
                stmt.setInt(8, profile.getUserId());

                return stmt.executeUpdate() > 0;
            }
        }
    }

    private List<Skill> getFreelancerSkills(Connection conn, int userId) throws SQLException {
        List<Skill> skills = new ArrayList<>();
        String sql = "SELECT s.id, s.skill_name " +
                     "FROM skills s " +
                     "INNER JOIN freelancer_skills fs ON s.id = fs.skill_id " +
                     "WHERE fs.freelancer_id = ? " +
                     "ORDER BY s.skill_name ASC";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    skills.add(new Skill(rs.getInt("id"), rs.getString("skill_name")));
                }
            }
        }
        return skills;
    }
}
