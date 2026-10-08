<%@ page import="com.skillmatch.util.HtmlUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.skillmatch.model.*" %>
<%
    User user = (User) session.getAttribute("user");
    List<Project> projects = (List<Project>) request.getAttribute("projects");
    if (projects == null) projects = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Available Projects - SkillMatch</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="<%= request.getContextPath() %>/index.jsp" class="nav-brand">
            <span>⚡ SkillMatch</span>
            <span class="brand-badge">Explore</span>
        </a>
        <ul class="nav-links">
            <% if (user != null && user.isFreelancer()) { %>
                <li><a href="<%= request.getContextPath() %>/freelancer/dashboard" class="nav-link">Dashboard</a></li>
                <li><a href="<%= request.getContextPath() %>/freelancer/projects" class="nav-link active">Browse Projects</a></li>
                <li><a href="<%= request.getContextPath() %>/freelancer/applications" class="nav-link">My Applications</a></li>
                <li><a href="<%= request.getContextPath() %>/freelancer/skills" class="nav-link">Skills</a></li>
                <li><a href="<%= request.getContextPath() %>/freelancer/profile" class="nav-link">Profile</a></li>
                <li><a href="<%= request.getContextPath() %>/logout" class="nav-link">Logout</a></li>
            <% } else if (user != null && user.isClient()) { %>
                <li><a href="<%= request.getContextPath() %>/client/dashboard" class="nav-link">Client Dashboard</a></li>
                <li><a href="<%= request.getContextPath() %>/logout" class="nav-link">Logout</a></li>
            <% } else { %>
                <li><a href="<%= request.getContextPath() %>/login" class="nav-link">Sign In</a></li>
                <li><a href="<%= request.getContextPath() %>/register?role=FREELANCER" class="btn btn-primary btn-sm">Join as Freelancer</a></li>
            <% } %>
        </ul>
    </nav>

    <div class="container">
        <div style="margin-bottom: 2rem;">
            <h1 style="font-size: 2rem; font-weight: 800;">Available Projects</h1>
            <p style="color: var(--text-muted); font-size: 1rem;">
                Browse open opportunities, submit competitive proposals, and connect directly with clients
            </p>
        </div>

        <% if (projects.isEmpty()) { %>
            <div class="card" style="text-align: center; padding: 4rem 1rem; color: var(--text-muted);">
                <div style="font-size: 3rem; margin-bottom: 1rem;">🔍</div>
                <h2>No Open Projects Available</h2>
                <p style="margin-top: 0.5rem;">Check back shortly for new project postings.</p>
            </div>
        <% } else { %>
            <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr)); gap: 1.5rem;">
                <% for (Project p : projects) { %>
                    <div class="card" style="display: flex; flex-direction: column; justify-content: space-between; margin-bottom: 0;">
                        <div>
                            <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 0.75rem;">
                                <span class="badge badge-open">OPEN</span>
                                <span style="font-size: 1.25rem; font-weight: 800; color: #0f172a;">
                                    $<%= String.format("%.2f", p.getBudget()) %>
                                </span>
                            </div>

                            <h2 style="font-size: 1.2rem; font-weight: 700; margin-bottom: 0.5rem; line-height: 1.3;">
                                <a href="<%= request.getContextPath() %>/project-details?id=<%= p.getId() %>" style="color: inherit; text-decoration: none;">
                                    <%= HtmlUtil.escape(p.getTitle()) %>
                                </a>
                            </h2>

                            <p style="color: var(--text-muted); font-size: 0.9rem; line-height: 1.45; margin-bottom: 1rem; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden;">
                                <%= HtmlUtil.escape(p.getDescription()) %>
                            </p>
                        </div>

                        <div style="border-top: 1px solid var(--border); padding-top: 1rem; margin-top: 0.5rem;">
                            <div style="display: flex; justify-content: space-between; font-size: 0.8rem; color: var(--text-muted); margin-bottom: 1rem;">
                                <span>Client: <strong><%= HtmlUtil.escape(p.getClientName()) %></strong></span>
                                <span>Deadline: <strong><%= p.getDeadline() %></strong></span>
                            </div>

                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <span style="font-size: 0.8rem; color: var(--text-muted);">
                                    <%= p.getApplicationCount() %> Proposals
                                </span>
                                <a href="<%= request.getContextPath() %>/project-details?id=<%= p.getId() %>" class="btn btn-primary btn-sm">
                                    View Details &rarr;
                                </a>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>

    <footer>
        <p>&copy; 2026 SkillMatch Marketplace</p>
    </footer>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
