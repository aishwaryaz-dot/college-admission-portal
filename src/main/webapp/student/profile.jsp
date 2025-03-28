<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.college.model.User" %>
<%@ page import="com.college.model.Student" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Student Portal</title>
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
    </style>
</head>
<body>
    <% 
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"STUDENT".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Get student info if it exists (from servlet attribute)
        Student student = (Student) request.getAttribute("studentInfo");
        boolean hasProfile = student != null;
    %>

    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 p-0 sidebar">
                <div class="text-center py-4">
                    <h4 class="text-white">Student Portal</h4>
                </div>
                <a href="dashboard.jsp"><i class="fas fa-tachometer-alt mr-2"></i> Dashboard</a>
                <a href="profile.jsp" class="active"><i class="fas fa-user mr-2"></i> My Profile</a>
                <a href="applications.jsp"><i class="fas fa-file-alt mr-2"></i> My Applications</a>
                <a href="apply.jsp"><i class="fas fa-plus-circle mr-2"></i> Apply</a>
                <a href="${pageContext.request.contextPath}/auth/logout"><i class="fas fa-sign-out-alt mr-2"></i> Logout</a>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-10 content">
                <h2 class="mb-4"><%= hasProfile ? "Edit Profile" : "Complete Your Profile" %></h2>
                
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><%= hasProfile ? "Update Your Information" : "Enter Your Information" %></h5>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/student/profile" method="post">
                            <input type="hidden" name="action" value="<%= hasProfile ? "update" : "create" %>">
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="firstName">First Name</label>
                                        <input type="text" class="form-control" id="firstName" name="firstName" value="<%= hasProfile ? student.getFirstName() : "" %>" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="lastName">Last Name</label>
                                        <input type="text" class="form-control" id="lastName" name="lastName" value="<%= hasProfile ? student.getLastName() : "" %>" required>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="email">Email Address</label>
                                <input type="email" class="form-control" id="email" value="<%= currentUser.getEmail() %>" readonly>
                                <small class="form-text text-muted">Email cannot be changed</small>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="dateOfBirth">Date of Birth</label>
                                        <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" value="<%= hasProfile && student.getDateOfBirth() != null ? student.getDateOfBirth() : "" %>" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="phone">Phone Number</label>
                                        <input type="tel" class="form-control" id="phone" name="phone" value="<%= hasProfile && student.getPhone() != null ? student.getPhone() : "" %>" required>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="address">Address</label>
                                <textarea class="form-control" id="address" name="address" rows="3" required><%= hasProfile && student.getAddress() != null ? student.getAddress() : "" %></textarea>
                            </div>
                            
                            <hr>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="highSchool">High School</label>
                                        <input type="text" class="form-control" id="highSchool" name="highSchool" value="">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="graduationYear">Graduation Year</label>
                                        <input type="number" class="form-control" id="graduationYear" name="graduationYear" min="2000" max="2030" value="">
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="gpa">GPA</label>
                                <input type="number" step="0.01" min="0" max="4.0" class="form-control" id="gpa" name="gpa" value="">
                            </div>
                            
                            <div class="text-right">
                                <button type="submit" class="btn btn-primary">
                                    <%= hasProfile ? "Update Profile" : "Save Profile" %>
                                </button>
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
