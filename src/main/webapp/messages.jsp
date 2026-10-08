<%@ page import="com.skillmatch.util.HtmlUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.skillmatch.model.*" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login?error=login_required");
        return;
    }

    Project project = (Project) request.getAttribute("project");
    List<Message> messages = (List<Message>) request.getAttribute("messages");
    if (messages == null) messages = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Project Chat - <%= HtmlUtil.escape(project != null ? project.getTitle() : "Messages") %> - SkillMatch</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="<%= request.getContextPath() %>/index.jsp" class="nav-brand">
            <span>⚡ SkillMatch</span>
            <span class="brand-badge">Direct Messaging</span>
        </a>
        <ul class="nav-links">
            <% if (currentUser.isClient()) { %>
                <li><a href="<%= request.getContextPath() %>/client/dashboard" class="nav-link">Dashboard</a></li>
                <li><a href="<%= request.getContextPath() %>/client/applications" class="nav-link">Applications</a></li>
            <% } else { %>
                <li><a href="<%= request.getContextPath() %>/freelancer/dashboard" class="nav-link">Dashboard</a></li>
                <li><a href="<%= request.getContextPath() %>/freelancer/my-applications" class="nav-link">My Applications</a></li>
            <% } %>
            <li><a href="<%= request.getContextPath() %>/logout" class="nav-link">Logout</a></li>
        </ul>
    </nav>

    <div class="container" style="max-width: 860px;">
        <div style="margin-bottom: 1rem;">
            <% if (currentUser.isClient()) { %>
                <a href="<%= request.getContextPath() %>/client/dashboard" style="color: var(--primary); text-decoration: none; font-weight: 600; font-size: 0.9rem;">
                    &larr; Back to Client Dashboard
                </a>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/freelancer/my-applications" style="color: var(--primary); text-decoration: none; font-weight: 600; font-size: 0.9rem;">
                    &larr; Back to Applications
                </a>
            <% } %>
        </div>

        <div class="chat-container">
            <!-- Chat Header -->
            <div class="chat-header">
                <div>
                    <h2 style="font-size: 1.15rem; font-weight: 700; margin-bottom: 0.2rem;">
                        <%= HtmlUtil.escape(project != null ? project.getTitle() : "Project Workspace") %>
                    </h2>
                    <p style="font-size: 0.8rem; color: var(--text-muted);">
                        Contract Active &bull;
                        <% if (currentUser.isClient()) { %>
                            Chatting with Freelancer: <strong><%= HtmlUtil.escape(project != null ? project.getAcceptedFreelancerName() : "Partner") %></strong>
                        <% } else { %>
                            Chatting with Client: <strong><%= HtmlUtil.escape(project != null ? project.getClientName() : "Client") %></strong>
                        <% } %>
                    </p>
                </div>
                <div>
                    <span class="badge badge-accepted">Active Contract</span>
                </div>
            </div>

            <!-- Messages Stream -->
            <div class="chat-messages">
                <% if (messages.isEmpty()) { %>
                    <div style="text-align: center; margin: auto; color: var(--text-muted);">
                        <div style="font-size: 2.5rem; margin-bottom: 0.5rem;">💬</div>
                        <p style="font-weight: 600;">No messages yet.</p>
                        <p style="font-size: 0.85rem;">Say hello to initiate collaboration on this project.</p>
                    </div>
                <% } else { %>
                    <% for (Message m : messages) { 
                        boolean isMe = (m.getSenderId() == currentUser.getId());
                    %>
                        <div class="message-bubble <%= isMe ? "outgoing" : "incoming" %>">
                            <div style="font-size: 0.75rem; font-weight: 700; margin-bottom: 0.25rem; opacity: 0.9;">
                                <%= HtmlUtil.escape(isMe ? "You" : m.getSenderName()) %> (<%= m.getSenderRole() %>)
                            </div>
                            <div><%= HtmlUtil.escape(m.getMessageText()) %></div>
                            <div class="message-time">
                                <%= m.getSentAt() %>
                            </div>
                        </div>
                    <% } %>
                <% } %>
            </div>

            <!-- Message Input Composer -->
            <form action="<%= request.getContextPath() %>/messages" method="POST" class="chat-input-bar">
                <input type="hidden" name="projectId" value="<%= project != null ? project.getId() : "" %>">
                <input type="text" name="messageText" class="form-control" 
                       placeholder="Type your message here and press Send..." required autocomplete="off">
                <button type="submit" class="btn btn-primary" style="white-space: nowrap;">
                    Send &rarr;
                </button>
            </form>
        </div>
    </div>

    <footer>
        <p>&copy; 2026 SkillMatch Marketplace</p>
    </footer>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
