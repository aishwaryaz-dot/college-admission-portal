<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.college.model.User" %>
<%@ page import="com.college.model.Application" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Applications - Student Portal</title>
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
        
        // Get applications if they exist (from servlet attribute)
        List<Application> applications = (List<Application>) request.getAttribute("applications");
        boolean hasApplications = applications != null && !applications.isEmpty();
    %>

    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 p-0 sidebar">
                <div class="text-center py-4">
                    <h4 class="text-white">Student Portal</h4>
                </div>
                <a href="dashboard.jsp"><i class="fas fa-tachometer-alt mr-2"></i> Dashboard</a>
                <a href="profile.jsp"><i class="fas fa-user mr-2"></i> My Profile</a>
                <a href="applications.jsp" class="active"><i class="fas fa-file-alt mr-2"></i> My Applications</a>
                <a href="apply.jsp"><i class="fas fa-plus-circle mr-2"></i> Apply</a>
                <a href="${pageContext.request.contextPath}/auth/logout"><i class="fas fa-sign-out-alt mr-2"></i> Logout</a>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-10 content">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>My Applications</h2>
                    <a href="apply.jsp" class="btn btn-primary"><i class="fas fa-plus-circle mr-2"></i>New Application</a>
                </div>
                
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">All Applications</h5>
                    </div>
                    <div class="card-body">
                        <% if (hasApplications) { %>
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Program</th>
                                        <th>Submission Date</th>
                                        <th>Last Updated</th>
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
                                        <td><%= app.getLastUpdated() %></td>
                                        <td>
                                            <span class="<%= statusClass %>">
                                                <i class="fas <%= "PENDING".equals(app.getStatus()) ? "fa-clock" : ("APPROVED".equals(app.getStatus()) ? "fa-check-circle" : "fa-times-circle") %>"></i>
                                                <%= app.getStatus() %>
                                            </span>
                                        </td>
                                        <td>
                                            <a href="view-application.jsp?id=<%= app.getId() %>" class="btn btn-info btn-sm"><i class="fas fa-eye mr-1"></i>View</a>
                                            <% if ("PENDING".equals(app.getStatus())) { %>
                                                <a href="edit-application.jsp?id=<%= app.getId() %>" class="btn btn-warning btn-sm"><i class="fas fa-edit mr-1"></i>Edit</a>
                                                <a href="javascript:void(0);" class="btn btn-danger btn-sm delete-app" data-id="<%= app.getId() %>" data-toggle="modal" data-target="#deleteApplicationModal"><i class="fas fa-trash mr-1"></i>Cancel</a>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } else { %>
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle mr-2"></i>You haven't submitted any applications yet.
                        </div>
                        <div class="text-center my-4">
                            <a href="apply.jsp" class="btn btn-lg btn-primary"><i class="fas fa-plus-circle mr-2"></i>Submit Your First Application</a>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete Application Modal -->
    <div class="modal fade" id="deleteApplicationModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title">Cancel Application</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to cancel this application? This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">No, Keep It</button>
                    <form id="deleteApplicationForm" action="${pageContext.request.contextPath}/application" method="post">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" id="applicationId" name="id" value="">
                        <button type="submit" class="btn btn-danger">Yes, Cancel Application</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        $(document).ready(function() {
            $('.delete-app').click(function() {
                var appId = $(this).data('id');
                $('#applicationId').val(appId);
            });
        });
    </script>
</body>
</html> 
