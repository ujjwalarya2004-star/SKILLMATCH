<%@ page import="com.skillmatch.util.HtmlUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillmatch.model.*" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !currentUser.isClient()) {
        response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
        return;
    }
    Project project = (Project) request.getAttribute("project");
    if (project == null) {
        response.sendRedirect(request.getContextPath() + "/client/dashboard");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= HtmlUtil.escape(project.getTitle()) %> - Client Project Details</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="<%= request.getContextPath() %>/client/dashboard" class="nav-brand">
            <span>⚡ SkillMatch</span>
            <span class="brand-badge">Client View</span>
        </a>
        <ul class="nav-links">
            <li><a href="<%= request.getContextPath() %>/client/dashboard" class="nav-link">Dashboard</a></li>
            <li><a href="<%= request.getContextPath() %>/client/projects" class="nav-link">My Projects</a></li>
            <li><a href="<%= request.getContextPath() %>/client/applications?projectId=<%= project.getId() %>" class="nav-link">Applications (<%= project.getApplicationCount() %>)</a></li>
            <li><a href="<%= request.getContextPath() %>/logout" class="nav-link">Logout</a></li>
        </ul>
    </nav>

    <div class="container" style="max-width: 900px;">
        <div style="margin-bottom: 1.5rem;">
            <a href="<%= request.getContextPath() %>/client/dashboard" style="color: var(--primary); text-decoration: none; font-weight: 600; font-size: 0.9rem;">
                &larr; Back to Dashboard
            </a>
        </div>

        <div class="card">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 1rem; margin-bottom: 1.5rem;">
                <div>
                    <span class="badge badge-<%= project.getStatus().toLowerCase() %>"><%= project.getStatus() %></span>
                    <h1 style="font-size: 1.85rem; font-weight: 800; margin-top: 0.5rem; margin-bottom: 0.25rem;"><%= HtmlUtil.escape(project.getTitle()) %></h1>
                    <p style="color: var(--text-muted); font-size: 0.85rem;">
                        Project ID: #<%= project.getId() %> &bull; Posted on <%= project.getCreatedAt() %>
                    </p>
                </div>

                <div style="text-align: right;">
                    <span style="font-size: 0.85rem; color: var(--text-muted); display: block;">Allocated Budget</span>
                    <span style="font-size: 2rem; font-weight: 800; color: #0f172a;">$<%= String.format("%.2f", project.getBudget()) %></span>
                    <span style="font-size: 0.85rem; color: var(--text-muted); display: block; margin-top: 0.25rem;">Deadline: <%= project.getDeadline() %></span>
                </div>
            </div>

            <div style="border-top: 1px solid var(--border); padding-top: 1.5rem;">
                <h3 style="font-size: 1.1rem; font-weight: 700; margin-bottom: 0.75rem;">Description & Scope</h3>
                <p style="font-size: 1rem; line-height: 1.6; white-space: pre-line; color: #334155;">
                    <%= HtmlUtil.escape(project.getDescription()) %>
                </p>
            </div>

            <div style="border-top: 1px solid var(--border); padding-top: 1.5rem; margin-top: 1.5rem; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
                <div>
                    <span style="font-size: 0.85rem; color: var(--text-muted);">Applications:</span>
                    <strong style="margin-left: 0.25rem;"><%= project.getApplicationCount() %> received</strong>
                </div>

                <div style="display: flex; gap: 0.75rem; flex-wrap: wrap;">
                    <a href="<%= request.getContextPath() %>/client/applications?projectId=<%= project.getId() %>" class="btn btn-primary btn-sm">
                        Review Proposals (<%= project.getApplicationCount() %>)
                    </a>
                    <a href="<%= request.getContextPath() %>/client/edit-project?id=<%= project.getId() %>" class="btn btn-secondary btn-sm">
                        Edit Project
                    </a>
                    <% if ("IN_PROGRESS".equalsIgnoreCase(project.getStatus()) || "COMPLETED".equalsIgnoreCase(project.getStatus())) { %>
                        <a href="<%= request.getContextPath() %>/messages?projectId=<%= project.getId() %>" class="btn btn-accent btn-sm">
                            💬 Open Project Chat
                        </a>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <footer>
        <p>&copy; 2026 SkillMatch Marketplace</p>
    </footer>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
