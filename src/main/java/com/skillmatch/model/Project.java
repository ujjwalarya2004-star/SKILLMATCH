package com.skillmatch.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Project implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int clientId;
    private String title;
    private String description;
    private BigDecimal budget;
    private Date deadline;
    private String status; // 'OPEN', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED'
    private Timestamp createdAt;

    // Joined fields for display
    private String clientName;
    private String clientEmail;
    private int applicationCount;
    private String acceptedFreelancerName;
    private int acceptedFreelancerId;
    private List<String> requiredSkills = new ArrayList<>();

    public Project() {}

    public Project(int id, int clientId, String title, String description, BigDecimal budget, Date deadline, String status, Timestamp createdAt) {
        this.id = id;
        this.clientId = clientId;
        this.title = title;
        this.description = description;
        this.budget = budget;
        this.deadline = deadline;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public int getClientId() {
        return clientId;
    }
    public void setClientId(int clientId) {
        this.clientId = clientId;
    }

    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getBudget() {
        return budget;
    }
    public void setBudget(BigDecimal budget) {
        this.budget = budget;
    }

    public Date getDeadline() {
        return deadline;
    }
    public void setDeadline(Date deadline) {
        this.deadline = deadline;
    }

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getClientName() {
        return clientName;
    }
    public void setClientName(String clientName) {
        this.clientName = clientName;
    }

    public String getClientEmail() {
        return clientEmail;
    }
    public void setClientEmail(String clientEmail) {
        this.clientEmail = clientEmail;
    }

    public int getApplicationCount() {
        return applicationCount;
    }
    public void setApplicationCount(int applicationCount) {
        this.applicationCount = applicationCount;
    }

    public String getAcceptedFreelancerName() {
        return acceptedFreelancerName;
    }
    public void setAcceptedFreelancerName(String acceptedFreelancerName) {
        this.acceptedFreelancerName = acceptedFreelancerName;
    }

    public int getAcceptedFreelancerId() {
        return acceptedFreelancerId;
    }
    public void setAcceptedFreelancerId(int acceptedFreelancerId) {
        this.acceptedFreelancerId = acceptedFreelancerId;
    }

    public List<String> getRequiredSkills() {
        return requiredSkills;
    }
    public void setRequiredSkills(List<String> requiredSkills) {
        this.requiredSkills = requiredSkills;
    }
}
