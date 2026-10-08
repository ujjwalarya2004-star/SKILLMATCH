package com.skillmatch.controller;

import com.skillmatch.dao.ProjectDAO;
import com.skillmatch.dao.SkillDAO;
import com.skillmatch.model.Project;
import com.skillmatch.model.Skill;
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
import java.time.LocalDate;
import java.util.List;

@WebServlet("/client/create-project")
public class CreateProjectServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ProjectDAO projectDAO = new ProjectDAO();
    private final SkillDAO skillDAO = new SkillDAO();

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
            List<Skill> availableSkills = skillDAO.getAllSkills();
            request.setAttribute("availableSkills", availableSkills);
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/client/create-project.jsp").forward(request, response);
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

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String budgetStr = request.getParameter("budget");
        String deadlineStr = request.getParameter("deadline");

        if (title == null || title.trim().isEmpty() ||
            description == null || description.trim().isEmpty() ||
            budgetStr == null || budgetStr.trim().isEmpty() ||
            deadlineStr == null || deadlineStr.trim().isEmpty()) {

            request.setAttribute("errorMessage", "All project fields are required.");
            retainFormValues(request, title, description, budgetStr, deadlineStr);
            doGet(request, response);
            return;
        }

        BigDecimal budget;
        try {
            budget = new BigDecimal(budgetStr.trim());
            if (budget.compareTo(BigDecimal.ZERO) <= 0) {
                request.setAttribute("errorMessage", "Budget must be a positive number.");
                retainFormValues(request, title, description, budgetStr, deadlineStr);
                doGet(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid budget format.");
            retainFormValues(request, title, description, budgetStr, deadlineStr);
            doGet(request, response);
            return;
        }

        Date deadline;
        try {
            deadline = Date.valueOf(deadlineStr.trim());
            if (deadline.toLocalDate().isBefore(LocalDate.now())) {
                request.setAttribute("errorMessage", "Project deadline must be in the future.");
                retainFormValues(request, title, description, budgetStr, deadlineStr);
                doGet(request, response);
                return;
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Invalid deadline format. Use YYYY-MM-DD.");
            retainFormValues(request, title, description, budgetStr, deadlineStr);
            doGet(request, response);
            return;
        }

        try {
            Project project = new Project();
            project.setClientId(user.getId());
            project.setTitle(title.trim());
            project.setDescription(description.trim());
            project.setBudget(budget);
            project.setDeadline(deadline);

            int projectId = projectDAO.createProject(project);
            if (projectId > 0) {
                response.sendRedirect(request.getContextPath() + "/client/dashboard?created=true");
            } else {
                request.setAttribute("errorMessage", "Could not create project. Please try again.");
                retainFormValues(request, title, description, budgetStr, deadlineStr);
                doGet(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            retainFormValues(request, title, description, budgetStr, deadlineStr);
            doGet(request, response);
        }
    }

    private void retainFormValues(HttpServletRequest request, String title, String desc, String budget, String deadline) {
        request.setAttribute("title", title);
        request.setAttribute("description", desc);
        request.setAttribute("budget", budget);
        request.setAttribute("deadline", deadline);
    }
}
