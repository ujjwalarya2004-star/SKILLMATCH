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
import java.math.BigDecimal;

@WebServlet("/freelancer/apply")
public class ApplyProjectServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ApplicationDAO applicationDAO = new ApplicationDAO();
    private final ProjectDAO projectDAO = new ProjectDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=login_required");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!user.isFreelancer()) {
            response.sendRedirect(request.getContextPath() + "/client/dashboard");
            return;
        }

        String projectIdStr = request.getParameter("projectId");
        String proposal = request.getParameter("proposal");
        String proposedBudgetStr = request.getParameter("proposedBudget");

        if (projectIdStr == null || proposal == null || proposedBudgetStr == null ||
            proposal.trim().isEmpty() || proposedBudgetStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/projects?id=" + projectIdStr + "&error=missing_fields");
            return;
        }

        try {
            int projectId = Integer.parseInt(projectIdStr.trim());
            Project project = projectDAO.getProjectById(projectId);

            if (project == null || !"OPEN".equalsIgnoreCase(project.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/projects?id=" + projectId + "&error=project_closed");
                return;
            }

            if (applicationDAO.hasApplied(projectId, user.getId())) {
                response.sendRedirect(request.getContextPath() + "/projects?id=" + projectId + "&error=already_applied");
                return;
            }

            BigDecimal proposedBudget = new BigDecimal(proposedBudgetStr.trim());
            if (proposedBudget.compareTo(BigDecimal.ZERO) <= 0) {
                response.sendRedirect(request.getContextPath() + "/projects?id=" + projectId + "&error=invalid_budget");
                return;
            }

            boolean applied = applicationDAO.apply(projectId, user.getId(), proposal.trim(), proposedBudget);
            if (applied) {
                response.sendRedirect(request.getContextPath() + "/freelancer/my-applications?applied=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/projects?id=" + projectId + "&error=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/projects?id=" + projectIdStr + "&error=server_error");
        }
    }
}
