<%@ page import="com.skillmatch.util.HtmlUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillmatch.model.*" %>
<%
    User currentUser = (User) session.getAttribute("user");
    FreelancerProfile profile = (FreelancerProfile) request.getAttribute("profile");
    Boolean isOwnerObj = (Boolean) request.getAttribute("isOwner");
    boolean isOwner = (isOwnerObj != null && isOwnerObj);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= HtmlUtil.escape(profile != null ? profile.getFreelancerName() : "Freelancer Profile") %> - SkillMatch</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="<%= request.getContextPath() %>/index.jsp" class="nav-brand">
            <span>⚡ SkillMatch</span>
            <span class="brand-badge">Profile</span>
        </a>
        <ul class="nav-links">
            <% if (currentUser != null) { %>
                <% if (currentUser.isClient()) { %>
                    <li><a href="<%= request.getContextPath() %>/client/dashboard" class="nav-link">Dashboard</a></li>
                    <li><a href="<%= request.getContextPath() %>/client/applications" class="nav-link">Applications</a></li>
                <% } else { %>
                    <li><a href="<%= request.getContextPath() %>/freelancer/dashboard" class="nav-link">Dashboard</a></li>
                    <li><a href="<%= request.getContextPath() %>/freelancer/my-applications" class="nav-link">Applications</a></li>
                    <li><a href="<%= request.getContextPath() %>/freelancer/profile" class="nav-link <%= isOwner ? "active" : "" %>">My Profile</a></li>
                <% } %>
                <li><a href="<%= request.getContextPath() %>/logout" class="nav-link">Logout</a></li>
            <% } else { %>
                <li><a href="<%= request.getContextPath() %>/login" class="nav-link">Sign In</a></li>
            <% } %>
        </ul>
    </nav>

    <div class="container" style="max-width: 860px;">
        <% if ("true".equals(request.getParameter("updated"))) { %>
            <div class="alert alert-success">Profile updated successfully!</div>
        <% } %>

        <% if (profile == null) { %>
            <div class="alert alert-danger">Profile could not be located.</div>
        <% } else { %>
            <!-- Profile Public Header View -->
            <div class="card" style="margin-bottom: 2rem;">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 1rem;">
                    <div>
                        <div style="display: flex; align-items: center; gap: 0.75rem;">
                            <h1 style="font-size: 1.85rem; font-weight: 800;"><%= HtmlUtil.escape(profile.getFreelancerName()) %></h1>
                            <span class="badge" style="background-color: #dbeafe; color: #1e40af;">Freelancer</span>
                        </div>
                        <p style="color: var(--text-muted); font-size: 0.95rem; margin-top: 0.25rem;">
                            <%= HtmlUtil.escape(profile.getFreelancerEmail()) %>
                            <% if (profile.getPhone() != null && !profile.getPhone().isEmpty()) { %>
                                &bull; <%= HtmlUtil.escape(profile.getPhone()) %>
                            <% } %>
                            <% if (profile.getLocation() != null && !profile.getLocation().isEmpty()) { %>
                                &bull; 📍 <%= HtmlUtil.escape(profile.getLocation()) %>
                            <% } %>
                        </p>
                    </div>

                    <% if (profile.getPortfolioUrl() != null && !profile.getPortfolioUrl().isEmpty()) { %>
                        <a href="<%= HtmlUtil.safeUrl(profile.getPortfolioUrl()) %>" target="_blank" rel="noopener noreferrer" class="btn btn-secondary btn-sm">
                            🌐 Visit Portfolio &nearr;
                        </a>
                    <% } %>
                </div>

                <!-- Expertise Section -->
                <% if (profile.getExpertise() != null && !profile.getExpertise().isEmpty()) { %>
                    <div style="margin-top: 1.25rem; background-color: #f1f5f9; padding: 0.75rem 1rem; border-radius: 8px;">
                        <span style="font-size: 0.8rem; font-weight: 700; color: #475569; text-transform: uppercase; letter-spacing: 0.05em; display: block; margin-bottom: 0.2rem;">
                            Areas of Expertise
                        </span>
                        <div style="font-size: 0.95rem; font-weight: 600; color: #1e293b;">
                            <%= HtmlUtil.escape(profile.getExpertise()) %>
                        </div>
                    </div>
                <% } %>

                <!-- Bio -->
                <div style="margin-top: 1.25rem;">
                    <h3 style="font-size: 1rem; font-weight: 700; margin-bottom: 0.4rem; color: #334155;">About / Bio</h3>
                    <p style="font-size: 0.95rem; line-height: 1.6; color: #475569; white-space: pre-line;">
                        <%= HtmlUtil.escape((profile.getBio() != null && !profile.getBio().isEmpty()) ? profile.getBio() : "No bio provided yet.") %>
                    </p>
                </div>

                <!-- Skills -->
                <div style="margin-top: 1.25rem; border-top: 1px solid var(--border); padding-top: 1rem;">
                    <h3 style="font-size: 1rem; font-weight: 700; margin-bottom: 0.5rem; color: #334155;">Technical Skills</h3>
                    <% if (profile.getSkills() != null && !profile.getSkills().isEmpty()) { %>
                        <div>
                            <% for (Skill s : profile.getSkills()) { %>
                                <span class="skill-tag"><%= HtmlUtil.escape(s.getSkillName()) %></span>
                            <% } %>
                        </div>
                    <% } else { %>
                        <p style="font-size: 0.85rem; color: var(--text-muted);">No skills assigned.</p>
                    <% } %>
                </div>

                <!-- Past Project Highlights -->
                <% if (profile.getPastProjects() != null && !profile.getPastProjects().isEmpty()) { %>
                    <div style="margin-top: 1.25rem; border-top: 1px solid var(--border); padding-top: 1rem;">
                        <h3 style="font-size: 1rem; font-weight: 700; margin-bottom: 0.5rem; color: #334155;">Past Project Highlights</h3>
                        <div style="font-size: 0.925rem; line-height: 1.6; color: #334155; white-space: pre-line; background-color: #f8fafc; padding: 1rem; border-radius: 8px; border: 1px solid var(--border);">
                            <%= HtmlUtil.escape(profile.getPastProjects()) %>
                        </div>
                    </div>
                <% } %>
            </div>

            <!-- Profile Edit Section (Only visible to the account owner) -->
            <% if (isOwner) { %>
                <div class="card">
                    <h2 style="font-size: 1.35rem; font-weight: 700; margin-bottom: 0.5rem;">Edit Profile Details</h2>
                    <p style="color: var(--text-muted); font-size: 0.9rem; margin-bottom: 1.5rem;">
                        Keep your portfolio, expertise, and project highlights up to date
                    </p>

                    <form action="<%= request.getContextPath() %>/freelancer/profile" method="POST">
                        <div class="form-group">
                            <label class="form-label" for="bio">Professional Bio</label>
                            <textarea id="bio" name="bio" class="form-control" rows="4" 
                                      placeholder="Summarize your professional background, passions, and core services..."><%= HtmlUtil.escape(profile.getBio()) %></textarea>
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                            <div class="form-group">
                                <label class="form-label" for="experience">Experience Level</label>
                                <input type="text" id="experience" name="experience" class="form-control" 
                                       value="<%= HtmlUtil.escape(profile.getExperience()) %>" placeholder="e.g. 3+ Years / Senior">
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="location">Location</label>
                                <input type="text" id="location" name="location" class="form-control" 
                                       value="<%= HtmlUtil.escape(profile.getLocation()) %>" placeholder="e.g. New York, USA">
                            </div>
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                            <div class="form-group">
                                <label class="form-label" for="phone">Phone Number</label>
                                <input type="text" id="phone" name="phone" class="form-control" 
                                       value="<%= HtmlUtil.escape(profile.getPhone()) %>" placeholder="+1 555-019-2834">
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="portfolioUrl">Portfolio / Website URL</label>
                                <input type="url" id="portfolioUrl" name="portfolioUrl" class="form-control" 
                                       value="<%= HtmlUtil.escape(profile.getPortfolioUrl()) %>" 
                                       placeholder="https://myportfolio.dev">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="expertise">Areas of Expertise</label>
                            <input type="text" id="expertise" name="expertise" class="form-control" 
                                   value="<%= HtmlUtil.escape(profile.getExpertise() != null ? profile.getExpertise() : "") %>" 
                                   placeholder="e.g. Enterprise Web Systems, High-throughput SQL, REST APIs">
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="pastProjects">Past Project Highlights</label>
                            <textarea id="pastProjects" name="pastProjects" class="form-control" rows="4" 
                                      placeholder="List 2-3 notable projects with achievements or links..."><%= HtmlUtil.escape(profile.getPastProjects() != null ? profile.getPastProjects() : "") %></textarea>
                        </div>

                        <div style="display: flex; gap: 1rem;">
                            <button type="submit" class="btn btn-primary" style="flex: 1;">Save Profile Changes</button>
                            <a href="<%= request.getContextPath() %>/freelancer/skills" class="btn btn-secondary">Manage Skills &rarr;</a>
                        </div>
                    </form>
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
