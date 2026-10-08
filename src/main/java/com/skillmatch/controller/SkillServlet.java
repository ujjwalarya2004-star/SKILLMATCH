package com.skillmatch.controller;

import com.skillmatch.dao.SkillDAO;
import com.skillmatch.model.Skill;
import com.skillmatch.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/freelancer/skills")
public class SkillServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final SkillDAO skillDAO = new SkillDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!user.isFreelancer()) {
            response.sendRedirect(request.getContextPath() + "/client/dashboard");
            return;
        }

        try {
            int freelancerId = user.getId();
            List<Skill> allSkills = skillDAO.getAllSkills();
            List<Skill> mySkills = skillDAO.getSkillsByFreelancerId(freelancerId);

            request.setAttribute("allSkills", allSkills);
            request.setAttribute("mySkills", mySkills);
            request.getRequestDispatcher("/freelancer/skills.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading skills: " + e.getMessage());
            request.getRequestDispatcher("/freelancer/skills.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!user.isFreelancer()) {
            response.sendRedirect(request.getContextPath() + "/client/dashboard");
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("add".equalsIgnoreCase(action)) {
                String skillIdStr = request.getParameter("skillId");
                if (skillIdStr != null && !skillIdStr.trim().isEmpty()) {
                    int skillId = Integer.parseInt(skillIdStr);
                    skillDAO.addSkillToFreelancer(user.getId(), skillId);
                }
            } else if ("remove".equalsIgnoreCase(action)) {
                String skillIdStr = request.getParameter("skillId");
                if (skillIdStr != null && !skillIdStr.trim().isEmpty()) {
                    int skillId = Integer.parseInt(skillIdStr);
                    skillDAO.removeSkillFromFreelancer(user.getId(), skillId);
                }
            } else if ("create".equalsIgnoreCase(action)) {
                String newSkillName = request.getParameter("skillName");
                if (newSkillName != null && !newSkillName.trim().isEmpty()) {
                    Skill created = skillDAO.getOrCreateSkill(newSkillName.trim());
                    if (created != null) {
                        skillDAO.addSkillToFreelancer(user.getId(), created.getId());
                    }
                }
            }
            response.sendRedirect(request.getContextPath() + "/freelancer/skills?updated=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/freelancer/skills?error=failed");
        }
    }
}
