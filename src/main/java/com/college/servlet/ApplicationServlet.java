package com.college.servlet;

import com.college.dao.ApplicationDAO;
import com.college.dao.DocumentDAO;
import com.college.dao.MessageDAO;
import com.college.model.Application;
import com.college.model.Document;
import com.college.model.User;

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

@WebServlet("/application/*")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 15 // 15 MB
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
        
        // Debug information
        System.out.println("=== DEBUG INFO ===");
        System.out.println("Context Path: " + request.getContextPath());
        System.out.println("Servlet Path: " + request.getServletPath());
        System.out.println("Path Info: " + request.getPathInfo());
        System.out.println("User Role: " + (user != null ? user.getRole() : "null"));
        System.out.println("JSP Path: " + getServletContext().getRealPath("/WEB-INF/views/applications.jsp"));
        System.out.println("==================");
        
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
        int applicationId = Integer.parseInt(request.getParameter("id"));
        Application application = applicationDAO.getApplicationById(applicationId);
        
        if (application != null) {
            // Get documents for this application
            List<Document> documents = documentDAO.getDocumentsByApplicationId(applicationId);
            request.setAttribute("application", application);
            request.setAttribute("documents", documents);
            request.getRequestDispatcher("/WEB-INF/views/application-details.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/application/list");
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
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        if (user == null || "ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            // Validate required fields
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String dateOfBirthStr = request.getParameter("dateOfBirth");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String program = request.getParameter("program");

            System.out.println("DEBUG - Application Submission - User: " + user.getEmail());
            System.out.println("DEBUG - Form data: " + firstName + " " + lastName + ", " + program);
            System.out.println("DEBUG - DOB: " + dateOfBirthStr + ", Phone: " + phone);

            // Check for empty required fields
            if (firstName == null || firstName.trim().isEmpty() ||
                lastName == null || lastName.trim().isEmpty() ||
                dateOfBirthStr == null || dateOfBirthStr.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                address == null || address.trim().isEmpty() ||
                program == null || program.trim().isEmpty()) {
                
                System.out.println("DEBUG - Missing required fields in form submission");
                request.getSession().setAttribute("errorMessage", "Please fill in all required fields");
                response.sendRedirect(request.getContextPath() + "/application/new?error=true");
                return;
            }

            try {
                // Parse and validate date
                LocalDate localDate = LocalDate.parse(dateOfBirthStr);
                Date sqlDate = Date.valueOf(localDate);
                
                Application application = new Application();
                application.setUserId(user.getId());
                application.setFirstName(firstName.trim());
                application.setLastName(lastName.trim());
                application.setDateOfBirth(sqlDate);
                application.setPhone(phone.trim());
                application.setAddress(address.trim());
                application.setProgram(program.trim());
                application.setStatus("PENDING");
                
                boolean created = applicationDAO.createApplication(application);
                System.out.println("DEBUG - Application creation result: " + created + ", ID: " + application.getId());
                
                if (created) {
                    // Create uploads directory if it doesn't exist
                    String uploadsPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
                    File uploadsDir = new File(uploadsPath);
                    if (!uploadsDir.exists()) {
                        uploadsDir.mkdirs();
                    }
                    
                    for (Part filePart : request.getParts()) {
                        if (filePart != null && filePart.getName().startsWith("document") && filePart.getSize() > 0) {
                            String fileName = getSubmittedFileName(filePart);
                            if (fileName == null || fileName.isEmpty()) {
                                continue;
                            }
                            
                            String fileType = filePart.getContentType();
                            String documentType = request.getParameter(filePart.getName() + "Type");
                            
                            System.out.println("DEBUG - Processing document: " + fileName + ", type: " + documentType);
                            
                            // Generate unique filename
                            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                            String filePath = UPLOAD_DIRECTORY + File.separator + uniqueFileName;
                            String absolutePath = getServletContext().getRealPath("") + File.separator + filePath;
                            
                            // Save file
                            System.out.println("DEBUG - Saving file to: " + absolutePath);
                            filePart.write(absolutePath);
                            
                            // Save document record
                            Document document = new Document(
                                application.getId(),
                                fileName, 
                                null, // fileType is not used in the database
                                filePath,
                                documentType
                            );
                            int documentId = documentDAO.saveDocument(document);
                            System.out.println("DEBUG - Document saved with ID: " + documentId);
                        }
                    }
                    
                    request.getSession().setAttribute("successMessage", "Application submitted successfully!");
                    response.sendRedirect(request.getContextPath() + "/application/list");
                } else {
                    System.out.println("DEBUG - Failed to create application record");
                    request.getSession().setAttribute("errorMessage", "Failed to create application record");
                    response.sendRedirect(request.getContextPath() + "/application/new?error=true");
                }
            } catch (DateTimeException e) {
                System.out.println("DEBUG - Error parsing date: " + dateOfBirthStr + " - " + e.getMessage());
                request.getSession().setAttribute("errorMessage", "Invalid date format");
                response.sendRedirect(request.getContextPath() + "/application/new?error=true");
            }
        } catch (Exception e) {
            System.out.println("DEBUG - Unexpected error in application submission: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "An unexpected error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/application/new?error=true");
        }
    }

    private String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String item : items) {
            if (item.trim().startsWith("filename")) {
                return item.substring(item.indexOf("=") + 2, item.length() - 1);
            }
        }
        return "";
    }

    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        if (!"ADMIN".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        try {
            int applicationId = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");
            
            if (applicationDAO.updateApplicationStatus(applicationId, status)) {
                response.sendRedirect(request.getContextPath() + "/application/list");
            } else {
                response.sendRedirect(request.getContextPath() + "/application/list?error=true");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/application/list?error=true");
        }
    }

    private void handleDownloadDocument(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        int documentId = Integer.parseInt(request.getParameter("id"));
        Document document = documentDAO.getDocumentById(documentId);
        
        if (document != null) {
            String filePath = getServletContext().getRealPath("") + File.separator + document.getFilePath();
            File file = new File(filePath);
            
            if (file.exists()) {
                response.setContentType(document.getFileType());
                response.setHeader("Content-Disposition", "attachment; filename=\"" + document.getFileName() + "\"");
                response.setHeader("Content-Length", String.valueOf(file.length()));
                
                try (InputStream fileInputStream = new FileInputStream(file);
                     OutputStream responseOutputStream = response.getOutputStream()) {
                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                        responseOutputStream.write(buffer, 0, bytesRead);
                    }
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Document not found");
        }
    }

    private void handleDeleteApplication(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        // Get user from session and verify admin role
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            System.out.println("Delete attempt by unauthorized user: " + (user != null ? user.getRole() : "not logged in"));
            request.getSession().setAttribute("errorMessage", "Unauthorized: Only admins can delete applications");
            response.sendRedirect(request.getContextPath() + "/application/list");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            System.out.println("Delete failed: Invalid ID parameter");
            request.getSession().setAttribute("errorMessage", "Invalid application ID");
            response.sendRedirect(request.getContextPath() + "/application/list");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            
            // First delete associated messages
            MessageDAO messageDAO = new MessageDAO();
            boolean messagesDeleted = messageDAO.deleteMessagesByApplicationId(id);
            System.out.println("Messages deleted for application ID=" + id + ": " + messagesDeleted);
            
            // Then get documents for deletion of physical files
            List<Document> documents = documentDAO.getDocumentsByApplicationId(id);
            
            // Delete document database records first
            boolean documentsDeleted = documentDAO.deleteDocumentsByApplicationId(id);
            System.out.println("Document records deleted for application ID=" + id + ": " + documentsDeleted);
            
            // Now delete physical files
            for (Document doc : documents) {
                String filePath = getServletContext().getRealPath("") + File.separator + doc.getFilePath();
                File file = new File(filePath);
                if (file.exists()) {
                    boolean deleted = file.delete();
                    System.out.println("Deleting file: " + filePath + " - Result: " + deleted);
                }
            }
            
            // Finally delete the application
            boolean deleted = applicationDAO.deleteApplication(id);

            if (deleted) {
                System.out.println("Application deleted successfully: ID=" + id);
                request.getSession().setAttribute("successMessage", "Application deleted successfully");
            } else {
                System.out.println("Delete failed: Application not found or DB error for ID=" + id);
                request.getSession().setAttribute("errorMessage", "Failed to delete application");
            }
        } catch (NumberFormatException e) {
            System.out.println("Delete failed: Invalid ID format: " + idParam);
            request.getSession().setAttribute("errorMessage", "Invalid application ID format");
        } catch (Exception e) {
            System.out.println("Delete failed: Unexpected error: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "An error occurred: " + e.getMessage());
        }
        
        // Always redirect back to applications list
        response.sendRedirect(request.getContextPath() + "/application/list");
    }
} 