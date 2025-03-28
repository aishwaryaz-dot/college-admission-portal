<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.college.model.User" %>
<%@ page import="com.college.model.Student" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.college.model.Application" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - College Admission Portal</title>
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
        .dashboard-card {
            transition: transform 0.3s;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
        }
        .status-pending {
            color: #ffc107;
        }
        .status-approved {
            color: #28a745;
        }
        .status-rejected {
            color: #dc3545;
        }
    </style>
</head>
<body>
    <% 
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"STUDENT".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        Student student = (Student) request.getAttribute("studentInfo");
        List<Application> applications = (List<Application>) request.getAttribute("applications");
        
        // Initialize to empty list if null to avoid NPE
        if (applications == null) {
            applications = new ArrayList<>();
        }
        
        boolean hasProfile = student != null;
        boolean hasApplication = !applications.isEmpty();
    %>

    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 p-0 sidebar">
                <div class="text-center py-4">
                    <h4 class="text-white">Student Portal</h4>
                </div>
                <a href="dashboard.jsp" class="active"><i class="fas fa-tachometer-alt mr-2"></i> Dashboard</a>
                <a href="profile.jsp"><i class="fas fa-user mr-2"></i> My Profile</a>
                <a href="applications.jsp"><i class="fas fa-file-alt mr-2"></i> My Applications</a>
                <a href="apply.jsp"><i class="fas fa-plus-circle mr-2"></i> Apply</a>
                <a href="${pageContext.request.contextPath}/auth/logout"><i class="fas fa-sign-out-alt mr-2"></i> Logout</a>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-10 content">
                <h2 class="mb-4">Welcome, <%= currentUser.getEmail() %></h2>
                
                <!-- Main Action Cards -->
                <div class="row mb-5">
                    <div class="col-md-6">
                        <div class="card dashboard-card bg-primary text-white h-100">
                            <div class="card-body text-center">
                                <i class="fas fa-file-alt fa-4x mb-3"></i>
                                <h3>View Applications</h3>
                                <p class="lead">Check the status of your submitted applications</p>
                                <a href="applications.jsp" class="btn btn-light btn-lg mt-3">View Applications</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card dashboard-card bg-success text-white h-100">
                            <div class="card-body text-center">
                                <i class="fas fa-plus-circle fa-4x mb-3"></i>
                                <h3>Apply Now</h3>
                                <p class="lead">Submit a new application to your desired program</p>
                                <a href="<% if (hasProfile) { %>apply.jsp<% } else { %>profile.jsp<% } %>" class="btn btn-light btn-lg mt-3">
                                    <% if (hasProfile) { %>Apply Now<% } else { %>Complete Profile First<% } %>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="card dashboard-card bg-primary text-white h-100">
                            <div class="card-body">
                                <h5 class="card-title">Profile Status</h5>
                                <p class="card-text">
                                    <% if (hasProfile) { %>
                                        <i class="fas fa-check-circle fa-2x"></i> Profile Complete
                                    <% } else { %>
                                        <i class="fas fa-exclamation-circle fa-2x"></i> Profile Incomplete
                                    <% } %>
                                </p>
                                <a href="profile.jsp" class="btn btn-light mt-3">
                                    <% if (hasProfile) { %>Edit Profile<% } else { %>Complete Profile<% } %>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card dashboard-card bg-success text-white h-100">
                            <div class="card-body">
                                <h5 class="card-title">Applications</h5>
                                <p class="card-text">
                                    <i class="fas fa-file-alt fa-2x"></i>
                                    <% if (hasApplication) { %>
                                        <%= applications.size() %> Application(s)
                                    <% } else { %>
                                        No Applications
                                    <% } %>
                                </p>
                                <a href="<% if (hasProfile) { %>apply.jsp<% } else { %>profile.jsp<% } %>" class="btn btn-light mt-3">
                                    <% if (hasProfile) { %>Apply Now<% } else { %>Complete Profile First<% } %>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card dashboard-card bg-info text-white h-100">
                            <div class="card-body">
                                <h5 class="card-title">Help & Support</h5>
                                <p class="card-text">
                                    <i class="fas fa-question-circle fa-2x"></i>
                                    Need assistance with your application?
                                </p>
                                <a href="support.jsp" class="btn btn-light mt-3">Contact Support</a>
                            </div>
                        </div>
                    </div>
                </div>
                
                <% if (hasApplication) { %>
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Recent Applications</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Program</th>
                                        <th>Submission Date</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Application app : applications) { 
                                        String statusClass = "";
                                        switch (app.getStatus()) {
                                            case "PENDING": statusClass = "status-pending"; break;
                                            case "APPROVED": statusClass = "status-approved"; break;
                                            case "REJECTED": statusClass = "status-rejected"; break;
                                        }
                                    %>
                                    <tr>
                                        <td><%= app.getProgram() %></td>
                                        <td><%= app.getSubmissionDate() %></td>
                                        <td>
                                            <span class="<%= statusClass %>">
                                                <i class="fas <%= "PENDING".equals(app.getStatus()) ? "fa-clock" : ("APPROVED".equals(app.getStatus()) ? "fa-check-circle" : "fa-times-circle") %>"></i>
                                                <%= app.getStatus() %>
                                            </span>
                                        </td>
                                        <td>
                                            <a href="view-application.jsp?id=<%= app.getId() %>" class="btn btn-info btn-sm">View</a>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <% } else if (hasProfile) { %>
                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i> You haven't submitted any applications yet. <a href="apply.jsp" class="alert-link">Apply now</a> to a program.
                </div>
                <% } else { %>
                <div class="alert alert-warning">
                    <i class="fas fa-exclamation-triangle"></i> Please <a href="profile.jsp" class="alert-link">complete your profile</a> before applying to any programs.
                </div>
                <% } %>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 