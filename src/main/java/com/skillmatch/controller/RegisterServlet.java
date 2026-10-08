package com.skillmatch.controller;

import com.skillmatch.dao.UserDAO;
import com.skillmatch.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String roleParam = request.getParameter("role");
        if (roleParam != null) {
            request.setAttribute("selectedRole", roleParam.toUpperCase());
        }
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role = request.getParameter("role");

        // Input validation
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            role == null || role.trim().isEmpty()) {

            request.setAttribute("errorMessage", "All fields are required.");
            forwardWithInputs(request, response, name, email, role);
            return;
        }

        name = name.trim();
        email = email.trim().toLowerCase();
        role = role.trim().toUpperCase();

        if (!role.equals("CLIENT") && !role.equals("FREELANCER")) {
            request.setAttribute("errorMessage", "Invalid role selected.");
            forwardWithInputs(request, response, name, email, role);
            return;
        }

        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            request.setAttribute("errorMessage", "Please provide a valid email address.");
            forwardWithInputs(request, response, name, email, role);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("errorMessage", "Password must be at least 6 characters long.");
            forwardWithInputs(request, response, name, email, role);
            return;
        }

        if (confirmPassword != null && !password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            forwardWithInputs(request, response, name, email, role);
            return;
        }

        try {
            if (userDAO.emailExists(email)) {
                request.setAttribute("errorMessage", "An account with this email already exists.");
                forwardWithInputs(request, response, name, email, role);
                return;
            }

            User newUser = userDAO.registerUser(name, email, password, role);
            if (newUser != null) {
                HttpSession session = request.getSession(true);
                session.setAttribute("user", newUser);
                session.setAttribute("role", newUser.getRole());
                session.setAttribute("userId", newUser.getId());
                session.setAttribute("userName", newUser.getName());

                if (newUser.isClient()) {
                    response.sendRedirect(request.getContextPath() + "/client/dashboard?registered=true");
                } else {
                    response.sendRedirect(request.getContextPath() + "/freelancer/dashboard?registered=true");
                }
            } else {
                request.setAttribute("errorMessage", "Registration failed. Please try again.");
                forwardWithInputs(request, response, name, email, role);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Internal server error: " + e.getMessage());
            forwardWithInputs(request, response, name, email, role);
        }
    }

    private void forwardWithInputs(HttpServletRequest request, HttpServletResponse response,
                                   String name, String email, String role) 
            throws ServletException, IOException {
        request.setAttribute("name", name);
        request.setAttribute("email", email);
        request.setAttribute("selectedRole", role);
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
}
