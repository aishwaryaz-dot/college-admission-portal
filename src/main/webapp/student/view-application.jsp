<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.college.model.User" %>
<%@ page import="com.college.model.Application" %>
<%@ page import="com.college.model.Document" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Application Details - Student Portal</title>
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
        
        // Get application if it exists (from servlet attribute)
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
        String lastUpdatedDate = "2023-04-15";
        String personalStatement = "I am very interested in studying Computer Science as I have been programming since I was 13 years old. I have experience in Java, Python, and web development. I hope to gain deeper knowledge in algorithms and data structures during this program.";
        
        // CSS class for status badge
        String statusClass = "";
        switch (status) {
            case "PENDING": statusClass = "status-pending"; break;
            case "APPROVED": statusClass = "status-approved"; break;
            case "REJECTED": statusClass = "status-rejected"; break;
            default: statusClass = "status-secondary";
        }
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
                                        <th width="40%">Application ID:</th>
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
                                </table>
                            </div>
                            <div class="col-md-6">
                                <table class="table table-borderless">
                                    <tr>
                                        <th width="40%">Status:</th>
                                        <td>
                                            <span class="<%= statusClass %>">
                                                <i class="fas <%= "PENDING".equals(status) ? "fa-clock" : ("APPROVED".equals(status) ? "fa-check-circle" : "fa-times-circle") %>"></i>
                                                <%= status %>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>Last Updated:</th>
                                        <td><%= lastUpdatedDate %></td>
                                    </tr>
                                    <tr>
                                        <th>Actions:</th>
                                        <td>
                                            <% if ("PENDING".equals(status)) { %>
                                                <a href="edit-application.jsp?id=<%= request.getParameter("id") %>" class="btn btn-sm btn-warning"><i class="fas fa-edit mr-1"></i>Edit</a>
                                                <a href="javascript:void(0);" class="btn btn-sm btn-danger" data-toggle="modal" data-target="#cancelApplicationModal"><i class="fas fa-times-circle mr-1"></i>Cancel</a>
                                            <% } %>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Personal Statement</h5>
                    </div>
                    <div class="card-body">
                        <p><%= personalStatement %></p>
                    </div>
                </div>
                
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Submitted Documents</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Document Type</th>
                                        <th>Filename</th>
                                        <th>Upload Date</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Transcript</td>
                                        <td>transcript.pdf</td>
                                        <td>2023-04-15</td>
                                        <td>
                                            <a href="#" class="btn btn-sm btn-info"><i class="fas fa-download mr-1"></i>Download</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>ID Proof</td>
                                        <td>id_card.jpg</td>
                                        <td>2023-04-15</td>
                                        <td>
                                            <a href="#" class="btn btn-sm btn-info"><i class="fas fa-download mr-1"></i>Download</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Recommendation Letter</td>
                                        <td>recommendation.pdf</td>
                                        <td>2023-04-15</td>
                                        <td>
                                            <a href="#" class="btn btn-sm btn-info"><i class="fas fa-download mr-1"></i>Download</a>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                
                <% if ("APPROVED".equals(status) || "REJECTED".equals(status)) { %>
                <div class="card mb-4">
                    <div class="card-header bg-<%= "APPROVED".equals(status) ? "success" : "danger" %> text-white">
                        <h5 class="mb-0">Application <%= status %></h5>
                    </div>
                    <div class="card-body">
                        <% if ("APPROVED".equals(status)) { %>
                            <div class="alert alert-success">
                                <i class="fas fa-check-circle mr-2"></i>Congratulations! Your application has been approved. You will receive further instructions about the enrollment process via email.
                            </div>
                            <p>Please be on the lookout for an email with the following information:</p>
                            <ul>
                                <li>Enrollment dates and procedures</li>
                                <li>Tuition payment details</li>
                                <li>Orientation schedule</li>
                                <li>Additional paperwork that may be required</li>
                            </ul>
                        <% } else { %>
                            <div class="alert alert-danger">
                                <i class="fas fa-times-circle mr-2"></i>We regret to inform you that your application has not been approved at this time.
                            </div>
                            <p>If you have any questions about the decision or would like to discuss your options for future applications, please contact our admissions office.</p>
                            <a href="support.jsp" class="btn btn-primary"><i class="fas fa-envelope mr-1"></i>Contact Admissions</a>
                        <% } %>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </div>
    
    <!-- Cancel Application Modal -->
    <div class="modal fade" id="cancelApplicationModal" tabindex="-1" role="dialog" aria-hidden="true">
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
                    <form action="${pageContext.request.contextPath}/application" method="post">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" value="<%= request.getParameter("id") %>">
                        <button type="submit" class="btn btn-danger">Yes, Cancel Application</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 
