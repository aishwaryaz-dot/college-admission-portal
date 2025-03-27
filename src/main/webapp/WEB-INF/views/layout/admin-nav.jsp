<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<li class="nav-item">
    <a class="nav-link ${requestScope['javax.servlet.forward.request_uri'].endsWith('/admin/clear-data') ? 'active' : ''}" 
       href="${pageContext.request.contextPath}/admin/clear-data">
        <i class="bi bi-trash me-1"></i> Clear Student Data
    </a>
</li> 