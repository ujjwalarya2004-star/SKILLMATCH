package com.skillmatch.controller;

import com.skillmatch.dao.ApplicationDAO;
import com.skillmatch.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/client/update-application")
public class UpdateApplicationStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ApplicationDAO applicationDAO = new ApplicationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!user.isClient()) {
            response.sendRedirect(request.getContextPath() + "/freelancer/dashboard");
            return;
        }

        String applicationIdStr = request.getParameter("applicationId");
        String projectIdStr = request.getParameter("projectId");
        String action = request.getParameter("action"); // "ACCEPT" or "REJECT"

        if (applicationIdStr == null || projectIdStr == null || action == null) {
            response.sendRedirect(request.getContextPath() + "/client/dashboard?error=invalid_request");
            return;
        }

        try {
            int applicationId = Integer.parseInt(applicationIdStr.trim());
            int projectId = Integer.parseInt(projectIdStr.trim());
            int clientId = user.getId();

            boolean success = false;
            if ("ACCEPT".equalsIgnoreCase(action)) {
                success = applicationDAO.acceptApplication(applicationId, projectId, clientId);
            } else if ("REJECT".equalsIgnoreCase(action)) {
                success = applicationDAO.rejectApplication(applicationId, projectId, clientId);
            }

            if (success) {
                response.sendRedirect(request.getContextPath() + "/client/applications?projectId=" + projectId + "&statusUpdated=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/client/applications?projectId=" + projectId + "&error=unauthorized_or_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/client/dashboard?error=server_error");
        }
    }
}
