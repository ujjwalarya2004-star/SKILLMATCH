<%@ page import="com.skillmatch.util.HtmlUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.skillmatch.model.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.isFreelancer()) {
        response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
        return;
    }

    List<Skill> allSkills = (List<Skill>) request.getAttribute("allSkills");
    if (allSkills == null) allSkills = new ArrayList<>();
    List<Skill> mySkills = (List<Skill>) request.getAttribute("mySkills");
    if (mySkills == null) mySkills = new ArrayList<>();

    Set<Integer> mySkillIds = new HashSet<>();
    for (Skill s : mySkills) {
        mySkillIds.add(s.getId());
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Skills - SkillMatch</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="<%= request.getContextPath() %>/freelancer/dashboard" class="nav-brand">
            <span>⚡ SkillMatch</span>
            <span class="brand-badge">Skills</span>
        </a>
        <ul class="nav-links">
            <li><a href="<%= request.getContextPath() %>/freelancer/dashboard" class="nav-link">Dashboard</a></li>
            <li><a href="<%= request.getContextPath() %>/freelancer/skills" class="nav-link active">My Skills</a></li>
            <li><a href="<%= request.getContextPath() %>/freelancer/profile" class="nav-link">My Profile</a></li>
            <li><a href="<%= request.getContextPath() %>/logout" class="nav-link">Logout</a></li>
        </ul>
    </nav>

    <div class="container" style="max-width: 800px;">
        <h1 style="font-size: 1.75rem; font-weight: 700; margin-bottom: 0.5rem;">Manage Technical Skills</h1>
        <p style="color: var(--text-muted); font-size: 0.95rem; margin-bottom: 1.5rem;">
            Clients review your verified skill badges when evaluating proposals
        </p>

        <!-- Current Skills Card -->
        <div class="card">
            <h2 style="font-size: 1.2rem; font-weight: 700; margin-bottom: 1rem;">My Active Skills (<%= mySkills.size() %>)</h2>

            <% if (mySkills.isEmpty()) { %>
                <p style="color: var(--text-muted); font-size: 0.9rem;">No skills added yet. Select from the available list below.</p>
            <% } else { %>
                <div style="display: flex; flex-wrap: wrap; gap: 0.5rem;">
                    <% for (Skill s : mySkills) { %>
                        <div style="display: inline-flex; align-items: center; gap: 0.4rem; background: #eff6ff; color: #1e40af; border: 1px solid #bfdbfe; padding: 0.35rem 0.75rem; border-radius: 9999px; font-size: 0.875rem; font-weight: 600;">
                            <span><%= HtmlUtil.escape(s.getSkillName()) %></span>
                            <form action="<%= request.getContextPath() %>/freelancer/skills" method="POST" style="margin: 0; display: inline;">
                                <input type="hidden" name="action" value="remove">
                                <input type="hidden" name="skillId" value="<%= s.getId() %>">
                                <button type="submit" style="background: none; border: none; cursor: pointer; color: #ef4444; font-weight: bold; font-size: 0.9rem; padding: 0 0.2rem;" title="Remove skill">&times;</button>
                            </form>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>

        <!-- Add from Existing Catalog Card -->
        <div class="card">
            <h2 style="font-size: 1.2rem; font-weight: 700; margin-bottom: 0.5rem;">Add from Catalog</h2>
            <p style="color: var(--text-muted); font-size: 0.85rem; margin-bottom: 1rem;">Click any skill below to add it to your profile</p>

            <div style="display: flex; flex-wrap: wrap; gap: 0.5rem;">
                <% for (Skill s : allSkills) { %>
                    <% if (!mySkillIds.contains(s.getId())) { %>
                        <form action="<%= request.getContextPath() %>/freelancer/skills" method="POST" style="margin: 0; display: inline;">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="skillId" value="<%= s.getId() %>">
                            <button type="submit" class="btn btn-secondary btn-sm" style="border-radius: 9999px;">
                                + <%= HtmlUtil.escape(s.getSkillName()) %>
                            </button>
                        </form>
                    <% } %>
                <% } %>
            </div>
        </div>

        <!-- Add Custom Skill Card -->
        <div class="card">
            <h2 style="font-size: 1.2rem; font-weight: 700; margin-bottom: 0.5rem;">Add a New Custom Skill</h2>
            <p style="color: var(--text-muted); font-size: 0.85rem; margin-bottom: 1rem;">Can't find your specialty? Enter a new skill name</p>

            <form action="<%= request.getContextPath() %>/freelancer/skills" method="POST" style="display: flex; gap: 0.75rem;">
                <input type="hidden" name="action" value="create">
                <input type="text" name="skillName" class="form-control" placeholder="e.g. Flutter, GraphQL, Docker..." required style="flex: 1;">
                <button type="submit" class="btn btn-primary">Add Skill</button>
            </form>
        </div>
    </div>

    <footer>
        <p>&copy; 2026 SkillMatch Marketplace</p>
    </footer>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
