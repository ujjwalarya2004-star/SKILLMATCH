<%@ page import="com.skillmatch.util.HtmlUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.skillmatch.model.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.isClient()) {
        response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
        return;
    }

    List<Project> projects = (List<Project>) request.getAttribute("projects");
    if (projects == null) projects = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Projects - SkillMatch</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="<%= request.getContextPath() %>/client/dashboard" class="nav-brand">
            <span>⚡ SkillMatch</span>
            <span class="brand-badge">Client</span>
        </a>
        <ul class="nav-links">
            <li><a href="<%= request.getContextPath() %>/client/dashboard" class="nav-link">Dashboard</a></li>
            <li><a href="<%= request.getContextPath() %>/client/projects" class="nav-link active">My Projects</a></li>
            <li><a href="<%= request.getContextPath() %>/client/create-project" class="btn btn-primary btn-sm">+ Post Project</a></li>
            <li><a href="<%= request.getContextPath() %>/client/applications" class="nav-link">Applications</a></li>
            <li><a href="<%= request.getContextPath() %>/logout" class="nav-link">Logout</a></li>
        </ul>
    </nav>

    <div class="container">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 1rem;">
            <div>
                <h1 style="font-size: 1.75rem; font-weight: 700;">My Projects</h1>
                <p style="color: var(--text-muted); font-size: 0.95rem;">Manage all projects created under your account</p>
            </div>
            <a href="<%= request.getContextPath() %>/client/create-project" class="btn btn-primary">+ Create New Project</a>
        </div>

        <div class="card" style="padding: 0; overflow: hidden;">
            <% if (projects.isEmpty()) { %>
                <div style="text-align: center; padding: 3rem 1rem; color: var(--text-muted);">
                    <div style="font-size: 2.5rem; margin-bottom: 0.5rem;">📁</div>
                    <p style="font-size: 1.1rem; margin-bottom: 1rem;">You have not created any projects yet.</p>
                    <a href="<%= request.getContextPath() %>/client/create-project" class="btn btn-primary">Create Your First Project</a>
                </div>
            <% } else { %>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Project Title</th>
                                <th>Budget</th>
                                <th>Deadline</th>
                                <th>Status</th>
                                <th>Applications</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Project p : projects) { %>
                                <tr>
                                    <td>
                                        <strong><%= HtmlUtil.escape(p.getTitle()) %></strong>
                                        <div style="font-size: 0.8rem; color: var(--text-muted); margin-top: 0.2rem;">
                                            Created: <%= p.getCreatedAt() %>
                                        </div>
                                    </td>
                                    <td><strong>$<%= String.format("%.2f", p.getBudget()) %></strong></td>
                                    <td><%= p.getDeadline() %></td>
                                    <td>
                                        <span class="badge badge-<%= p.getStatus().toLowerCase() %>">
                                            <%= p.getStatus().replace('_', ' ') %>
                                        </span>
                                    </td>
                                    <td>
                                        <a href="<%= request.getContextPath() %>/client/applications?projectId=<%= p.getId() %>" style="color: var(--primary); font-weight: 600; text-decoration: none;">
                                            <%= p.getApplicationCount() %> Received &rarr;
                                        </a>
                                    </td>
                                    <td>
                                        <div style="display: flex; gap: 0.4rem; align-items: center; flex-wrap: wrap;">
                                            <a href="<%= request.getContextPath() %>/project-details?id=<%= p.getId() %>" class="btn btn-secondary btn-sm">View</a>
                                            <a href="<%= request.getContextPath() %>/client/edit-project?id=<%= p.getId() %>" class="btn btn-secondary btn-sm">Edit</a>
                                            <% if ("IN_PROGRESS".equalsIgnoreCase(p.getStatus()) || "COMPLETED".equalsIgnoreCase(p.getStatus())) { %>
                                                <a href="<%= request.getContextPath() %>/messages?projectId=<%= p.getId() %>" class="btn btn-accent btn-sm">💬 Chat</a>
                                            <% } %>
                                            <form action="<%= request.getContextPath() %>/client/delete-project" method="POST" style="display: inline;" onsubmit="return confirm('Are you sure you want to delete this project?');">
                                                <input type="hidden" name="id" value="<%= p.getId() %>">
                                                <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
    </div>

    <footer>
        <p>&copy; 2026 SkillMatch Marketplace | B.Tech Mini Project</p>
    </footer>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
