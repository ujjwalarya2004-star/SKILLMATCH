<%@ page import="com.skillmatch.util.HtmlUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.skillmatch.model.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.isFreelancer()) {
        response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
        return;
    }

    List<Application> applications = (List<Application>) request.getAttribute("applications");
    if (applications == null) applications = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Submitted Applications - SkillMatch</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="<%= request.getContextPath() %>/freelancer/dashboard" class="nav-brand">
            <span>⚡ SkillMatch</span>
            <span class="brand-badge">Freelancer</span>
        </a>
        <ul class="nav-links">
            <li><a href="<%= request.getContextPath() %>/freelancer/dashboard" class="nav-link">Dashboard</a></li>
            <li><a href="<%= request.getContextPath() %>/freelancer/projects" class="nav-link">Browse Projects</a></li>
            <li><a href="<%= request.getContextPath() %>/freelancer/applications" class="nav-link active">My Applications</a></li>
            <li><a href="<%= request.getContextPath() %>/freelancer/skills" class="nav-link">Skills</a></li>
            <li><a href="<%= request.getContextPath() %>/freelancer/profile" class="nav-link">Profile</a></li>
            <li><a href="<%= request.getContextPath() %>/logout" class="nav-link">Logout</a></li>
        </ul>
    </nav>

    <div class="container">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 1rem;">
            <div>
                <h1 style="font-size: 1.75rem; font-weight: 700;">My Submitted Applications</h1>
                <p style="color: var(--text-muted); font-size: 0.95rem;">Track the real-time status of your proposals and client decisions</p>
            </div>
            <a href="<%= request.getContextPath() %>/freelancer/projects" class="btn btn-primary">+ Browse More Projects</a>
        </div>

        <% if ("true".equals(request.getParameter("applied"))) { %>
            <div class="alert alert-success">Proposal successfully submitted! The client will review your application.</div>
        <% } %>

        <% if (applications.isEmpty()) { %>
            <div class="card" style="text-align: center; padding: 3.5rem 1rem; color: var(--text-muted);">
                <div style="font-size: 3rem; margin-bottom: 0.5rem;">📄</div>
                <h3>No Applications Yet</h3>
                <p style="margin-top: 0.5rem; margin-bottom: 1.25rem;">You haven't submitted any proposals yet. Check out open opportunities.</p>
                <a href="<%= request.getContextPath() %>/freelancer/projects" class="btn btn-primary">Find Projects</a>
            </div>
        <% } else { %>
            <div class="table-responsive card" style="padding: 0;">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Project Title</th>
                            <th>Client Budget</th>
                            <th>Your Proposal</th>
                            <th>Your Bid</th>
                            <th>Application Status</th>
                            <th>Project Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Application app : applications) { %>
                            <tr>
                                <td>
                                    <strong><%= HtmlUtil.escape(app.getProjectTitle()) %></strong>
                                    <div style="font-size: 0.75rem; color: var(--text-muted);">Applied: <%= app.getAppliedAt() %></div>
                                </td>
                                <td>$<%= String.format("%.2f", app.getProjectBudget()) %></td>
                                <td style="max-width: 280px;">
                                    <div style="font-size: 0.85rem; color: #334155; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                                        <%= HtmlUtil.escape(app.getProposal()) %>
                                    </div>
                                </td>
                                <td><strong>$<%= String.format("%.2f", app.getProposedBudget()) %></strong></td>
                                <td>
                                    <span class="badge badge-<%= app.getStatus().toLowerCase() %>">
                                        <%= app.getStatus() %>
                                    </span>
                                </td>
                                <td>
                                    <span class="badge badge-<%= app.getProjectStatus().toLowerCase() %>">
                                        <%= app.getProjectStatus().replace('_', ' ') %>
                                    </span>
                                </td>
                                <td>
                                    <% if ("ACCEPTED".equalsIgnoreCase(app.getStatus())) { %>
                                        <a href="<%= request.getContextPath() %>/messages?projectId=<%= app.getProjectId() %>" class="btn btn-accent btn-sm">
                                            💬 Project Chat
                                        </a>
                                    <% } else { %>
                                        <a href="<%= request.getContextPath() %>/project-details?id=<%= app.getProjectId() %>" class="btn btn-secondary btn-sm">
                                            View Project
                                        </a>
                                    <% } %>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>

    <footer>
        <p>&copy; 2026 SkillMatch Marketplace</p>
    </footer>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
