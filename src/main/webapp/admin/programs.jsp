<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.college.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Programs - Admin Dashboard</title>
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
    </style>
</head>
<body>
    <% 
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
    %>

    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 p-0 sidebar">
                <div class="text-center py-4">
                    <h4 class="text-white">Admin Panel</h4>
                </div>
                <a href="dashboard.jsp"><i class="fas fa-tachometer-alt mr-2"></i> Dashboard</a>
                <a href="applications.jsp"><i class="fas fa-file-alt mr-2"></i> Applications</a>
                <a href="students.jsp"><i class="fas fa-user-graduate mr-2"></i> Students</a>
                <a href="programs.jsp" class="active"><i class="fas fa-graduation-cap mr-2"></i> Programs</a>
                <a href="settings.jsp"><i class="fas fa-cog mr-2"></i> Settings</a>
                <a href="${pageContext.request.contextPath}/auth?action=logout"><i class="fas fa-sign-out-alt mr-2"></i> Logout</a>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-10 content">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>Programs Management</h2>
                    <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#addProgramModal">
                        <i class="fas fa-plus mr-2"></i>Add Program
                    </button>
                </div>
                
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Available Programs</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Program Name</th>
                                        <th>Description</th>
                                        <th>Duration</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- Sample Program Data -->
                                    <tr>
                                        <td>1</td>
                                        <td>Computer Science</td>
                                        <td>Bachelor's program in Computer Science</td>
                                        <td>4 years</td>
                                        <td><span class="badge badge-success">Active</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-info" data-toggle="modal" data-target="#editProgramModal"><i class="fas fa-edit mr-1"></i>Edit</button>
                                            <button class="btn btn-sm btn-danger" data-toggle="modal" data-target="#deleteProgramModal"><i class="fas fa-trash mr-1"></i>Delete</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>2</td>
                                        <td>Business Administration</td>
                                        <td>Bachelor's program in Business Administration</td>
                                        <td>3 years</td>
                                        <td><span class="badge badge-success">Active</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-info" data-toggle="modal" data-target="#editProgramModal"><i class="fas fa-edit mr-1"></i>Edit</button>
                                            <button class="btn btn-sm btn-danger" data-toggle="modal" data-target="#deleteProgramModal"><i class="fas fa-trash mr-1"></i>Delete</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>3</td>
                                        <td>Mechanical Engineering</td>
                                        <td>Bachelor's program in Mechanical Engineering</td>
                                        <td>4 years</td>
                                        <td><span class="badge badge-success">Active</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-info" data-toggle="modal" data-target="#editProgramModal"><i class="fas fa-edit mr-1"></i>Edit</button>
                                            <button class="btn btn-sm btn-danger" data-toggle="modal" data-target="#deleteProgramModal"><i class="fas fa-trash mr-1"></i>Delete</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Add Program Modal -->
    <div class="modal fade" id="addProgramModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title">Add New Program</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form action="${pageContext.request.contextPath}/admin/program" method="post">
                        <input type="hidden" name="action" value="add">
                        <div class="form-group">
                            <label for="programName">Program Name</label>
                            <input type="text" class="form-control" id="programName" name="programName" required>
                        </div>
                        <div class="form-group">
                            <label for="description">Description</label>
                            <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
                        </div>
                        <div class="form-group">
                            <label for="duration">Duration</label>
                            <input type="text" class="form-control" id="duration" name="duration" required>
                        </div>
                        <div class="form-group">
                            <label for="status">Status</label>
                            <select class="form-control" id="status" name="status" required>
                                <option value="active">Active</option>
                                <option value="inactive">Inactive</option>
                            </select>
                        </div>
                        <div class="text-right">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">Add Program</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Edit Program Modal (Template) -->
    <div class="modal fade" id="editProgramModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title">Edit Program</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form action="${pageContext.request.contextPath}/admin/program" method="post">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="programId" value="1">
                        <div class="form-group">
                            <label for="editProgramName">Program Name</label>
                            <input type="text" class="form-control" id="editProgramName" name="programName" value="Computer Science" required>
                        </div>
                        <div class="form-group">
                            <label for="editDescription">Description</label>
                            <textarea class="form-control" id="editDescription" name="description" rows="3" required>Bachelor's program in Computer Science</textarea>
                        </div>
                        <div class="form-group">
                            <label for="editDuration">Duration</label>
                            <input type="text" class="form-control" id="editDuration" name="duration" value="4 years" required>
                        </div>
                        <div class="form-group">
                            <label for="editStatus">Status</label>
                            <select class="form-control" id="editStatus" name="status" required>
                                <option value="active" selected>Active</option>
                                <option value="inactive">Inactive</option>
                            </select>
                        </div>
                        <div class="text-right">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete Program Confirmation Modal -->
    <div class="modal fade" id="deleteProgramModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title">Confirm Delete</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete this program? This action cannot be undone.</p>
                    <p><strong>Note:</strong> This will not affect existing applications for this program.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <form action="${pageContext.request.contextPath}/admin/program" method="post">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="programId" value="1">
                        <button type="submit" class="btn btn-danger">Delete Program</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 