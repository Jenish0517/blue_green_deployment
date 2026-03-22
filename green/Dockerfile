# Use eclipse-temurin as it's the current recommended Java image
FROM eclipse-temurin:21-jdk-jammy
WORKDIR /app

# Copy all files at once for simplicity
COPY . .

# Compile inside Docker
RUN javac Server.java

# Define defaults but allow override
ENV SERVER_PORT=80
ENV STATIC_DIR=.

EXPOSE 80

# Simple run command
CMD ["java", "Server"]
