<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>College Admission Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">College Admission Portal</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <c:choose>
                        <c:when test="${empty sessionScope.user}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/login.jsp">Login</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/register.jsp">Register</a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/application/list">My Applications</a>
                            </li>
                            <c:if test="${sessionScope.user.role eq 'ADMIN'}">
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard.jsp">Admin Dashboard</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/clear-data">Clear Student Data</a>
                                </li>
                            </c:if>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/auth/logout">Logout</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="jumbotron">
            <h1 class="display-4">Welcome to College Admission Portal</h1>
            <p class="lead">Your gateway to a brighter future through quality education.</p>
            <hr class="my-4">
            
            <c:choose>
                <c:when test="${empty sessionScope.user}">
                    <p>Please login or register to get started.</p>
                    <div class="d-flex gap-2">
                        <a class="btn btn-primary btn-lg" href="${pageContext.request.contextPath}/login.jsp" role="button">Login</a>
                        <a class="btn btn-secondary btn-lg" href="${pageContext.request.contextPath}/register.jsp" role="button">Register</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <% 
                    // Get the user from the session
                    com.college.model.User currentUser = (com.college.model.User) session.getAttribute("user");
                    if (currentUser != null) {
                    %>
                    <div class="alert alert-info mb-4">
                        <strong>Current User Session:</strong> <%= currentUser.getRole() %>
                    </div>
                    <% } %>
                    
                    <p>Welcome back, ${sessionScope.user.email}!</p>
                    <div class="d-flex gap-2">
                        <a class="btn btn-primary btn-lg" href="${pageContext.request.contextPath}/application/list" role="button">View Applications</a>
                        <c:if test="${sessionScope.user.role ne 'ADMIN'}">
                            <a class="btn btn-success btn-lg" href="${pageContext.request.contextPath}/application/new" role="button">Apply Now</a>
                        </c:if>
                        <c:if test="${sessionScope.user.role eq 'ADMIN'}">
                            <a class="btn btn-danger btn-lg" href="${pageContext.request.contextPath}/admin/clear-data" role="button">Clear Student Data</a>
                            <a class="btn btn-info btn-lg" href="${pageContext.request.contextPath}/admin/dashboard.jsp" role="button">Admin Dashboard</a>
                        </c:if>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 