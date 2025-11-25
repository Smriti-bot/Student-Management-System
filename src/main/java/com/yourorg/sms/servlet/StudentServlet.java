package com.yourorg.sms.servlet;

import com.yourorg.sms.dao.StudentDAO;
import com.yourorg.sms.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/students")
public class StudentServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(StudentServlet.class.getName());
    private StudentDAO dao;

    @Override
    public void init() {
        dao = new StudentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "add":
                    req.getRequestDispatcher("/WEB-INF/student-form.jsp").forward(req, resp);
                    break;
                case "edit":
                    openEditForm(req, resp);
                    break;
                case "delete":
                    deleteStudent(req, resp);
                    break;
                case "search":
                    searchStudents(req, resp);
                    break;
                default:
                    listStudents(req, resp);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in doGet", e);
            throw new ServletException(e);
        }
    }

    private void listStudents(HttpServletRequest req, HttpServletResponse resp) throws SQLException, ServletException, IOException {
        List<Student> students = dao.findAll();
        req.setAttribute("students", students);
        req.setAttribute("totalStudents", students == null ? 0 : students.size());
        req.getRequestDispatcher("/WEB-INF/student-list.jsp").forward(req, resp);
    }

    private void searchStudents(HttpServletRequest req, HttpServletResponse resp) throws SQLException, ServletException, IOException {
        String keyword = req.getParameter("keyword");
        if (keyword == null) keyword = "";
        List<Student> students = dao.search(keyword);
        req.setAttribute("students", students);
        req.setAttribute("totalStudents", students == null ? 0 : students.size());
        req.getRequestDispatcher("/WEB-INF/student-list.jsp").forward(req, resp);
    }

    private void openEditForm(HttpServletRequest req, HttpServletResponse resp) throws SQLException, ServletException, IOException {
        String idParam = req.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            req.getRequestDispatcher("/WEB-INF/student-form.jsp").forward(req, resp);
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException nfe) {
            LOGGER.log(Level.WARNING, "Invalid id parameter: {0}", idParam);
            resp.sendRedirect(req.getContextPath() + "/students");
            return;
        }

        Student s = dao.findById(id);
        if (s == null) {
            LOGGER.log(Level.WARNING, "Student with id {0} not found", id);
            resp.sendRedirect(req.getContextPath() + "/students");
            return;
        }

        req.setAttribute("student", s);
        req.getRequestDispatcher("/WEB-INF/student-form.jsp").forward(req, resp);
    }

    private void deleteStudent(HttpServletRequest req, HttpServletResponse resp) throws SQLException, IOException {
        String idParam = req.getParameter("id");
        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                dao.delete(id);
            } catch (NumberFormatException ex) {
                LOGGER.log(Level.WARNING, "Invalid id for delete: {0}", idParam);
            }
        }
        // Redirect to list so servlet sets totalStudents again
        resp.sendRedirect(req.getContextPath() + "/students?msg=Student+deleted");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String idStr = req.getParameter("id");

            Student s = new Student();
            s.setFirstName(req.getParameter("firstName"));
            s.setLastName(req.getParameter("lastName"));
            s.setEmail(req.getParameter("email"));
            s.setCourse(req.getParameter("course"));
            s.setGrade(req.getParameter("grade"));

            String dateString = req.getParameter("enrollmentDate");
            s.setEnrollmentDate(dateString == null || dateString.isEmpty() ? null : Date.valueOf(dateString));

            if (idStr == null || idStr.isEmpty()) {
                dao.create(s);
                resp.sendRedirect(req.getContextPath() + "/students?msg=Student+created");
            } else {
                s.setId(Integer.parseInt(idStr));
                dao.update(s);
                resp.sendRedirect(req.getContextPath() + "/students?msg=Student+updated");
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in doPost", e);
            throw new ServletException(e);
        }
    }
}
