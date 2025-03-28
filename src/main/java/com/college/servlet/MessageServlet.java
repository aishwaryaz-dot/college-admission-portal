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
            sendJsonError(response, HttpServletResponse.SC_NOT_FOUND, "Invalid endpoint");
        }
    }
    
    private void handleListMessages(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        setJsonResponse(response);
        
        try {
            User user = (User) request.getSession().getAttribute("user");
            if (user == null) {
                sendJsonError(response, HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
                return;
            }
            
            List<Message> messages = messageDAO.getMessagesByUserId(user.getId());
            JSONArray jsonArray = new JSONArray();
            
            for (Message msg : messages) {
                JSONObject jsonMsg = new JSONObject();
                jsonMsg.put("id", msg.getId());
                jsonMsg.put("userId", msg.getUserId());
                jsonMsg.put("message", msg.getMessage());
                jsonMsg.put("fromAdmin", msg.isFromAdmin());
                if (msg.getCreatedAt() != null) {
                    jsonMsg.put("createdAt", msg.getCreatedAt().toString());
                }
                jsonArray.put(jsonMsg);
            }
            
            sendJsonResponse(response, new JSONObject().put("success", true).put("messages", jsonArray));
        } catch (Exception e) {
            sendJsonError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error fetching messages: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if ("/send".equals(pathInfo)) {
            handleSendMessage(request, response);
        } else {
            sendJsonError(response, HttpServletResponse.SC_NOT_FOUND, "Invalid endpoint");
        }
    }
    
    private void handleSendMessage(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        setJsonResponse(response);
        
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                sendJsonError(response, HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
                return;
            }
            
            User user = (User) session.getAttribute("user");
            String messageText = request.getParameter("message");
            
            if (messageText == null || messageText.trim().isEmpty()) {
                sendJsonError(response, HttpServletResponse.SC_BAD_REQUEST, "Message cannot be empty");
                return;
            }
            
            Message message = new Message(user.getId(), messageText, "ADMIN".equals(user.getRole()));
            boolean success = messageDAO.saveMessage(message);
            
            if (success) {
                sendJsonResponse(response, new JSONObject().put("success", true).put("message", "Message sent successfully"));
            } else {
                sendJsonError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to send message");
            }
        } catch (Exception e) {
            sendJsonError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error sending message: " + e.getMessage());
        }
    }
    
    private void setJsonResponse(HttpServletResponse response) {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
    }
    
    private void sendJsonResponse(HttpServletResponse response, JSONObject json) throws IOException {
        response.getWriter().write(json.toString());
    }
    
    private void sendJsonError(HttpServletResponse response, int status, String message) throws IOException {
        response.setStatus(status);
        JSONObject error = new JSONObject()
            .put("success", false)
            .put("message", message);
        sendJsonResponse(response, error);
    }
} 