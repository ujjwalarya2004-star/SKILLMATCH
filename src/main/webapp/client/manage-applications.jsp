<%@ page import="com.skillmatch.util.HtmlUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.skillmatch.model.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.isClient()) {
        response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
        return;
    }

    Project project = (Project) request.getAttribute("project");
    List<Application> applications = (List<Application>) request.getAttribute("applications");
    List<Project> clientProjects = (List<Project>) request.getAttribute("clientProjects");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Applications - SkillMatch</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="<%= request.getContextPath() %>/client/dashboard" class="nav-brand">
            <span>⚡ SkillMatch</span>
            <span class="brand-badge">Applications</span>
        </a>
        <ul class="nav-links">
            <li><a href="<%= request.getContextPath() %>/client/dashboard" class="nav-link">Dashboard</a></li>
            <li><a href="<%= request.getContextPath() %>/client/applications" class="nav-link active">Applications</a></li>
            <li><a href="<%= request.getContextPath() %>/logout" class="nav-link">Logout</a></li>
        </ul>
    </nav>

    <div class="container">
        <div style="margin-bottom: 1.5rem;">
            <a href="<%= request.getContextPath() %>/client/dashboard" style="color: var(--primary); text-decoration: none; font-size: 0.9rem; font-weight: 600;">
                &larr; Back to Dashboard
            </a>
            <h1 style="font-size: 1.75rem; font-weight: 700; margin-top: 0.5rem;">
                <% if (project != null) { %>
                    Applications for: <%= HtmlUtil.escape(project.getTitle()) %>
                <% } else { %>
                    Manage Received Applications
                <% } %>
            </h1>
        </div>

        <% if ("true".equals(request.getParameter("statusUpdated"))) { %>
            <div class="alert alert-success">Application status updated successfully. Project status adjusted accordingly.</div>
        <% } %>

        <% if (project != null) { %>
            <!-- Single Project Application Review -->
            <div class="card" style="margin-bottom: 2rem; background-color: #f8fafc;">
                <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
                    <div>
                        <span class="badge badge-<%= project.getStatus().toLowerCase() %>"><%= project.getStatus() %></span>
                        <h2 style="font-size: 1.25rem; font-weight: 700; margin-top: 0.25rem;"><%= HtmlUtil.escape(project.getTitle()) %></h2>
                        <p style="color: var(--text-muted); font-size: 0.9rem;">
                            Budget: <strong>$<%= String.format("%.2f", project.getBudget()) %></strong> | Deadline: <%= project.getDeadline() %>
                        </p>
                    </div>
                    <% if ("IN_PROGRESS".equalsIgnoreCase(project.getStatus()) || "COMPLETED".equalsIgnoreCase(project.getStatus())) { %>
                        <a href="<%= request.getContextPath() %>/messages?projectId=<%= project.getId() %>" class="btn btn-accent">
                            💬 Open Project Chat
                        </a>
                    <% } %>
                </div>
            </div>

            <% if (applications == null || applications.isEmpty()) { %>
                <div class="card" style="text-align: center; padding: 3rem 1rem; color: var(--text-muted);">
                    <div style="font-size: 2.5rem; margin-bottom: 0.5rem;">📬</div>
                    <h3>No Applications Received Yet</h3>
                    <p style="font-size: 0.9rem; margin-top: 0.5rem;">
                        Freelancers browsing open projects will submit proposals here.
                    </p>
                </div>
            <% } else { %>
                <div style="display: flex; flex-direction: column; gap: 1.25rem;">
                    <% for (Application app : applications) { %>
                        <div class="card" style="margin-bottom: 0;">
                            <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 1rem;">
                                <div>
                                    <div style="display: flex; align-items: center; gap: 0.75rem;">
                                        <h3 style="font-size: 1.15rem; font-weight: 700;"><%= HtmlUtil.escape(app.getFreelancerName()) %></h3>
                                        <span class="badge badge-<%= app.getStatus().toLowerCase() %>"><%= app.getStatus() %></span>
                                    </div>
                                    <p style="color: var(--text-muted); font-size: 0.85rem; margin-top: 0.2rem;">
                                        <%= HtmlUtil.escape(app.getFreelancerEmail()) %> &bull; Experience: <%= HtmlUtil.escape(app.getFreelancerExperience() != null ? app.getFreelancerExperience() : "Not specified") %>
                                        <% if (app.getFreelancerPortfolioUrl() != null && !app.getFreelancerPortfolioUrl().isEmpty()) { %>
                                            &bull; <a href="<%= HtmlUtil.safeUrl(app.getFreelancerPortfolioUrl()) %>" target="_blank" style="color: var(--primary);">Portfolio Link &nearr;</a>
                                        <% } %>
                                    </p>
                                    <div style="margin-top: 0.5rem;">
                                        <a href="<%= request.getContextPath() %>/freelancer/profile?userId=<%= app.getFreelancerId() %>" style="color: var(--primary); font-size: 0.85rem; font-weight: 600; text-decoration: none;">
                                            View Full Freelancer Profile &rarr;
                                        </a>
                                    </div>
                                </div>

                                <div style="text-align: right;">
                                    <div style="font-size: 0.85rem; color: var(--text-muted);">Proposed Bid</div>
                                    <div style="font-size: 1.4rem; font-weight: 800; color: #0f172a;">$<%= String.format("%.2f", app.getProposedBudget()) %></div>
                                    <div style="font-size: 0.75rem; color: var(--text-muted);">Applied: <%= app.getAppliedAt() %></div>
                                </div>
                            </div>

                            <!-- Skills -->
                            <div style="margin-top: 0.75rem;">
                                <% for (Skill s : app.getFreelancerSkills()) { %>
                                    <span class="skill-tag"><%= HtmlUtil.escape(s.getSkillName()) %></span>
                                <% } %>
                            </div>

                            <!-- Proposal text -->
                            <div style="margin-top: 1rem; background-color: #f8fafc; padding: 1rem; border-radius: 8px; border: 1px solid var(--border);">
                                <strong style="font-size: 0.85rem; color: var(--text-muted); display: block; margin-bottom: 0.25rem;">Proposal Pitch:</strong>
                                <p style="font-size: 0.95rem; white-space: pre-line;"><%= HtmlUtil.escape(app.getProposal()) %></p>
                            </div>

                            <!-- Action Buttons -->
                            <div style="margin-top: 1rem; display: flex; justify-content: flex-end; gap: 0.75rem; align-items: center;">
                                <% if ("PENDING".equalsIgnoreCase(app.getStatus())) { %>
                                    <form action="<%= request.getContextPath() %>/client/update-application" method="POST" style="display: inline;">
                                        <input type="hidden" name="applicationId" value="<%= app.getId() %>">
                                        <input type="hidden" name="projectId" value="<%= project.getId() %>">
                                        <input type="hidden" name="action" value="ACCEPT">
                                        <button type="submit" class="btn btn-accent btn-sm" onclick="return confirm('Accept this proposal? This will mark project IN_PROGRESS and reject other proposals.');">
                                            ✔ Accept Application
                                        </button>
                                    </form>
                                    <form action="<%= request.getContextPath() %>/client/update-application" method="POST" style="display: inline;">
                                        <input type="hidden" name="applicationId" value="<%= app.getId() %>">
                                        <input type="hidden" name="projectId" value="<%= project.getId() %>">
                                        <input type="hidden" name="action" value="REJECT">
                                        <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Reject this proposal?');">
                                            ✖ Reject
                                        </button>
                                    </form>
                                <% } else if ("ACCEPTED".equalsIgnoreCase(app.getStatus())) { %>
                                    <span style="font-weight: 600; color: #059669; font-size: 0.9rem;">✔ Accepted Proposal</span>
                                    <a href="<%= request.getContextPath() %>/messages?projectId=<%= project.getId() %>" class="btn btn-primary btn-sm">💬 Send Message</a>
                                <% } else { %>
                                    <span style="color: var(--text-muted); font-size: 0.85rem;">Status: Rejected</span>
                                <% } %>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>

        <% } else if (clientProjects != null) { %>
            <!-- Select a project to view applications -->
            <div class="card">
                <h2 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 1rem;">Select a Project to View Applications</h2>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Project</th>
                                <th>Status</th>
                                <th>Budget</th>
                                <th>Applications</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Project p : clientProjects) { %>
                                <tr>
                                    <td><strong><%= HtmlUtil.escape(p.getTitle()) %></strong></td>
                                    <td><span class="badge badge-<%= p.getStatus().toLowerCase() %>"><%= p.getStatus() %></span></td>
                                    <td>$<%= String.format("%.2f", p.getBudget()) %></td>
                                    <td><strong><%= p.getApplicationCount() %></strong> applications</td>
                                    <td>
                                        <a href="<%= request.getContextPath() %>/client/applications?projectId=<%= p.getId() %>" class="btn btn-primary btn-sm">
                                            Review Applications &rarr;
                                        </a>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        <% } %>
    </div>

    <footer>
        <p>&copy; 2026 SkillMatch Marketplace</p>
    </footer>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
