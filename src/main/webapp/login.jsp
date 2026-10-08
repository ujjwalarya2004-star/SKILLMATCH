<%@ page import="com.skillmatch.util.HtmlUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - SkillMatch</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="<%= request.getContextPath() %>/index.jsp" class="nav-brand">
            <span>⚡ SkillMatch</span>
        </a>
        <ul class="nav-links">
            <li><a href="<%= request.getContextPath() %>/projects" class="nav-link">Browse Projects</a></li>
            <li><a href="<%= request.getContextPath() %>/register" class="nav-link">Create Account</a></li>
        </ul>
    </nav>

    <div class="container" style="max-width: 460px; margin-top: 2.5rem;">
        <div class="card">
            <h2 style="font-size: 1.5rem; font-weight: 700; margin-bottom: 0.5rem; text-align: center;">Welcome Back</h2>
            <p style="text-align: center; color: var(--text-muted); font-size: 0.9rem; margin-bottom: 1.5rem;">
                Sign in to your SkillMatch account
            </p>

            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-danger">
                    <%= HtmlUtil.escape(request.getAttribute("errorMessage")) %>
                </div>
            <% } %>

            <% if ("true".equals(request.getParameter("loggedOut"))) { %>
                <div class="alert alert-success">
                    You have successfully logged out.
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/login" method="POST">
                <div class="form-group">
                    <label class="form-label" for="email">Email Address</label>
                    <input type="email" id="email" name="email" class="form-control" 
                           value="<%= HtmlUtil.escape(request.getAttribute("email") != null ? request.getAttribute("email") : "") %>" 
                           required autofocus placeholder="name@domain.com">
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" 
                           required placeholder="••••••••">
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 0.5rem;">
                    Sign In
                </button>
            </form>

            <div style="margin-top: 1.5rem; padding-top: 1rem; border-top: 1px solid var(--border); text-align: center; font-size: 0.875rem;">
                <p style="color: var(--text-muted); margin-bottom: 0.5rem;">Don't have an account?</p>
                <a href="<%= request.getContextPath() %>/register?role=CLIENT" style="color: var(--primary); text-decoration: none; font-weight: 600; margin-right: 0.75rem;">Client Signup</a>
                <span>•</span>
                <a href="<%= request.getContextPath() %>/register?role=FREELANCER" style="color: var(--primary); text-decoration: none; font-weight: 600; margin-left: 0.75rem;">Freelancer Signup</a>
            </div>

            <!-- Demo Credentials Helper -->
            <div style="margin-top: 1.25rem; background: #f8fafc; border: 1px dashed #cbd5e1; border-radius: 8px; padding: 0.85rem; font-size: 0.8rem; color: #475569;">
                <strong>Sample Logins (from skillmatch_db.sql):</strong><br>
                • <strong>Client:</strong> <code>client@skillmatch.com</code> / <code>client123</code><br>
                • <strong>Freelancer:</strong> <code>freelancer@skillmatch.com</code> / <code>freelancer123</code>
            </div>
        </div>
    </div>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
