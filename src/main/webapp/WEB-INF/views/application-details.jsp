<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>College Admission Portal - Application Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        .message-container {
            height: 300px;
            overflow-y: auto;
            border: 1px solid #dee2e6;
            border-radius: 0.25rem;
            padding: 1rem;
            background: #f8f9fa;
        }
        .message {
            margin-bottom: 1rem;
            padding: 0.5rem 1rem;
            border-radius: 0.25rem;
        }
        .message.admin {
            background: #e3f2fd;
            margin-left: 2rem;
        }
        .message.student {
            background: #fff;
            margin-right: 2rem;
        }
        .message-meta {
            font-size: 0.8rem;
            color: #6c757d;
        }
        .message-text {
            margin-top: 0.25rem;
        }
        .document-card {
            border: 1px solid #dee2e6;
            border-radius: 0.25rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
        }
        .document-card:hover {
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .document-icon {
            font-size: 2rem;
            color: #dc3545;
        }
    </style>
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/application/list">My Applications</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/auth/logout">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row mb-4">
            <div class="col">
                <h2>Application Details</h2>
            </div>
            <div class="col text-end">
                <a href="${pageContext.request.contextPath}/application/list" class="btn btn-secondary">Back to List</a>
            </div>
        </div>

        <div class="row">
            <div class="col-md-8">
                <div class="card mb-4">
                    <div class="card-body">
                        <c:if test="${param.error eq 'true'}">
                            <div class="alert alert-danger">
                                Failed to update application status. Please try again.
                            </div>
                        </c:if>

                        <div class="row">
                            <div class="col-md-6">
                                <h4 class="card-title">Personal Information</h4>
                                <table class="table">
                                    <tr>
                                        <th>Name:</th>
                                        <td>${application.firstName} ${application.lastName}</td>
                                    </tr>
                                    <tr>
                                        <th>Date of Birth:</th>
                                        <td><fmt:formatDate value="${application.dateOfBirth}" pattern="MMMM dd, yyyy"/></td>
                                    </tr>
                                    <tr>
                                        <th>Phone:</th>
                                        <td>${application.phone}</td>
                                    </tr>
                                    <tr>
                                        <th>Address:</th>
                                        <td>${application.address}</td>
                                    </tr>
                                    <tr>
                                        <th>Program:</th>
                                        <td>${application.program}</td>
                                    </tr>
                                    <tr>
                                        <th>Status:</th>
                                        <td>
                                            <span class="badge bg-${application.status eq 'PENDING' ? 'warning' : (application.status eq 'UNDER_REVIEW' ? 'info' : (application.status eq 'ACCEPTED' ? 'success' : 'danger'))}">
                                                ${application.status}
                                            </span>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <div class="col-md-6">
                                <h4 class="card-title">Application Information</h4>
                                <table class="table">
                                    <tr>
                                        <th>Submitted:</th>
                                        <td><fmt:formatDate value="${application.createdAt}" pattern="MMMM dd, yyyy HH:mm:ss"/></td>
                                    </tr>
                                    <tr>
                                        <th>Last Updated:</th>
                                        <td><fmt:formatDate value="${application.updatedAt}" pattern="MMMM dd, yyyy HH:mm:ss"/></td>
                                    </tr>
                                </table>
                            </div>
                        </div>

                        <div class="mt-4">
                            <h4>Uploaded Documents</h4>
                            <c:choose>
                                <c:when test="${empty documents}">
                                    <div class="alert alert-info">
                                        <i class="bi bi-info-circle-fill me-2"></i> No documents have been uploaded for this application.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="row">
                                        <c:forEach items="${documents}" var="doc">
                                            <div class="col-md-6 col-lg-4">
                                                <div class="document-card p-3">
                                                    <div class="d-flex align-items-center mb-2">
                                                        <div class="document-icon me-3">
                                                            <i class="bi bi-file-earmark-pdf"></i>
                                                        </div>
                                                        <div>
                                                            <h5 class="mb-1">${doc.documentType}</h5>
                                                            <small class="text-muted">${doc.fileName}</small>
                                                        </div>
                                                    </div>
                                                    <div class="text-end">
                                                        <a href="${pageContext.request.contextPath}/application/download?id=${doc.id}" 
                                                           class="btn btn-sm btn-primary">
                                                            <i class="bi bi-download"></i> Download
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <c:if test="${isAdmin}">
                            <div class="mt-4">
                                <h4>Admin Actions</h4>
                                <div class="btn-group">
                                    <c:if test="${application.status != 'ACCEPTED' && application.status != 'REJECTED'}">
                                        <a href="${pageContext.request.contextPath}/application/update-status?id=${application.id}&status=ACCEPTED" 
                                           class="btn btn-success">
                                           <i class="bi bi-check-circle"></i> Accept Application
                                        </a>
                                        <a href="${pageContext.request.contextPath}/application/update-status?id=${application.id}&status=REJECTED" 
                                           class="btn btn-danger ms-2">
                                           <i class="bi bi-x-circle"></i> Reject Application
                                        </a>
                                    </c:if>
                                    <a href="${pageContext.request.contextPath}/application/delete?id=${application.id}" 
                                       class="btn btn-danger ms-2"
                                       onclick="return confirm('Are you sure you want to delete this application? This action cannot be undone.')">
                                       <i class="bi bi-trash"></i> Delete Application
                                    </a>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card mb-4">
                    <div class="card-header">
                        <h4 class="card-title mb-0">
                            <i class="bi bi-chat-left-text me-2"></i> Communication
                        </h4>
                    </div>
                    <div class="card-body">
                        <div class="message-container" id="messageContainer">
                            <div class="text-center my-3">
                                <div class="spinner-border text-primary" role="status">
                                    <span class="visually-hidden">Loading...</span>
                                </div>
                                <p class="mt-2">Loading messages...</p>
                            </div>
                        </div>

                        <form id="messageForm" class="mt-3">
                            <div class="mb-3">
                                <textarea class="form-control" id="messageText" rows="3" placeholder="Write a message..." required></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-send"></i> Send Message
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const messageContainer = document.getElementById('messageContainer');
            const messageForm = document.getElementById('messageForm');
            const messageText = document.getElementById('messageText');
            const applicationId = ${application.id};

            // Load messages
            function loadMessages() {
                fetch('${pageContext.request.contextPath}/message/list?applicationId=' + applicationId)
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Network response was not ok: ' + response.status);
                        }
                        return response.json();
                    })
                    .then(messages => {
                        if (messages.length === 0) {
                            messageContainer.innerHTML = '<div class="text-center text-muted my-5">No messages yet. Start the conversation!</div>';
                        } else {
                            messageContainer.innerHTML = '';
                            messages.forEach(message => {
                                const messageDiv = document.createElement('div');
                                messageDiv.className = `message ${message.senderRole.toLowerCase()}`;
                                messageDiv.innerHTML = `
                                    <div class="message-meta">
                                        <span class="fw-bold">\${message.senderName}</span> 
                                        <span class="badge bg-\${message.senderRole == 'ADMIN' ? 'primary' : 'secondary'}">\${message.senderRole}</span>
                                        <span class="ms-2">\${new Date(message.createdAt).toLocaleString()}</span>
                                    </div>
                                    <div class="message-text">\${message.message}</div>
                                `;
                                messageContainer.appendChild(messageDiv);
                            });
                            // Scroll to bottom
                            messageContainer.scrollTop = messageContainer.scrollHeight;
                        }
                    })
                    .catch(error => {
                        console.error('Error loading messages:', error);
                        messageContainer.innerHTML = '<div class="alert alert-danger">Failed to load messages: ' + error.message + '. Please refresh the page.</div>';
                    });
            }

            loadMessages();

            // Send message
            messageForm.addEventListener('submit', function(e) {
                e.preventDefault();
                if (messageText.value.trim() === '') {
                    return;
                }

                const data = new URLSearchParams();
                data.append('applicationId', applicationId);
                data.append('message', messageText.value);

                // Show sending indicator
                const sendButton = this.querySelector('button[type="submit"]');
                const originalButtonText = sendButton.innerHTML;
                sendButton.disabled = true;
                sendButton.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Sending...';

                fetch('${pageContext.request.contextPath}/message/send', {
                    method: 'POST',
                    body: data,
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    }
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok: ' + response.status);
                    }
                    return response.json();
                })
                .then(result => {
                    if (result.success) {
                        messageText.value = '';
                        loadMessages();
                    } else {
                        alert('Failed to send message: ' + (result.message || 'Unknown error'));
                    }
                })
                .catch(error => {
                    console.error('Error sending message:', error);
                    messageContainer.innerHTML += '<div class="alert alert-danger mt-2">Error sending message: ' + error.message + '</div>';
                })
                .finally(() => {
                    // Restore button state
                    sendButton.disabled = false;
                    sendButton.innerHTML = originalButtonText;
                });
            });
        });
    </script>
</body>
</html>