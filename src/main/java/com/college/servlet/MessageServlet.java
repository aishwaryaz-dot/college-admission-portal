package com.college.servlet;

import com.college.dao.MessageDAO;
import com.college.model.Message;
import com.college.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/message/*")
public class MessageServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(MessageServlet.class.getName());
    private MessageDAO messageDAO;

    @Override
    public void init() throws ServletException {
        messageDAO = new MessageDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if ("/list".equals(pathInfo)) {
            handleListMessages(request, response);
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid endpoint\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if ("/send".equals(pathInfo)) {
            handleSendMessage(request, response);
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid endpoint\"}");
        }
    }

    private void handleListMessages(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            String applicationIdParam = request.getParameter("applicationId");
            if (applicationIdParam == null || applicationIdParam.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"Missing applicationId parameter\"}");
                return;
            }
            
            int applicationId = Integer.parseInt(applicationIdParam);
            List<Message> messages = messageDAO.getMessagesByApplicationId(applicationId);
            
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < messages.size(); i++) {
                Message msg = messages.get(i);
                json.append("{")
                    .append("\"id\":").append(msg.getId()).append(",")
                    .append("\"message\":\"").append(escapeJson(msg.getMessage())).append("\",")
                    .append("\"senderName\":\"").append(escapeJson(msg.getSenderName())).append("\",")
                    .append("\"senderRole\":\"").append(escapeJson(msg.getSenderRole())).append("\",")
                    .append("\"createdAt\":\"").append(msg.getCreatedAt()).append("\"")
                    .append("}");
                
                if (i < messages.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]");
            
            response.getWriter().write(json.toString());
        } catch (NumberFormatException e) {
            LOGGER.severe("Error parsing applicationId: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid applicationId format\"}");
        } catch (Exception e) {
            LOGGER.severe("Error fetching messages: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"Error fetching messages: " + escapeJson(e.getMessage()) + "\"}");
        }
    }

    private void handleSendMessage(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"success\": false, \"message\": \"User not logged in\"}");
                return;
            }
            
            User user = (User) session.getAttribute("user");
            
            String applicationIdParam = request.getParameter("applicationId");
            if (applicationIdParam == null || applicationIdParam.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"Missing applicationId parameter\"}");
                return;
            }
            
            String messageText = request.getParameter("message");
            if (messageText == null || messageText.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"Message cannot be empty\"}");
                return;
            }
            
            int applicationId = Integer.parseInt(applicationIdParam);
            Message message = new Message(applicationId, user.getId(), messageText);
            
            boolean success = messageDAO.createMessage(message);
            
            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"Message sent successfully\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to send message\"}");
            }
        } catch (NumberFormatException e) {
            LOGGER.severe("Error parsing applicationId: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid applicationId format\"}");
        } catch (Exception e) {
            LOGGER.severe("Error sending message: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"Error sending message: " + escapeJson(e.getMessage()) + "\"}");
        }
    }
    
    private String escapeJson(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
} 