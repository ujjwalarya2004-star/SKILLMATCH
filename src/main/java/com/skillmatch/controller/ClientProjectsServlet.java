package com.skillmatch.controller;

import com.skillmatch.dao.ProjectDAO;
import com.skillmatch.model.Project;
import com.skillmatch.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/client/projects")
public class ClientProjectsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ProjectDAO projectDAO = new ProjectDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!user.isClient()) {
            response.sendRedirect(request.getContextPath() + "/freelancer/dashboard");
            return;
        }

        try {
            int clientId = user.getId();
            List<Project> projects = projectDAO.getProjectsByClientId(clientId);
            request.setAttribute("projects", projects);
            request.getRequestDispatcher("/client/projects.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/client/dashboard?error=load_failed");
        }
    }
}
