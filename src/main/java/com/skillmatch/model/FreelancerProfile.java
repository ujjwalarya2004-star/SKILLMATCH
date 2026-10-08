package com.skillmatch.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class FreelancerProfile implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int userId;
    private String bio;
    private String experience;
    private String phone;
    private String location;
    private String portfolioUrl;
    private String expertise;
    private String pastProjects;
    
    // Joined data for presentation
    private String freelancerName;
    private String freelancerEmail;
    private List<Skill> skills = new ArrayList<>();

    public FreelancerProfile() {}

    public FreelancerProfile(int id, int userId, String bio, String experience, String phone, String location, String portfolioUrl, String expertise, String pastProjects) {
        this.id = id;
        this.userId = userId;
        this.bio = bio;
        this.experience = experience;
        this.phone = phone;
        this.location = location;
        this.portfolioUrl = portfolioUrl;
        this.expertise = expertise;
        this.pastProjects = pastProjects;
    }

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }
    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getBio() {
        return bio;
    }
    public void setBio(String bio) {
        this.bio = bio;
    }

    public String getExperience() {
        return experience;
    }
    public void setExperience(String experience) {
        this.experience = experience;
    }

    public String getPhone() {
        return phone;
    }
    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getLocation() {
        return location;
    }
    public void setLocation(String location) {
        this.location = location;
    }

    public String getPortfolioUrl() {
        return portfolioUrl;
    }
    public void setPortfolioUrl(String portfolioUrl) {
        this.portfolioUrl = portfolioUrl;
    }

    public String getExpertise() {
        return expertise;
    }
    public void setExpertise(String expertise) {
        this.expertise = expertise;
    }

    public String getPastProjects() {
        return pastProjects;
    }
    public void setPastProjects(String pastProjects) {
        this.pastProjects = pastProjects;
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

    public List<Skill> getSkills() {
        return skills;
    }
    public void setSkills(List<Skill> skills) {
        this.skills = skills;
    }
}
