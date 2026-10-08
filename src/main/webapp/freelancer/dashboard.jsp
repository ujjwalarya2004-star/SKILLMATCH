<%@ page import="com.skillmatch.util.HtmlUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.skillmatch.model.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.isFreelancer()) {
        response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
        return;
    }

    Map<String, Integer> stats = (Map<String, Integer>) request.getAttribute("stats");
    if (stats == null) stats = new HashMap<>();
    List<Application> recentApps = (List<Application>) request.getAttribute("recentApplications");
    if (recentApps == null) recentApps = new ArrayList<>();
    FreelancerProfile profile = (FreelancerProfile) request.getAttribute("profile");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Freelancer Dashboard - SkillMatch</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="<%= request.getContextPath() %>/freelancer/dashboard" class="nav-brand">
            <span>⚡ SkillMatch</span>
            <span class="brand-badge">Freelancer</span>
        </a>
        <ul class="nav-links">
            <li><a href="<%= request.getContextPath() %>/freelancer/dashboard" class="nav-link active">Dashboard</a></li>
            <li><a href="<%= request.getContextPath() %>/projects" class="nav-link">Browse Projects</a></li>
            <li><a href="<%= request.getContextPath() %>/freelancer/my-applications" class="nav-link">My Applications</a></li>
            <li><a href="<%= request.getContextPath() %>/freelancer/skills" class="nav-link">My Skills</a></li>
            <li><a href="<%= request.getContextPath() %>/freelancer/profile" class="nav-link">My Profile</a></li>
            <li><a href="<%= request.getContextPath() %>/logout" class="nav-link">Logout</a></li>
        </ul>
    </nav>

    <div class="container">
        <!-- Header -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 1rem;">
            <div>
                <h1 style="font-size: 1.75rem; font-weight: 700;">Welcome, <%= HtmlUtil.escape(user.getName()) %></h1>
                <p style="color: var(--text-muted); font-size: 0.95rem;">Track your proposals, profile visibility, and ongoing contracts</p>
            </div>
            <div style="display: flex; gap: 0.75rem; flex-wrap: wrap;">
                <a href="<%= request.getContextPath() %>/projects" class="btn btn-primary">🔍 Browse Projects</a>
                <a href="<%= request.getContextPath() %>/freelancer/my-applications" class="btn btn-secondary">My Applications</a>
                <a href="<%= request.getContextPath() %>/freelancer/profile" class="btn btn-secondary">Edit Profile</a>
            </div>
        </div>

        <% if ("true".equals(request.getParameter("registered"))) { %>
            <div class="alert alert-success">Welcome to SkillMatch! Please complete your profile and add your technical skills.</div>
        <% } %>

        <!-- Statistics Grid -->
        <div class="stats-grid">
            <div class="stat-card">
                <span class="stat-title">Total Applications</span>
                <span class="stat-value"><%= stats.getOrDefault("total", 0) %></span>
            </div>
            <div class="stat-card">
                <span class="stat-title">Pending</span>
                <span class="stat-value" style="color: #d97706;"><%= stats.getOrDefault("pending", 0) %></span>
            </div>
            <div class="stat-card">
                <span class="stat-title">Accepted</span>
                <span class="stat-value" style="color: #059669;"><%= stats.getOrDefault("accepted", 0) %></span>
            </div>
            <div class="stat-card">
                <span class="stat-title">Rejected</span>
                <span class="stat-value" style="color: #dc2626;"><%= stats.getOrDefault("rejected", 0) %></span>
            </div>
            <div class="stat-card">
                <span class="stat-title">Active Projects</span>
                <span class="stat-value" style="color: #2563eb;"><%= stats.getOrDefault("activeProjects", 0) %></span>
            </div>
        </div>

        <!-- Two Column Layout: Profile Overview & Recent Applications -->
        <div style="display: grid; grid-template-columns: 1fr 2fr; gap: 1.5rem; align-items: start;">
            <!-- Left: Profile Snapshot -->
            <div class="card">
                <h2 style="font-size: 1.15rem; font-weight: 700; margin-bottom: 1rem;">Profile Snapshot</h2>
                <div style="margin-bottom: 0.75rem;">
                    <div style="font-size: 0.8rem; color: var(--text-muted);">Experience</div>
                    <strong><%= HtmlUtil.escape((profile != null && profile.getExperience() != null && !profile.getExperience().isEmpty()) ? profile.getExperience() : "Not specified") %></strong>
                </div>
                <div style="margin-bottom: 0.75rem;">
                    <div style="font-size: 0.8rem; color: var(--text-muted);">Location</div>
                    <div><%= HtmlUtil.escape((profile != null && profile.getLocation() != null && !profile.getLocation().isEmpty()) ? profile.getLocation() : "Not specified") %></div>
                </div>
                <div style="margin-bottom: 1rem;">
                    <div style="font-size: 0.8rem; color: var(--text-muted); margin-bottom: 0.35rem;">My Skills</div>
                    <% if (profile != null && profile.getSkills() != null && !profile.getSkills().isEmpty()) { %>
                        <div>
                            <% for (Skill s : profile.getSkills()) { %>
                                <span class="skill-tag"><%= HtmlUtil.escape(s.getSkillName()) %></span>
                            <% } %>
                        </div>
                    <% } else { %>
                        <p style="font-size: 0.85rem; color: var(--text-muted);">No skills added yet.</p>
                    <% } %>
                </div>
                <div style="display: flex; gap: 0.5rem; margin-top: 1rem;">
                    <a href="<%= request.getContextPath() %>/freelancer/skills" class="btn btn-secondary btn-sm" style="flex: 1;">Manage Skills</a>
                    <a href="<%= request.getContextPath() %>/freelancer/profile" class="btn btn-primary btn-sm" style="flex: 1;">Full Profile</a>
                </div>
            </div>

            <!-- Right: Recent Applications -->
            <div class="card">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                    <h2 style="font-size: 1.15rem; font-weight: 700;">Recent Applications</h2>
                    <a href="<%= request.getContextPath() %>/freelancer/my-applications" style="font-size: 0.85rem; color: var(--primary); text-decoration: none; font-weight: 600;">View All &rarr;</a>
                </div>

                <% if (recentApps.isEmpty()) { %>
                    <div style="text-align: center; padding: 2.5rem 1rem; color: var(--text-muted);">
                        <p style="font-size: 1rem; margin-bottom: 1rem;">You haven't submitted any proposals yet.</p>
                        <a href="<%= request.getContextPath() %>/projects" class="btn btn-primary btn-sm">Browse Available Projects</a>
                    </div>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Project</th>
                                    <th>Proposed Rate</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Application app : recentApps) { %>
                                    <tr>
                                        <td>
                                            <strong><%= HtmlUtil.escape(app.getProjectTitle()) %></strong>
                                            <div style="font-size: 0.8rem; color: var(--text-muted);">Client Budget: $<%= String.format("%.2f", app.getProjectBudget()) %></div>
                                        </td>
                                        <td><strong>$<%= String.format("%.2f", app.getProposedBudget()) %></strong></td>
                                        <td>
                                            <span class="badge badge-<%= app.getStatus().toLowerCase() %>">
                                                <%= app.getStatus() %>
                                            </span>
                                        </td>
                                        <td>
                                            <% if ("ACCEPTED".equalsIgnoreCase(app.getStatus())) { %>
                                                <a href="<%= request.getContextPath() %>/messages?projectId=<%= app.getProjectId() %>" class="btn btn-accent btn-sm">💬 Chat</a>
                                            <% } else { %>
                                                <a href="<%= request.getContextPath() %>/projects?id=<%= app.getProjectId() %>" class="btn btn-secondary btn-sm">Details</a>
                                            <% } %>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <footer>
        <p>&copy; 2026 SkillMatch Marketplace | Freelancer Portal</p>
    </footer>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
