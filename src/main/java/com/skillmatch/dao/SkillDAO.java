package com.skillmatch.dao;

import com.skillmatch.model.Skill;
import com.skillmatch.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SkillDAO {

    public List<Skill> getAllSkills() throws SQLException {
        List<Skill> list = new ArrayList<>();
        String sql = "SELECT * FROM skills ORDER BY skill_name ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                list.add(new Skill(rs.getInt("id"), rs.getString("skill_name")));
            }
        }
        return list;
    }

    public List<Skill> getSkillsByFreelancerId(int freelancerId) throws SQLException {
        List<Skill> list = new ArrayList<>();
        String sql = "SELECT s.id, s.skill_name " +
                     "FROM skills s " +
                     "JOIN freelancer_skills fs ON s.id = fs.skill_id " +
                     "WHERE fs.freelancer_id = ? " +
                     "ORDER BY s.skill_name ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, freelancerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(new Skill(rs.getInt("id"), rs.getString("skill_name")));
                }
            }
        }
        return list;
    }

    public boolean addSkillToFreelancer(int freelancerId, int skillId) throws SQLException {
        String sql = "INSERT IGNORE INTO freelancer_skills (freelancer_id, skill_id) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, freelancerId);
            stmt.setInt(2, skillId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean removeSkillFromFreelancer(int freelancerId, int skillId) throws SQLException {
        String sql = "DELETE FROM freelancer_skills WHERE freelancer_id = ? AND skill_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, freelancerId);
            stmt.setInt(2, skillId);
            return stmt.executeUpdate() > 0;
        }
    }

    public Skill getOrCreateSkill(String skillName) throws SQLException {
        if (skillName == null || skillName.trim().isEmpty()) {
            return null;
        }
        String cleanName = skillName.trim();
        String selectSql = "SELECT * FROM skills WHERE LOWER(skill_name) = LOWER(?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement selectStmt = conn.prepareStatement(selectSql)) {

            selectStmt.setString(1, cleanName);
            try (ResultSet rs = selectStmt.executeQuery()) {
                if (rs.next()) {
                    return new Skill(rs.getInt("id"), rs.getString("skill_name"));
                }
            }

            // Insert new skill
            String insertSql = "INSERT INTO skills (skill_name) VALUES (?)";
            try (PreparedStatement insertStmt = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                insertStmt.setString(1, cleanName);
                insertStmt.executeUpdate();
                try (ResultSet keys = insertStmt.getGeneratedKeys()) {
                    if (keys.next()) {
                        return new Skill(keys.getInt(1), cleanName);
                    }
                }
            }
        }
        return null;
    }
}
