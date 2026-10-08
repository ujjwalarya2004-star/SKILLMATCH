<%@ page import="com.skillmatch.util.HtmlUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillmatch.model.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.isClient()) {
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
    <title>Edit Project - SkillMatch</title>
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
            <li><a href="<%= request.getContextPath() %>/logout" class="nav-link">Logout</a></li>
        </ul>
    </nav>

    <div class="container" style="max-width: 720px;">
        <div class="card">
            <h1 style="font-size: 1.5rem; font-weight: 700; margin-bottom: 0.5rem;">Edit Project</h1>
            <p style="color: var(--text-muted); font-size: 0.9rem; margin-bottom: 1.5rem;">
                Update requirements, budget, status, or deadline
            </p>

            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-danger"><%= HtmlUtil.escape(request.getAttribute("errorMessage")) %></div>
            <% } %>

            <form action="<%= request.getContextPath() %>/client/edit-project" method="POST">
                <input type="hidden" name="id" value="<%= project.getId() %>">

                <div class="form-group">
                    <label class="form-label" for="title">Project Title</label>
                    <input type="text" id="title" name="title" class="form-control" 
                           value="<%= HtmlUtil.escape(project.getTitle()) %>" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="description">Description</label>
                    <textarea id="description" name="description" class="form-control" rows="6" required><%= HtmlUtil.escape(project.getDescription()) %></textarea>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <div class="form-group">
                        <label class="form-label" for="budget">Budget (USD $)</label>
                        <input type="number" step="0.01" min="1" id="budget" name="budget" class="form-control" 
                               value="<%= project.getBudget() %>" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="deadline">Deadline</label>
                        <input type="date" id="deadline" name="deadline" class="form-control" 
                               value="<%= project.getDeadline() %>" required>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="status">Project Status</label>
                    <select id="status" name="status" class="form-control">
                        <option value="OPEN" <%= "OPEN".equals(project.getStatus()) ? "selected" : "" %>>OPEN (Accepting Applications)</option>
                        <option value="IN_PROGRESS" <%= "IN_PROGRESS".equals(project.getStatus()) ? "selected" : "" %>>IN PROGRESS (Under Development)</option>
                        <option value="COMPLETED" <%= "COMPLETED".equals(project.getStatus()) ? "selected" : "" %>>COMPLETED (Finished)</option>
                        <option value="CANCELLED" <%= "CANCELLED".equals(project.getStatus()) ? "selected" : "" %>>CANCELLED</option>
                    </select>
                </div>

                <div style="display: flex; gap: 1rem; margin-top: 1rem;">
                    <button type="submit" class="btn btn-primary" style="flex: 1;">Save Changes</button>
                    <a href="<%= request.getContextPath() %>/client/dashboard" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </div>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
