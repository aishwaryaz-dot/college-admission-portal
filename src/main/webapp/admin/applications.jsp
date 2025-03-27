<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.college.model.Application" %>
<%@ page import="com.college.model.Student" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Applications - Admin Dashboard</title>
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
                <h2 class="mb-4">Applications Management</h2>
                
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">All Applications</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Student Name</th>
                                        <th>Program</th>
                                        <th>Date Submitted</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                    List<Application> applications = (List<Application>) request.getAttribute("applications");
                                    if (applications != null && !applications.isEmpty()) {
                                        for (Application app : applications) {
                                            Student student = app.getStudent();
                                            String statusClass = "";
                                            switch (app.getStatus()) {
                                                case "PENDING": statusClass = "badge-pending"; break;
                                                case "APPROVED": statusClass = "badge-approved"; break;
                                                case "REJECTED": statusClass = "badge-rejected"; break;
                                                default: statusClass = "badge-secondary";
                                            }
                                    %>
                                    <tr>
                                        <td><%= app.getId() %></td>
                                        <td><%= student != null ? student.getFirstName() + " " + student.getLastName() : "N/A" %></td>
                                        <td><%= app.getProgram() %></td>
                                        <td><%= app.getSubmissionDate() %></td>
                                        <td><span class="badge <%= statusClass %>"><%= app.getStatus() %></span></td>
                                        <td>
                                            <a href="application-details.jsp?id=<%= app.getId() %>" class="btn btn-info btn-sm">View</a>
                                            <a href="${pageContext.request.contextPath}/application?action=updateStatus&id=<%= app.getId() %>&status=APPROVED" class="btn btn-success btn-sm">Approve</a>
                                            <a href="${pageContext.request.contextPath}/application?action=updateStatus&id=<%= app.getId() %>&status=REJECTED" class="btn btn-danger btn-sm">Reject</a>
                                        </td>
                                    </tr>
                                    <% 
                                        }
                                    } else {
                                    %>
                                    <tr>
                                        <td colspan="6" class="text-center">No applications found</td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 