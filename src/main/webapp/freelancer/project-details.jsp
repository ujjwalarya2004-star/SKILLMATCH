<%@ page import="com.skillmatch.util.HtmlUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillmatch.model.*" %>
<%
    User currentUser = (User) session.getAttribute("user");
    Project project = (Project) request.getAttribute("project");
    Boolean alreadyAppliedObj = (Boolean) request.getAttribute("alreadyApplied");
    boolean alreadyApplied = (alreadyAppliedObj != null && alreadyAppliedObj);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= HtmlUtil.escape(project != null ? project.getTitle() : "Project Details") %> - SkillMatch</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="<%= request.getContextPath() %>/index.jsp" class="nav-brand">
            <span>⚡ SkillMatch</span>
        </a>
        <ul class="nav-links">
            <li><a href="<%= request.getContextPath() %>/projects" class="nav-link">Browse Projects</a></li>
            <% if (currentUser != null) { %>
                <% if (currentUser.isClient()) { %>
                    <li><a href="<%= request.getContextPath() %>/client/dashboard" class="nav-link">Dashboard</a></li>
                <% } else { %>
                    <li><a href="<%= request.getContextPath() %>/freelancer/dashboard" class="nav-link">Dashboard</a></li>
                    <li><a href="<%= request.getContextPath() %>/freelancer/my-applications" class="nav-link">My Applications</a></li>
                <% } %>
                <li><a href="<%= request.getContextPath() %>/logout" class="nav-link">Logout</a></li>
            <% } else { %>
                <li><a href="<%= request.getContextPath() %>/login" class="nav-link">Sign In</a></li>
            <% } %>
        </ul>
    </nav>

    <div class="container" style="max-width: 900px;">
        <div style="margin-bottom: 1.5rem;">
            <a href="<%= request.getContextPath() %>/projects" style="color: var(--primary); text-decoration: none; font-weight: 600; font-size: 0.9rem;">
                &larr; Back to Open Projects
            </a>
        </div>

        <% if ("already_applied".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger">You have already submitted an application for this project.</div>
        <% } %>
        <% if ("missing_fields".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger">Please fill in both the proposal pitch and your proposed budget.</div>
        <% } %>

        <% if (project != null) { %>
            <!-- Project Header Card -->
            <div class="card">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 1rem; margin-bottom: 1rem;">
                    <div>
                        <span class="badge badge-<%= project.getStatus().toLowerCase() %>"><%= project.getStatus() %></span>
                        <h1 style="font-size: 1.75rem; font-weight: 800; margin-top: 0.5rem; margin-bottom: 0.5rem;"><%= HtmlUtil.escape(project.getTitle()) %></h1>
                        <p style="color: var(--text-muted); font-size: 0.9rem;">
                            Posted by <strong><%= HtmlUtil.escape(project.getClientName()) %></strong> &bull; <%= project.getCreatedAt() %>
                        </p>
                    </div>
                    <div style="text-align: right;">
                        <span style="font-size: 0.85rem; color: var(--text-muted); display: block;">Client Budget</span>
                        <span style="font-size: 2rem; font-weight: 800; color: #0f172a;">$<%= String.format("%.2f", project.getBudget()) %></span>
                        <span style="font-size: 0.85rem; color: var(--text-muted); display: block; margin-top: 0.25rem;">Deadline: <%= project.getDeadline() %></span>
                    </div>
                </div>

                <div style="border-top: 1px solid var(--border); padding-top: 1.5rem; margin-top: 1rem;">
                    <h3 style="font-size: 1.1rem; font-weight: 700; margin-bottom: 0.75rem;">Project Description</h3>
                    <p style="font-size: 1rem; line-height: 1.6; white-space: pre-line; color: #334155;">
                        <%= HtmlUtil.escape(project.getDescription()) %>
                    </p>
                </div>

                <div style="border-top: 1px solid var(--border); padding-top: 1rem; margin-top: 1.5rem; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
                    <div>
                        <span style="font-size: 0.85rem; color: var(--text-muted);">Client Email:</span>
                        <strong style="margin-left: 0.25rem;"><%= HtmlUtil.escape(project.getClientEmail()) %></strong>
                    </div>
                    <div>
                        <span style="font-size: 0.85rem; color: var(--text-muted);">Applications Received:</span>
                        <strong style="margin-left: 0.25rem;"><%= project.getApplicationCount() %></strong>
                    </div>
                </div>
            </div>

            <!-- Application Section -->
            <% if (currentUser == null) { %>
                <div class="card" style="text-align: center; background-color: #f8fafc; border-style: dashed;">
                    <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 0.5rem;">Interested in this project?</h3>
                    <p style="color: var(--text-muted); font-size: 0.95rem; margin-bottom: 1.25rem;">
                        Sign in as a freelancer to submit your proposal and quote your rate.
                    </p>
                    <a href="<%= request.getContextPath() %>/login" class="btn btn-primary">Sign In to Apply</a>
                </div>
            <% } else if (currentUser.isFreelancer()) { %>
                <% if (alreadyApplied) { %>
                    <div class="card" style="background-color: #f0fdf4; border-color: #bbf7d0;">
                        <h3 style="font-size: 1.15rem; font-weight: 700; color: #166534; margin-bottom: 0.5rem;">✔ Application Already Submitted</h3>
                        <p style="color: #15803d; font-size: 0.95rem;">
                            You have submitted a proposal for this project. You can track its status in your applications dashboard.
                        </p>
                        <div style="margin-top: 1rem;">
                            <a href="<%= request.getContextPath() %>/freelancer/my-applications" class="btn btn-primary btn-sm">View My Applications</a>
                        </div>
                    </div>
                <% } else if (!"OPEN".equalsIgnoreCase(project.getStatus())) { %>
                    <div class="card" style="background-color: #f8fafc;">
                        <h3 style="font-size: 1.15rem; font-weight: 700; color: #64748b; margin-bottom: 0.5rem;">Project Not Accepting Applications</h3>
                        <p style="color: var(--text-muted); font-size: 0.95rem;">
                            This project is currently marked as <%= project.getStatus() %>.
                        </p>
                    </div>
                <% } else { %>
                    <!-- Application Submission Form -->
                    <div class="card">
                        <h2 style="font-size: 1.35rem; font-weight: 700; margin-bottom: 0.5rem;">Submit Your Proposal</h2>
                        <p style="color: var(--text-muted); font-size: 0.9rem; margin-bottom: 1.5rem;">
                            Explain how your skills make you the ideal choice and state your proposed budget.
                        </p>

                        <form action="<%= request.getContextPath() %>/freelancer/apply" method="POST">
                            <input type="hidden" name="projectId" value="<%= project.getId() %>">

                            <div class="form-group">
                                <label class="form-label" for="proposedBudget">Your Proposed Budget (USD $) *</label>
                                <input type="number" step="0.01" min="1" id="proposedBudget" name="proposedBudget" class="form-control" 
                                       value="<%= project.getBudget() %>" required placeholder="e.g. 1500.00">
                                <small style="color: var(--text-muted); font-size: 0.8rem;">Client's estimated budget is $<%= String.format("%.2f", project.getBudget()) %></small>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="proposal">Proposal Pitch & Timeline *</label>
                                <textarea id="proposal" name="proposal" class="form-control" rows="5" required 
                                          placeholder="Detail your approach, previous similar work, milestones, and why you are the best fit for this project..."></textarea>
                            </div>

                            <button type="submit" class="btn btn-primary" style="width: 100%;">
                                Submit Proposal to Client
                            </button>
                        </form>
                    </div>
                <% } %>
            <% } else { %>
                <div class="card" style="background-color: #f8fafc;">
                    <p style="color: var(--text-muted); font-size: 0.9rem;">
                        You are viewing this project as a <strong>Client</strong> account. Freelancers can apply to this posting.
                    </p>
                </div>
            <% } %>
        <% } %>
    </div>

    <footer>
        <p>&copy; 2026 SkillMatch Marketplace</p>
    </footer>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
