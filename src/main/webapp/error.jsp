<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - College Admission Portal</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .error-container {
            max-width: 600px;
            margin: 100px auto;
            padding: 30px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        .error-icon {
            font-size: 60px;
            color: #dc3545;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="error-container bg-white">
            <div class="error-icon">
                <i class="fas fa-exclamation-circle"></i>⚠️
            </div>
            <h2 class="text-danger mb-4">Error Occurred</h2>
            
            <% if(request.getAttribute("errorMessage") != null) { %>
                <p class="lead"><%= request.getAttribute("errorMessage") %></p>
            <% } else { %>
                <p class="lead">Sorry, an unexpected error has occurred. Please try again later.</p>
            <% } %>
            
            <div class="mt-4">
                <a href="index.jsp" class="btn btn-primary">Go to Home</a>
                <a href="javascript:history.back()" class="btn btn-secondary ml-2">Go Back</a>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 