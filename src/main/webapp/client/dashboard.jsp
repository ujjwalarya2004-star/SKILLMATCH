<%@ page import="com.skillmatch.util.HtmlUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.skillmatch.model.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.isClient()) {
        response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
        return;
    }

    Map<String, Integer> stats = (Map<String, Integer>) request.getAttribute("stats");
    if (stats == null) stats = new HashMap<>();
    List<Project> projects = (List<Project>) request.getAttribute("projects");
    if (projects == null) projects = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Client Dashboard - SkillMatch</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Navigation -->
    <nav class="navbar">
        <a href="<%= request.getContextPath() %>/client/dashboard" class="nav-brand">
            <span>⚡ SkillMatch</span>
            <span class="brand-badge">Client Portal</span>
        </a>
        <ul class="nav-links">
            <li><a href="<%= request.getContextPath() %>/client/dashboard" class="nav-link active">Dashboard</a></li>
            <li><a href="<%= request.getContextPath() %>/client/create-project" class="btn btn-primary btn-sm">+ Add New Project</a></li>
            <li><a href="<%= request.getContextPath() %>/client/applications" class="nav-link">Manage Applications</a></li>
            <li><a href="<%= request.getContextPath() %>/logout" class="nav-link">Logout</a></li>
        </ul>
    </nav>

    <div class="container">
        <!-- Header -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 1rem;">
            <div>
                <h1 style="font-size: 1.75rem; font-weight: 700;">Welcome, <%= HtmlUtil.escape(user.getName()) %></h1>
                <p style="color: var(--text-muted); font-size: 0.95rem;">Manage your job postings, proposals, and active contracts</p>
            </div>
            <div style="display: flex; gap: 0.75rem;">
                <a href="<%= request.getContextPath() %>/client/create-project" class="btn btn-primary">+ Add New Project</a>
                <a href="<%= request.getContextPath() %>/client/applications" class="btn btn-secondary">Manage Applications</a>
            </div>
        </div>

        <% if ("true".equals(request.getParameter("created"))) { %>
            <div class="alert alert-success">Project posted successfully! Freelancers can now view and apply.</div>
        <% } %>
        <% if ("true".equals(request.getParameter("updated"))) { %>
            <div class="alert alert-success">Project details updated successfully.</div>
        <% } %>
        <% if ("true".equals(request.getParameter("deleted"))) { %>
            <div class="alert alert-success">Project deleted successfully.</div>
        <% } %>
        <% if ("true".equals(request.getParameter("statusUpdated"))) { %>
            <div class="alert alert-success">Project status changed successfully.</div>
        <% } %>

        <!-- Dashboard Statistics Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <span class="stat-title">Total Projects</span>
                <span class="stat-value"><%= stats.getOrDefault("total", 0) %></span>
            </div>
            <div class="stat-card">
                <span class="stat-title">Open Projects</span>
                <span class="stat-value" style="color: #2563eb;"><%= stats.getOrDefault("open", 0) %></span>
            </div>
            <div class="stat-card">
                <span class="stat-title">In Progress</span>
                <span class="stat-value" style="color: #d97706;"><%= stats.getOrDefault("inProgress", 0) %></span>
            </div>
            <div class="stat-card">
                <span class="stat-title">Completed Projects</span>
                <span class="stat-value" style="color: #059669;"><%= stats.getOrDefault("completed", 0) %></span>
            </div>
        </div>

        <!-- Recent Projects Table -->
        <div class="card">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.25rem;">
                <h2 style="font-size: 1.25rem; font-weight: 700;">Your Projects</h2>
                <span style="font-size: 0.85rem; color: var(--text-muted);"><%= projects.size() %> Projects Total</span>
            </div>

            <% if (projects.isEmpty()) { %>
                <div style="text-align: center; padding: 3rem 1rem; color: var(--text-muted);">
                    <div style="font-size: 2.5rem; margin-bottom: 0.5rem;">📁</div>
                    <p style="font-size: 1.1rem; margin-bottom: 1rem;">No projects posted yet.</p>
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
                                        <% if (p.getAcceptedFreelancerName() != null && !p.getAcceptedFreelancerName().isEmpty()) { %>
                                            <div style="font-size: 0.8rem; color: #059669; margin-top: 0.25rem;">
                                                Assigned: <strong><%= HtmlUtil.escape(p.getAcceptedFreelancerName()) %></strong>
                                            </div>
                                        <% } %>
                                    </td>
                                    <td><strong>$<%= String.format("%.2f", p.getBudget()) %></strong></td>
                                    <td><%= p.getDeadline() %></td>
                                    <td>
                                        <span class="badge badge-<%= p.getStatus().toLowerCase() %>">
                                            <%= p.getStatus().replace('_', ' ') %>
                                        </span>
                                    </td>
                                    <td>
                                        <a href="<%= request.getContextPath() %>/client/applications?projectId=<%= p.getId() %>" style="text-decoration: none; font-weight: 600; color: var(--primary);">
                                            <%= p.getApplicationCount() %> Received
                                        </a>
                                    </td>
                                    <td>
                                        <div style="display: flex; gap: 0.5rem; align-items: center; flex-wrap: wrap;">
                                            <a href="<%= request.getContextPath() %>/projects?id=<%= p.getId() %>" class="btn btn-secondary btn-sm">View</a>
                                            <a href="<%= request.getContextPath() %>/client/edit-project?id=<%= p.getId() %>" class="btn btn-secondary btn-sm">Edit</a>
                                            <a href="<%= request.getContextPath() %>/client/applications?projectId=<%= p.getId() %>" class="btn btn-secondary btn-sm">Applications</a>
                                            
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
        <p>&copy; 2026 SkillMatch Marketplace | Client Dashboard</p>
    </footer>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
