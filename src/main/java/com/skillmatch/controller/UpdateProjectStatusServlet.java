package com.skillmatch.controller;

import com.skillmatch.dao.ProjectDAO;
import com.skillmatch.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/client/update-project-status")
public class UpdateProjectStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ProjectDAO projectDAO = new ProjectDAO();

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

        String projectIdStr = request.getParameter("projectId");
        String status = request.getParameter("status");

        if (projectIdStr != null && status != null) {
            try {
                int projectId = Integer.parseInt(projectIdStr.trim());
                String upperStatus = status.trim().toUpperCase();
                if (upperStatus.equals("OPEN") || upperStatus.equals("IN_PROGRESS") ||
                    upperStatus.equals("COMPLETED") || upperStatus.equals("CANCELLED")) {
                    
                    projectDAO.updateStatus(projectId, user.getId(), upperStatus);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/client/dashboard?statusUpdated=true");
    }
}
