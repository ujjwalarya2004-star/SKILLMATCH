package com.skillmatch.controller;

import com.skillmatch.dao.ApplicationDAO;
import com.skillmatch.model.Application;
import com.skillmatch.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/freelancer/applications", "/freelancer/my-applications"})
public class FreelancerApplicationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ApplicationDAO applicationDAO = new ApplicationDAO();

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
            List<Application> myApps = applicationDAO.getApplicationsByFreelancerId(user.getId());
            request.setAttribute("applications", myApps);
            request.getRequestDispatcher("/freelancer/applications.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/freelancer/dashboard?error=load_failed");
        }
    }
}
