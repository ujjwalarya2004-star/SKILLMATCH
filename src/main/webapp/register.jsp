<%@ page import="com.skillmatch.util.HtmlUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String selectedRole = (String) request.getAttribute("selectedRole");
    if (selectedRole == null) {
        selectedRole = request.getParameter("role");
    }
    if (selectedRole == null || selectedRole.isEmpty()) {
        selectedRole = "FREELANCER";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - SkillMatch</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="<%= request.getContextPath() %>/index.jsp" class="nav-brand">
            <span>⚡ SkillMatch</span>
        </a>
        <ul class="nav-links">
            <li><a href="<%= request.getContextPath() %>/login" class="nav-link">Sign In</a></li>
        </ul>
    </nav>

    <div class="container" style="max-width: 520px; margin-top: 2rem;">
        <div class="card">
            <h2 style="font-size: 1.5rem; font-weight: 700; margin-bottom: 0.5rem; text-align: center;">Join SkillMatch</h2>
            <p style="text-align: center; color: var(--text-muted); font-size: 0.9rem; margin-bottom: 1.5rem;">
                Create a client or freelancer account
            </p>

            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-danger">
                    <%= HtmlUtil.escape(request.getAttribute("errorMessage")) %>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/register" method="POST">
                <div class="form-group">
                    <label class="form-label">I want to:</label>
                    <div style="display: flex; gap: 1rem;">
                        <label style="flex: 1; border: 1px solid var(--border); padding: 0.75rem; border-radius: 8px; cursor: pointer; display: flex; align-items: center; gap: 0.5rem;">
                            <input type="radio" name="role" value="CLIENT" <%= "CLIENT".equalsIgnoreCase(selectedRole) ? "checked" : "" %>>
                            <div>
                                <strong style="font-size: 0.9rem; display: block;">Hire Freelancers</strong>
                                <span style="font-size: 0.75rem; color: var(--text-muted);">Client Account</span>
                            </div>
                        </label>
                        <label style="flex: 1; border: 1px solid var(--border); padding: 0.75rem; border-radius: 8px; cursor: pointer; display: flex; align-items: center; gap: 0.5rem;">
                            <input type="radio" name="role" value="FREELANCER" <%= "FREELANCER".equalsIgnoreCase(selectedRole) ? "checked" : "" %>>
                            <div>
                                <strong style="font-size: 0.9rem; display: block;">Work on Projects</strong>
                                <span style="font-size: 0.75rem; color: var(--text-muted);">Freelancer Account</span>
                            </div>
                        </label>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="name">Full Name / Organization</label>
                    <input type="text" id="name" name="name" class="form-control" 
                           value="<%= HtmlUtil.escape(request.getAttribute("name") != null ? request.getAttribute("name") : "") %>" 
                           required placeholder="e.g. John Doe or Tech Solutions">
                </div>

                <div class="form-group">
                    <label class="form-label" for="email">Email Address</label>
                    <input type="email" id="email" name="email" class="form-control" 
                           value="<%= HtmlUtil.escape(request.getAttribute("email") != null ? request.getAttribute("email") : "") %>" 
                           required placeholder="name@domain.com">
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Password (min 6 characters)</label>
                    <input type="password" id="password" name="password" minlength="6" class="form-control" 
                           required placeholder="••••••••">
                </div>

                <div class="form-group">
                    <label class="form-label" for="confirmPassword">Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" minlength="6" class="form-control" 
                           required placeholder="••••••••">
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 0.5rem;">
                    Create Account
                </button>
            </form>

            <div style="margin-top: 1.5rem; padding-top: 1rem; border-top: 1px solid var(--border); text-align: center; font-size: 0.875rem;">
                <span style="color: var(--text-muted);">Already have an account?</span>
                <a href="<%= request.getContextPath() %>/login" style="color: var(--primary); text-decoration: none; font-weight: 600; margin-left: 0.5rem;">Sign In</a>
            </div>
        </div>
    </div>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
