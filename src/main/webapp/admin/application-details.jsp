<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.college.model.Application" %>
<%@ page import="com.college.model.Student" %>
<%@ page import="com.college.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="com.college.model.Document" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Application Details - Admin Dashboard</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    <style>
        .sidebar {
            min-height: 100vh;
            background-color: #343a40;
        }
        .sidebar a {
            color: #f8f9fa;
            padding: 10px 15px;
            display: block;
        }
        .sidebar a:hover {
            background-color: #495057;
            text-decoration: none;
        }
        .sidebar a.active {
            background-color: #007bff;
        }
        .content {
            padding: 20px;
        }
        .badge-pending {
            background-color: #ffc107;
            color: #212529;
        }
        .badge-approved {
            background-color: #28a745;
        }
        .badge-rejected {
            background-color: #dc3545;
        }
    </style>
</head>
<body>
    <% 
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Normally you would retrieve this from a servlet attribute
        Application application = (Application) request.getAttribute("application");
        if (application == null) {
            // Fallback to using request parameter and loading it
            String applicationId = request.getParameter("id");
            if (applicationId != null) {
                // This would be handled by a servlet in a real implementation
                // For now just show a placeholder
            } else {
                response.sendRedirect("applications.jsp");
                return;
            }
        }
        
        // Placeholder data for the UI (normally retrieved from database)
        String program = "Computer Science";
        String status = "PENDING";
        String submissionDate = "2023-04-15";
        String studentName = "John Doe";
        String studentEmail = "john.doe@example.com";
        String studentPhone = "+1 123-456-7890";
        
        // CSS class for status badge
        String statusClass = "";
        switch (status) {
            case "PENDING": statusClass = "badge-pending"; break;
            case "APPROVED": statusClass = "badge-approved"; break;
            case "REJECTED": statusClass = "badge-rejected"; break;
            default: statusClass = "badge-secondary";
        }
    %>

    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 p-0 sidebar">
                <div class="text-center py-4">
                    <h4 class="text-white">Admin Panel</h4>
                </div>
                <a href="dashboard.jsp"><i class="fas fa-tachometer-alt mr-2"></i> Dashboard</a>
                <a href="applications.jsp" class="active"><i class="fas fa-file-alt mr-2"></i> Applications</a>
                <a href="students.jsp"><i class="fas fa-user-graduate mr-2"></i> Students</a>
                <a href="settings.jsp"><i class="fas fa-cog mr-2"></i> Settings</a>
                <a href="${pageContext.request.contextPath}/auth?action=logout"><i class="fas fa-sign-out-alt mr-2"></i> Logout</a>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-10 content">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>Application Details</h2>
                    <a href="applications.jsp" class="btn btn-secondary"><i class="fas fa-arrow-left mr-2"></i>Back to Applications</a>
                </div>
                
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Application Summary</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <table class="table table-borderless">
                                    <tr>
                                        <th width="30%">Application ID:</th>
                                        <td><%= request.getParameter("id") %></td>
                                    </tr>
                                    <tr>
                                        <th>Program:</th>
                                        <td><%= program %></td>
                                    </tr>
                                    <tr>
                                        <th>Submission Date:</th>
                                        <td><%= submissionDate %></td>
                                    </tr>
                                    <tr>
                                        <th>Status:</th>
                                        <td><span class="badge <%= statusClass %>"><%= status %></span></td>
                                    </tr>
                                </table>
                            </div>
                            <div class="col-md-6">
                                <table class="table table-borderless">
                                    <tr>
                                        <th width="30%">Student Name:</th>
                                        <td><%= studentName %></td>
                                    </tr>
                                    <tr>
                                        <th>Email:</th>
                                        <td><%= studentEmail %></td>
                                    </tr>
                                    <tr>
                                        <th>Phone:</th>
                                        <td><%= studentPhone %></td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Documents</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Document Type</th>
                                        <th>Upload Date</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Transcript</td>
                                        <td>2023-04-10</td>
                                        <td>
                                            <a href="#" class="btn btn-info btn-sm"><i class="fas fa-download mr-1"></i>Download</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>ID Proof</td>
                                        <td>2023-04-10</td>
                                        <td>
                                            <a href="#" class="btn btn-info btn-sm"><i class="fas fa-download mr-1"></i>Download</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Recommendation Letter</td>
                                        <td>2023-04-12</td>
                                        <td>
                                            <a href="#" class="btn btn-info btn-sm"><i class="fas fa-download mr-1"></i>Download</a>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Application Review</h5>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/application" method="post">
                            <input type="hidden" name="action" value="updateStatus">
                            <input type="hidden" name="id" value="<%= request.getParameter("id") %>">
                            
                            <div class="form-group">
                                <label for="status">Update Status</label>
                                <select class="form-control" id="status" name="status">
                                    <option value="PENDING" <%= "PENDING".equals(status) ? "selected" : "" %>>Pending</option>
                                    <option value="APPROVED" <%= "APPROVED".equals(status) ? "selected" : "" %>>Approved</option>
                                    <option value="REJECTED" <%= "REJECTED".equals(status) ? "selected" : "" %>>Rejected</option>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label for="comments">Comments</label>
                                <textarea class="form-control" id="comments" name="comments" rows="3"></textarea>
                            </div>
                            
                            <div class="text-right">
                                <button type="submit" class="btn btn-primary"><i class="fas fa-save mr-1"></i>Save Changes</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 