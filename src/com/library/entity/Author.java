package com.library.entity;

import java.sql.Date;
import java.sql.Timestamp;

public class Author {
    private int authorId;
    private String firstName;
    private String lastName;
    private String fullName;
    private Date birthDate;
    private Date deathDate;
    private String nationality;
    private String biography;
    private String website;
    private String awards;
    private Timestamp createdAt;
    
    // Getters and Setters
    public int getAuthorId() {
        return authorId;
    }
    
    public void setAuthorId(int authorId) {
        this.authorId = authorId;
    }
    
    public String getFirstName() {
        return firstName;
    }
    
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }
    
    public String getLastName() {
        return lastName;
    }
    
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public Date getBirthDate() {
        return birthDate;
    }
    
    public void setBirthDate(Date birthDate) {
        this.birthDate = birthDate;
    }
    
    public Date getDeathDate() {
        return deathDate;
    }
    
    public void setDeathDate(Date deathDate) {
        this.deathDate = deathDate;
    }
    
    public String getNationality() {
        return nationality;
    }
    
    public void setNationality(String nationality) {
        this.nationality = nationality;
    }
    
    public String getBiography() {
        return biography;
    }
    
    public void setBiography(String biography) {
        this.biography = biography;
    }
    
    public String getWebsite() {
        return website;
    }
    
    public void setWebsite(String website) {
        this.website = website;
    }
    
    public String getAwards() {
        return awards;
    }
    
    public void setAwards(String awards) {
        this.awards = awards;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}

