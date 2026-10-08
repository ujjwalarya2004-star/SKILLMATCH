package com.skillmatch.controller;

import com.skillmatch.dao.FreelancerProfileDAO;
import com.skillmatch.model.FreelancerProfile;
import com.skillmatch.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/freelancer/profile")
public class FreelancerProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final FreelancerProfileDAO profileDAO = new FreelancerProfileDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String targetUserIdParam = request.getParameter("userId");

        try {
            int targetUserId;
            boolean isOwner = false;

            if (targetUserIdParam != null) {
                targetUserId = Integer.parseInt(targetUserIdParam);
                if (session != null && session.getAttribute("user") != null) {
                    User currentUser = (User) session.getAttribute("user");
                    isOwner = (currentUser.getId() == targetUserId);
                }
            } else {
                if (session == null || session.getAttribute("user") == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }
                User currentUser = (User) session.getAttribute("user");
                if (!currentUser.isFreelancer()) {
                    response.sendRedirect(request.getContextPath() + "/client/dashboard");
                    return;
                }
                targetUserId = currentUser.getId();
                isOwner = true;
            }

            FreelancerProfile profile = profileDAO.getProfileByUserId(targetUserId);
            if (profile == null) {
                request.setAttribute("errorMessage", "Freelancer profile not found.");
            } else {
                request.setAttribute("profile", profile);
                request.setAttribute("isOwner", isOwner);
            }
            request.getRequestDispatcher("/freelancer/profile.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/index.jsp");
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

        String bio = request.getParameter("bio");
        String experience = request.getParameter("experience");
        String phone = request.getParameter("phone");
        String location = request.getParameter("location");
        String portfolioUrl = request.getParameter("portfolioUrl");
        String expertise = request.getParameter("expertise");
        String pastProjects = request.getParameter("pastProjects");

        try {
            FreelancerProfile profile = new FreelancerProfile();
            profile.setUserId(user.getId());
            profile.setBio(bio != null ? bio.trim() : "");
            profile.setExperience(experience != null ? experience.trim() : "");
            profile.setPhone(phone != null ? phone.trim() : "");
            profile.setLocation(location != null ? location.trim() : "");
            profile.setPortfolioUrl(portfolioUrl != null ? portfolioUrl.trim() : "");
            profile.setExpertise(expertise != null ? expertise.trim() : "");
            profile.setPastProjects(pastProjects != null ? pastProjects.trim() : "");

            boolean updated = profileDAO.updateProfile(profile);
            if (updated) {
                response.sendRedirect(request.getContextPath() + "/freelancer/profile?updated=true");
            } else {
                request.setAttribute("errorMessage", "Could not save profile changes.");
                doGet(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error saving profile: " + e.getMessage());
            doGet(request, response);
        }
    }
}
