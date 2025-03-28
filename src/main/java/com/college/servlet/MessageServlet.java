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
import java.util.List;
import org.json.JSONObject;
import org.json.JSONArray;

@WebServlet("/message/*")
public class MessageServlet extends HttpServlet {
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
    
    private void handleListMessages(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            User user = (User) request.getSession().getAttribute("user");
            if (user == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"success\": false, \"message\": \"User not logged in\"}");
                return;
            }
            
            List<Message> messages = messageDAO.getMessagesByUserId(user.getId());
            JSONArray jsonArray = new JSONArray();
            
            for (Message msg : messages) {
                JSONObject jsonMsg = new JSONObject();
                jsonMsg.put("id", msg.getId());
                jsonMsg.put("message", msg.getMessage());
                jsonMsg.put("fromAdmin", msg.isFromAdmin());
                jsonMsg.put("createdAt", msg.getCreatedAt().toString());
                jsonArray.put(jsonMsg);
            }
            
            response.getWriter().write(jsonArray.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"Error fetching messages: " + escapeJson(e.getMessage()) + "\"}");
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
            String messageText = request.getParameter("message");
            
            if (messageText == null || messageText.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"Message cannot be empty\"}");
                return;
            }
            
            Message message = new Message(user.getId(), messageText, "ADMIN".equals(user.getRole()));
            boolean success = messageDAO.saveMessage(message);
            
            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"Message sent successfully\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to send message\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
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