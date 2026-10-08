package com.skillmatch.controller;

import com.skillmatch.dao.ApplicationDAO;
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

@WebServlet(urlPatterns = {"/project-details", "/freelancer/project-details", "/client/project-details"})
public class ProjectDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ProjectDAO projectDAO = new ProjectDAO();
    private final ApplicationDAO applicationDAO = new ApplicationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/projects");
            return;
        }

        try {
            int projectId = Integer.parseInt(idParam.trim());
            Project project = projectDAO.getProjectById(projectId);

            if (project == null) {
                response.sendRedirect(request.getContextPath() + "/projects?error=not_found");
                return;
            }

            boolean alreadyApplied = false;
            HttpSession session = request.getSession(false);
            User currentUser = null;
            if (session != null && session.getAttribute("user") != null) {
                currentUser = (User) session.getAttribute("user");
                if (currentUser.isFreelancer()) {
                    alreadyApplied = applicationDAO.hasApplied(projectId, currentUser.getId());
                }
            }

            request.setAttribute("project", project);
            request.setAttribute("alreadyApplied", alreadyApplied);

            if (currentUser != null && currentUser.isClient() && project.getClientId() == currentUser.getId()) {
                request.getRequestDispatcher("/client/project-details.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/freelancer/project-details.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/projects?error=invalid_id");
        }
    }
}
