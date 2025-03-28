<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.college.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settings - Admin Dashboard</title>
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
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
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
                <a href="applications.jsp"><i class="fas fa-file-alt mr-2"></i> Applications</a>
                <a href="students.jsp"><i class="fas fa-user-graduate mr-2"></i> Students</a>
                <a href="settings.jsp" class="active"><i class="fas fa-cog mr-2"></i> Settings</a>
                <a href="${pageContext.request.contextPath}/auth?action=logout"><i class="fas fa-sign-out-alt mr-2"></i> Logout</a>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-10 content">
                <h2 class="mb-4">System Settings</h2>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="card mb-4">
                            <div class="card-header bg-primary text-white">
                                <h5 class="mb-0">Admin Account</h5>
                            </div>
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/admin/update-password" method="post">
                                    <div class="form-group">
                                        <label for="currentPassword">Current Password</label>
                                        <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="newPassword">New Password</label>
                                        <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="confirmPassword">Confirm New Password</label>
                                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                    </div>
                                    <button type="submit" class="btn btn-primary">Update Password</button>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card mb-4">
                            <div class="card-header bg-primary text-white">
                                <h5 class="mb-0">Application Settings</h5>
                            </div>
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/admin/update-settings" method="post">
                                    <div class="form-group">
                                        <label for="allowRegistration">Allow Registration</label>
                                        <select class="form-control" id="allowRegistration" name="allowRegistration">
                                            <option value="true">Yes</option>
                                            <option value="false">No</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label for="maintenanceMode">Maintenance Mode</label>
                                        <select class="form-control" id="maintenanceMode" name="maintenanceMode">
                                            <option value="false">Off</option>
                                            <option value="true">On</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label for="applicationDeadline">Application Deadline</label>
                                        <input type="date" class="form-control" id="applicationDeadline" name="applicationDeadline">
                                    </div>
                                    <button type="submit" class="btn btn-primary">Save Settings</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-header bg-danger text-white">
                        <h5 class="mb-0">Danger Zone</h5>
                    </div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div>
                                <h6 class="mb-1">Reset Database</h6>
                                <p class="mb-0 text-muted">This will reset all application data. This action cannot be undone.</p>
                            </div>
                            <button type="button" class="btn btn-danger" data-toggle="modal" data-target="#resetDatabaseModal">Reset</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Reset Database Confirmation Modal -->
    <div class="modal fade" id="resetDatabaseModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title">Confirm Reset</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to reset the database? This will delete all students, applications, and documents. This action cannot be undone.</p>
                    <form id="resetDatabaseForm" action="${pageContext.request.contextPath}/admin/reset-database" method="post">
                        <div class="form-group">
                            <label for="confirmReset">Type "RESET" to confirm:</label>
                            <input type="text" class="form-control" id="confirmReset" required>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" id="confirmResetBtn">Reset Database</button>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#confirmResetBtn').click(function() {
                if ($('#confirmReset').val() === 'RESET') {
                    $('#resetDatabaseForm').submit();
                } else {
                    alert('Please type "RESET" to confirm');
                }
            });
        });
    </script>
</body>
</html> 