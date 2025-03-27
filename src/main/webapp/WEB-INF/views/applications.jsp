<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>College Admission Portal - Applications</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .navbar {
            box-shadow: 0 2px 4px rgba(0,0,0,.1);
        }
        .doc-badge {
            display: inline-block;
            margin-right: 5px;
            margin-bottom: 5px;
        }
        .doc-badge a {
            text-decoration: none;
            color: inherit;
        }
        .status-badge {
            display: inline-block;
            padding: 0.25em 0.4em;
            font-size: 75%;
            font-weight: 700;
            line-height: 1;
            text-align: center;
            white-space: nowrap;
            vertical-align: baseline;
            border-radius: 0.25rem;
        }
        .status-pending {
            background-color: #ffc107;
            color: #212529;
        }
        .status-accepted {
            background-color: #28a745;
            color: white;
        }
        .status-rejected {
            background-color: #dc3545;
            color: white;
        }
        .action-buttons .btn {
            margin-right: 5px;
            margin-bottom: 5px;
        }
        .card {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0,0,0,.1);
            border: none;
        }
        .card-header {
            background-color: #f8f9fa;
            border-bottom: 1px solid rgba(0,0,0,.125);
            padding: 15px 20px;
        }
        .card-body {
            padding: 20px;
        }
        .table th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #495057;
        }
        .table td {
            vertical-align: middle;
        }
        .btn-view {
            background-color: #17a2b8;
            border-color: #17a2b8;
            color: white;
        }
        .btn-view:hover {
            background-color: #138496;
            border-color: #117a8b;
            color: white;
        }
        .alert {
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,.05);
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
                    <% 
                    // Get the user from the session
                    com.college.model.User currentUser = (com.college.model.User) session.getAttribute("user");
                    // Check if user is logged in and is an admin
                    if (currentUser != null && "ADMIN".equals(currentUser.getRole())) {
                        // Now we know the user is an admin, display admin actions
                        pageContext.setAttribute("isAdmin", true);
                        %>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                                <i class="bi bi-speedometer me-1"></i> Admin Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/clear-data">
                                <i class="bi bi-trash me-1"></i> Clear Student Data
                            </a>
                        </li>
                        <%
                    } else {
                        pageContext.setAttribute("isAdmin", false);
                    }
                    %>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/application/list">
                            <i class="bi bi-list-check me-1"></i> My Applications
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
                <h2><i class="bi bi-list-check me-2"></i>Applications</h2>
                <p class="text-muted">View and manage your submitted applications</p>
            </div>
            <div class="col text-end">
                <a href="${pageContext.request.contextPath}/application/new" class="btn btn-success">
                    <i class="bi bi-plus-circle"></i> New Application
                </a>
            </div>
        </div>
        
        <%
        // Reuse the currentUser variable from earlier in the page
        if (currentUser != null) {
        %>
        <div class="alert alert-info mb-4">
            <strong>Current User Session:</strong> <%= currentUser.getRole() %>
        </div>
        <% } %>

        <!-- Display messages from URL parameters -->
        <c:if test="${param.error != null}">
            <div class="alert alert-danger">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <c:choose>
                    <c:when test="${param.error == 'delete_failed'}">Failed to delete application.</c:when>
                    <c:when test="${param.error == 'invalid_id'}">Invalid application ID.</c:when>
                    <c:otherwise>An error occurred.</c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <c:if test="${param.success != null}">
            <div class="alert alert-success">
                <i class="bi bi-check-circle-fill me-2"></i>
                <c:choose>
                    <c:when test="${param.success == 'deleted'}">Application deleted successfully.</c:when>
                    <c:otherwise>Operation completed successfully.</c:otherwise>
                </c:choose>
            </div>
        </c:if>
        
        <!-- Display messages from session -->
        <% 
        String message = (String)session.getAttribute("message");
        if (message != null) {
            // Clear the message from session after displaying it
            session.removeAttribute("message");
        %>
            <div class="alert alert-info">
                <i class="bi bi-info-circle-fill me-2"></i><%= message %>
            </div>
        <% } %>
        
        <% 
        String sessionErrorMsg = (String) session.getAttribute("errorMessage");
        String sessionSuccessMsg = (String) session.getAttribute("successMessage");
        
        if (sessionErrorMsg != null) {
        %>
            <div class="alert alert-danger">
                <i class="bi bi-exclamation-triangle-fill me-2"></i><%= sessionErrorMsg %>
            </div>
        <%
            session.removeAttribute("errorMessage");
        }
        
        if (sessionSuccessMsg != null) {
        %>
            <div class="alert alert-success">
                <i class="bi bi-check-circle-fill me-2"></i><%= sessionSuccessMsg %>
            </div>
        <%
            session.removeAttribute("successMessage");
        }
        %>

        <div class="card mb-4">
            <div class="card-body">
                <c:choose>
                    <c:when test="${empty applications}">
                        <div class="text-center py-5">
                            <i class="bi bi-folder-x display-3 text-muted mb-3"></i>
                            <h4 class="text-muted">No applications found</h4>
                            <c:if test="${sessionScope.user.role != 'ADMIN'}">
                                <p class="text-muted mb-4">Click the "New Application" button to submit your first application.</p>
                                <a href="${pageContext.request.contextPath}/application/new" class="btn btn-primary">
                                    <i class="bi bi-plus-lg"></i> New Application
                                </a>
                            </c:if>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Program</th>
                                        <th>Status</th>
                                        <th>Documents</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${applications}" var="app">
                                        <tr>
                                            <td>${app.id}</td>
                                            <td>${app.firstName} ${app.lastName}</td>
                                            <td>${app.program}</td>
                                            <td>
                                                <span class="badge ${app.status == 'ACCEPTED' ? 'bg-success' : 
                                                           app.status == 'REJECTED' ? 'bg-danger' : 
                                                           'bg-warning'}">
                                                    ${app.status}
                                                </span>
                                            </td>
                                            <td>
                                                <c:if test="${empty app.documents}">
                                                    <span class="text-muted"><i class="bi bi-file-earmark-x me-1"></i>No documents</span>
                                                </c:if>
                                                <c:if test="${not empty app.documents}">
                                                    <c:forEach items="${app.documents}" var="doc">
                                                        <a href="${pageContext.request.contextPath}/application/download?id=${doc.id}" 
                                                           class="btn btn-sm btn-outline-primary me-1 mb-1">
                                                            <i class="bi bi-file-earmark-text me-1"></i>${doc.documentType}
                                                        </a>
                                                    </c:forEach>
                                                </c:if>
                                            </td>
                                            <td class="action-buttons">
                                                <!-- View button for everyone -->
                                                <a href="${pageContext.request.contextPath}/application/view?id=${app.id}" 
                                                   class="btn btn-sm btn-info mb-2">
                                                   <i class="bi bi-eye"></i> View
                                                </a>
                                                
                                                <!-- ADMIN ONLY BUTTONS - using scriptlet to ensure proper role check -->
                                                <% 
                                                // We already have currentUser from the top of the page
                                                // Just reuse it for consistency
                                                if (currentUser != null && "ADMIN".equals(currentUser.getRole())) {
                                                    // Now we know the user is an admin, display admin actions
                                                    pageContext.setAttribute("isAdmin", true);
                                                } else {
                                                    pageContext.setAttribute("isAdmin", false);
                                                }
                                                %>
                                                
                                                <c:if test="${isAdmin}">
                                                    <!-- Accept/Reject buttons -->
                                                    <c:if test="${app.status ne 'ACCEPTED' && app.status ne 'REJECTED'}">
                                                        <div class="btn-group mt-1 mb-2 w-100">
                                                            <a href="${pageContext.request.contextPath}/application/update-status?id=${app.id}&status=ACCEPTED" 
                                                               class="btn btn-sm btn-success">
                                                               <i class="bi bi-check-lg"></i> Accept
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/application/update-status?id=${app.id}&status=REJECTED" 
                                                               class="btn btn-sm btn-danger">
                                                               <i class="bi bi-x-lg"></i> Reject
                                                            </a>
                                                        </div>
                                                    </c:if>
                                                    
                                                    <!-- Delete button -->
                                                    <form method="POST" action="${pageContext.request.contextPath}/application/delete" class="mt-1">
                                                        <input type="hidden" name="id" value="${app.id}">
                                                        <button type="submit" class="btn btn-sm btn-danger w-100"
                                                            onclick="return confirm('Are you sure you want to delete this application? This action cannot be undone.')">
                                                            <i class="bi bi-trash"></i> Delete
                                                        </button>
                                                    </form>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <footer class="mt-5 mb-3 text-center text-muted">
            <p><small>College Admission Portal &copy; 2025. All rights reserved.</small></p>
        </footer>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 