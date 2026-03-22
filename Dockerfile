# Build stage
FROM openjdk:21-slim AS build
WORKDIR /app
COPY Server.java .
RUN javac Server.java

# Runtime stage
FROM openjdk:21-slim
WORKDIR /app
COPY --from=build /app/*.class .
COPY blue/ ./blue/
COPY green/ ./green/

EXPOSE 8080
# Default command, port and static dir will be passed via docker run
CMD ["java", "-Dserver.port=8080", "-Dstatic.dir=blue", "Server"]
