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

@WebServlet("/client/delete-project")
public class DeleteProjectServlet extends HttpServlet {
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

        String idStr = request.getParameter("id");
        if (idStr != null) {
            try {
                int projectId = Integer.parseInt(idStr);
                boolean deleted = projectDAO.deleteProject(projectId, user.getId());
                if (deleted) {
                    response.sendRedirect(request.getContextPath() + "/client/dashboard?deleted=true");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/client/dashboard?error=delete_failed");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
}
