package com.college.servlet;

import com.college.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/application/*")
public class AdminCheckFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            // Add a debug attribute to show the user's role
            request.setAttribute("userRole", user.getRole());
            request.setAttribute("isAdmin", "ADMIN".equals(user.getRole()));
            
            // Debug print
            System.out.println("User Role: " + user.getRole());
            System.out.println("Is Admin: " + "ADMIN".equals(user.getRole()));
        }
        
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
} 