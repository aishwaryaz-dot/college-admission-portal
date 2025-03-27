<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.college.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - College Admission Portal</title>
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
    </style>
</head>
<body>
    <% 
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Stats - you would normally get these from the database
        int totalStudents = (Integer) request.getAttribute("totalStudents") != null ? (Integer) request.getAttribute("totalStudents") : 0;
        int totalApplications = (Integer) request.getAttribute("totalApplications") != null ? (Integer) request.getAttribute("totalApplications") : 0;
        int pendingApplications = (Integer) request.getAttribute("pendingApplications") != null ? (Integer) request.getAttribute("pendingApplications") : 0;
    %>

    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 p-0 sidebar">
                <div class="text-center py-4">
                    <h4 class="text-white">Admin Panel</h4>
                </div>
                <a href="dashboard.jsp" class="active"><i class="fas fa-tachometer-alt mr-2"></i> Dashboard</a>
                <a href="applications.jsp"><i class="fas fa-file-alt mr-2"></i> Applications</a>
                <a href="students.jsp"><i class="fas fa-user-graduate mr-2"></i> Students</a>
                <a href="settings.jsp"><i class="fas fa-cog mr-2"></i> Settings</a>
                <a href="${pageContext.request.contextPath}/auth?action=logout"><i class="fas fa-sign-out-alt mr-2"></i> Logout</a>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-10 content">
                <h2 class="mb-4">Admin Dashboard</h2>
                
                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="card dashboard-card bg-primary text-white h-100">
                            <div class="card-body text-center">
                                <i class="fas fa-user-graduate fa-3x mb-3"></i>
                                <h5 class="card-title">Total Students</h5>
                                <h2 class="mb-0"><%= totalStudents %></h2>
                                <a href="students.jsp" class="btn btn-light btn-sm mt-3">View All</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card dashboard-card bg-success text-white h-100">
                            <div class="card-body text-center">
                                <i class="fas fa-file-alt fa-3x mb-3"></i>
                                <h5 class="card-title">Total Applications</h5>
                                <h2 class="mb-0"><%= totalApplications %></h2>
                                <a href="applications.jsp" class="btn btn-light btn-sm mt-3">View All</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card dashboard-card bg-warning text-dark h-100">
                            <div class="card-body text-center">
                                <i class="fas fa-clock fa-3x mb-3"></i>
                                <h5 class="card-title">Pending Applications</h5>
                                <h2 class="mb-0"><%= pendingApplications %></h2>
                                <a href="applications.jsp?status=PENDING" class="btn btn-dark btn-sm mt-3">Review Now</a>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-7">
                        <div class="card mb-4">
                            <div class="card-header bg-primary text-white">
                                <h5 class="mb-0">Recent Applications</h5>
                            </div>
                            <div class="card-body">
                                <p>Please go to <a href="applications.jsp">Applications</a> page to view all applications.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-5">
                        <div class="card">
                            <div class="card-header bg-primary text-white">
                                <h5 class="mb-0">Quick Actions</h5>
                            </div>
                            <div class="card-body">
                                <div class="list-group">
                                    <a href="applications.jsp?status=PENDING" class="list-group-item list-group-item-action">
                                        <i class="fas fa-check-circle text-success mr-2"></i> Review Pending Applications
                                    </a>
                                    <a href="students.jsp" class="list-group-item list-group-item-action">
                                        <i class="fas fa-user-plus text-primary mr-2"></i> Manage Student Records
                                    </a>
                                    <a href="programs.jsp" class="list-group-item list-group-item-action">
                                        <i class="fas fa-graduation-cap text-info mr-2"></i> Manage Programs
                                    </a>
                                    <a href="reports.jsp" class="list-group-item list-group-item-action">
                                        <i class="fas fa-chart-bar text-warning mr-2"></i> Generate Reports
                                    </a>
                                </div>
                            </div>
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