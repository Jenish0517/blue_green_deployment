# Simple Dockerfile: Compile and Run in one place
FROM openjdk:21-slim
WORKDIR /app

# Copy all files at once for simplicity
COPY . .

# Compile inside Docker to avoid needing Java on the Jenkins agent
RUN javac Server.java

# Define defaults but allow override
ENV SERVER_PORT=80
ENV STATIC_DIR=blue

EXPOSE 80

# Simple run command
CMD java Server
