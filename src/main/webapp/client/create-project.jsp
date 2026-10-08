<%@ page import="com.skillmatch.util.HtmlUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.skillmatch.model.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.isClient()) {
        response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
        return;
    }
    List<Skill> availableSkills = (List<Skill>) request.getAttribute("availableSkills");
    if (availableSkills == null) availableSkills = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Post a New Project - SkillMatch</title>
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
            <li><a href="<%= request.getContextPath() %>/client/applications" class="nav-link">Applications</a></li>
            <li><a href="<%= request.getContextPath() %>/logout" class="nav-link">Logout</a></li>
        </ul>
    </nav>

    <div class="container" style="max-width: 720px;">
        <div class="card">
            <h1 style="font-size: 1.5rem; font-weight: 700; margin-bottom: 0.5rem;">Post a New Project</h1>
            <p style="color: var(--text-muted); font-size: 0.9rem; margin-bottom: 1.5rem;">
                Provide comprehensive requirements to attract top qualified freelancers
            </p>

            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-danger">
                    <%= HtmlUtil.escape(request.getAttribute("errorMessage")) %>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/client/create-project" method="POST">
                <div class="form-group">
                    <label class="form-label" for="title">Project Title *</label>
                    <input type="text" id="title" name="title" class="form-control" 
                           value="<%= HtmlUtil.escape(request.getAttribute("title") != null ? request.getAttribute("title") : "") %>"
                           required placeholder="e.g. E-Commerce Inventory Management System">
                </div>

                <div class="form-group">
                    <label class="form-label" for="description">Detailed Description *</label>
                    <textarea id="description" name="description" class="form-control" rows="6" 
                              required placeholder="Describe key deliverables, expected technologies, milestones, and scope..."><%= HtmlUtil.escape(request.getAttribute("description") != null ? request.getAttribute("description") : "") %></textarea>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <div class="form-group">
                        <label class="form-label" for="budget">Budget (USD $) *</label>
                        <input type="number" step="0.01" min="1" id="budget" name="budget" class="form-control" 
                               value="<%= HtmlUtil.escape(request.getAttribute("budget") != null ? request.getAttribute("budget") : "") %>"
                               required placeholder="1500.00">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="deadline">Project Deadline *</label>
                        <input type="date" id="deadline" name="deadline" class="form-control" 
                               value="<%= HtmlUtil.escape(request.getAttribute("deadline") != null ? request.getAttribute("deadline") : "") %>"
                               required>
                    </div>
                </div>

                <div style="display: flex; gap: 1rem; margin-top: 1rem;">
                    <button type="submit" class="btn btn-primary" style="flex: 1;">Publish Project</button>
                    <a href="<%= request.getContextPath() %>/client/dashboard" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </div>

    <footer>
        <p>&copy; 2026 SkillMatch Marketplace</p>
    </footer>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
