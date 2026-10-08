package com.skillmatch.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Application implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int projectId;
    private int freelancerId;
    private String proposal;
    private BigDecimal proposedBudget;
    private String status; // 'PENDING', 'ACCEPTED', 'REJECTED'
    private Timestamp appliedAt;

    // Joined fields for display
    private String freelancerName;
    private String freelancerEmail;
    private String freelancerExperience;
    private String freelancerPortfolioUrl;
    private String projectTitle;
    private BigDecimal projectBudget;
    private String projectStatus;
    private List<Skill> freelancerSkills = new ArrayList<>();

    public Application() {}

    public Application(int id, int projectId, int freelancerId, String proposal, BigDecimal proposedBudget, String status, Timestamp appliedAt) {
        this.id = id;
        this.projectId = projectId;
        this.freelancerId = freelancerId;
        this.proposal = proposal;
        this.proposedBudget = proposedBudget;
        this.status = status;
        this.appliedAt = appliedAt;
    }

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public int getProjectId() {
        return projectId;
    }
    public void setProjectId(int projectId) {
        this.projectId = projectId;
    }

    public int getFreelancerId() {
        return freelancerId;
    }
    public void setFreelancerId(int freelancerId) {
        this.freelancerId = freelancerId;
    }

    public String getProposal() {
        return proposal;
    }
    public void setProposal(String proposal) {
        this.proposal = proposal;
    }

    public BigDecimal getProposedBudget() {
        return proposedBudget;
    }
    public void setProposedBudget(BigDecimal proposedBudget) {
        this.proposedBudget = proposedBudget;
    }

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getAppliedAt() {
        return appliedAt;
    }
    public void setAppliedAt(Timestamp appliedAt) {
        this.appliedAt = appliedAt;
    }

    public String getFreelancerName() {
        return freelancerName;
    }
    public void setFreelancerName(String freelancerName) {
        this.freelancerName = freelancerName;
    }

    public String getFreelancerEmail() {
        return freelancerEmail;
    }
    public void setFreelancerEmail(String freelancerEmail) {
        this.freelancerEmail = freelancerEmail;
    }

    public String getFreelancerExperience() {
        return freelancerExperience;
    }
    public void setFreelancerExperience(String freelancerExperience) {
        this.freelancerExperience = freelancerExperience;
    }

    public String getFreelancerPortfolioUrl() {
        return freelancerPortfolioUrl;
    }
    public void setFreelancerPortfolioUrl(String freelancerPortfolioUrl) {
        this.freelancerPortfolioUrl = freelancerPortfolioUrl;
    }

    public String getProjectTitle() {
        return projectTitle;
    }
    public void setProjectTitle(String projectTitle) {
        this.projectTitle = projectTitle;
    }

    public BigDecimal getProjectBudget() {
        return projectBudget;
    }
    public void setProjectBudget(BigDecimal projectBudget) {
        this.projectBudget = projectBudget;
    }

    public String getProjectStatus() {
        return projectStatus;
    }
    public void setProjectStatus(String projectStatus) {
        this.projectStatus = projectStatus;
    }

    public List<Skill> getFreelancerSkills() {
        return freelancerSkills;
    }
    public void setFreelancerSkills(List<Skill> freelancerSkills) {
        this.freelancerSkills = freelancerSkills;
    }
}
