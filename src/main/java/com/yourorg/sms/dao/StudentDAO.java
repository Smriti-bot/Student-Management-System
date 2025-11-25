package com.yourorg.sms.dao;

import com.yourorg.sms.model.Student;
import com.yourorg.sms.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    // ---------- CRUD OPERATIONS ---------- //

    private Connection getConnection() throws SQLException {
        return DBUtil.getConnection();
    }

    public List<Student> findAll() throws SQLException {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT * FROM students ORDER BY id DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    public Student findById(int id) throws SQLException {
        String sql = "SELECT * FROM students WHERE id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    public void create(Student s) throws SQLException {
        String sql = "INSERT INTO students (first_name, last_name, email, course, grade, enrollment_date) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, s.getFirstName());
            ps.setString(2, s.getLastName());
            ps.setString(3, s.getEmail());
            ps.setString(4, s.getCourse());
            ps.setString(5, s.getGrade());
            ps.setDate(6, s.getEnrollmentDate());

            ps.executeUpdate();
        }
    }

    public void update(Student s) throws SQLException {
        String sql = "UPDATE students SET first_name=?, last_name=?, email=?, course=?, grade=?, enrollment_date=? " +
                "WHERE id=?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, s.getFirstName());
            ps.setString(2, s.getLastName());
            ps.setString(3, s.getEmail());
            ps.setString(4, s.getCourse());
            ps.setString(5, s.getGrade());
            ps.setDate(6, s.getEnrollmentDate());
            ps.setInt(7, s.getId());

            ps.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM students WHERE id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    // ---------- SEARCH ---------- //

    public List<Student> search(String keyword) throws SQLException {
        List<Student> list = new ArrayList<>();

        // Defensive: treat null as empty string, trim whitespace
        if (keyword == null) keyword = "";
        keyword = keyword.trim();

        // If the keyword is empty, return all results (optional behavior)
        if (keyword.isEmpty()) {
            return findAll();
        }

        // Search first_name, last_name, email, course and full name
        String sql = "SELECT * FROM students " +
                "WHERE first_name LIKE ? OR last_name LIKE ? OR email LIKE ? OR course LIKE ? " +
                "OR CONCAT_WS(' ', first_name, last_name) LIKE ? " +
                "ORDER BY id DESC";

        String pattern = "%" + keyword + "%";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            ps.setString(4, pattern);
            ps.setString(5, pattern);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }


    // ---------- MAP RESULTSET TO OBJECT ---------- //

    private Student mapRow(ResultSet rs) throws SQLException {
        return new Student(
                rs.getInt("id"),
                rs.getString("first_name"),
                rs.getString("last_name"),
                rs.getString("email"),
                rs.getString("course"),
                rs.getString("grade"),
                rs.getDate("enrollment_date")
        );
    }
}
