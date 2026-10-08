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
import java.math.BigDecimal;
import java.sql.Date;

@WebServlet("/client/edit-project")
public class EditProjectServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ProjectDAO projectDAO = new ProjectDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
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
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/client/dashboard");
            return;
        }

        try {
            int projectId = Integer.parseInt(idStr);
            Project project = projectDAO.getProjectById(projectId);

            if (project == null || project.getClientId() != user.getId()) {
                response.sendRedirect(request.getContextPath() + "/client/dashboard?error=unauthorized");
                return;
            }

            request.setAttribute("project", project);
            request.getRequestDispatcher("/client/edit-project.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/client/dashboard?error=invalid_id");
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
        if (!user.isClient()) {
            response.sendRedirect(request.getContextPath() + "/freelancer/dashboard");
            return;
        }

        String idStr = request.getParameter("id");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String budgetStr = request.getParameter("budget");
        String deadlineStr = request.getParameter("deadline");
        String status = request.getParameter("status");

        try {
            int projectId = Integer.parseInt(idStr);
            Project existing = projectDAO.getProjectById(projectId);
            if (existing == null || existing.getClientId() != user.getId()) {
                response.sendRedirect(request.getContextPath() + "/client/dashboard?error=unauthorized");
                return;
            }

            BigDecimal budget = new BigDecimal(budgetStr.trim());
            Date deadline = Date.valueOf(deadlineStr.trim());

            Project project = new Project();
            project.setId(projectId);
            project.setClientId(user.getId());
            project.setTitle(title.trim());
            project.setDescription(description.trim());
            project.setBudget(budget);
            project.setDeadline(deadline);
            project.setStatus(status != null ? status : existing.getStatus());

            boolean updated = projectDAO.updateProject(project);
            if (updated) {
                response.sendRedirect(request.getContextPath() + "/client/dashboard?updated=true");
            } else {
                request.setAttribute("errorMessage", "Failed to update project.");
                doGet(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error updating project: " + e.getMessage());
            doGet(request, response);
        }
    }
}
