<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>College Admission Portal - Admin - Clear Student Data</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        .warning-area {
            background-color: #fff3cd;
            border-left: 5px solid #ffc107;
            padding: 20px;
            margin-bottom: 20px;
        }
        .danger-area {
            background-color: #f8d7da;
            border-left: 5px solid #dc3545;
            padding: 20px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="bi bi-mortarboard-fill me-2"></i>College Admission Portal
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                            <i class="bi bi-speedometer me-1"></i> Admin Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/application/list">
                            <i class="bi bi-list-check me-1"></i> Applications
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/clear-data">
                            <i class="bi bi-trash me-1"></i> Clear Student Data
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/auth/logout">
                            <i class="bi bi-box-arrow-right me-1"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row mb-4">
            <div class="col">
                <h2><i class="bi bi-exclamation-triangle-fill text-danger me-2"></i>Clear Student Data</h2>
                <p class="text-muted">Admin tools for clearing student data from the system</p>
            </div>
            <div class="col text-end">
                <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="btn btn-primary me-2">
                    <i class="bi bi-speedometer"></i> Admin Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/application/list" class="btn btn-secondary">
                    <i class="bi bi-arrow-left"></i> Back to Applications
                </a>
            </div>
        </div>

        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${sessionScope.errorMessage}
            </div>
            <% session.removeAttribute("errorMessage"); %>
        </c:if>
        
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success">
                <i class="bi bi-check-circle-fill me-2"></i>${sessionScope.successMessage}
            </div>
            <% session.removeAttribute("successMessage"); %>
        </c:if>

        <div class="card mb-4">
            <div class="card-header bg-danger text-white">
                <h4 class="mb-0"><i class="bi bi-trash-fill me-2"></i>Delete Student Data</h4>
            </div>
            <div class="card-body">
                <div class="danger-area">
                    <h5><i class="bi bi-exclamation-triangle-fill me-2"></i>Warning: Destructive Action</h5>
                    <p>This action will permanently delete all student data from the system including:</p>
                    <ul>
                        <li>All student accounts (users with role "STUDENT")</li>
                        <li>All applications submitted by students</li>
                        <li>All documents uploaded by students</li>
                        <li>All messages related to applications</li>
                    </ul>
                    <p class="fw-bold">This action cannot be undone. Admin accounts will be preserved.</p>
                </div>

                <form method="POST" action="${pageContext.request.contextPath}/admin/clear-data" onsubmit="return confirm('Are you ABSOLUTELY SURE you want to delete ALL student data? This cannot be undone!');">
                    <div class="mb-3">
                        <label for="confirm" class="form-label">Confirmation</label>
                        <input type="text" class="form-control" id="confirm" name="confirm" 
                               placeholder="Type DELETE_ALL_STUDENT_DATA to confirm" required>
                        <div class="form-text text-danger">Type exactly DELETE_ALL_STUDENT_DATA to confirm deletion.</div>
                    </div>
                    
                    <button type="submit" class="btn btn-danger">
                        <i class="bi bi-trash"></i> Delete All Student Data
                    </button>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 