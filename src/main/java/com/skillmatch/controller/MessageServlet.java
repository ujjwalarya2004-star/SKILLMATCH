package com.skillmatch.controller;

import com.skillmatch.dao.MessageDAO;
import com.skillmatch.dao.ProjectDAO;
import com.skillmatch.model.Message;
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

@WebServlet("/messages")
public class MessageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final MessageDAO messageDAO = new MessageDAO();
    private final ProjectDAO projectDAO = new ProjectDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=login_required");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String projectIdStr = request.getParameter("projectId");

        if (projectIdStr == null || projectIdStr.trim().isEmpty()) {
            // Redirect to appropriate dashboard if no project specified
            if (currentUser.isClient()) {
                response.sendRedirect(request.getContextPath() + "/client/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/freelancer/dashboard");
            }
            return;
        }

        try {
            int projectId = Integer.parseInt(projectIdStr.trim());
            Project project = projectDAO.getProjectById(projectId);

            if (project == null) {
                response.sendRedirect(request.getContextPath() + "/index.jsp?error=project_not_found");
                return;
            }

            // Verify user is either client or accepted freelancer
            boolean isParticipant = messageDAO.isUserParticipantInProject(projectId, currentUser.getId());
            if (!isParticipant) {
                response.sendRedirect(request.getContextPath() + "/index.jsp?error=unauthorized_chat");
                return;
            }

            int receiverId = messageDAO.getOtherParticipantId(projectId, currentUser.getId());
            List<Message> messages = messageDAO.getMessagesByProject(projectId);

            request.setAttribute("project", project);
            request.setAttribute("receiverId", receiverId);
            request.setAttribute("messages", messages);
            request.setAttribute("currentUser", currentUser);
            request.getRequestDispatcher("/messages.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=server_error");
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

        User currentUser = (User) session.getAttribute("user");
        String projectIdStr = request.getParameter("projectId");
        String messageText = request.getParameter("messageText");

        if (projectIdStr == null || messageText == null || messageText.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/messages?projectId=" + projectIdStr);
            return;
        }

        try {
            int projectId = Integer.parseInt(projectIdStr.trim());
            boolean isParticipant = messageDAO.isUserParticipantInProject(projectId, currentUser.getId());
            if (!isParticipant) {
                response.sendRedirect(request.getContextPath() + "/index.jsp?error=unauthorized_chat");
                return;
            }

            int receiverId = messageDAO.getOtherParticipantId(projectId, currentUser.getId());
            if (receiverId > 0) {
                messageDAO.sendMessage(projectId, currentUser.getId(), receiverId, messageText.trim());
            }

            response.sendRedirect(request.getContextPath() + "/messages?projectId=" + projectId);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/messages?projectId=" + projectIdStr + "&error=send_failed");
        }
    }
}
