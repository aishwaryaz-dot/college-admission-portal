package com.college.servlet;

import com.college.dao.ApplicationDAO;
import com.college.dao.DocumentDAO;
import com.college.dao.MessageDAO;
import com.college.model.Application;
import com.college.model.Document;
import com.college.model.User;
import com.college.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.sql.SQLException;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.time.DateTimeException;
import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.UUID;
import java.time.format.DateTimeParseException;

@WebServlet("/application/*")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class ApplicationServlet extends HttpServlet {
    private ApplicationDAO applicationDAO;
    private DocumentDAO documentDAO;
    private static final String UPLOAD_DIRECTORY = "uploads";

    @Override
    public void init() throws ServletException {
        applicationDAO = new ApplicationDAO();
        documentDAO = new DocumentDAO();
        
        // Create upload directory if it doesn't exist
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if ("/list".equals(pathInfo)) {
                handleListApplications(request, response);
            } else if ("/view".equals(pathInfo)) {
                handleViewApplication(request, response);
            } else if ("/new".equals(pathInfo)) {
                handleNewApplication(request, response);
            } else if ("/update-status".equals(pathInfo)) {
                handleUpdateStatus(request, response);
            } else if ("/download".equals(pathInfo)) {
                handleDownloadDocument(request, response);
            } else if ("/delete".equals(pathInfo)) {
                handleDeleteApplication(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if ("/submit".equals(pathInfo)) {
                handleSubmitApplication(request, response);
            } else if ("/delete".equals(pathInfo)) {
                handleDeleteApplication(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    private void handleListApplications(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        List<Application> applications;
        if ("ADMIN".equals(user.getRole())) {
            applications = applicationDAO.getAllApplications();
        } else {
            applications = applicationDAO.getApplicationsByUserId(user.getId());
        }
        
        request.setAttribute("applications", applications);
        request.getRequestDispatcher("/WEB-INF/views/applications.jsp").forward(request, response);
    }

    private void handleViewApplication(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/application/list");
            return;
        }
        
        try {
            Long applicationId = Long.parseLong(idParam);
            Application application = applicationDAO.getApplicationById(applicationId);
            
            if (application == null) {
                response.sendRedirect(request.getContextPath() + "/application/list?error=notfound");
                return;
            }
            
            List<Document> documents = documentDAO.getDocumentsByApplicationId(applicationId);
            request.setAttribute("documents", documents);
            request.setAttribute("application", application);
            request.getRequestDispatcher("/student/view-application.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/application/list?error=invalid");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to view application: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private void handleNewApplication(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        if (user == null || "ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        request.getRequestDispatcher("/WEB-INF/views/application-form.jsp").forward(request, response);
    }

    private void handleSubmitApplication(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get the logged-in user
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            // Create the application object
            Application application = new Application();
            
            // Create student object
            Student student = new Student();
            student.setFirstName(request.getParameter("firstName"));
            student.setLastName(request.getParameter("lastName"));
            
            // Parse and set date of birth
            String dateOfBirth = request.getParameter("dateOfBirth");
            if (dateOfBirth != null && !dateOfBirth.isEmpty()) {
                try {
                    LocalDate localDate = LocalDate.parse(dateOfBirth);
                    Date sqlDate = Date.valueOf(localDate);
                    student.setDateOfBirth(sqlDate);
                } catch (DateTimeParseException e) {
                    e.printStackTrace();
                }
            }
            
            student.setPhone(request.getParameter("phone"));
            student.setAddress(request.getParameter("address"));
            
            // Set user to student
            student.setUser(user);
            
            // Set student to application
            application.setStudent(student);
            
            // Set application fields
            application.setProgram(request.getParameter("program"));
            application.setStatus("PENDING");
            
            // Save the application
            boolean success = applicationDAO.createApplication(application);
            if (success) {
                // Create uploads directory if it doesn't exist
                String uploadsPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
                File uploadsDir = new File(uploadsPath);
                if (!uploadsDir.exists()) {
                    uploadsDir.mkdirs();
                }
                
                // Handle file uploads
                for (Part part : request.getParts()) {
                    String fieldName = part.getName();
                    if (fieldName.startsWith("document") && part.getSize() > 0) {
                        // Get document type from field name (e.g., document-transcript, document-photo, etc.)
                        String documentType = fieldName.replace("document-", "");
                        
                        // Generate unique file name
                        String fileName = getSubmittedFileName(part);
                        String extension = fileName.substring(fileName.lastIndexOf("."));
                        String uniqueFileName = UUID.randomUUID().toString() + extension;
                        
                        // Save file to disk
                        String filePath = uploadsPath + File.separator + uniqueFileName;
                        part.write(filePath);
                        
                        // Create document record in database
                        Document document = new Document();
                        document.setApplicationId(application.getId());
                        document.setDocumentType(documentType);
                        document.setFileName(fileName);
                        document.setFilePath(uniqueFileName);
                        
                        documentDAO.saveDocument(document);
                    }
                }
                
                response.sendRedirect(request.getContextPath() + "/student/applications.jsp");
            } else {
                request.setAttribute("error", "Failed to submit application");
                request.getRequestDispatcher("/student/apply.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to submit application: " + e.getMessage());
            request.getRequestDispatcher("/student/apply.jsp").forward(request, response);
        }
    }

    private String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }

    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String idParam = request.getParameter("id");
        String status = request.getParameter("status");
        
        if (idParam == null || status == null) {
            response.sendRedirect(request.getContextPath() + "/admin/applications.jsp?error=missing");
            return;
        }
        
        try {
            Long applicationId = Long.parseLong(idParam);
            boolean updated = applicationDAO.updateApplicationStatus(applicationId, status);
            
            if (updated) {
                response.sendRedirect(request.getContextPath() + "/admin/applications.jsp?updated=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/applications.jsp?error=updatefailed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/applications.jsp?error=invalid");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to update application status: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private void handleDownloadDocument(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String documentIdStr = request.getParameter("documentId");
        if (documentIdStr == null || documentIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Document ID is required");
            return;
        }

        try {
            Long documentId = Long.parseLong(documentIdStr);
            Document document = documentDAO.getDocumentById(documentId);
            
            if (document == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Document not found");
                return;
            }

            // Get the full file path
            String filePath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY + File.separator + document.getFilePath();
            File file = new File(filePath);
            
            if (!file.exists()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found on server");
                return;
            }

            // Set content type based on file extension
            String fileName = document.getFileName();
            String contentType = getServletContext().getMimeType(fileName);
            if (contentType == null) {
                contentType = "application/octet-stream";
            }
            
            response.setContentType(contentType);
            response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
            response.setContentLength((int) file.length());

            try (FileInputStream in = new FileInputStream(file);
                 OutputStream out = response.getOutputStream()) {
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid document ID format");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error downloading document: " + e.getMessage());
        }
    }

    private void handleDeleteApplication(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Only administrators can delete applications");
            return;
        }

        String applicationIdStr = request.getParameter("id");
        if (applicationIdStr == null || applicationIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Application ID is required");
            return;
        }

        try {
            Long applicationId = Long.parseLong(applicationIdStr);
            
            // Delete associated messages first
            MessageDAO messageDAO = new MessageDAO();
            messageDAO.deleteMessagesByUserId(applicationId);
            
            // Delete associated documents
            documentDAO.deleteDocumentsByApplicationId(applicationId);
            
            // Finally delete the application
            boolean deleted = applicationDAO.deleteApplication(applicationId);
            
            if (deleted) {
                response.sendRedirect(request.getContextPath() + "/application/list?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/application/list?error=deletefailed");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid application ID format");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error deleting application: " + e.getMessage());
        }
    }
} 