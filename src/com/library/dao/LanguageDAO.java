package com.library.dao;

import com.library.entity.Language;
import com.library.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LanguageDAO {
    private Connection connection;
    
    public LanguageDAO() {
        this.connection = DatabaseConnection.getConnection();
    }
    
    public List<Language> getAllLanguages() {
        List<Language> languages = new ArrayList<>();
        String sql = "SELECT * FROM languages ORDER BY language_name";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                languages.add(mapResultSetToLanguage(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return languages;
    }
    
    public Language getLanguageById(int languageId) {
        String sql = "SELECT * FROM languages WHERE language_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, languageId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToLanguage(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public Language getLanguageByCode(String languageCode) {
        String sql = "SELECT * FROM languages WHERE language_code = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, languageCode);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToLanguage(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean addLanguage(Language language) {
        String sql = "INSERT INTO languages (language_code, language_name) VALUES (?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, language.getLanguageCode());
            stmt.setString(2, language.getLanguageName());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    language.setLanguageId(generatedKeys.getInt(1));
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updateLanguage(Language language) {
        String sql = "UPDATE languages SET language_code=?, language_name=? WHERE language_id=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, language.getLanguageCode());
            stmt.setString(2, language.getLanguageName());
            stmt.setInt(3, language.getLanguageId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean deleteLanguage(int languageId) {
        String sql = "DELETE FROM languages WHERE language_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, languageId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private Language mapResultSetToLanguage(ResultSet rs) throws SQLException {
        Language language = new Language();
        language.setLanguageId(rs.getInt("language_id"));
        language.setLanguageCode(rs.getString("language_code"));
        language.setLanguageName(rs.getString("language_name"));
        return language;
    }
}

