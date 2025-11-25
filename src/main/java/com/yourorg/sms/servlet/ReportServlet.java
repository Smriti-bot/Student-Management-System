package com.yourorg.sms.servlet;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.yourorg.sms.dao.StudentDAO;
import com.yourorg.sms.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/downloadReport")
public class ReportServlet extends HttpServlet {

    private final StudentDAO dao = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String type = req.getParameter("type"); // expected: "csv" or "pdf"
        if (type == null) type = "csv";

        try {
            List<Student> students = dao.findAll();

            if ("pdf".equalsIgnoreCase(type)) {
                downloadPDF(students, resp);
            } else {
                downloadCSV(students, resp);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void downloadCSV(List<Student> students, HttpServletResponse resp) throws IOException {
        resp.setContentType("text/csv");
        resp.setHeader("Content-Disposition", "attachment; filename=\"students.csv\"");

        try (PrintWriter writer = resp.getWriter()) {
            // header
            writer.println("ID,First Name,Last Name,Email,Course,Grade,Enrollment Date");

            for (Student s : students) {
                String line = String.format("%d,%s,%s,%s,%s,%s,%s",
                        s.getId(),
                        safe(s.getFirstName()),
                        safe(s.getLastName()),
                        safe(s.getEmail()),
                        safe(s.getCourse()),
                        safe(s.getGrade()),
                        s.getEnrollmentDate() == null ? "" : s.getEnrollmentDate().toString()
                );
                writer.println(line);
            }
            writer.flush();
        }
    }

    private void downloadPDF(List<Student> students, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/pdf");
        resp.setHeader("Content-Disposition", "attachment; filename=\"students.pdf\"");

        Document document = new Document(PageSize.A4.rotate(), 36, 36, 54, 36);
        try {
            PdfWriter.getInstance(document, resp.getOutputStream());
            document.open();

            // Title
            Font titleFont = new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD);
            Paragraph title = new Paragraph("Student Report", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(12f);
            document.add(title);

            // Table with 7 columns
            PdfPTable table = new PdfPTable(7);
            table.setWidthPercentage(100);
            table.setSpacingBefore(6f);
            table.setSpacingAfter(6f);

            // Header row
            Font headerFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
            table.addCell(new Phrase("ID", headerFont));
            table.addCell(new Phrase("First Name", headerFont));
            table.addCell(new Phrase("Last Name", headerFont));
            table.addCell(new Phrase("Email", headerFont));
            table.addCell(new Phrase("Course", headerFont));
            table.addCell(new Phrase("Grade", headerFont));
            table.addCell(new Phrase("Enrollment Date", headerFont));

            // Rows
            Font rowFont = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL);
            for (Student s : students) {
                table.addCell(new Phrase(String.valueOf(s.getId()), rowFont));
                table.addCell(new Phrase(safe(s.getFirstName()), rowFont));
                table.addCell(new Phrase(safe(s.getLastName()), rowFont));
                table.addCell(new Phrase(safe(s.getEmail()), rowFont));
                table.addCell(new Phrase(safe(s.getCourse()), rowFont));
                table.addCell(new Phrase(safe(s.getGrade()), rowFont));
                table.addCell(new Phrase(s.getEnrollmentDate() == null ? "" : s.getEnrollmentDate().toString(), rowFont));
            }

            document.add(table);
        } catch (DocumentException de) {
            throw new IOException("Error creating PDF: " + de.getMessage(), de);
        } finally {
            document.close();
        }
    }

    // helper to escape nulls and remove newlines/commas minimally for CSV simplicity
    private String safe(String s) {
        if (s == null) return "";
        // remove new lines and carriage returns, and wrap fields containing comma in quotes
        String clean = s.replace("\n", " ").replace("\r", " ");
        if (clean.contains(",")) {
            // escape double quotes
            clean = "\"" + clean.replace("\"", "\"\"") + "\"";
        }
        return clean;
    }
}
