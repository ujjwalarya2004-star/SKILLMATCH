<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillmatch.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SkillMatch - Connect Skills With Opportunities</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Navigation Bar -->
    <nav class="navbar">
        <a href="<%= request.getContextPath() %>/index.jsp" class="nav-brand">
            <span>⚡ SkillMatch</span>
            <span class="brand-badge">Marketplace</span>
        </a>
        <ul class="nav-links">
            <li><a href="<%= request.getContextPath() %>/projects" class="nav-link">Browse Projects</a></li>
            <% if (currentUser == null) { %>
                <li><a href="<%= request.getContextPath() %>/login" class="nav-link">Login</a></li>
                <li><a href="<%= request.getContextPath() %>/register?role=CLIENT" class="btn btn-secondary btn-sm">Client Signup</a></li>
                <li><a href="<%= request.getContextPath() %>/register?role=FREELANCER" class="btn btn-primary btn-sm">Freelancer Signup</a></li>
            <% } else if (currentUser.isClient()) { %>
                <li><a href="<%= request.getContextPath() %>/client/dashboard" class="nav-link">Dashboard</a></li>
                <li><a href="<%= request.getContextPath() %>/client/create-project" class="btn btn-primary btn-sm">Post Project</a></li>
                <li><a href="<%= request.getContextPath() %>/logout" class="nav-link">Logout</a></li>
            <% } else { %>
                <li><a href="<%= request.getContextPath() %>/freelancer/dashboard" class="nav-link">Dashboard</a></li>
                <li><a href="<%= request.getContextPath() %>/freelancer/profile" class="nav-link">My Profile</a></li>
                <li><a href="<%= request.getContextPath() %>/logout" class="nav-link">Logout</a></li>
            <% } %>
        </ul>
    </nav>

    <!-- Hero Section -->
    <section class="hero">
        <div class="container">
            <h1>SkillMatch</h1>
            <p>Connect Skills With Opportunities</p>
            <div class="hero-actions">
                <% if (currentUser == null) { %>
                    <a href="<%= request.getContextPath() %>/login" class="btn btn-secondary">Login</a>
                    <a href="<%= request.getContextPath() %>/register?role=CLIENT" class="btn btn-primary">Register as Client</a>
                    <a href="<%= request.getContextPath() %>/register?role=FREELANCER" class="btn btn-accent">Register as Freelancer</a>
                <% } else if (currentUser.isClient()) { %>
                    <a href="<%= request.getContextPath() %>/client/dashboard" class="btn btn-primary">Go to Client Dashboard</a>
                    <a href="<%= request.getContextPath() %>/client/create-project" class="btn btn-secondary">Post a New Project</a>
                <% } else { %>
                    <a href="<%= request.getContextPath() %>/freelancer/dashboard" class="btn btn-primary">Go to Freelancer Dashboard</a>
                    <a href="<%= request.getContextPath() %>/projects" class="btn btn-secondary">Browse Open Projects</a>
                <% } %>
            </div>
        </div>
    </section>

    <!-- Platform Highlights Section -->
    <section class="container" style="padding-top: 3rem; padding-bottom: 3rem;">
        <div class="stats-grid">
            <div class="card" style="text-align: center;">
                <div style="font-size: 2.25rem; margin-bottom: 0.5rem;">💼</div>
                <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 0.5rem;">Post Projects</h3>
                <p style="color: var(--text-muted); font-size: 0.95rem;">
                    Clients create detailed projects with budgets, requirements, and deadlines.
                </p>
            </div>
            <div class="card" style="text-align: center;">
                <div style="font-size: 2.25rem; margin-bottom: 0.5rem;">🚀</div>
                <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 0.5rem;">Submit Proposals</h3>
                <p style="color: var(--text-muted); font-size: 0.95rem;">
                    Skilled freelancers browse opportunities, showcase portfolio items, and pitch their rates.
                </p>
            </div>
            <div class="card" style="text-align: center;">
                <div style="font-size: 2.25rem; margin-bottom: 0.5rem;">💬</div>
                <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 0.5rem;">In-App Chat</h3>
                <p style="color: var(--text-muted); font-size: 0.95rem;">
                    Upon project award, collaborate directly with instant messaging history and tracking.
                </p>
            </div>
        </div>
    </section>

    <footer>
        <p>&copy; 2026 SkillMatch – A Web-Based Freelancer Marketplace Platform | B.Tech Mini Project</p>
    </footer>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
