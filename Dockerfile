# Simple Dockerfile: Compile and Run in one place
FROM openjdk:21-slim
WORKDIR /app

# Copy all files at once for simplicity
COPY . .

# Compile inside Docker to avoid needing Java on the Jenkins agent
RUN javac Server.java

# Define defaults but allow override
ENV SERVER_PORT=8080
ENV STATIC_DIR=blue

EXPOSE 8080 8082 8083

# Simple run command
CMD java Server
