# College Admission Portal

A web application for managing college admissions, built with Java Servlets, JSP, and MySQL.

## Features

- User registration and authentication (Student and Admin roles)
- Application submission with document uploads
- Admin dashboard for application management
- Communication system between applicants and administrators
- Admin tools for data management

## Technologies Used

- Java Servlets & JSP
- MySQL Database
- Bootstrap 5 for UI
- Tomcat Application Server

## Deployment to Render

This application is configured for easy deployment to Render. Follow these steps:

1. Push this repository to GitHub
2. Sign up for a free account at [render.com](https://render.com)
3. Create a new Web Service and connect your GitHub repository
4. Configure as follows:
   - Environment: Java
   - Build Command: `mvn clean package`
   - Start Command: `java -jar target/dependency/webapp-runner.jar --port $PORT target/*.war`
5. Create a PostgreSQL database in Render
6. Add environment variables for database connection

## Local Development

To run this application locally:

1. Clone the repository
2. Set up a MySQL database
3. Update database connection details in the configuration
4. Run `mvn clean package` to build the application
5. Deploy the WAR file to a local Tomcat server

## License

This project is licensed under the MIT License - see the LICENSE file for details. 