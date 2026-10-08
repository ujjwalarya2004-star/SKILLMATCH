package com.skillmatch.controller;

import com.skillmatch.dao.ApplicationDAO;
import com.skillmatch.dao.FreelancerProfileDAO;
import com.skillmatch.model.Application;
import com.skillmatch.model.FreelancerProfile;
import com.skillmatch.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/freelancer/dashboard")
public class FreelancerDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ApplicationDAO applicationDAO = new ApplicationDAO();
    private final FreelancerProfileDAO profileDAO = new FreelancerProfileDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!user.isFreelancer()) {
            response.sendRedirect(request.getContextPath() + "/client/dashboard");
            return;
        }

        try {
            int freelancerId = user.getId();
            Map<String, Integer> stats = applicationDAO.getFreelancerStatistics(freelancerId);
            List<Application> recentApps = applicationDAO.getApplicationsByFreelancerId(freelancerId);
            FreelancerProfile profile = profileDAO.getProfileByUserId(freelancerId);

            request.setAttribute("stats", stats);
            request.setAttribute("recentApplications", recentApps);
            request.setAttribute("profile", profile);
            request.getRequestDispatcher("/freelancer/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading freelancer dashboard: " + e.getMessage());
            request.getRequestDispatcher("/freelancer/dashboard.jsp").forward(request, response);
        }
    }
}
