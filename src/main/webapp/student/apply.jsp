<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.college.model.User" %>
<%@ page import="com.college.model.Student" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Apply for Program - Student Portal</title>
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
        .program-card {
            transition: transform 0.3s;
            cursor: pointer;
        }
        .program-card:hover {
            transform: translateY(-5px);
        }
        .program-card.selected {
            border: 2px solid #007bff;
            background-color: #f0f7ff;
        }
        .custom-file-label::after {
            content: "Browse";
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
        
        // Check if student has completed their profile
        Student student = (Student) request.getAttribute("studentInfo");
        if (student == null) {
            // Redirect to profile completion page if profile is not complete
            request.setAttribute("errorMessage", "Please complete your profile before applying");
            request.getRequestDispatcher("/student/profile.jsp").forward(request, response);
            return;
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
                <a href="applications.jsp"><i class="fas fa-file-alt mr-2"></i> My Applications</a>
                <a href="apply.jsp" class="active"><i class="fas fa-plus-circle mr-2"></i> Apply</a>
                <a href="${pageContext.request.contextPath}/auth/logout"><i class="fas fa-sign-out-alt mr-2"></i> Logout</a>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-10 content">
                <h2 class="mb-4">Apply for a Program</h2>
                
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Select a Program</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <!-- Program Cards - In a real implementation, these would be loaded from the database -->
                            <div class="col-md-4 mb-3">
                                <div class="card program-card h-100" data-program="Computer Science">
                                    <div class="card-body text-center">
                                        <i class="fas fa-laptop-code fa-3x mb-3 text-primary"></i>
                                        <h5 class="card-title">Computer Science</h5>
                                        <p class="card-text">Bachelor's program in Computer Science</p>
                                        <p class="text-muted">Duration: 4 years</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="card program-card h-100" data-program="Business Administration">
                                    <div class="card-body text-center">
                                        <i class="fas fa-chart-line fa-3x mb-3 text-success"></i>
                                        <h5 class="card-title">Business Administration</h5>
                                        <p class="card-text">Bachelor's program in Business Administration</p>
                                        <p class="text-muted">Duration: 3 years</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="card program-card h-100" data-program="Mechanical Engineering">
                                    <div class="card-body text-center">
                                        <i class="fas fa-cogs fa-3x mb-3 text-danger"></i>
                                        <h5 class="card-title">Mechanical Engineering</h5>
                                        <p class="card-text">Bachelor's program in Mechanical Engineering</p>
                                        <p class="text-muted">Duration: 4 years</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <form action="${pageContext.request.contextPath}/application" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="create">
                    <input type="hidden" id="selectedProgram" name="program" value="">
                    
                    <div class="card mb-4">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0">Application Details</h5>
                        </div>
                        <div class="card-body">
                            <div class="form-group">
                                <label for="programDisplay">Selected Program</label>
                                <input type="text" class="form-control" id="programDisplay" readonly placeholder="Select a program above">
                            </div>
                            
                            <div class="form-group">
                                <label for="personalStatement">Personal Statement</label>
                                <textarea class="form-control" id="personalStatement" name="personalStatement" rows="5" placeholder="Tell us why you want to join this program..." required></textarea>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card mb-4">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0">Required Documents</h5>
                        </div>
                        <div class="card-body">
                            <div class="form-group">
                                <label>Transcript</label>
                                <div class="custom-file">
                                    <input type="file" class="custom-file-input" id="transcript" name="transcript" required>
                                    <label class="custom-file-label" for="transcript">Choose file</label>
                                </div>
                                <small class="form-text text-muted">Upload your high school or previous education transcript (PDF format).</small>
                            </div>
                            
                            <div class="form-group">
                                <label>ID Proof</label>
                                <div class="custom-file">
                                    <input type="file" class="custom-file-input" id="idProof" name="idProof" required>
                                    <label class="custom-file-label" for="idProof">Choose file</label>
                                </div>
                                <small class="form-text text-muted">Upload a copy of your ID card or passport (PDF or image format).</small>
                            </div>
                            
                            <div class="form-group">
                                <label>Recommendation Letter (Optional)</label>
                                <div class="custom-file">
                                    <input type="file" class="custom-file-input" id="recommendation" name="recommendation">
                                    <label class="custom-file-label" for="recommendation">Choose file</label>
                                </div>
                                <small class="form-text text-muted">Upload a recommendation letter if available (PDF format).</small>
                            </div>
                        </div>
                    </div>
                    
                    <div class="text-right mb-4">
                        <a href="dashboard.jsp" class="btn btn-secondary mr-2"><i class="fas fa-times mr-1"></i>Cancel</a>
                        <button type="submit" class="btn btn-primary" id="submitApplication" disabled><i class="fas fa-paper-plane mr-1"></i>Submit Application</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        $(document).ready(function() {
            // Handle program selection
            $('.program-card').click(function() {
                $('.program-card').removeClass('selected');
                $(this).addClass('selected');
                var program = $(this).data('program');
                $('#selectedProgram').val(program);
                $('#programDisplay').val(program);
                // Enable the submit button once a program is selected
                $('#submitApplication').prop('disabled', false);
            });
            
            // Handle file input display
            $('.custom-file-input').change(function() {
                var fileName = $(this).val().split('\\').pop();
                $(this).next('.custom-file-label').html(fileName);
            });
        });
    </script>
</body>
</html> 
