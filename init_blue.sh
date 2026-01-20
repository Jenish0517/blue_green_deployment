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
docker run -d --name bluegreen-blue -p 8081:8081 bluegreen-calculator:blue

# 5. Wait for Blue to initialize
echo "Waiting for Blue to be ready..."
sleep 15

# 6. Configure Nginx to point to Blue
echo "Configuring Nginx to point to Blue..."
sed -i 's/set \$deployment "green"/set \$deployment "blue"/' nginx/nginx.conf

# 7. Apply Nginx Configuration
# Note: This assumes /etc/nginx/nginx.conf is the main config file.
# We back it up and replace it with our project config.
echo "Applying Nginx Configuration..."
if [ -f /etc/nginx/nginx.conf ]; then
    sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
fi

# Get absolute path to the project's nginx.conf
PROJECT_NGINX_CONF="$(pwd)/nginx/nginx.conf"
sudo cp "$PROJECT_NGINX_CONF" /etc/nginx/nginx.conf

# 8. Reload Nginx
echo "Reloading Nginx..."
sudo nginx -t
sudo systemctl reload nginx

echo "--------------------------------------------------"
echo "Blue Deployment Complete!"
echo "Blue App: http://localhost:8081 (Direct)"
echo "Nginx:    http://localhost (Points to Blue)"
echo "--------------------------------------------------"
