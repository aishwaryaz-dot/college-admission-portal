<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.college.model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>Session Debug Information</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h1>Session Debug Information</h1>
        
        <% User user = (User) session.getAttribute("user"); %>
        <% if (user != null) { %>
            <div class="alert alert-primary mb-4">
                <h3 class="mb-3">USER LOGIN SESSION: <%= user.getRole() %></h3>
                <p><strong>User ID:</strong> <%= user.getId() %></p>
                <p><strong>Name:</strong> <%= user.getFirstName() %> <%= user.getLastName() %></p>
                <p><strong>Email:</strong> <%= user.getEmail() %></p>
            </div>
        <% } else { %>
            <div class="alert alert-warning mb-4">
                <h3>No user logged in</h3>
                <p>You need to <a href="${pageContext.request.contextPath}/login.jsp">login</a> first</p>
            </div>
        <% } %>
        
        <div class="card mb-4">
            <div class="card-header bg-primary text-white">
                Session Information
            </div>
            <div class="card-body">
                <p><strong>Session ID:</strong> <%= session.getId() %></p>
                <p><strong>Creation Time:</strong> <%= new Date(session.getCreationTime()) %></p>
                <p><strong>Last Accessed Time:</strong> <%= new Date(session.getLastAccessedTime()) %></p>
                <p><strong>Max Inactive Interval:</strong> <%= session.getMaxInactiveInterval() %> seconds</p>
                <p><strong>Is New Session:</strong> <%= session.isNew() %></p>
            </div>
        </div>
        
        <div class="card mb-4">
            <div class="card-header bg-info text-white">
                User Information
            </div>
            <div class="card-body">
                <% if (user != null) { %>
                    <p><strong>User ID:</strong> <%= user.getId() %></p>
                    <p><strong>Email:</strong> <%= user.getEmail() %></p>
                    <p><strong>Name:</strong> <%= user.getFirstName() %> <%= user.getLastName() %></p>
                    <p><strong>Role:</strong> <%= user.getRole() %></p>
                    <p><strong>Status:</strong> <%= user.getStatus() %></p>
                    <div class="alert alert-info">
                        <strong>User Login Session:</strong> <%= user.getRole() %>
                    </div>
                <% } else { %>
                    <div class="alert alert-warning">
                        No user in session.
                    </div>
                <% } %>
            </div>
        </div>
        
        <div class="card mb-4">
            <div class="card-header bg-secondary text-white">
                All Session Attributes
            </div>
            <div class="card-body">
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>Attribute Name</th>
                            <th>Attribute Value</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% Enumeration<String> attributeNames = session.getAttributeNames(); %>
                        <% while (attributeNames.hasMoreElements()) { %>
                            <% String name = attributeNames.nextElement(); %>
                            <% Object value = session.getAttribute(name); %>
                            <tr>
                                <td><%= name %></td>
                                <td><pre><%= value %></pre></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
        
        <div class="card mb-4">
            <div class="card-header bg-dark text-white">
                Request Information
            </div>
            <div class="card-body">
                <p><strong>Request URI:</strong> <%= request.getRequestURI() %></p>
                <p><strong>Context Path:</strong> <%= request.getContextPath() %></p>
                <p><strong>Servlet Path:</strong> <%= request.getServletPath() %></p>
                <p><strong>Remote Address:</strong> <%= request.getRemoteAddr() %></p>
                <p><strong>User Agent:</strong> <%= request.getHeader("User-Agent") %></p>
            </div>
        </div>
        
        <div class="mt-4">
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Go to Home</a>
            <a href="${pageContext.request.contextPath}/application/list" class="btn btn-secondary">Go to Applications</a>
            <% if (user != null && "ADMIN".equals(user.getRole())) { %>
                <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="btn btn-success">Go to Admin Dashboard</a>
                <a href="${pageContext.request.contextPath}/admin/clear-data" class="btn btn-danger">Clear Student Data</a>
            <% } %>
        </div>
    </div>
</body>
</html> 