<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.college.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Support - Student Portal</title>
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
        .contact-card {
            transition: transform 0.3s;
        }
        .contact-card:hover {
            transform: translateY(-5px);
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
                <a href="apply.jsp"><i class="fas fa-plus-circle mr-2"></i> Apply</a>
                <a href="support.jsp" class="active"><i class="fas fa-question-circle mr-2"></i> Support</a>
                <a href="${pageContext.request.contextPath}/auth/logout"><i class="fas fa-sign-out-alt mr-2"></i> Logout</a>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-10 content">
                <h2 class="mb-4">Help & Support</h2>
                
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Contact Support</h5>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/support" method="post">
                            <input type="hidden" name="action" value="contact">
                            
                            <div class="form-group">
                                <label for="subject">Subject</label>
                                <select class="form-control" id="subject" name="subject" required>
                                    <option value="">Select a subject...</option>
                                    <option value="Application Question">Application Question</option>
                                    <option value="Document Submission">Document Submission</option>
                                    <option value="Technical Issue">Technical Issue</option>
                                    <option value="General Inquiry">General Inquiry</option>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label for="message">Message</label>
                                <textarea class="form-control" id="message" name="message" rows="5" placeholder="Describe your issue or question in detail..." required></textarea>
                            </div>
                            
                            <div class="form-group">
                                <div class="custom-control custom-checkbox">
                                    <input type="checkbox" class="custom-control-input" id="urgentFlag" name="urgentFlag">
                                    <label class="custom-control-label" for="urgentFlag">Mark as urgent</label>
                                </div>
                            </div>
                            
                            <div class="text-right">
                                <button type="submit" class="btn btn-primary"><i class="fas fa-paper-plane mr-1"></i>Send Message</button>
                            </div>
                        </form>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-4 mb-4">
                        <div class="card contact-card h-100">
                            <div class="card-body text-center">
                                <i class="fas fa-phone-alt fa-3x mb-3 text-primary"></i>
                                <h5 class="card-title">Phone Support</h5>
                                <p class="card-text">Call our admissions helpline</p>
                                <p class="text-muted">(123) 456-7890</p>
                                <p class="text-muted small">Monday - Friday: 9AM - 5PM</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 mb-4">
                        <div class="card contact-card h-100">
                            <div class="card-body text-center">
                                <i class="fas fa-envelope fa-3x mb-3 text-success"></i>
                                <h5 class="card-title">Email Support</h5>
                                <p class="card-text">Send us an email</p>
                                <p class="text-muted">admissions@college.edu</p>
                                <p class="text-muted small">Response time: 24-48 hours</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 mb-4">
                        <div class="card contact-card h-100">
                            <div class="card-body text-center">
                                <i class="fas fa-comments fa-3x mb-3 text-info"></i>
                                <h5 class="card-title">Live Chat</h5>
                                <p class="card-text">Chat with support representative</p>
                                <a href="#" class="btn btn-info mt-2">Start Chat</a>
                                <p class="text-muted small mt-2">Available: 10AM - 4PM</p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Frequently Asked Questions</h5>
                    </div>
                    <div class="card-body">
                        <div class="accordion" id="faqAccordion">
                            <div class="card">
                                <div class="card-header" id="headingOne">
                                    <h2 class="mb-0">
                                        <button class="btn btn-link btn-block text-left" type="button" data-toggle="collapse" data-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                            How long does the application process take?
                                        </button>
                                    </h2>
                                </div>
                                <div id="collapseOne" class="collapse show" aria-labelledby="headingOne" data-parent="#faqAccordion">
                                    <div class="card-body">
                                        Most applications are processed within 2-3 weeks. Once you submit all required documents, the admissions committee will review your application and make a decision. You will be notified via email about the status of your application.
                                    </div>
                                </div>
                            </div>
                            <div class="card">
                                <div class="card-header" id="headingTwo">
                                    <h2 class="mb-0">
                                        <button class="btn btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                            What documents are required for application?
                                        </button>
                                    </h2>
                                </div>
                                <div id="collapseTwo" class="collapse" aria-labelledby="headingTwo" data-parent="#faqAccordion">
                                    <div class="card-body">
                                        Required documents include your academic transcript, ID proof (passport or national ID), and a personal statement. Some programs may require additional documents like recommendation letters or specific certifications.
                                    </div>
                                </div>
                            </div>
                            <div class="card">
                                <div class="card-header" id="headingThree">
                                    <h2 class="mb-0">
                                        <button class="btn btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                                            Can I edit my application after submission?
                                        </button>
                                    </h2>
                                </div>
                                <div id="collapseThree" class="collapse" aria-labelledby="headingThree" data-parent="#faqAccordion">
                                    <div class="card-body">
                                        Yes, you can edit your application as long as it is still in "Pending" status. Once your application has been reviewed or approved, you will not be able to make changes. Please contact the admissions office if you need to make significant changes to an application that has already been reviewed.
                                    </div>
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
