#!/bin/bash
set -e

echo "Starting Blue Deployment Initialization..."

# 1. Build Blue Application
echo "Building Blue Application..."
mvn clean package -Pblue

# 2. Build Docker Image
echo "Building Docker Image for Blue..."
docker build -t bluegreen-calculator:blue --build-arg JAR_FILE=calculator-blue.jar .

# 3. Stop Green Container if running
echo "Stopping Green Container..."
docker stop bluegreen-green || true
docker rm bluegreen-green || true

# 4. Start Blue Container
echo "Starting Blue Container..."
docker run -d --name bluegreen-blue -p 8082:8082 bluegreen-calculator:blue

# 5. Wait for Blue to initialize
echo "Waiting for Blue to be ready..."
sleep 15

# 6. Configure Nginx to point to Blue
echo "Configuring Nginx to point to Blue..."
sed -i 's/set \$deployment "green"/set \$deployment "blue"/' nginx/nginx.conf

# 7. Start Nginx Container
echo "Starting Nginx Container..."
if docker ps -a --format '{{.Names}}' | grep -q "^bluegreen-nginx$"; then
    echo "Removing existing Nginx container..."
    docker rm -f bluegreen-nginx
fi

docker run -d \
    --name bluegreen-nginx \
    -p 80:80 \
    --add-host host.docker.internal:host-gateway \
    -v "$(pwd)/nginx/nginx.conf:/etc/nginx/nginx.conf:ro" \
    nginx

echo "--------------------------------------------------"
echo "Blue Deployment Complete!"
echo "Blue App: http://localhost:8082 (Direct)"
echo "Nginx:    http://localhost (Points to Blue)"
echo "--------------------------------------------------"
