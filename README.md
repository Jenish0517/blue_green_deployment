# Blue-Green Deployment Calculator

This project demonstrates a **Blue-Green deployment strategy** for a containerized calculator application using Docker, Nginx, Jenkins, and GitHub.

## Project Overview
The application is designed for zero-downtime deployments. It consists of two environments:
*   **🔵 Blue**: The current live version (Running on Port 8082).
*   **🟢 Green**: The updated version (Running on Port 8083).

**Nginx** (Port 8090) acts as a reverse proxy, controlling user traffic and ensuring only one environment is live at a time.

## Key Features
*   **Zero Downtime**: Switch traffic between environments seamlessly.
*   **Maven-Free**: The backend is a lightweight Java `HttpServer`, making builds extremely fast and dependency-free.
*   **CI/CD Ready**: Jenkinsfile included for automated building, testing, and deployment.
*   **Easy Rollback**: If a failure occurs in the Green environment, traffic remains on Blue.

## Folder Structure
*   `/blue`: Static assets for the Blue version.
*   `/green`: Static assets for the Green version.
*   `/nginx`: Nginx configuration for traffic routing.
*   `Server.java`: Lightweight Java backend server.
*   `Dockerfile`: Multi-purpose container definition.
*   `Jenkinsfile`: Automated deployment pipeline.

## Quick Start (Manual)
1. **Compile**: `javac Server.java`
2. **Run Blue**: `java -Dserver.port=8082 -Dstatic.dir=blue Server`
3. **Run Green**: `java -Dserver.port=8083 -Dstatic.dir=green Server`

---
*Developed for modern DevOps practices to ensure continuous delivery and reliable service.*
